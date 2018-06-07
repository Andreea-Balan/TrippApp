//
//  FeedMeViewController.swift
//  TravelApp
//
//  Created by Demo on 6/6/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import GoogleMaps

class FeedMeViewController: UIViewController {

    private let dataProvider = GoogleDataProvider()
    private let searchRadius: Double = 1000
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    private let locationManager = CLLocationManager()
    @IBOutlet private weak var mapCenterPinImage: UIImageView!
    @IBOutlet private weak var pinImageVerticalConstraint: NSLayoutConstraint!
    var searchedTypes = ["bakery", "bar", "cafe", "grocery_or_supermarket", "restaurant"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        mapView.delegate = self
    }
    
    @IBAction func refreshPlaces(_ sender: Any) {
        fetchNearbyPlaces(coordinate: mapView.camera.target)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
            let controller = navigationController.topViewController as? TypesTableViewController else {
                return
        }
        controller.selectedTypes = searchedTypes
        controller.delegate = self
    }
    private func fetchNearbyPlaces(coordinate: CLLocationCoordinate2D) {
        // 1
        mapView.clear()
        // 2
        dataProvider.fetchPlacesNearCoordinate(coordinate, radius:searchRadius, types: searchedTypes) { places in
            places.forEach {
                // 3
                let marker = PlaceMarker(place: $0)
                // 4
                marker.map = self.mapView
            }
        }
    }
    @available(iOS 11.0, *)
    @available(iOS 11.0, *)
    @available(iOS 11.0, *)
    private func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
        self.addressLabel.unlock()
        // 1
        let geocoder = GMSGeocoder()
        
        // 2
        geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
            guard let address = response?.firstResult(), let lines = address.lines else {
                return
            }
            
            // 3
            self.addressLabel.text = lines.joined(separator: "\n")
            
            let labelHeight = self.addressLabel.intrinsicContentSize.height
            if #available(iOS 11.0, *) {
                self.mapView.padding = UIEdgeInsets(top: self.view.safeAreaInsets.top, left: 0,bottom: labelHeight, right: 0)
            } else {
                // Fallback on earlier versions
            }
            
            UIView.animate(withDuration: 0.25) {
                //2
                if #available(iOS 11.0, *) {
                    self.pinImageVerticalConstraint.constant = ((labelHeight - self.view.safeAreaInsets.top) * 0.5)
                } else {
                    // Fallback on earlier versions
                }
                self.view.layoutIfNeeded()
            }
        }
    }
    
}

// MARK: - TypesTableViewControllerDelegate
extension FeedMeViewController: TypesTableViewControllerDelegate {
  
    func typesController(_ controller: TypesTableViewController, didSelectTypes types: [String]) {
        searchedTypes = controller.selectedTypes.sorted()
        dismiss(animated: true)
        fetchNearbyPlaces(coordinate: mapView.camera.target)
    }
}


extension FeedMeViewController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        if #available(iOS 11.0, *) {
            reverseGeocodeCoordinate(position.target)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
        addressLabel.lock()
    }
    
}

extension FeedMeViewController: CLLocationManagerDelegate {
    // 2
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        // 3
        guard status == .authorizedWhenInUse else {
            return
        }
        // 4
        locationManager.startUpdatingLocation()
        
        //5
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
    }
    
    // 6
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        // 7
        mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
        // 8
        locationManager.stopUpdatingLocation()
        
        fetchNearbyPlaces(coordinate: location.coordinate)
    }
    
    
}
