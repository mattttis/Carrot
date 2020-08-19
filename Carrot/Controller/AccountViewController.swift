//
//  AccountViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 21/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage

class AccountViewController: UIViewController {
    
    // Firebase variables
    let db = Firestore.firestore()
    var listRef: DocumentReference?
    var userRef: DocumentReference?
    
    // Account variables
    var userFirstName: String?
    var userEmail: String?
    var imageURL: String?
    var currentUserID: String?
    var currentLists: [String] = []
    var currentListID: String?
   
    var listCodeString: String?
    
    // Profile picture
    var image: UIImage? = nil
    let storageRef = Storage.storage().reference().child(K.FStore.users).child(Auth.auth().currentUser!.uid).child(K.User.profilePicture)
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var listCode: UILabel!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var progress1: UIProgressView!
    @IBAction func button1A(_ sender: Any) {
        UIView.animate(withDuration: 5.0) {
            self.progress1.setProgress(1.0, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        progress1.progress = 0.0
        
        // Store UserDefaults variables locally
        userFirstName = UserDefaults.standard.string(forKey: "firstName")
        userEmail = UserDefaults.standard.string(forKey: "email")
        listCodeString = UserDefaults.standard.string(forKey: "code")
        
        // Change labels & text fields
        tabBarController?.title = "Hey \(userFirstName!)!"
        
        
//        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
//        let shareImage = UIImage(systemName: "barcode.viewfinder", withConfiguration: configuration)
//        let shareButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(showCard))
//        shareButton.tintColor = UIColor.label
        tabBarController?.navigationItem.rightBarButtonItems = nil
        
        listCode.text = listCodeString
        firstName.text = userFirstName
        emailAddress.text = userEmail
        
        DispatchQueue.global(qos: .background).async {
            self.storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                if let error = error {
                    print(error)
                } else {
                        let image = UIImage(data: data!)
                    self.profilePicture.image = image
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAvatar()
        self.hideKeyboardWhenTappedAround()
        
        
        
        let user = Auth.auth().currentUser
        if let user = user {
            self.currentUserID = user.uid
            self.userRef = self.db.collection(K.FStore.users).document(self.currentUserID!)
            self.userRef!.getDocument { (snapshot, error) in
                if let data = snapshot?.data() {
                    self.userFirstName = (data[K.User.firstName] as! String)
                    self.navigationController?.title = "Hey \(self.userFirstName!)"
                    self.userEmail = (data[K.User.email] as! String)
                    self.currentLists = (data[K.User.lists] as! [String])
                    self.imageURL = (data[K.User.profilePicture] as! String)
                    self.currentListID = self.currentLists[0]
                    self.listRef = self.db.collection(K.FStore.lists).document(self.currentListID!)
                    
                    self.emailAddress.text = self.userEmail!
                    self.firstName.text = self.userFirstName!
                    
                    self.listRef?.getDocument(completion: { (snapshot, error) in
                        if let data = snapshot?.data() {
                            self.listCodeString = (data[K.List.code] as! String)
                            // self.heyName.text = "Hey \(self.userFirstName!)!"
                            self.listCode.text = self.listCodeString
                        }
                    })
                    
                    // Load profile picture asynchronously
//                    DispatchQueue.main.async() {
//
//
//                        if self.imageURL == nil {
//                            print("ImageURL is nil")
//                        } else if let url = self.imageURL {
//                            print(url)
//                            self.profilePicture.kf.indicatorType = .activity
//                            let url2 = URL(string: url)
//                            self.profilePicture.kf.setImage(with: url2)
//                        }
//                    }
                    
                } else {
                    print("Could not find document")
                }
            }
        }
    }
    
    //MARK: - Profile picture
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
    
    
    @IBAction func logOutPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Sign out?", message: "You can always access your content by signing back in", preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Cancel", style:
            UIAlertAction.Style.default, handler: { _ in
            print("Signing out canceled")
        }))
        
        alert.addAction(UIAlertAction(title: "Sign out", style: UIAlertAction.Style.default, handler: {(_: UIAlertAction!) in
            do {
                try Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "isLoggedIn")
                UserDefaults.standard.synchronize()
            } catch {
                print("Already logged out")
            }
            
            self.navigationController?.popToRootViewController(animated: true)
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
}


//MARK: - Profile picture delegate methods

extension AccountViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            image = imageSelected
            profilePicture.image = imageSelected
        }
        
        if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            image = originalImage
            profilePicture.image = originalImage
        }
        
        saveImage()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func saveImage() {
        guard let imageSelected = self.image else {
            print("Avatar is nil")
            return
        }
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.000005) else {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://carrot-ios.appspot.com")
        let storageProfileRef = storageRef.child(K.FStore.users).child(currentUserID!).child(K.User.profilePicture)
        
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
    
    @objc func showCard() {
        print("Showing card...")
        performSegue(withIdentifier: K.Segues.accountToCard, sender: self)
    }
}

