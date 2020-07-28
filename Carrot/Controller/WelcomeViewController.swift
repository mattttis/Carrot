//
//  WelcomeViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 17/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        
        // Redirect to tableView if user is logged in
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            performSegue(withIdentifier: K.welcomeSegue, sender: self)
        }
        
        print("UD ID: \(UserDefaults.standard.string(forKey: "uid"))")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == K.Segues.welcomeToTable {
        let objVC = segue.destination as? TableViewController
        objVC?.navigationItem.hidesBackButton = true
      }
    }

}
