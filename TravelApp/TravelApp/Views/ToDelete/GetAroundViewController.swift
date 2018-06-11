//
//  GetAroundViewController.swift
//  TravelApp
//
//  Created by Demo on 5/20/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase
import CoreLocation


class GetAroundViewController: UIViewController, CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    var city:String!
    var camera = GMSCameraPosition()
    var mapView = GMSMapView()
    var currentLocation = CLLocationCoordinate2D()
    var destinations = [Location]()
    var currentDestination: Location!
    var nextDestination : Location!
    var userLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       locationManager.delegate = self
       locationManager.desiredAccuracy = kCLLocationAccuracyBest
       locationManager.requestWhenInUseAuthorization()
       locationManager.stopUpdatingLocation()
       setMap()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(nextObjective(sender:)))
        setLocations()
 
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations[0]
        print("test")
        print(userLocation.coordinate)
        manager.stopUpdatingLocation()
    }
     func setMap(){
        
        camera =  GMSCameraPosition.camera(withLatitude: 47.171246, longitude: 27.575909, zoom: 15)
        //print(userLocation.coordinate.latitude)
       // camera =  GMSCameraPosition.camera(withLatitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude, zoom: 15)
        
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        currentLocation = CLLocationCoordinate2D(latitude: 47.171246, longitude: 27.575909)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "Unirii Squere"
        marker.map = mapView
        
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
             nextDestination = destinations.first
        }
        else {
            if let index = destinations.index(of: currentDestination){
                currentDestination = destinations[index + 1]
                if(index != destinations.count - 1){
                    nextDestination = destinations[index]
                    
                }
                
            }
        }
        let path = GMSMutablePath()
        path.add(currentDestination.location)
        path.add(nextDestination.location)
        
        let rect = GMSPolyline(path: path)
        rect.strokeWidth = 2.0
        rect.map = mapView
        setMapCamera()
    }

    private func setMapCamera(){
        
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        mapView.animate(to: GMSCameraPosition.camera(withTarget: currentDestination.location, zoom: 18))
        CATransaction.commit()
        
        let marker = GMSMarker(position: currentDestination.location)
        marker.title = currentDestination.name
  
      
        
        marker.icon = UIImage(named:"mark")
        marker.map = mapView
    }
    
    

}
