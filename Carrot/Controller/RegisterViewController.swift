//
//  RegisterViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 17/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var firstNameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        errorMessage.text = ""
    }
    
    @IBAction func registerPressed(_ sender: Any) {
        view.endEditing(true)
        
        if let email = emailTextfield.text, let password = passwordTextfield.text, let firstName = firstNameTextfield.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if error != nil {
                    self.errorMessage.text = error!.localizedDescription
                    return
                }
                
                if let authData = authResult {
                    // Save profile picture
                    var dict: Dictionary<String, Any> = [
                        "firstname" : firstName,
                        "email" : authData.user.email,
                        "dateCreated" : Date(),
                        "lists": []
                    ]
                    let db = Firestore.firestore()
                    let userRef = db.collection(K.FStore.users).document(authData.user.uid)
                    
                    userRef.setData(dict) { (error) in
                        if error != nil {
                            self.errorMessage.text = error?.localizedDescription
                        } else {
                            
                            // Create a new list and save it to FB
                            var currentListID: String?
                            
                            let listRef = db.collection(K.FStore.lists)
                            let someData = [
                                "date": Date(),
                                "name": "Groceries",
                                "sections": FoodData.foodCategories
                                ] as [String : Any]
                            
                            let aDoc = listRef.document()
                            currentListID = aDoc.documentID
                            aDoc.setData(someData)
                            
                            // Add previously created list to user
                            userRef.updateData([
                                "lists" : FieldValue.arrayUnion([currentListID])
                            ])
                            
                            // Redirect user to groceries
                            self.performSegue(withIdentifier: K.registerSegue, sender: self)
                            UserDefaults.standard.set(true, forKey: "isLoggedIn")
                            UserDefaults.standard.synchronize()
                            
                            // Set up sections
                            for (index, section) in FoodData.foodCategories.enumerated() {
                                db.collection(K.FStore.lists).document(currentListID!).collection(K.FStore.sections).document("\(index)").setData([
                                    "name": "\(section)"
                                ])
                            }
                        }
                    }
                }
            }
        }
        
        
        
        
    }
    
    
}
