//
//  PostCollectionViewCell.swift
//  TravelApp
//
//  Created by Demo on 4/14/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import Firebase

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var followImage: UIImageView!
    var postID: String!
    
    var liked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(changeFollowImage))
        followImage.isUserInteractionEnabled = true
        followImage.addGestureRecognizer(imageTap)
    }
    
    func setPost(post:Post, liked: Bool) {
        ImageService.getImage(withURL: post.photoURL) { image in
            self.postPhoto.image = image
        }
        category.text = post.category
        title.text = post.title
        price.text = String(post.price) + "$ per person"
        city.text = post.location
        postID = post.id

        
        if(liked == false){
            followImage.image = UIImage(named: "heart")
        }
        else {
            followImage.image = UIImage(named: "heart_after")
            self.liked = true
        }
       
       
        
    }
    
    @objc func changeFollowImage(_ sender: Any){
        guard let userUid = Auth.auth().currentUser?.uid else { return }
        let likeObjects = ["user": userUid,
                           "post": postID] as [String:Any]
        
        if liked == false {
            followImage.image = UIImage(named: "heart_after")
            liked = true
            let likeRef = Database.database().reference().child("likes").childByAutoId()
            likeRef.setValue(likeObjects, withCompletionBlock: {error, ref in
                if error == nil {
                    print("like rel in DB")
                }else {
                    //handle the error
                }
            })
        }else {
            
            let likeRef = Database.database().reference().child("likes")
            likeRef.observe(.value, with: {snapshot in
                for child in snapshot.children {
                    if let childSnap = child as? DataSnapshot,
                    let dict = childSnap.value as? [String:Any],
                    let user = dict["user"] as? String,
                    let post = dict["post"]  as? String{
                        if(user == userUid && post == self.postID){
                            let key = childSnap.key
                            likeRef.child(key).removeValue()
                            print("remove rel in DB")
                            }
                        }
                    }
            })
            followImage.image = UIImage(named: "heart")
            liked = false
            
        }
       
       
      
    }

}
