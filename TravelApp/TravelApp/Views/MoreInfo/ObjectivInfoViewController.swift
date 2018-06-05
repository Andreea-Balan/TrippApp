//
//  ObjectivInfoViewController.swift
//  TravelApp
//
//  Created by Demo on 5/30/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class ObjectivInfoViewController: UIViewController {
    var tappedObjective: Objectiv?
    
    @IBOutlet weak var objectivLocationMap: MKMapView!
    @IBOutlet weak var objectivTitle: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    @IBOutlet weak var objectiveDescription: UILabel!
    var location: Location!
    override func viewDidLoad() {
        super.viewDidLoad()

        objectivTitle.text = tappedObjective?.title.components(separatedBy: "-")[1]
        objectiveDescription.text = tappedObjective?.description
        
        ImageService.getImage(withURL: (tappedObjective?.featuredImageURL)!) { image in
            self.coverImage.image = image
        }
        
        
        let center = tappedObjective?.location.coordinate
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        let region = MKCoordinateRegion(center: center!, span: span)
        
        //sourceDestination.coordinate = region.center
        objectivLocationMap.setRegion(region, animated: true)
        
        let pin = PinAnnotation(title: objectivTitle.text!, coordinate: center!)
        objectivLocationMap.addAnnotation(pin)
       
        
   }

}
