//
//  RegisterViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 17/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var signUp: UIButton!
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var password: String?
    var image: UIImage? = nil
    
    var userRef: DocumentReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.setupAvatar()
        errorMessage.text = ""
        passwordTextfield.placeholder = NSLocalizedString("Password", comment: "Placeholder on second sign up step")
        signUp.setTitle(NSLocalizedString("Sign up", comment: "Button title on second sign up step"), for: .normal)
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        view.endEditing(true)
        
        email = emailTextfield.text
        password = passwordTextfield.text
        
        if let email = email, let password = password, let firstName = firstName, let lastName = lastName {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.errorMessage.text = error!.localizedDescription
                    return
                }
                
                if let authData = authResult {
                    // Save profile picture
                    let dict: Dictionary<String, Any> = [
                        K.User.firstName: firstName,
                        K.User.lastName: lastName,
                        K.User.email: authData.user.email!,
                        K.User.dateCreated: Date(),
                        K.User.profilePicture: "",
                        K.User.lists: []
                    ]

                    UserDefaults.standard.set(dict[K.User.firstName], forKey: "firstName")
                    UserDefaults.standard.set(dict[K.User.email], forKey: "email")
                    UserDefaults.standard.synchronize()
                    
                    self.userRef = Firestore.firestore().collection(K.FStore.users).document(authData.user.uid)
                    
                    Analytics.logEvent(AnalyticsEventSignUp, parameters: [
                        AnalyticsParameterMethod: self.method
                    ])
                    
                    self.userRef!.setData(dict)
                    
                    if self.image != nil {
                        self.saveImage(id: authData.user.uid)
                    }
                }
                
                // Redirect user to groceries
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                self.performSegue(withIdentifier: K.Segues.registerToAddList, sender: self)
            }
        }
    }
    
    func setupAvatar() {
        
        profilePicture.isUserInteractionEnabled = true
        profilePicture.clipsToBounds = true
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(presentPicker))
        profilePicture.addGestureRecognizer(tapGesture)
    }
    
    @objc func presentPicker() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            profilePicture.image = imageSelected
        }
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = originalImage
            profilePicture.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage(id: String) {
        guard let imageSelected = self.image else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.000005) else {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://carrot-ios.appspot.com")
        let storageProfileRef = storageRef.child(K.FStore.users).child(id).child(K.User.profilePicture)
        
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        storageProfileRef.putData(imageData, metadata: metaData) { (storageMetaData, error) in
            if let e = error {
                print("Error uploading profile picture: \(e.localizedDescription)")
                return
            }
            
            storageProfileRef.downloadURL { (url, error) in
                if let metaImageURL = url?.absoluteString {
                    self.userRef?.updateData([
                        K.User.profilePicture: metaImageURL
                    ])
                }
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            DispatchQueue.main.async() { [weak self] in
                self?.profilePicture.image = UIImage(data: data)
            }
        }
    }
}
