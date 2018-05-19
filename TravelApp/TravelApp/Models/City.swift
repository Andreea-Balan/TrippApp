//
//  City.swift
//  TravelApp
//
//  Created by Demo on 5/19/18.
//  Copyright © 2018 HS. All rights reserved.
//

import Foundation

class City {
    var id: String
    var name: String
    var objectives: [Objectiv]
    var photoURL: [URL]
 
    
    init(id: String, name:String, objectives: [Objectiv] ,photoURL: [URL]) {
        self.id = id
        self.name = name
        self.objectives = objectives
        self.photoURL = photoURL
    
    }
    
    
}
