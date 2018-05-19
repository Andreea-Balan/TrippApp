//
//  CityDetailViewController.swift
//  TravelApp
//
//  Created by Demo on 5/16/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class CityDetailViewController: UIViewController {

    @IBOutlet weak var cityImage: UIImageView!
    @IBOutlet weak var thingsToDoImage: UIImageView!
    var tappedCity: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pictureLayout()
        
        ImageService.getImage(withURL: (tappedCity?.photoURL[1])!) { image in
            self.cityImage.image = image
        }

    }
    
    func pictureLayout() {
        thingsToDoImage.layer.cornerRadius = thingsToDoImage.bounds.height / 2
        thingsToDoImage.clipsToBounds = true
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openThingToDo))
        thingsToDoImage.isUserInteractionEnabled = true
        thingsToDoImage.addGestureRecognizer(imageTap)
    }

    @objc func openThingToDo(_ sender: Any){

        performSegue(withIdentifier: "thingstodo", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    
        
        if(segue.identifier == "thingstodo") {
            let detailView = segue.destination as! ThingsToDoViewController
            detailView.tappedCity = tappedCity
        }
    }
    



}
