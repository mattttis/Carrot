//
//  AddListViewController.swift
//  Carrot
//
//  Created by Matthijs Tolmeijer on 26/07/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase
import PinCodeTextField

class AddListViewController: UIViewController, UNUserNotificationCenterDelegate, PinCodeTextFieldDelegate {
    
    let db = Firestore.firestore()
    let user = Auth.auth().currentUser

    @IBOutlet weak var existingListOutlet: PinCodeTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        existingListOutlet.delegate = self
    }
    
    func myTextFieldTextChanged (textField: UITextField) {
        textField.text =  textField.text?.uppercased()
    }
    
    func textFieldShouldReturn(_ textField: PinCodeTextField) -> Bool {
        self.existingList()
        return true
    }
    
//    func textFieldDidEndEditing(_ textField: PinCodeTextField) {
//        print(textField.text)
//        self.existingList()
//    }
    
    func textFieldShouldEndEditing(_ textField: PinCodeTextField) -> Bool {
        self.existingList()
        return true
    }
    
    func existingList() {
        print("Existing list action III")
        
        let listRef = db.collection(K.FStore.lists)
        let userRef = db.collection(K.FStore.users).document(user!.uid)
        
        if let enteredCode = existingListOutlet.text?.uppercased() {
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
        
        var currentListID: String?
        
        // Create 5 letter random string to save as code
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let code1 = ((0..<5).map{ _ in letters.randomElement()! })
        let code = String(code1)
        print(code)
        
        
//        print("Create list")
//
        let userRef = db.collection(K.FStore.users).document(Auth.auth().currentUser!.uid)
//
//        // Create a new list and save it to FireStore
//        var currentListID: String?
//
//        // Create 5 letter random string to save as code
//        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
//        let code = ((0..<5).map{ _ in letters.randomElement()! })
//
        let listRef = db.collection(K.FStore.lists)
        let someData = [
            // K.List.dateCreated: Date(),
            K.List.dateCreated: Timestamp(date: Date()),
            K.List.name: "Groceries",
            K.List.sections: FoodData.foodCategories,
            K.List.createdBy: Auth.auth().currentUser!.uid,
            K.List.members: [Auth.auth().currentUser!.uid],
            K.List.membersEmail: [Auth.auth().currentUser?.email],
            K.List.code: code,
            K.List.language: Locale.current.languageCode!
        ] as [String : Any]

        UserDefaults.standard.set(String(code), forKey: "code")
        UserDefaults.standard.set(String(Locale.current.languageCode!), forKey: "language")
        UserDefaults.standard.synchronize()

        let aDoc = listRef.document()
        currentListID = aDoc.documentID
        aDoc.setData(someData)

        //  Append previously created list ID to user's "lists" array
        userRef.updateData([
            // K.User.lists: FieldValue.arrayUnion([currentListID])
            K.User.lists: [currentListID]
        ])

        // Set up sections
        for (index, section) in FoodData.foodCategories.enumerated() {
            print("Got till line 103")
            db.collection(K.FStore.lists).document(currentListID!).collection(K.FStore.sections).document("\(index)").setData([
                K.Section.name: "\(section)",
                K.Section.index: "\(index)",
                K.Section.dateCreated: Timestamp(date: Date())
            ])
            print("Until heree")
        }

        // Redirect user to groceries
        self.performSegue(withIdentifier: K.Segues.addListToTable, sender: self)
    }
}
