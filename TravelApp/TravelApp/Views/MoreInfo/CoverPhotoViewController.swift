//
//  CoverPhotoViewController.swift
//  TravelApp
//
//  Created by Demo on 5/30/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class CoverPhotoViewController: UIViewController{
    var tappedCity: City?
    
    @IBOutlet weak var coverImage: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

     //print(tappedCity?.photoURL[0])
        ImageService.getImage(withURL: (tappedCity?.photoURL[0])!) { image in
            self.coverImage.image = image
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
