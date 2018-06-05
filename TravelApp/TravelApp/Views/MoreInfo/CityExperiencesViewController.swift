//
//  CityExperiencesViewController.swift
//  TravelApp
//
//  Created by Demo on 5/31/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import  Firebase

class CityExperiencesViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var tappedPost: Post?
    var posts = [Post]()
    var city: String?
    @IBOutlet weak var CityTilte: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "PostCollectionViewCell", bundle: nil)
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: "citycollectioncell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        

        
        observePosts()
        
    }

    func observePosts(){
        let postsRef = Database.database().reference().child("posts").queryOrdered(byChild: "city").queryEqual(toValue:(city) )
    
        postsRef.observe(.value, with:{ (snapshot: DataSnapshot) in
            var temporaryPosts = [Post]()
            for snap in snapshot.children {
                print((snap as! DataSnapshot).key)
                if let childSnapshot = snap as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let category = dict["category"] as? String,
                    let city = dict["city"] as? String,
                    let postPhotoURL = dict["photoURL"] as? String,
                    let postURL = URL(string: postPhotoURL),
                    let price =  dict["price"] as? String,
                    let title = dict["title"] as? String,
                    let location = dict["location"] as? [String:Any],
                    let description = dict["description"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let author = dict["author"] as? [String:Any],
                    let uid = author["userId"] as? String,
                    let lastname = author["lastname"] as? String,
                    let firstname = author["firstname"] as? String,
                    let phoneNumber = author["phoneNumber"] as? String,
                    let authorDescription = author["description"] as? String,
                    let country = author["country"] as? String,
                    let authorPhotoURL = author["photoURL"] as? String,
                    let authorURL = URL(string: authorPhotoURL) {
                    
                        let authorProfile = User(uid: uid, lastname: lastname, firstname: firstname, photoURL: authorURL, phoneNumber: phoneNumber,description: authorDescription,  country: country)
                    
                        let post =  Post(id: childSnapshot.key, author: authorProfile, category: category, title: title, price: Int(price)!, location: city,  description: description, locationAddress: location ,timestamp: timestamp, photoURL: postURL)
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "citycollectioncell", for: indexPath) as! PostCollectionViewCell
        
        
        cell.setPost(post: posts[indexPath.row], liked: false)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostCollectionViewCell
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
        
        tappedPost = posts[indexPath.row]
        
        
        self.performSegue(withIdentifier: "goToDetails2", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToDetails2") {
            let detailView = segue.destination as! PostDetailsViewController
            detailView.post = tappedPost
        }
        
       
    }
    
    
    
}

