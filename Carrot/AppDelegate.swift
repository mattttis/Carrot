//
//  AppDelegate.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        let db = Firestore.firestore()
        let storage = Storage.storage()
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard =  UIStoryboard(name: "Main", bundle: nil)
        let startMainVC = storyboard.instantiateViewController(withIdentifier: "TableViewController")
        let startIntroVC = storyboard.instantiateViewController(withIdentifier: "WelcomeViewController")
        
        // Check if user is logged
        let currentUser = Auth.auth().currentUser
//        if currentUser != nil {
//            self.window?.rootViewController = startMainVC
//            print("User not logged in")
//        } else {
//            self.window?.rootViewController = startIntroVC
//            print("User logged in")
//        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

