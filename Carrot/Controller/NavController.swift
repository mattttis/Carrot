//
//  TabController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 15/08/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

class NavController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let vc1 = TableViewController()
//        let vc2 = ActionAddViewController()
//        let vc3 = AccountViewController()
//        
//        
//        viewControllers = [vc1, vc2, vc3]
        
        delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // if tabBarItem.tag == 4 {
            let image = UIImage(systemName: "plus.square.fill", withConfiguration: UIImage.SymbolConfiguration(weight: .bold))
            tabBarItem.image = image!
            tabBarController?.tabBarItem.image = image!
        // }
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
        if item.tag == 4 {
            NotificationCenter.default.post(name: Notification.Name("NewFunctionName"), object: nil)
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
