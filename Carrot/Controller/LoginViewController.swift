//
//  LoginViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 15/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let db = Firestore.firestore().collection(K.FStore.lists)

    @IBOutlet weak var hiThere: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
//        errorMessage.text = ""
//
//        // Typing animation
//        hiThere.text = ""
//        var charIndex = 0
//        let titleText = "Hi there, nice to see you again!"
//
//        for letter in titleText {
//            Timer.scheduledTimer(withTimeInterval: 0.08 * Double(charIndex), repeats: false) { (timer) in
//                self.hiThere.text?.append(letter)
//            }
//            charIndex += 1
//        }
        
        errorMessage.text = ""
        hiThere.text = NSLocalizedString("Hi there, nice to see you again",
        comment: "Login title")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField {
            textField.resignFirstResponder()
            passwordTextfield.becomeFirstResponder()
        } else if textField == passwordTextfield {
            textField.resignFirstResponder()
            login()
        }
     return true
    }

    
    @IBAction func loginAction(_ sender: Any) {
        login()
    }
    
    func login() {
        view.endEditing(true)
            if let email = emailTextField.text, let password = passwordTextfield.text {
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error {
                    self.errorMessage.text = e.localizedDescription
                } else {
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(authResult?.user.uid, forKey: "uid")
                    UserDefaults.standard.set(email, forKey: "email")
                    UserDefaults.standard.synchronize()
                    
                    Analytics.logEvent(AnalyticsEventLogin, parameters: [
                        AnalyticsParameterMethod: self.method
                    ])
                    
                    Firestore.firestore().collection(K.FStore.users).document((authResult?.user.uid)!).getDocument { (doc, error) in
                        if let e = error {
                            print(e)
                        } else {
                            let firstName = doc?.data()?[K.User.firstName]
                            let barcode = doc?.data()?[K.User.barcodeNumber]
                            UserDefaults.standard.set(firstName, forKey: "firstName")
                            UserDefaults.standard.set(barcode, forKey: K.User.barcodeNumber)
                            UserDefaults.standard.synchronize()
                        }
                    }
                    
                    self.db.whereField("members", arrayContains: authResult!.user.uid).getDocuments { (querySnapshot, err) in
                        if let e = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let listCode = document.data()[K.List.code]!
                                let language = document.data()[K.List.language] as? String
                                UserDefaults.standard.set(listCode, forKey: "code")
                                UserDefaults.standard.set(language, forKey: "language")
                                FoodData.language = language
                                print("LANGUAGE IS: \(language)")
                                UserDefaults.standard.synchronize()
                            }
                        }
                    }
                    
                    self.performSegue(withIdentifier: K.Segues.loginToTable, sender: self)
                }
            }
        }
    }
}


