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
                        K.User.firstName: firstName,
                        K.User.email: authData.user.email,
                        K.User.dateCreated: Date(),
                        K.User.lists: []
                    ]
                    
                    let userRef = Firestore.firestore().collection(K.FStore.users).document(authData.user.uid)
                    
                    userRef.setData(dict)
                }
                
                // Redirect user to groceries
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
                self.performSegue(withIdentifier: K.Segues.registerToAddList, sender: self)
                
            }
        }
    }
}
