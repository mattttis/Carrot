//
//  TabController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 15/08/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

class NavController: UITabBarController, UITabBarControllerDelegate {
    
    var isAccount: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        
        
        if tabBarItem.tag == 4 {
            self.tabBar.unselectedItemTintColor = UIColor.orange
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tabBarItem.tag == 4 {
            print("HELLO")
        }
        
        
    }
    
    
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 5 {
            isAccount = true
        }
        
        if item.tag == 4 {
            NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
            print(isAccount)
            if self.isAccount == true {
                print("isAccount = true")
                self.selectedIndex = 0
            }
        }
        
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers?[1] {
            return false
        } else {
            return true
        }
    }
}

