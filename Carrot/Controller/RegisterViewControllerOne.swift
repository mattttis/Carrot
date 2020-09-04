//
//  RegisterViewControllerOne.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 04/09/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

class RegisterViewControllerOne: UIViewController {
    
    @IBOutlet weak var hiThere: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        errorMessage.text = ""
        self.hideKeyboardWhenTappedAround()
        
        nextButton.setTitle(NSLocalizedString("Next", comment: "Button title on first registration step"), for: .normal)
        hiThere.text = NSLocalizedString("Hi there, welcome to Carrot!", comment: "Hi there text displayed on first registration step")
        firstName.placeholder = NSLocalizedString("First name", comment: "Placeholder on first registration step")
        lastName.placeholder = NSLocalizedString("Last name", comment: "Placeholder on first registration step")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func nextButton(_ sender: Any) {
        if firstName.text != "" && lastName.text != "" {
            performSegue(withIdentifier: K.Segues.registerOneToTwo, sender: self)
        } else {
            errorMessage.text = NSLocalizedString("Please fill in both fields.", comment: "Shown on register screen step one")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == K.Segues.registerOneToTwo) {
            let secondViewController = segue.destination as! RegisterViewController
            secondViewController.firstName = firstName.text
            secondViewController.lastName = lastName.text
        }
    }
    

}
