//
//  SceneDelegate.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        // Check if user is logged
        let currentUser = Auth.auth().currentUser
        if currentUser != nil {
            print("User logged in")
            
            // Access the storyboard and fetch an instance of the view controller
            let storyboard = UIStoryboard(name: "Main", bundle: nil);
            let viewController: NavController = storyboard.instantiateViewController(withIdentifier: "NavController") as! NavController;

            // Then push that view controller onto the navigation stack
            let rootViewController = self.window?.rootViewController as! UINavigationController;
            rootViewController.pushViewController(viewController, animated: false);
            
        } else {
            print("User not logged in")
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    
    }

    func sceneWillResignActive(_ scene: UIScene) {
    
    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
    
    func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
               
        switch shortcutItem.type {
            
            // Add item
            case "com.mattt.Carrot.addItem":
                print("Adding item...")
                NotificationCenter.default.post(name: Notification.Name("addNewItem"), object: nil)
                break
            
            // Show AH Bonuskaart
            case "com.mattt.Carrot.showCard":
                print("Showing card...")
                NotificationCenter.default.post(name: Notification.Name("showCard"), object: nil)
                break
            
            // Share list
            case "com.mattt.Carrot.shareList":
                print("Sharing list...")
                NotificationCenter.default.post(name: Notification.Name("shareFunction"), object: nil)
                break
            
            
            default:
                break
            }
    }


}

