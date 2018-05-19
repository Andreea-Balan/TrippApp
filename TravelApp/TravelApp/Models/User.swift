//
//  User.swift
//  TravelApp
//
//  Created by Demo on 4/15/18.
//  Copyright © 2018 HS. All rights reserved.
//

import Foundation

class User {
    var uid: String
    var lastname: String
    var firstname: String
    var photoURL : URL
    var phoneNumber: String
    var description: String
    var country: String
    
    
    init(uid: String, lastname:String, firstname:String,photoURL:URL,phoneNumber: String,description: String, country:String) {
        self.uid = uid
        self.lastname = lastname
        self.firstname = firstname
        self.photoURL = photoURL
        self.phoneNumber = phoneNumber
        self.description = description
        self.country = country
    }
    
    
}
