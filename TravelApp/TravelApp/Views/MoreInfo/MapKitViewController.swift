//
//  MapKitViewController.swift
//  TravelApp
//
//  Created by Demo on 5/20/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class MapKitViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{

    var city:String!
    var destinations = [Location]()
    var locationManager = CLLocationManager()
    var currentDestination: Location!
    var sourceDestination: Location!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let sourceCoord = CLLocationCoordinate2DMake(47.174184, 27.574933)
       // let sourceDest = MKPlacemark(coordinate: sourceCoord)
        let sourceDest = Location(name: "Computer Science", location: sourceCoord)
        sourceDestination = sourceDest
        self.mapView.delegate = self
        setLocations()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextObjective(sender:)))
    }

    func setLocations(){
        print(city)
        var test: String = city
        let citiesRef = Database.database().reference().child("locations/\(test)")
        
        citiesRef.observe(.value, with: {snapshot in
            var temporaryLocations = [Location]()
            for child in snapshot.children {
                if let childSnap = child as? DataSnapshot,
                    let dict = childSnap.value as? [String:Any],
                    let name = dict["name"] as? String,
                    let coord =  dict["location"] as? [String:Double]{
                    
                    let location = Location(name: name, location: CLLocationCoordinate2D(latitude: coord["lat"]!, longitude: coord["lon"]!))
                    temporaryLocations.append(location)
                }
            }
            self.destinations = temporaryLocations
        })
    }
    
    @objc func nextObjective(sender: UIBarButtonItem) {
        
        if currentDestination == nil {
            currentDestination = destinations.first
            //sourceDestination = destinations.first
            
        }
        else {
            if let index = destinations.index(of: currentDestination){
                if(index != destinations.count - 1){
                    currentDestination = destinations[index + 1]
                    sourceDestination = destinations[index]
                }
                else {
                    navigationItem.rightBarButtonItem = nil
                }
            }
        }
        
        setMapCamera()
    }

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: center, span: span)
        
        //sourceDestination.coordinate = region.center
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        locationManager.stopUpdatingLocation()
        
    }
    
    private let regionRedius: CLLocationDistance = 1000
   
    private func setMapCamera(){
    
    let span = MKCoordinateSpan(latitudeDelta: 0.15, longitudeDelta: 0.15)
    let loc = MKCoordinateRegion(center: currentDestination.coordinate, span: span)
    let coord = MKCoordinateRegionMakeWithDistance(currentDestination.coordinate, regionRedius * 2.0, regionRedius * 2.0)
    mapView.setRegion(coord, animated: true)
    mapView.addAnnotation(currentDestination)
        
    let sourcePlacemark = MKPlacemark(coordinate: sourceDestination.coordinate)
    let destPlacemark = MKPlacemark(coordinate: currentDestination.coordinate)
    
    let sourceItem = MKMapItem(placemark: sourcePlacemark)
    let destItem = MKMapItem(placemark: destPlacemark)
    
    let directionRequest = MKDirectionsRequest()
    directionRequest.source = sourceItem
    directionRequest.destination = destItem
    directionRequest.transportType = .walking
        
    let directions = MKDirections(request: directionRequest)
        directions.calculate(completionHandler: {
            (response, error) in
            
            guard let response = response else {
                if let error = error {
                    print("Something went wrong")
                }
                return
            }
            let route = response.routes[0]
            self.mapView.add(route.polyline, level: .aboveRoads)
            
            let rekt = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rekt), animated: true)
            
        })

    }
 
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 3.0
        
        return renderer
    }



}
