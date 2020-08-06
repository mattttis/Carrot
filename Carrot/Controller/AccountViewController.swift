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
import BarcodeScanner

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
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var heyName: UILabel!
    @IBOutlet weak var listCode: UILabel!
    @IBOutlet weak var tabBar: UITabBarItem!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var firstName: UITextField!
     @IBOutlet weak var scanCardOutlet: UIButton!
    @IBOutlet weak var cardView: UIImageView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        userFirstName = UserDefaults.standard.string(forKey: "firstName")
        userEmail = UserDefaults.standard.string(forKey: "email")
        listCodeString = UserDefaults.standard.string(forKey: "code")
        
        heyName.text = "Hey \(userFirstName!)!"
        listCode.text = listCodeString
        firstName.text = userFirstName
        emailAddress.text = userEmail
        
        
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
                    
                    DispatchQueue.main.async() {
                        if let url = self.imageURL {
                            if let image = URL(string: url) {
                                self.downloadImage(from: image)
                            }
                        }
                    }
                    
                } else {
                    print("Could not find document")
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAvatar()
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.backBarButtonItem?.accessibilityElementsHidden = true
        
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
    
    
    @IBAction func scanCardAction(_ sender: Any) {
        
        let barcodeVC = BarcodeScannerViewController()
        barcodeVC.codeDelegate = self
        barcodeVC.errorDelegate = self
        barcodeVC.dismissalDelegate = self

        present(barcodeVC, animated: true, completion: nil)
        
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
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.005) else {
            return
        }
        
        let storageRef = Storage.storage().reference(forURL: "gs://carrot-ios.appspot.com")
        let storageProfileRef = storageRef.child("profile").child(currentUserID!).child("avatar")
        
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

extension AccountViewController: BarcodeScannerCodeDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
    print("Barcode Data: \(code)")
    print("Symbology Type: \(type)")
    
    let barcode = UIImage(barcode: code)
    cardView.image = barcode
    
    controller.dismiss(animated: true, completion: nil)

    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
      controller.resetWithError()
    }
  }
}

// MARK: - BarcodeScannerErrorDelegate
extension AccountViewController: BarcodeScannerErrorDelegate {
  func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
    print(error)
  }
}

// MARK: - BarcodeScannerDismissalDelegate
extension AccountViewController: BarcodeScannerDismissalDelegate {
  func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
    controller.dismiss(animated: true, completion: nil)
  }
}

extension UIImage {

    convenience init?(barcode: String) {
        let data = barcode.data(using: .ascii)
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else {
            return nil
        }
        
        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return nil
        }
        
        self.init(ciImage: ciImage)
    }

}
