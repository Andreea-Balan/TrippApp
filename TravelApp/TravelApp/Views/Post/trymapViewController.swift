//
//  trymapViewController.swift
//  TravelApp
//
//  Created by Demo on 5/5/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import GooglePlacesSearchController

class trymapViewController: UIViewController, UISearchBarDelegate, LocateOnTheMap, GMSAutocompleteFetcherDelegate {
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
       
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction?{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
    }

   
    @IBOutlet weak var doneButton: UIBarButtonItem!
    var gmsFetcher: GMSAutocompleteFetcher!
    @IBOutlet weak var googleContaine: UIView!
        var searchResultController: SearchResultsController!
    
    var resultsArray = [String]()
    var googleMapsView: GMSMapView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
      doneButton.isEnabled = false
        
    }
    @IBAction func searchWithAdress(_ sender: Any) {
        
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)
    }
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () ->Void in
            
            let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let marker = GMSMarker(position: position)
            let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
            self.googleMapsView.camera = camera
            
            marker.title = "Address : \(title)"
            marker.map = self.googleMapsView
            self.doneButton.isEnabled = true
            
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        /*let placeClient = GMSPlacesClient()
        placeClient.autocompleteQuery(searchText, bounds: nil, filter: nil){ (results, error: NSError)  -> Void in
            
            self.resultsArray.removeAll()
            if results == nil {
                return
        
            for result in results! {
                if let res = result as? GMSAutocompletePrediction {
                    self.resultsArray.append()
                
            }
            self.searchResultController.reloadDataWithArray(self.resultsArray)
        }
 */
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.googleMapsView =  GMSMapView(frame: self.googleContaine.frame)
        self.view.addSubview(self.googleMapsView)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
}
