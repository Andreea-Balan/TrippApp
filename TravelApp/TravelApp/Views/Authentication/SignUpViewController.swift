//
//  SignUpViewController.swift
//  TravelApp
//
//  Created by HS on 3/25/18.
//  Copyright © 2018 HS. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class SignUpViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var changeProfileButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    var continueButton:RoundedWhiteButton!
    var activityView:UIActivityIndicatorView!
    
    var imagePicker :UIImagePickerController!
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addVerticalGradientLayer(topColor: primaryColor, bottomColor: secondaryColor)
        
        continueButton = RoundedWhiteButton(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        continueButton.setTitleColor(secondaryColor, for: .normal)
        continueButton.setTitle("Continue", for: .normal)
        continueButton.titleLabel?.font = UIFont.systemFont(ofSize: 18.0, weight: UIFont.Weight.bold)
        continueButton.center = CGPoint(x: view.center.x, y: view.frame.height - continueButton.frame.height - 24)
        continueButton.highlightedColor = UIColor(white: 1.0, alpha: 1.0)
        continueButton.defaultColor = UIColor.white
        continueButton.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        view.addSubview(continueButton)
        
        activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityView.color = secondaryColor
        activityView.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0)
        activityView.center = continueButton.center
        
        view.addSubview(activityView)
        lastNameField.delegate = self
        firstNameField.delegate = self
        //usernameField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        
        
        firstNameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        lastNameField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        emailField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        passwordField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(imageTap)
        profileImage.layer.cornerRadius = profileImage.bounds.height / 2
        profileImage.clipsToBounds = true
        changeProfileButton.addTarget(self, action: #selector(openImagePicker), for:.touchUpInside)
        
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
    }

    @objc func openImagePicker(_ sender: Any){
        self.present(imagePicker, animated: true, completion: nil)
        
    }
    @IBAction func handleDismissButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func textFieldChanged(_ target:UITextField) {
        //let username = usernameField.text
       
        let lastname = lastNameField.text
        let firstname = firstNameField.text
        let email = emailField.text
        let password = passwordField.text
        let formFilled = lastname != nil && lastname != "" && firstname != nil && firstname != "" && email != nil && email != "" && password != nil && password != ""
        setContinueButton(enabled: formFilled)
    }
    
    func setContinueButton(enabled:Bool) {
        if enabled {
            continueButton.alpha = 1.0
            continueButton.isEnabled = true
        } else {
            continueButton.alpha = 0.5
            continueButton.isEnabled = false
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        // Resigns the target textField and assigns the next textField in the form.
        
        switch textField {
        case lastNameField:
            lastNameField.resignFirstResponder()
            emailField.becomeFirstResponder()
            break
        case firstNameField:
            firstNameField.resignFirstResponder()
            emailField.becomeFirstResponder()
        case emailField:
            emailField.resignFirstResponder()
            passwordField.becomeFirstResponder()
            break
        case passwordField:
            handleSignUp()
            break
        default:
            break
        }
        return true
    }
    
    @objc func handleSignUp() {
        guard let lastname = lastNameField.text else { return }
        guard let firstname = firstNameField.text else { return }
        guard let email = emailField.text else { return }
        guard let pass = passwordField.text else { return }
        guard let image = profileImage.image else { return }
        
        setContinueButton(enabled: false)
        continueButton.setTitle("", for: .normal)
        activityView.startAnimating()
        
        
        Auth.auth().createUser(withEmail: email, password: pass) { user, error in
            if error == nil && user != nil {
                print("User created!")
                
                // Upload profile image to firebase storage
                self.uploadProfileImage(image) { url in
                    if url != nil {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = firstname
                        changeRequest?.photoURL = url
                    
                        changeRequest?.commitChanges{ error in
                            if error == nil {
                                self.saveProfile(lastname: lastname, firstname: firstname, profileImageURL: url!){ success in
                                    if success {
                                        self.dismiss(animated: false, completion: nil)
                                    } else {
                                        self.resetForm()
                                    }
                                }
                            }else {
                                print("Error user signup: \(error!.localizedDescription)")
                                self.resetForm()
                            }
                        }
                    
                    } else {
                        print("Error unable to upload file \(error!.localizedDescription)")
                        self.resetForm()
                    }
                }
                    // Dismiss the view
            } else {
                print("Error:  \(error!.localizedDescription)")
                self.resetForm()
            }
        }
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
    
    func saveProfile(lastname: String,firstname: String, profileImageURL : URL, completion: @escaping((_ success:Bool)->())) {
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        print("Check1")
        let userObject = [
            "lastname" : lastname,
            "firstname": firstname,
            "photoURL" : profileImageURL.absoluteString,
            "description": "",
            "phoneNumber": "",
            "country": "",
            "followers": "0"
        ] as [String: Any]
        print("Check2")
        databaseRef.setValue(userObject){ error, ref in
            completion(error == nil )
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        lastNameField.becomeFirstResponder()
       //NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillAppear), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
        lastNameField.resignFirstResponder()
        firstNameField.resignFirstResponder()
      emailField.resignFirstResponder()
     passwordField.resignFirstResponder()
        
     NotificationCenter.default.removeObserver(self)
   }
    
    func resetForm(){
        let alert = UIAlertController(title: "Error singing up ", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert,animated:true, completion: nil)
        
        self.setContinueButton(enabled: true)
        self.continueButton.setTitle("Continue", for: .normal)
        self.activityView.stopAnimating()
    }


}

extension SignUpViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
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
