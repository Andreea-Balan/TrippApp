//
//  NewPostViewController.swift
//  TravelApp
//
//  Created by Demo on 4/14/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import Firebase
import GoogleMaps
import GooglePlaces
import GooglePlacesSearchController


class NewPostViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate, UISearchBarDelegate, LocateOnTheMap, GMSAutocompleteFetcherDelegate{
    
    func locateWithLongitude(_ lon: Double, andLatitude lat: Double, andTitle title: String) {
        DispatchQueue.main.async { () ->Void in
            
            self.positon = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            self.adress.text = title
        }
    }
  
    
    func didAutocomplete(with predictions: [GMSAutocompletePrediction]) {
        
        for prediction in predictions {
            
            if let prediction = prediction as GMSAutocompletePrediction?{
                self.resultsArray.append(prediction.attributedFullText.string)
            }
        }
        self.searchResultController.reloadDataWithArray(self.resultsArray)
        //self.searchResultsTable.reloadDataWithArray(self.resultsArray)
        print(resultsArray)
    }
    
    func didFailAutocompleteWithError(_ error: Error) {
        
    }
    

    
   var gmsFetcher: GMSAutocompleteFetcher!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var googleMapsContainer: UIView!
    var googleMapsView: GMSMapView!
    var searchResultController: SearchResultsController!
    var resultsArray = [String]()
    
    //trasmitedData
    
    
    
    //fields to save
    @IBOutlet weak var imageAdded: UIImageView!
    @IBOutlet weak var city: UITextField!
    @IBOutlet weak var price: UITextField!
    @IBOutlet weak var postTitle: UITextField!
    @IBOutlet weak var category: UITextField!
    @IBOutlet weak var experienceDescription: UITextView!
    @IBOutlet weak var adress: UITextField!
    var positon:CLLocationCoordinate2D?
    
    
    var imagePicker :UIImagePickerController!

    override func viewDidLoad() {
        super.viewDidLoad()
        experienceDescription.layer.cornerRadius = 5
        experienceDescription.layer.borderColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0).cgColor
        experienceDescription.layer.borderWidth = 1
        
    }
   
    @IBAction func hanndleSearchButton(_ sender: Any) {
       
        let searchController = UISearchController(searchResultsController: searchResultController)
        searchController.searchBar.delegate = self
        
        self.present(searchController, animated:true, completion: nil)
    }
 
    
    @IBAction func handlePostButton(_ sender: Any) {
        
        guard let image = imageAdded.image else { return }
        var postImageURL:URL? = nil
        let postRef = Database.database().reference().child("posts").childByAutoId()
        let citiesRef = Database.database().reference().child("cities").childByAutoId()
        self.uploadPostImage(image) { url in
            if url != nil {
                postImageURL = url
            }
        guard let userProfile = UserService.currentUserProfile else { return }
        // guard let uid = Auth.auth().currentUser?.uid else { return }
        let citiesObject = [
            "name": self.city.text
            ]
        let postObject = [
            "author": [
                "userId": userProfile.uid,
                "username": userProfile.username,
                "photoURL":userProfile.photoURL.absoluteString
            ],
            //"userID": uid,
            "city" : self.city.text,
            "title" : self.postTitle.text,
            "category": self.category.text,
            "price" : self.price.text,
            "description" : self.experienceDescription.text,
            "location": [
                "address":self.adress.text,
                "lat": self.positon?.latitude,
                "lon": self.positon?.longitude
            ],
            "timestamp": [".sv":"timestamp"],
            "photoURL" : postImageURL?.absoluteString
        ] as [String:Any]
        
        postRef.setValue(postObject, withCompletionBlock: {error, ref in
            if error == nil {
                Database.database().reference().child("cities").queryOrdered(byChild: "name").queryEqual(toValue: self.city.text!).observe(.value, with: {(snapshot) in
                    if snapshot.exists() == true {
                        print("city exists in DB")
                    }else {
                        print("city doesn't exist")
                        citiesRef.setValue(citiesObject, withCompletionBlock: {error, ref in
                            if error == nil {
                                print("city in DB")
                            }else {
                                 //handle the error
                            }
                        })
                    }
                })
                self.dismiss(animated: true, completion: nil)
            }  else {
                //handle the error
            }
        })
        
    }
    }
    
    func uploadPostImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())){
        
        
        //create unic id for each picture uploaded
        let imageID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("post/\(imageID)")
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else {return}
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageRef.putData(imageData, metadata: metaData){ metaData, error in
            if error == nil, metaData != nil {
                if let url = metaData?.downloadURL(){
                    completion(url)
                }else {
                    completion(nil)
                }
                //success!
            }else {
                completion(nil)
            }
        }
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      
        self.resultsArray.removeAll()
        gmsFetcher?.sourceTextHasChanged(searchText)

    }
    
    @IBAction func handleCancelButton(_ sender: Any) {
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.contentSize.height = contentView.frame.height
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        imageAdded.isUserInteractionEnabled = true
        imageAdded.addGestureRecognizer(imageTap)
        imageAdded.layer.cornerRadius = imageAdded.bounds.height / 2
        imageAdded.clipsToBounds = true
        addImageButton.addTarget(self, action: #selector(openImagePicker), for:.touchUpInside)
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }
    
    @objc func openImagePicker(_ sender: Any){
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    //Placeholder text
    func textViewDidBeginEditing(_ textView: UITextView) {
        if(textView.text == "Enter a description"){
            textView.text = ""
            textView.textColor = UIColor.darkGray
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if(textView.text == ""){
            textView.textColor = UIColor.lightGray
            textView.text = "Enter a description"
        }
        textView.becomeFirstResponder()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if(textView.text == ""){
            textView.text = "Enter a description"
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
       // self.googleMapsView =  GMSMapView(frame: self.googleMapsContainer.frame)
       // self.view.addSubview(self.googleMapsView)
        
        searchResultController = SearchResultsController()
        searchResultController.delegate = self
        gmsFetcher = GMSAutocompleteFetcher()
        gmsFetcher.delegate = self
    }
  

}
extension NewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.imageAdded.image = pickedImage
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
