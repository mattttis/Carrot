//
//  ActionViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 19/08/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

class ActionViewController: UIViewController {

    @IBAction func segueStart(_ sender: Any) {
        performSegue(withIdentifier: K.Segues.addToTable, sender: self)
    }
    
    override func viewDidLoad() {
        let tableVC = TableViewController()
        tableVC.startEditing()
        
        performSegue(withIdentifier: K.Segues.addToTable, sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        performSegue(withIdentifier: K.Segues.addToTable, sender: self)
    }
}
