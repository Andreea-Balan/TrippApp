//
//  HomeViewController.swift
//  TravelApp
//
//  Created by HS on 3/29/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
   
    @IBOutlet weak var postTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

  
        let cellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        postTable.register(cellNib, forCellReuseIdentifier: "postCell")
        postTable.separatorStyle = UITableViewCellSeparatorStyle.none
        postTable.delegate = self
        postTable.dataSource = self
        postTable.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
      
       
        return cell
    }
}
