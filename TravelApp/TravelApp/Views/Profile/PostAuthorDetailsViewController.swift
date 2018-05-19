//
//  PostAuthorDetailsViewController.swift
//  TravelApp
//
//  Created by Demo on 5/10/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class PostAuthorDetailsViewController: UIViewController {

    var post: Post?
    var isUserLoged = 0
    @IBOutlet weak var followImage: UIImageView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var coverImage: UIView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userDescription: UITextView!
    
    @IBOutlet weak var userCountry: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    
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
                
            userName.text = userProfile.firstname + " " + userProfile.lastname
            userCountry.text = userProfile.country
            userDescription.text = userProfile.description
            
        }
        
      
        profileImage.layer.borderColor = UIColor.white.cgColor
        profileImage.layer.borderWidth = 4.0
        profileImage.layer.cornerRadius = 3
        coverImage.addBackground(imageName: "coverPhoto", contentMode: .scaleToFill)
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(changeFollowImage))
        followImage.isUserInteractionEnabled = true
        followImage.addGestureRecognizer(imageTap)
        
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
