//
//  Location.swift
//  TravelApp
//
//  Created by Demo on 5/20/18.
//  Copyright © 2018 HS. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps
import AddressBook
import  MapKit
class Location: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    
    
    let name: String
    let location: CLLocationCoordinate2D
    
    init(name:String, location: CLLocationCoordinate2D){
        self.name = name
        self.location = location
        self.coordinate = location
    }
    var subtitle: String? {
        return name
    }
    static func == (lhs: Location, rhs: Location) -> Bool{
        return lhs.location.latitude == rhs.location.latitude
    }
}
