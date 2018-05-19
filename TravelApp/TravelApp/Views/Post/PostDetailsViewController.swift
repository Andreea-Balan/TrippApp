//
//  PostDetailsViewController.swift
//  TravelApp
//
//  Created by Demo on 5/2/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import GoogleMaps

//add about your host on detail view

class PostDetailsViewController: UIViewController, LocateOnTheMap {
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let marker = GMSMarker(position: position)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
        self.googleMapsView.camera = camera
        
        marker.title = "Address : \(title)"
        marker.map = self.googleMapsView
        
    }
    

    var post: Post!
    
    //google map
    var googleMapsView: GMSMapView!
    @IBOutlet weak var googleContainer: UIView!
    
    
    @IBOutlet weak var postOverview: UITextView!
    @IBOutlet weak var postCity: UILabel!
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var postCategori: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var postAddress: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

    postOverview.translatesAutoresizingMaskIntoConstraints = true
        
        postOverview.sizeToFit()
        
        postOverview.isScrollEnabled = false
        ImageService.getImage(withURL: post.photoURL) { image in
            self.postImage.image = image
        }
        self.postTitle.text = post.title
        self.postCategori.text = post.category
        self.postAuthor.text = "Hosted by " + post.author.firstname
        
        ImageService.getImage(withURL: post.author.photoURL) { image in
            self.authorImage.image = image
        }
        self.postCity.text = post.location
        self.postDescription.text = post.description
        self.postAddress.text = (post.locationAddress["address"] as! String)
        
        
        authorImage.layer.cornerRadius = authorImage.bounds.height / 2
        authorImage.clipsToBounds = true
        // image tapped acction
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openAuthorDetails))
        authorImage.isUserInteractionEnabled = true
        authorImage.addGestureRecognizer(imageTap)
        
    }
  
    @objc func openAuthorDetails(_ sender: Any){
       // self.present(PostAuthorDetailsViewController, animated: true, completion: nil)
        performSegue(withIdentifier: "authordetails", sender: self)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.googleMapsView =  GMSMapView(frame: self.googleContainer.frame)
        let lat = post.locationAddress["lat"] as! Double
        let lon = post.locationAddress["lon"] as! Double
        let position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        let marker = GMSMarker(position: position)
        let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: lon, zoom: 10)
        self.googleMapsView.camera = camera
        
        marker.title = "Address : \(title)"
        marker.map = self.googleMapsView
        
       self.view.insertSubview(googleMapsView, aboveSubview: googleContainer)
        
        
        //Not working to bring subview on top
        //googleContainer.addSubview(self.googleMapsView)
        //googleContainer.bringSubview(toFront: self.googleMapsView)
        // self.googleMapsView.layer.zPosition = 1
    
        print(googleMapsView.isDescendant(of: self.googleContainer))
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "authordetails") {
            //   let cell = sender as! PostCollectionViewCell
            
            let detailView = segue.destination as! PostAuthorDetailsViewController
            detailView.post = post
        }
        
        if(segue.identifier == "goToProfile") {
            let detailView = segue.destination as! PostAuthorDetailsViewController
            detailView.isUserLoged = 1
        }
    }



}
