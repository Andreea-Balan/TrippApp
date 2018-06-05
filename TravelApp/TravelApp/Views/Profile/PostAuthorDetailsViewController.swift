//
//  PostAuthorDetailsViewController.swift
//  TravelApp
//
//  Created by Demo on 5/10/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import Firebase

class PostAuthorDetailsViewController: UIViewController, UICollectionViewDelegate,UICollectionViewDataSource  {

    var post: Post?
    var isUserLoged = 0
    var profileId = ""
    @IBOutlet weak var followImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var coverImage: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDescription: UITextView!
    
    @IBOutlet weak var organisedColectionView: UICollectionView!
    @IBOutlet weak var likedColectionView: UICollectionView!
    @IBOutlet weak var userCountry: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
    var tappedPost: Post?
    var posts = [Post]()
    var likedPosts = [Post]()
    var keys = [String]()
    
    //just for tes
    var fallow: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()

        if(isUserLoged == 0){
            editProfileButton.isHidden = true
            editProfileButton.frame.size.height = 0
           
            ImageService.getImage(withURL: (post?.author.photoURL)!) { image in
                self.profileImage.image = image
            }
            userName.text = (post?.author.firstname)! + " " + (post?.author.lastname)!
            userCountry.text = (post?.author.country)!
            userDescription.text = (post?.author.description)!
        }
        else {
            
             guard let userProfile = UserService.currentUserProfile else { return }
            
            ImageService.getImage(withURL: userProfile.photoURL) { image in
                self.profileImage.image = image
            }
            profileId = userProfile.uid
            userName.text = userProfile.firstname + " " + userProfile.lastname
            userCountry.text = userProfile.country
            userDescription.text = userProfile.description
            
        }
        
        let cellNib = UINib(nibName: "PostCollectionViewCell", bundle: nil)
        
        likedColectionView.register(cellNib, forCellWithReuseIdentifier: "likedcollectioncell")
        likedColectionView.delegate = self
        likedColectionView.dataSource = self
        likedColectionView.reloadData()
        
        organisedColectionView.register(cellNib, forCellWithReuseIdentifier: "organisedcollectioncell")
        organisedColectionView.delegate = self
        organisedColectionView.dataSource = self
        organisedColectionView.reloadData()
        
        
        
        observePosts()
        observeLikedPosts()
        print("check")
        print(keys)
        print(posts)
      
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 4.0
        profileImage.layer.cornerRadius = 3
        coverImage.addBackground(imageName: "coverPhoto", contentMode: .scaleToFill)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(changeFollowImage))
        followImage.isUserInteractionEnabled = true
        followImage.addGestureRecognizer(imageTap)
        
        
       // userDescription.translatesAutoresizingMaskIntoConstraints = true
