//
//  PostCollectionViewCell.swift
//  TravelApp
//
//  Created by Demo on 4/14/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class PostCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var postPhoto: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var city: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setPost(post:Post) {
        category.text = post.category
        title.text = post.title
        price.text = String(post.price) + "per person"
        city.text = post.location
    }

}
