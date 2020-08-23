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
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
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
            case "is.mattt.Carrot.addItem":
                print("Adding item...")
                break
            case "is.mattt.Carrot.showCard":
                print("Showing card...")
                break
            case "is.mattt.Carrot.shareList":
                print("Sharing list...")
                break
            default:
                break
            }
    }


}

