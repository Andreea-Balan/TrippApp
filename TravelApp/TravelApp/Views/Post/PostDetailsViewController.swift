//
//  PostDetailsViewController.swift
//  TravelApp
//
//  Created by Demo on 5/2/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit

class PostDetailsViewController: UIViewController {

    /*var postImage: UIImage!
    var postCategory: String!
    var postTitle: String!
    var postCity: String!
    var postPrice: String!*/
    var post: Post!
    
    @IBOutlet weak var authorImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postCategori: UILabel!
    @IBOutlet weak var postAuthor: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()

        ImageService.getImage(withURL: post.photoURL) { image in
            self.postImage.image = image
        }
        self.postTitle.text = post.title
        self.postCategori.text = post.category
        self.postAuthor.text = "Hosted by " + post.author.username
        
        ImageService.getImage(withURL: post.author.photoURL) { image in
            self.authorImage.image = image
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
