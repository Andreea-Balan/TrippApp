//
//  PinAnnotation.swift
//  TravelApp
//
//  Created by Demo on 5/30/18.
//  Copyright © 2018 HS. All rights reserved.
//

import Foundation
import  MapKit

class PinAnnotation:NSObject,MKAnnotation {
 
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title:String, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.coordinate = coordinate
    }

}
