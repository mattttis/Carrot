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
    
    @IBOutlet weak var tabBar: UITabBarItem!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Navigation bar setup
        tabBarController?.title = "Groceries"
        
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let shareImage = UIImage(systemName: "person.crop.circle.badge.plus", withConfiguration: configuration)
        let shareButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(shareFunction))
        
        let configuration2 = UIImage.SymbolConfiguration(weight: .semibold)
        let cardImage = UIImage(systemName: "barcode.viewfinder", withConfiguration: configuration)
        let cardButton = UIBarButtonItem(image: cardImage, style: .plain, target: self, action: #selector(showCard))
        cardButton.tintColor = UIColor.label
        
        shareButton.tintColor = UIColor.label
        tabBarController?.navigationItem.rightBarButtonItems = [shareButton, cardButton]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Storing user variables locally
        let user = Auth.auth().currentUser
        if let user = user {
            currentUserID = user.uid
            userRef = db.collection(K.FStore.users).document(currentUserID!)
            userRef!.getDocument { (snapshot, error) in
                if let data = snapshot?.data() {
                    self.userFirstName = (data[K.User.firstName] as! String)
                    self.userEmail = (data[K.User.email] as! String)
                    self.currentLists = (data[K.User.lists] as! [String])
                    self.currentListID = self.currentLists![0]
                    self.listsRef = self.db.collection(K.FStore.lists).document(self.currentListID!)
                    
                    // Load the section names
                    self.loadSections(listID: self.currentListID!)
                    
                    // Save variables in UserDefaults
                    UserDefaults.standard.set(self.userFirstName, forKey: "firstName")
                    UserDefaults.standard.synchronize()
                    
                } else {
                    print("Could not find document")
                }
            }
        }
        
        // Adding pull to refresh functionality
        refreshControlMT.attributedTitle = NSAttributedString(string: "Refreshing...")
        refreshControlMT.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControlMT)
    }
    
    

    // MARK: - TableView data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // Let the first section (add item) only have 1 cell
        if section == 0 {
            return 1
        }
        
        // If the section is hidden, hide the rows in the section
        if !sections[section].isExpanded {
            return 0
        }
        
        return sections[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // First section (1 cell) should use the inputCell
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
            cell.currentUid = currentUserID!
            cell.uid = sections[indexPath.section].items[indexPath.row].uid
            
            //MARK: - Profile picture loading
            if cell.uid == cell.currentUid {
                cell.profilePicture.isHidden = true
            } else {
                
                func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
                    URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
                }
                
                func downloadImage(from url: URL) {
                    getData(from: url) { data, response, error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async() { [weak self] in
                            cell.profilePicture.image = UIImage(data: data)
                        }
                    }
                }
                
                DispatchQueue.main.async() {
                    self.db.collection(K.FStore.users).document(cell.uid!).getDocument { (snapshot, error) in
                        if let e = error {
                            print("Error retrieving profile picture: \(e)")
                        } else {
                            if let imageURL = snapshot?.data()![K.User.profilePicture] as? String {
                                if let realURL = URL(string: imageURL) {
                                    downloadImage(from: realURL)
                                }
                            }
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    //MARK: - Swipeable cells
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let item = sections[indexPath.section].items[indexPath.row]
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            // Item's properties variables
            let itemID: String
            let name: String
            let uid: String
            let isChecked: Bool
            let checkedBy: String
            let dateCreated: Date
            let dateChecked: Date
            
            let itemRef = self.db.collection(K.FStore.lists).document(self.currentListID!).collection(K.FStore.sections).document("\(indexPath.section)").collection(K.FStore.items).document(item.itemID!)
            
            itemRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    
                    // Get the properties of the item
                    let name = document.data()?[K.Item.name] as? String
                    let uid = document.data()?[K.Item.uid] as? String
                    let category = document.data()?[K.Item.categoryNumber] as? Int
                    let isChecked = document.data()?[K.Item.isChecked] as? Bool
                    let dateCreated = document.data()?[K.Item.date] as? Date
                    let dateChecked = document.data()?[K.Item.dateChecked] as? Date
                    let checkedBy = document.data()?[K.Item.checkedBy] as? String
                    
                    var ref: DocumentReference? = nil
                    
                    // Save the properties of the item in sectionsDeleted
                    ref = self.db.collection(K.lists).document(self.currentListID!).collection(K.FStore.sectionsDeleted).document("\(category!)").collection(K.FStore.items).addDocument(data: [
                            K.Item.name: name,
                            K.Item.isChecked: isChecked,
                            K.Item.categoryNumber: category,
                            K.Item.date: dateCreated,
                            K.Item.dateChecked: dateChecked,
                            K.Item.checkedBy: checkedBy,
                            K.Item.uid: uid,
                            K.Item.dateDeleted: Date()
                    ]) { err in
                        if let err = err {
                            print("Error adding document: \(err)")
                        } else {

                            // If successfull, delete the item in the normal collection
                            itemRef.delete() { err in
                                if let err = err {
                                    print("Error removing document: \(err)")
                                } else {
                                    print("Document successfully removed!")
                                }
                            }
                        }
                    }
                } else {
                    print("Document does not exist")
                }
            }
            self.tableView.reloadData()
            // self.refreshTable()
            completion(true)
        }
        
        func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {

            let scale = newWidth / image.size.width
            let newHeight = image.size.height * scale
            UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
            image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))

            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return newImage
        }
        
        let image = #imageLiteral(resourceName: "delete")
        
        action.image = resizeImage(image: image, newWidth: 20)
        
        return action
    }
    
    
    //MARK: - Adding task (protocol)
    
    func addTask(name: String, uid: String) {
        let newTask = Task(name: name, uid: uid)
        let thisCategory = newTask.category
        
        // Check what the position of the category name is, return 17 (other) if nothing found
        if thisCategory != "" {
            newTask.number = FoodData.foodCategories.firstIndex(of: thisCategory) ?? 17
        } else {
            print("Category is nil")
        }
        
        // Adding to Firestore
        var ref: DocumentReference? = nil
        ref = db.collection(K.lists).document(currentListID!).collection(K.FStore.sections).document("\(newTask.number)").collection(K.FStore.items).addDocument(data: [
                K.Item.name: newTask.name,
                K.Item.isChecked: newTask.checked,
                K.Item.categoryNumber: newTask.number,
                K.Item.date: Date(),
                K.Item.uid: currentUserID!
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                if let newItemID = ref?.documentID {
                    newTask.itemID = newItemID
                    newTask.uid = self.currentUserID
                    
//                    let generator = UIImpactFeedbackGenerator(style: .medium)
//                    generator.impactOccurred()
                    
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    // Adding the task to array
                    print("Item \(newTask.name) has category of \(newTask.category) with number \(newTask.number) & id \(newTask.itemID!)")
                    let count = self.sections[newTask.number].items.count - 1
                    self.sections[newTask.number].items[count].itemID = ref?.documentID
                    self.sections[newTask.number].items[count].itemID = self.currentUserID ?? "hello"
                    self.sections[newTask.number].items = []
                    self.sections[newTask.number].items.append(newTask)
                    self.sections[newTask.number].isExpanded = true
                }
            }
        }
        
        refreshTable()
    }
    
    
    //MARK: - Change isChecked state & button
    
    func changeButton(state: Bool, indexSection: Int?, indexRow: Int?, itemID: String?) {
        sections[indexSection!].items[indexRow!].checked = state
        
//        let generator = UINotificationFeedbackGenerator()
//        generator.notificationOccurred(.success)
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if let itemID = itemID {
            let itemRef = db.collection(K.FStore.lists).document(currentListID!).collection(K.FStore.sections).document("\(indexSection!)").collection(K.FStore.items).document(itemID)
            
            if sections[indexSection!].items[indexRow!].checked {
                itemRef.updateData([
                    K.Item.isChecked : true,
                    K.Item.checkedBy: currentUserID!,
                    K.Item.dateChecked: Date()
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
//                        let generator = UINotificationFeedbackGenerator()
//                        generator.notificationOccurred(.success)
                    }
                }
            } else {
                itemRef.updateData([
                    K.Item.isChecked : false
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
//                        let generator = UINotificationFeedbackGenerator()
//                        generator.notificationOccurred(.success)
                    }
                }
            }
        } else {
            print("No item ID")
        }
        
        refreshTable()
        
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
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleExpandClose))
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-5)
        label.text = "   \(sections[section].name!)"
        label.font = UIFont .boldSystemFont(ofSize: 24)
        // label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        label.tag = section

        headerView.addSubview(label)
        
        if section == 0 {
            label.text = ""
        } else {
            headerView.addSubview(button)
        }

        return headerView
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // Hide the section title for the 'Add task' section
        if section == 0 {
            return CGFloat.leastNormalMagnitude
        }
        
        // Hide the section title if it is empty
        if sections[section].items.count == 0 {
            return 0
        }
        
        return 40
    }
    
    
    
    //MARK: - Closing/Expanding a section
    
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
    
    
    //MARK: - Load sections
    func loadSections(listID: String) {
        let listRef = db.collection(K.FStore.lists).document(listID)
        
        listRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let sectionNames = document.data()![K.List.sections] as? [String]
                
                self.sections.removeAll()
                if let sectionNames = sectionNames {
                    for (index, item) in sectionNames.enumerated() {
                        let newSection = Section(name: item, isExpanded: true, items: [])
                        self.sections.append(newSection)
                        
                        DispatchQueue.main.async {
                            self.loadItems(listID: listID, section: index)
                        }
                    }
                }
                self.tableView.reloadData()
                
            } else {
                print("Document does not exist")
            }
        }
    }
    
    
    
    //MARK: - Load items
    
    func loadItems(listID: String, section: Int) {
        
        var newItems = [Task]()
        let itemRef = db.collection(K.FStore.lists).document(listID).collection(K.FStore.sections).document("\(section)").collection(K.FStore.items)
        
        itemRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                   print("Error fetching documents: \(error!)")
                   return
               }
            self.items?.removeAll()
            self.sections[section].items.removeAll()
            newItems.removeAll()
            for document in documents {
                let name = document.data()[K.Item.name] as! String
                let isChecked = document.data()[K.Item.isChecked] as! Bool
                let documentID = document.documentID as! String
                let uid = document.data()[K.Item.uid] as! String
                
                let newTask = Task(name: name, isChecked: isChecked, itemID: documentID, uid: uid)
                newItems.append(newTask)
            }
            self.sections[section].items.removeAll()
            self.sections[section].items = newItems
            self.tableView.reloadData()
        }
        
    }

    
    
    //MARK: - Refresh function (obj-c) used in pull to refresh
    
    @objc func refresh(_ sender: AnyObject) {
        // Recollect data from Firestore
        refreshTable()
        
        // Stop refreshing animation
        refreshControlMT.endRefreshing()
    }
    
    
    //MARK: - Refresh function that can be used globally
    
    func refreshTable() {
        // loadSections(listID: currentListID!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    @objc func shareFunction() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        performSegue(withIdentifier: K.Segues.tableToShare, sender: self)
    }
    
    @objc func showCard() {
        print("Showing card...")
        performSegue(withIdentifier: K.Segues.tableToCard, sender: self)
    }
    
}


//MARK: - Hide the keyboard extension
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


