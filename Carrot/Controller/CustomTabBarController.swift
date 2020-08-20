//
//  CustomTabBarController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 19/08/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    var tableViewController: TableViewController!
    var accountViewController: AccountViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableViewController = TableViewController()
        accountViewController = AccountViewController()
        
//        tableViewController.tabBarItem.image = UIImage(named: "home")
//        tableViewController.tabBarItem.selectedImage =
//        UIImage(named: "home-selected")
//        accountViewController.tabBarItem.image = UIImage(named: "second")
//        accountViewController.tabBarItem.selectedImage = UIImage(named: "second-selected")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        print("Selected item")
        
        if item.tag == 5 {
            // performSegue(withIdentifier: K.Segues.addToTable, sender: self)
        }
    }
}
