//
//  FirstViewController.swift
//  TravelApp
//
//  Created by Demo on 4/14/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import  Firebase


class FirstViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
   
    
 

    var postImage: UIImage?
    var postCategory: String = ""
    var postTitle: String = ""
    var postCity: String = ""
    var postPrice: String = ""
    
    var isSearching = false
    @IBOutlet weak var searchedResultsTable: UITableView!
    @IBOutlet weak var searchLocation: CustomSearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    var posts = [Post]()
    var tappedPost: Post?
    var tappedCity: City?
    var cities = [City]()
    var filterCities = [City]()
    
    
    @IBAction func handleLogout(_target:UIBarButtonItem){
        try! Auth.auth().signOut()
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let cellNib = UINib(nibName: "PostCollectionViewCell", bundle: nil)
        
        collectionView.register(cellNib, forCellWithReuseIdentifier: "collectioncell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.reloadData()
        
        
        searchLocation.delegate = self
        searchedResultsTable.delegate = self
        searchedResultsTable.dataSource = self
        searchedResultsTable.reloadData()
        
        observePosts()
        
        searchLocation = CustomSearchBar(frame: searchedResultsTable.frame, textColor: UIColor.orange)
        //searchLocation.showsCancelButton = true
        var layout = self.collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5)
        
        layout.minimumInteritemSpacing = 5
        
        // should be -20 for screen rotated
        layout.itemSize = CGSize(width: (self.collectionView.frame.size.width - 5)/2, height: self.collectionView.frame.size.width/2)
        
        searchedResultsTable.layer.zPosition = 1
        searchedResultsTable.isHidden = true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
       // searchedResultsTable.reloadData()
    }

    func observePosts(){
       let postsRef = Database.database().reference().child("posts")
        
        postsRef.observe(.value, with: {snapshot in
            
            var temporaryPosts = [Post]()
            
            for child in snapshot.children {
                if let childSnapshot = child as? DataSnapshot,
                    let dict = childSnapshot.value as? [String:Any],
                    let category = dict["category"] as? String,
                    let city = dict["city"] as? String,
                    let postPhotoURL = dict["photoURL"] as? String,
                    let postURL = URL(string: postPhotoURL),
                    let price =  dict["price"] as? String,
                    let title = dict["title"] as? String,
                    let location = dict["location"] as? [String:Any],
                    let description = dict["description"] as? String,
                    let timestamp = dict["timestamp"] as? Double,
                    let author = dict["author"] as? [String:Any],
                    let uid = author["userId"] as? String,
                    let lastname = author["lastname"] as? String,
                    let firstname = author["firstname"] as? String,
                    let phoneNumber = author["phoneNumber"] as? String,
                    let authorDescription = author["description"] as? String,
                    let country = author["country"] as? String,
                    let authorPhotoURL = author["photoURL"] as? String,
                    let authorURL = URL(string: authorPhotoURL) {
                        
                    let authorProfile = User(uid: uid, lastname: lastname, firstname: firstname, photoURL: authorURL, phoneNumber: phoneNumber,description: authorDescription,  country: country)
                    
                    let post =  Post(id: childSnapshot.key, author: authorProfile, category: category, title: title, price: Int(price)!, location: city,  description: description, locationAddress: location ,timestamp: timestamp, photoURL: postURL)
                    temporaryPosts.append(post)
                    
                }
                
            }
            
            self.posts = temporaryPosts
            self.collectionView.reloadData()
        })
        
        let citiesRef = Database.database().reference().child("cities")
        
        citiesRef.observe(.value, with: {snapshot in
            var temporatyCity = [City]()
            var temporaryObjectives = [Objectiv]()
            var urls = [URL]()
            var color = UIColor()
            for child in snapshot.children {
                if let childSnap = child as? DataSnapshot,
                let dict = childSnap.value as? [String:Any],
                
                let cityname = dict["name"] as? String,
                let photoURL = dict["photoURL"] as? [String: String],
                let objectives =  dict["objectives"] as? [String:[String:Any]]
                {
                    for each in objectives.values {
                    
                    let objectiveName = each["name"] as? String
                    let objectiveImageURL = each["photoURL"] as? String
                        let objectiveImage = URL(string: objectiveImageURL!)
                    let objectiveDescription = each["description"] as? String
                    let objectiveColor = each["color"] as? String
                    
                        if objectiveColor == "grey"{
                            color = UIColor(red: 63/255.0, green: 71/255.0, blue: 80/255.0, alpha: 0.7)
                        }else if objectiveColor == "pink"{
                            color = UIColor(red:1.00, green:0.70, blue:1.00, alpha:0.5)
                        }else if objectiveColor == "green"{
                           color = UIColor(red: 105/255.0, green: 80/255.0, blue: 227/255.0, alpha: 0.5)
                        }
                        
                        let partialObjective = Objectiv(title: objectiveName!, featuredImage: objectiveImage!, color: color, description: objectiveDescription!)
                    temporaryObjectives.append(partialObjective)
                   
                        
                    }
                    
                    for each in photoURL.values{
                        let url = URL(string: each)
                        urls.append(url!)
                    }
                    let cities = City(id: childSnap.key, name: cityname, objectives: temporaryObjectives, photoURL: urls)
                    temporatyCity.append(cities)
                }
            }
            self.cities = temporatyCity
            self.searchedResultsTable.reloadData()
        })
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as! PostCollectionViewCell
        
        
        
        cell.setPost(post: posts[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! PostCollectionViewCell
        
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.layer.borderWidth = 2
        
        tappedPost = posts[indexPath.row]
        
        
        self.performSegue(withIdentifier: "goToDetails", sender: self)
    }
    

    
    //search for city
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filterCities.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = searchedResultsTable.dequeueReusableCell(withIdentifier: "citycell") as! cityNameTableViewCell
        
        cell.cityName.text = filterCities[indexPath.row].name
        
        return cell
        
        
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("here")
        tappedCity = filterCities[indexPath.row]
        self.performSegue(withIdentifier: "citydetails", sender: self)
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
        
        
    }
   
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchText == ""){
            searchedResultsTable.isHidden = true
            isSearching = false
            //filterCities = []
            view.endEditing(true) // ??
        }else {
            isSearching =  true
            filterCities = cities.filter({city -> Bool in
                city.name.contains(searchText)
            })
        }
        searchedResultsTable.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
         searchedResultsTable.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "goToDetails") {
         //   let cell = sender as! PostCollectionViewCell
         
            let detailView = segue.destination as! PostDetailsViewController
            detailView.post = tappedPost
        }
        
        if(segue.identifier == "goToProfile") {
            let detailView = segue.destination as! PostAuthorDetailsViewController
            detailView.isUserLoged = 1
        }
        
        if(segue.identifier == "citydetails") {
            let detailView = segue.destination as! CityDetailViewController
           detailView.tappedCity = tappedCity
        }
    }
  
    
}
//colection view cell looks like card view
extension UIView {
    
    func setCardView(view : UIView){
        
        view.layer.cornerRadius = 5.0
        view.layer.borderColor  =  UIColor.clear.cgColor
        view.layer.borderWidth = 5.0
        view.layer.shadowOpacity = 0.5
        view.layer.shadowColor =  UIColor.lightGray.cgColor
        view.layer.shadowRadius = 5.0
        view.layer.shadowOffset = CGSize(width:5, height: 5)
        view.layer.masksToBounds = true
        
    }
}

