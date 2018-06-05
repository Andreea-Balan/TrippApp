//
//  Objectiv.swift
//  TravelApp
//
//  Created by Demo on 5/16/18.
//  Copyright © 2018 HS. All rights reserved.
//

import Foundation
import UIKit

class Objectiv {
    // MARK: - Public API
    var title = ""
    var featuredImageURL: URL
    var color: UIColor
    var description: String
    var location: Location
    
    init(title: String, featuredImage: URL, color: UIColor, description:String, location:Location )
    {
        self.title = title
        self.featuredImageURL = featuredImage
        self.color = color
        self.description = description
        self.location = location
    }
    
    // MARK: - Private
    // dummy data
    static func fetchObjectivs() -> [Objectiv]
    {
        return [
         /*   Objectiv(title: "Botanical Garden", featuredImage: URL, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8), description: ""),
            Objectiv(title: "Opera", featuredImage: UIImage(named: "iasi2")!, color: UIColor(red: 240/255.0, green: 133/255.0, blue: 91/255.0, alpha: 0.8), description: ""),
            Objectiv(title: "Palace of Culture", featuredImage: UIImage(named: "iasi1")!, color: UIColor(red: 105/255.0, green: 80/255.0, blue: 227/255.0, alpha: 0.8), description: ""),
            Objectiv(title: "Botanical Garden", featuredImage: UIImage(named: "iasi3")!, color: UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.8), description: ""),
            Objectiv(title: "Opera", featuredImage: UIImage(named: "iasi2")!, color: UIColor(red: 240/255.0, green: 133/255.0, blue: 91/255.0, alpha: 0.8), description: ""),
            Objectiv(title: "Palace of Culture", featuredImage: UIImage(named: "iasi1")!, color: UIColor(red: 105/255.0, green: 80/255.0, blue: 227/255.0, alpha: 0.8), description: ""),
        */]
    }
    

    
    
}
