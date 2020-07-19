//
//  UITableViewController.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

class TableViewController: UITableViewController, AddTask, ChangeButton {
    
    var refreshControlMT = UIRefreshControl()
    var sections: [Section] = []
    
    // Database references
    let db = Firestore.firestore()
    var userRef: DocumentReference?
    var listsRef: DocumentReference?

    // Useful variables
    var currentListID: String?
    var currentLists: [String]?
    var currentUserID: String?
    var userFirstName: String?
    var userEmail: String?
    var items: [Task]?
    
//    var twoDArray = [
//        Section(name: FoodData.foodCategories[0], isExpanded: true, items: [Task(name: "Add new task")]),
//        Section(name: FoodData.foodCategories[1], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[2], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[3], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[4], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[5], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[6], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[7], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[8], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[9], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[10], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[11], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[12], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[13], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[14], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[15], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[16], isExpanded: true, items: []),
//        Section(name: FoodData.foodCategories[17], isExpanded: true, items: [])
//    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesBackButton = true
        
        title = "Groceries"
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            currentUserID = user.uid
            userRef = db.collection(K.FStore.users).document(currentUserID!)
            userRef!.getDocument { (snapshot, error) in
                if let data = snapshot?.data() {
                    self.userFirstName = data["firstname"] as! String
                    self.userEmail = data["email"] as! String
                    self.currentLists = data["lists"] as! [String]
                    self.currentListID = self.currentLists![0]
                    self.listsRef = self.db.collection(K.FStore.lists).document(self.currentListID!)
                    
                    // Load the section names
                    self.loadSections(listID: self.currentListID!)
                    
                } else {
                    print("Could not find document")
                }
            }
        }
        
        refreshControlMT.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControlMT.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControlMT) // not required when using UITableViewController
    }
    

    // MARK: - TableView data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        if !sections[section].isExpanded {
            return 0
        }
        
//        if !twoDArray[section].isExpanded {
//            return 0
//        }
        
        return sections[section].items.count
        // return twoDArray[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
            let current = sections[indexPath.section].items[indexPath.row]
            cell.taskNameLabel.text = current.name
            
            if current.checked {
                cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: UIControl.State.normal)
            } else {
                cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: UIControl.State.normal)
            }
            
            cell.delegate = self
            cell.items = sections[indexPath.section].items
            cell.indexSection = indexPath.section
            cell.indexRow = indexPath.row
            cell.itemID = sections[indexPath.section].items[indexPath.row].itemID
            
            return cell
        }
    }
    //MARK: - Add task protocol
    
    func addTask(name: String) {
        let newTask = Task(name: name)
        let thisCategory = newTask.category
        if thisCategory != "" {
            newTask.number = FoodData.foodCategories.firstIndex(of: thisCategory) ?? 17
        } else {
            print("Category is nil")
        }
        
        // Adding to Firestore
        var ref: DocumentReference? = nil
        ref = db.collection(K.lists).document(currentListID!).collection(K.FStore.sections).document("\(newTask.number)").collection(K.FStore.items).addDocument(data: [
            "name": newTask.name,
            "isChecked": newTask.checked,
            "categoryNumber": newTask.number,
            "date": Date()
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                newTask.itemID = ref!.documentID
            }
        }
        
        // Adding the task to array
        print("Item \(newTask.name) has category of \(newTask.category) with number \(newTask.number) & id")
        sections[newTask.number].items.append(Task(name: name))
        sections[newTask.number].isExpanded = true
        
        let count = sections[newTask.number].items.count - 1
        sections[newTask.number].items[count].itemID = ref!.documentID
        tableView.reloadData()
    
    }
    
    //MARK: - Change isChecked state & button
    
    func changeButton(state: Bool, indexSection: Int?, indexRow: Int?, itemID: String?) {
        // print("The item ID is \(itemID)")
        sections[indexSection!].items[indexRow!].checked = state
        
        if let itemID = itemID {
            let itemRef = db.collection(K.FStore.lists).document(currentListID!).collection(K.FStore.sections).document("\(indexSection!)").collection(K.FStore.items).document(itemID)
            
            if sections[indexSection!].items[indexRow!].checked {
                itemRef.updateData([
                    K.FStore.isChecked : true
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            } else {
                itemRef.updateData([
                    K.FStore.isChecked : false
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                }
            }
        } else {
            print("No item ID")
        }
        
        tableView.reloadData()
    }
    
    //MARK: - Section title
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        // Button configuration
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .small)
        let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
        button.setImage(image, for: .normal)
         button.tintColor = UIColor.label
        button.addTarget(self, action: #selector(handleExpandClose), for: .touchUpInside)
        button.tag = section
        button.frame = CGRect.init(x: 100, y: 5, width: headerView.frame.width+120, height: headerView.frame.height-5)
        
        // Label configuration
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-5)
        // label.text = "   \(sections[section])"
        label.text = "   \(sections[section].name!)"
        label.font = UIFont .boldSystemFont(ofSize: 24)

        headerView.addSubview(label)
        
        if section == 0 {
            label.text = ""
        } else {
            headerView.addSubview(button)
        }

        return headerView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        
        if sections[section].items.count == 0 {
            return 0
        }
        
        return 40
    }
    
    //MARK: - Closing a section
    
    @objc func handleExpandClose(button: UIButton) {
    
        // Deleting the rows
        var indexPaths = [IndexPath]()
        let section = button.tag
        
        for row in sections[section].items.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = sections[section].isExpanded
        sections[section].isExpanded = !isExpanded
        
        if isExpanded {
            tableView.deleteRows(at: indexPaths, with: .fade)
            let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .small)
            let image = UIImage(systemName: "chevron.up", withConfiguration: configuration)
            button.setImage(image, for: .normal)
        } else {
            tableView.insertRows(at: indexPaths, with: .fade)
            let configuration = UIImage.SymbolConfiguration(pointSize: 16, weight: .semibold, scale: .small)
            let image = UIImage(systemName: "chevron.down", withConfiguration: configuration)
            button.setImage(image, for: .normal)
        }
    }
    
    //MARK: - Load items
    func loadItems(listID: String, section: Int) {
        let itemRef = db.collection(K.FStore.lists).document(listID).collection(K.FStore.sections).document("\(section)").collection(K.FStore.items)
        var itemArray = [Task]()
        
        itemRef.getDocuments() { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let name = document.data()["name"] as? String
                    let isChecked : Bool = (document.data()["isChecked"] != nil)
                    let newItem = Task(name: name ?? "FIREBASE ERROR", isChecked: isChecked)
                    itemArray.append(newItem)
                    print(newItem.checked)
                }
            }
            print(itemArray)
            self.sections[section].items = itemArray
            self.tableView.reloadData()
        }
        
        
        
    }
    
    //MARK: - Load sections
    func loadSections(listID: String) {
        
        let listRef = db.collection(K.FStore.lists).document(listID)
        
        listRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let sectionNames = document.data()!["sections"] as? [String]
                
                if let sectionNames = sectionNames {
                    for (index, item) in sectionNames.enumerated() {
                        let newSection = Section(name: item, isExpanded: true, items: [])
                        self.sections.append(newSection)
                        self.loadItems(listID: listID, section: index)
                    }
                }
                
                self.tableView.reloadData()
                
            } else {
                print("Document does not exist")
            }
        }
    
    }
    
    @objc func refresh(_ sender: AnyObject) {
       // Code to refresh table view
        // loadSections(listID: currentListID ?? "hellor")
        tableView.reloadData()
        refreshControlMT.endRefreshing()
    }
    
}

