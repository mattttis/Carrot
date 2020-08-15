//
//  ShareViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 14/08/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

class ShareViewController: UIViewController {
    
    let code = UserDefaults.standard.string(forKey: "code")
    let gesture = UITapGestureRecognizer(target: self, action: "shareAction:")
    
    @IBOutlet weak var listCode: UILabel!
    @IBOutlet weak var shareButtonView: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        if let code2 = code {
            listCode.text = code2
        }
        
        shareButtonView.isUserInteractionEnabled = true
        shareButtonView.addGestureRecognizer(gesture)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func shareButton(_ sender: Any) {
        shareAction()
    }
    
    @objc func shareAction() {
        let listCode = code
        let myWebsite = NSURL(string:"https://google.com/")
        let text = "Hey, I'm using Carrot so we can have a shared grocery list! Download the app and create an account - it only takes one minute. To join my list, enter the code \(listCode). You can download the app here: \(String(describing: NSURL(string:"https://stackoverflow.com/users/4600136/mr-javed-multani?tab=profile")))"
        
        // set up activity view controller
        let textToShare = [text]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [UIActivity.ActivityType.postToFacebook]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}