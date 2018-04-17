//
//  InitialViewController.swift
//  TravelApp
//
//  Created by HS on 3/18/18.
//  Copyright © 2018 HS. All rights reserved.
//

import Foundation
import UIKit

class InitialViewController: UIViewController {
    
    @IBOutlet weak var planeImage: UIImageView!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animate(withDuration: 10, animations: {
            self.planeImage.frame = CGRect(x: 300, y: 244, width: 241, height: 150)
        }) {(finished) in
           // self.performSegue(withIdentifier: "toMenuScreen", sender: self)
        }
    
        //- Todo: Check if user is authenticated. If so, segue to the HomeViewController, otherwise, segue to the MenuViewController
        
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}
