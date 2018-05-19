//
//  UserProfileViewController.swift
//  TravelApp
//
//  Created by Demo on 5/14/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import Firebase
class UserProfileViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    var imagePicker :UIImagePickerController!
    
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var descriptionField: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let userProfile = UserService.currentUserProfile else { return }
        
        
        ImageService.getImage(withURL: userProfile.photoURL) { image in
            self.profileImage.image = image
        }
        
        firstNameField.text = userProfile.firstname
        lastNameField.text = userProfile.lastname
        phoneNumberField.text = userProfile.phoneNumber
        descriptionField.text = userProfile.description
        countryField.text = userProfile.country
       
    
         let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
    
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
    }
    
    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())){
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = Storage.storage().reference().child("user/\(uid)")
        
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
    

    @IBAction func handleUpdateProfile(_ sender: Any) {
       
        guard let lastname = lastNameField.text else { return }
        guard let firstname = firstNameField.text else { return }
        guard let phoneNumber = phoneNumberField.text else { return }
        guard let description = descriptionField.text else { return }
        guard let image = profileImage.image else { return }
        guard let country = countryField.text  else {return}
        
        self.uploadProfileImage(image) { url in
            if url != nil {
                let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                changeRequest?.displayName = firstname
                changeRequest?.photoURL = url
                
                changeRequest?.commitChanges{ error in
                    if error == nil {
                        self.saveProfile(lastname: lastname, firstname: firstname,phoneNumber:phoneNumber,description: description, country: country, profileImageURL: url!){ success in
                            if success {
                                self.dismiss(animated: false, completion: nil)
                                
                                let alert = UIAlertController(title: "Confirmation", message:"Profile Updated", preferredStyle: .alert)
                                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                                    alert.dismiss(animated: true, completion: nil)
                                }))
                                self.present(alert, animated: true, completion: nil)
                            } else {
                                 print("Error user signup: \(error!.localizedDescription)")
                            }
                        }
                    }else {
                        print("Error user signup: \(error!.localizedDescription)")
                        
                    }
                   
                }
               
               /* let alert = UIAlertController(title: "Confirmation", message:"Profile Updated", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: {(action) in
                    alert.dismiss(animated: true, completion: nil)
                
                }))*/
                
                
                
            } else {
                print("Error unable to upload file ")
            }
        }
       
        
    }
    
    func saveProfile(lastname: String,firstname: String, phoneNumber:String,description: String,country:String, profileImageURL : URL, completion: @escaping((_ success:Bool)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        
        let userObject = [
            "lastname" : lastname,
            "firstname": firstname,
            "phoneNumber": phoneNumber,
            "description": description,
            "country": country,
            "photoURL" : profileImageURL.absoluteString
            ] as [String: Any]
        
        databaseRef.setValue(userObject){ error, ref in
            completion(error == nil )
        }
    }
    
    
    @objc func openImagePicker(_ sender: Any){
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   
}

extension UserProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            self.profileImage.image = pickedImage
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

