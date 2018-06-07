//
//  userService.swift
//  TravelApp
//
//  Created by Demo on 4/15/18.
//  Copyright © 2018 HS. All rights reserved.
//

import Foundation
import Firebase

class UserService {
  
    static var currentUserProfile: User?
    
    static func observeUser(_ uid:String, completion: @escaping ((_ useProfile:User?)->())){
        let userRef = Database.database().reference().child("users/profile/\(uid)")
    
        userRef.observe(.value, with: {snapshot in
            var userProfile:User?
            
            if let dict = snapshot.value as? [String:Any],
                let lastname = dict["lastname"] as? String,
                let firstname = dict["firstname"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let phoneNumber = dict["phoneNumber"] as? String,
                let description = dict["description"] as? String,
                let country = dict["country"] as? String,
                let followers = dict["followers"] as? Int,
                let url = URL(string: photoURL) {
                userProfile = User(uid: snapshot.key, lastname: lastname, firstname:firstname, photoURL: url, phoneNumber: phoneNumber, description: description,country: country,followers: followers)
            }
            
            completion(userProfile)
        })
        
    }
    
}
