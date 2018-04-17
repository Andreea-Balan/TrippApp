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
                let username = dict["username"] as? String,
                let photoURL = dict["photoURL"] as? String,
                let url = URL(string: photoURL) {
                    userProfile = User(uid: snapshot.key, username: username, photoURL: url)
            }
            
            completion(userProfile)
        })
        
    }
    
}
