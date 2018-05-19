//
//  cityCollectionViewCell.swift
//  TravelApp
//
//  Created by Demo on 5/16/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class cityCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featuredImageView: UIImageView!
    @IBOutlet weak var objectivNameLabel: UILabel!
    @IBOutlet weak var backgroundColorView: UIView!
    
    var objectives: Objectiv? {
        didSet {
           self.updateUI()
        }
    }
    private func updateUI(){
        if let objectiv = objectives {
            ImageService.getImage(withURL: (objectiv.featuredImageURL)) { image in
                self.featuredImageView.image = image
            }
            //featuredImageView.image = UIImage(named: "iasipic1")
            objectivNameLabel.text = objectiv.title
            backgroundColorView.backgroundColor = objectiv.color
        } else {
            featuredImageView.image = nil
            objectivNameLabel.text = nil
            backgroundColorView.backgroundColor = nil
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.cornerRadius = 3.0
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.8
        layer.shadowOffset = CGSize(width: 5, height: 20)
        self.clipsToBounds = false
    }
}