//userDescription.sizeToFit()
      //  userDescription.isScrollEnabled = false
    }
    
    
    func observeLikedPosts(){
        var temporaryPosts = [Post]()
        var likeRef = DatabaseQuery()
        var postKeys = [String]()
        if(isUserLoged == 0){
            likeRef = Database.database().reference().child("likes").queryOrdered(byChild: "user").queryEqual(toValue:(post?.author.uid))
        }
        else {
            likeRef = Database.database().reference().child("likes").queryOrdered(byChild: "user").queryEqual(toValue:(self.profileId))
        }
        
        /*likeRef.observe(.value, with: {snapshot in
            for child in snapshot.children {
                if let childSnap = child as? DataSnapshot,
                    let dict = childSnap.value as? [String:Any],
                    let posts = dict["post"] as? String {
                 
                    postsRef.observe(.value, with: {snap in
                        var temporaryPosts = [Post]()
                    
                        for ch in snap.children {
                            if let childSn = ch as? DataSnapshot,
                                let key = childSn.key as? String {
                                if(key == posts){
                                    print("ok")
                                    postKeys.append(key)
                                }
                            }
                        }
                        self.keys = postKeys
                        print(self.keys)
                        
                    })
                    
                }
            }
            
        })*/
        
        likeRef.observe(.value, with: {snapshot in
            for child in snapshot.children {
                if let childSnap = child as? DataSnapshot,
                let k = childSnap.value as? [String:Any],
                let posts = k["post"] as? String{
                    self.keys.append(posts)
                }
            }
            print("test")
            print(self.keys)
            
            for each in self.keys {
                print(each)
                 let postsRef = Database.database().reference().child("posts").child(each)
                
                postsRef.observe(.value, with: {snap in
            
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
                        let authorURL = URL(string: authorPhotoURL){
                        print(city)
                        let authorProfile = User(uid: uid, lastname: lastname, firstname: firstname, photoURL: authorURL, phoneNumber: phoneNumber,description: authorDescription,  country: country)
                        
                        let post =  Post(id: childSnapshot.key, author: authorProfile, category: category, title: title, price: Int(price)!, location: city,  description: description, locationAddress: location ,timestamp: timestamp, photoURL: postURL)
                        temporaryPosts.append(post)
                    }
                    
                    self.likedPosts = temporaryPosts
                    self.likedColectionView.reloadData()
                    print(self.likedPosts)
                })
            }
        })
        
       
       /* let postsRef = Database.database().reference().child("posts")
        
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
                    
                    
                    likeRef.observe(.value, with: {snapshot in
                        for child in snapshot.children {
                            if let childSnap = child as? DataSnapshot,
                                let dict = childSnap.value as? [String:Any],
                                let posts = dict["post"] as? String {
                                if( posts == post.id){
                                    temporaryPosts.append(post)
                                }
                                
                            }
                        }
                    })
                }
                
            }
            
            self.likedPosts = temporaryPosts
            self.likedColectionView.reloadData()
            
        })*/
    }
    
    func observePosts(){
        var postsRef = DatabaseQuery()
        var likeRef = DatabaseQuery()
        if(isUserLoged == 0){
           postsRef = Database.database().reference().child("posts").queryOrdered(byChild: "author/userId").queryEqual(toValue: post?.author.uid)
           likeRef = Database.database().reference().child("likes").queryOrdered(byChild: "user").queryEqual(toValue:(post?.author.uid))
        }
        else {
            postsRef = Database.database().reference().child("posts").queryOrdered(byChild: "author/userId").queryEqual(toValue: profileId)
            likeRef = Database.database().reference().child("likes").queryOrdered(byChild: "user").queryEqual(toValue:(self.profileId))
        }
        
   
        
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
            
            self.organisedColectionView.reloadData()
           
        })
    }
        
       
    
    
    @objc func changeFollowImage(_ sender: Any){
        // self.present(PostAuthorDetailsViewController, animated: true, completion: nil)
        //just for test
        if(!fallow){
        followImage.image = UIImage(named: "heart_after")
            fallow = true
        }
        else {
            followImage.image = UIImage(named: "heart")
            fallow = false
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.likedColectionView{
            return likedPosts.count}
        else {
             return posts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var liked = false
        let userUid = Auth.auth().currentUser?.uid
        if collectionView == self.likedColectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "likedcollectioncell", for: indexPath) as! PostCollectionViewCell
            //cell.setPost(post: posts[indexPath.row], liked: false)
              //  return cell
            let likeRef = Database.database().reference().child("likes").queryOrdered(byChild: "post").queryEqual(toValue:(likedPosts[indexPath.row].id))
            likeRef.observe(.value, with: {snapshot in
                for child in snapshot.children {
                    if let childSnap = child as? DataSnapshot,
                        let dict = childSnap.value as? [String:Any],
                        let user = dict["user"] as? String {
                        if(user == userUid){
                            liked = true
                            cell.setPost(post: self.likedPosts[indexPath.row], liked: true)
                        }
                        
                    }
                }
            })
            cell.setPost(post: likedPosts[indexPath.row], liked: liked)
            return cell
        }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "organisedcollectioncell", for: indexPath) as! PostCollectionViewCell
               // cell.setPost(post: posts[indexPath.row], liked: false)
                //return cell
                let likeRef = Database.database().reference().child("likes").queryOrdered(byChild: "post").queryEqual(toValue:(posts[indexPath.row].id))
                likeRef.observe(.value, with: {snapshot in
                    for child in snapshot.children {
                        if let childSnap = child as? DataSnapshot,
                            let dict = childSnap.value as? [String:Any],
                            let user = dict["user"] as? String {
                            if(user == userUid){
                                liked = true
                                cell.setPost(post: self.posts[indexPath.row], liked: true)
                            }
                        }
                    }
                })
                cell.setPost(post: posts[indexPath.row], liked: liked)
                return cell
        }
            
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostCollectionViewCell
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
        
        tappedPost = posts[indexPath.row]
        
        
        self.performSegue(withIdentifier: "goToDetails3", sender: self)
    }
 
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToDetails3") {
            let detailView = segue.destination as! PostDetailsViewController
            detailView.post = tappedPost
        }
        
        
    }

}

extension UIView {
    func addBackground(imageName: String, contentMode: UIViewContentMode = .scaleToFill) {
        // setup the UIImageView
        let backgroundImageView = UIImageView(frame: UIScreen.main.bounds)
        backgroundImageView.image = UIImage(named: imageName)
        backgroundImageView.contentMode = contentMode
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(backgroundImageView)
        sendSubview(toBack: backgroundImageView)
        
        // adding NSLayoutConstraints
        let leadingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0.0)
        let trailingConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1.0, constant: 0.0)
        let topConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0.0)
        let bottomConstraint = NSLayoutConstraint(item: backgroundImageView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0.0)
        
        NSLayoutConstraint.activate([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint])
    }
}
