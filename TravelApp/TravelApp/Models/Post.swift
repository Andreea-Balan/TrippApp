//
//  Post.swift
//  TravelApp
//
//  Created by Demo on 4/12/18.
//  Copyright © 2018 HS. All rights reserved.
//

import Foundation

class Post {
    var id: String
    var author: User
    var category: String
    var title : String
    var price : Int
    var location : String
    var timestamp: Double
    var description: String
    var locationAddress: [String:Any]
    var photoURL: URL
    
    init(id: String, author: User, category:String, title:String, price: Int, location: String, description: String, locationAddress: [String:Any], timestamp: Double, photoURL: URL) {
        self.id = id
        self.author = author
        self.category = category
        self.price = price
        self.title = title
        self.location = location
        self.locationAddress = locationAddress
        self.timestamp = timestamp
        self.photoURL = photoURL
        self.description = description
        self.locationAddress = locationAddress
    }
    
    
}
