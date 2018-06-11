//
//  CityDetailViewController.swift
//  TravelApp
//
//  Created by Demo on 5/16/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {

    @IBOutlet weak var foodImage: UIImageView!
    @IBOutlet weak var experiencesImage: UIImageView!
    @IBOutlet weak var getAroundImage: UIImageView!
    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var thingsToDoImage: UIImageView!
    var tappedCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureLayout()
        
        ImageService.getImage(withURL: (tappedCity?.photoURL[2])!) { image in
            self.cityImage.image = image
        }

    }
    
    func pictureLayout() {
        thingsToDoImage.layer.cornerRadius = thingsToDoImage.bounds.height / 2
        thingsToDoImage.clipsToBounds = true
        experiencesImage.layer.cornerRadius = experiencesImage.bounds.height / 2
        experiencesImage.clipsToBounds = true
        foodImage.layer.cornerRadius = experiencesImage.bounds.height / 2
        foodImage.clipsToBounds = true
        
        let imageTap1 = UITapGestureRecognizer(target: self, action: #selector(openThingToDo))
        let imageTap2 = UITapGestureRecognizer(target: self, action: #selector(openGetAround))
        let imageTap3 = UITapGestureRecognizer(target: self, action: #selector(openExperiences))
        let imageTap4 = UITapGestureRecognizer(target: self, action: #selector(openFood))
        thingsToDoImage.isUserInteractionEnabled = true
        getAroundImage.isUserInteractionEnabled = true
        experiencesImage.isUserInteractionEnabled = true
        foodImage.isUserInteractionEnabled = true
        thingsToDoImage.addGestureRecognizer(imageTap1)
        getAroundImage.addGestureRecognizer(imageTap2)
        experiencesImage.addGestureRecognizer(imageTap3)
        foodImage.addGestureRecognizer(imageTap4)
    }

    @objc func openThingToDo(_ sender: UIImageView){
       
       // if( sender.restorationIdentifier == "thingtodo"){
            performSegue(withIdentifier: "thingstodo", sender: self)
      
    }

    @objc func openFood(_ sender: UIImageView){
        
        // if( sender.restorationIdentifier == "thingtodo"){
        performSegue(withIdentifier: "foodanddrinks", sender: self)
        
    }
    @objc func openExperiences(_ sender: UIImageView){
        
        // if( sender.restorationIdentifier == "thingtodo"){
        performSegue(withIdentifier: "experiences", sender: self)
        
    }


    @objc func openGetAround(_ sender: UIImageView){

        performSegue(withIdentifier: "trymapkit", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
        
        if(segue.identifier == "thingstodo") {
            let detailView = segue.destination as! ThingsToDoViewController
            detailView.tappedCity = tappedCity
        }
        
     /*   if(segue.identifier == "getaaround") {
            let detailView = segue.destination as! GetAroundViewController
            detailView.city = tappedCity?.name as! String
        }
   */
        if(segue.identifier == "trymapkit") {
            let detailView = segue.destination as! MapKitViewController
            detailView.city = tappedCity?.name as! String
        }
        
        if(segue.identifier == "experiences") {
            let detailView = segue.destination as! CityExperiencesViewController
            detailView.city = tappedCity?.name as! String
        }
        
       if(segue.identifier == "foodanddrinks") {
            let detailView = segue.destination as! FeedMeViewController
            detailView.tappedCity = tappedCity
        }

      
    }
    



}
