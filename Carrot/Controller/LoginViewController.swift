//
//  LoginViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 15/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var hiThere: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorMessage.text = ""
        
        hiThere.text = ""
        var charIndex = 0
        let titleText = "Hi there, nice to see you again!"
        
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.08 * Double(charIndex), repeats: false) { (timer) in
                self.hiThere.text?.append(letter)
            }
            charIndex += 1
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        view.endEditing(true)
        if let email = emailTextField.text, let password = passwordTextfield.text {
        Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
            if let e = error {
                self.errorMessage.text = e.localizedDescription
            } else {
                self.performSegue(withIdentifier: K.Segues.loginToTable, sender: self)
                UserDefaults.standard.set(true, forKey: "isLoggedIn")
                UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                UserDefaults.standard.synchronize()
            }
        }
    }
}
}
