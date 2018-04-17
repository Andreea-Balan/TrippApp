//
//  FirstViewController.swift
//  TravelApp
//
//  Created by Demo on 4/14/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import  Firebase

class FirstViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    @IBOutlet weak var collectionView: UICollectionView!
    var posts = [Post]()
    
    
    @IBAction func handleLogout(_target:UIBarButtonItem){
        try! Auth.auth().signOut()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "PostCollectionViewCell", bundle: nil)
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: "collectioncell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        observePosts()
        
        
        
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        
        layout.minimumInteritemSpacing = 5
        
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 20)/2, height: self.collectionView.frame.size.width/2)
        
        
    }

    func observePosts(){
       let postsRef = Database.database().reference().child("posts")
        
        postsRef.observe(.value, with: {snapshot in
            
            var temporaryPosts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let category = dict["category"] as? String,
                    let city = dict["city"] as? String,
                    let postPhotoURL = dict["photoURL"] as? String,
                    let postURL = URL(string: postPhotoURL),
                    let price =  dict["price"] as? String,
                    let title = dict["title"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let author = dict["author"] as? [String:Any],
                    let uid = author["userId"] as? String,
                    let username = author["username"] as? String,
                    let authorPhotoURL = author["photoURL"] as? String,
                    let authorURL = URL(string: authorPhotoURL) {
                        
                        let authorProfile = User(uid: uid, username: username, photoURL: authorURL)
                        let post =  Post(id: childSnapshot.key, author: authorProfile, category: category, title: title, price: Int(price)!, location: city, timestamp: timestamp, photoURL: postURL)
                    
                        temporaryPosts.append(post)
                }
            }
            
            self.posts = temporaryPosts
            self.collectionView.reloadData()
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! PostCollectionViewCell
        cell.setPost(post: posts[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.gray.cgColor
        cell?.layer.borderWidth = 2
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.layer.borderColor = UIColor.lightGray.cgColor
        cell?.layer.borderWidth = 0.5
    }
   
  
    
}
