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
    var username: String
    var photoURL : URL
    
    
    init(uid: String, username:String, photoURL:URL) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
      
    }
    
    
}
