//
//  AddListViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 26/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

class AddListViewController: UIViewController {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser

    @IBOutlet weak var existingListOutlet: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func existingListPrimaryAction(_ sender: Any) {
        existingList()
    }
    
    @IBAction func existingListAction(_ sender: Any) {
        existingList()
    }
    
    func existingList() {
        print("Existing list action III")
        
        let listRef = db.collection(K.FStore.lists)
        let userRef = db.collection(K.FStore.users).document(user!.uid)
        
        if let enteredCode = existingListOutlet.text {
            listRef.whereField(K.List.code, isEqualTo: enteredCode).getDocuments { (querySnapshot, error) in
                if let e = error {
                    print("Error getting documents: \(e)")
                } else {
                    for document in querySnapshot!.documents {
                        listRef.document(document.documentID).updateData(([
                            K.List.members: FieldValue.arrayUnion([self.user!.uid])
                            ]))
                        
                        UserDefaults.standard.set(enteredCode, forKey: "code")
                        UserDefaults.standard.synchronize()
                        
                        userRef.updateData([
                            K.User.lists: FieldValue.arrayUnion([document.documentID])
                        ])

                        
                        // Redirect user to groceries
                        self.performSegue(withIdentifier: K.Segues.addListToTable, sender: self)
                    }
                }
            }
            
        }
        
    }
    
    @IBAction func createPressed(_ sender: Any) {
        print("Create list")
        
        let userRef = db.collection(K.FStore.users).document(Auth.auth().currentUser!.uid)
        
        // Create a new list and save it to FireStore
        var currentListID: String?
        
        // Create 5 letter random string to save as code
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let code = ((0..<5).map{ _ in letters.randomElement()! })
        
        let listRef = db.collection(K.FStore.lists)
        let someData = [
            K.List.dateCreated: Date(),
            K.List.name: "Groceries",
            K.List.sections: FoodData.foodCategories,
            K.List.createdBy: Auth.auth().currentUser!.uid,
            K.List.members: [Auth.auth().currentUser!.uid],
            K.List.membersEmail: [Auth.auth().currentUser?.email],
            K.List.code: code
        ] as [String : Any]
        
        UserDefaults.standard.set(String(code), forKey: "code")
        UserDefaults.standard.synchronize()
        
        let aDoc = listRef.document()
        currentListID = aDoc.documentID
        aDoc.setData(someData)
        
        // Append previously created list ID to user's "lists" array
        userRef.updateData([
            K.User.lists: FieldValue.arrayUnion([currentListID])
        ])
        
        // Set up sections
        for (index, section) in FoodData.foodCategories.enumerated() {
            db.collection(K.FStore.lists).document(currentListID!).collection(K.FStore.sections).document("\(index)").setData([
                K.Section.name: "\(section)",
                K.Section.index: "\(index)",
                K.Section.dateCreated: Date()
            ])
        }
        
        // Redirect user to groceries
        self.performSegue(withIdentifier: K.Segues.addListToTable, sender: self)
    }
}
