//
//  UITableViewController.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher

class TableViewController: UITableViewController, AddTask, ChangeButton, UITableViewDragDelegate, UITableViewDropDelegate {
    
    var refreshControlMT = UIRefreshControl()
    var sections: [Section] = []
    var items: [Task]?
    
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
    var userToken: String?
    var receiverTokens: [String]?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        emptyTableView()
        
        // Navigation bar setup
        tabBarController?.title = NSLocalizedString("Groceries",
        comment: "TableVC Title")
        tabBarController?.navigationController?.hidesBarsOnTap = true
        tabBarController?.navigationController?.hidesBarsOnSwipe = true

        // Share list BarButton
        let configuration = UIImage.SymbolConfiguration(weight: .semibold)
        let shareImage = UIImage(systemName: "person.crop.circle.badge.plus", withConfiguration: configuration)
        let shareButton = UIBarButtonItem(image: shareImage, style: .plain, target: self, action: #selector(shareFunction))
        shareButton.tintColor = UIColor.label

        // Present Bonuskaart BarButton
        let cardImage = UIImage(systemName: "barcode.viewfinder", withConfiguration: configuration)
        let cardButton = UIBarButtonItem(image: cardImage, style: .plain, target: self, action: #selector(showCard))
        cardButton.tintColor = UIColor.label

        tabBarController?.navigationItem.rightBarButtonItems = [shareButton, cardButton]
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Homescreen shortcuts
        NotificationCenter.default.addObserver(self, selector: #selector(addNewItem), name: Notification.Name("addNewItem"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(showCard), name: Notification.Name("showCard"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(shareFunction), name: Notification.Name("shareFunction"), object: nil)
        
        // Extension of UIViewController
        self.hideKeyboardWhenTappedAround()
        
        // Methods for drag and drop
        tableView.dragInteractionEnabled = true
        tableView.dragDelegate = self
        tableView.dropDelegate = self
        
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
                    self.userToken = (data[K.User.token] as? String)
                    
                    if self.currentLists != [] {
                        if self.currentLists?[0] != nil {
                            
                            self.currentListID = self.currentLists![0]
                            
                            self.listsRef = self.db.collection(K.FStore.lists).document(self.currentListID!)
                            
                            DispatchQueue.global(qos: .background).async {
                                self.listsRef?.getDocument(completion: { (document, error) in
                                    if let e = error {
                                        print("Error accessing listRef: \(e)")
                                    } else {
                                        let token = Messaging.messaging().fcmToken
                                        self.receiverTokens = document?.data()?[K.List.tokens] as? [String]
                                        if let cardCode = document?.data()?[K.User.barcodeNumber] as? String {
                                            UserDefaults.standard.set(cardCode, forKey: K.User.barcodeNumber)
                                        }
                                        
                                        if let tokenss = self.receiverTokens {
                                            if tokenss.contains(token!) {
                                                print("Token already in list")
                                            } else {
                                                self.listsRef?.updateData([
                                                    K.List.tokens: FieldValue.arrayUnion([token!])
                                                ])
                                            }
                                        } else {
                                            self.listsRef?.updateData([
                                                K.List.tokens: FieldValue.arrayUnion([token!])
                                            ])
                                        }
                                    }
                                })
                            }
                            
                            // Load the section names
                            self.loadSections(listID: self.currentListID!)
                    
                        } else {
                            self.performSegue(withIdentifier: K.Segues.tableToAddList, sender: self)
                        }
                    } else {
                        self.performSegue(withIdentifier: K.Segues.tableToAddList, sender: self)
                    }
                    
                } else {
                    print("Could not find document")
                }
            }
        }
        
        // Adding pull to refresh functionality
        refreshControlMT.attributedTitle = NSAttributedString(string: NSLocalizedString("Refreshing...",
        comment: "Pull to refresh"))
        refreshControlMT.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControlMT)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == K.Segues.tableToAddList) {
            if let nextViewController = segue.destination as? AddListViewController {
                nextViewController.tabBarController?.navigationItem.hidesBackButton = true
            }
        }
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? TaskCell
        cell?.startAnimation()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // First section, the input field, should use the inputCell
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputCell
            cell.delegate = self
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
            let currentItem = sections[indexPath.section].items[indexPath.row]
            
            cell.taskNameLabel.text = currentItem.name
            cell.uid = currentItem.uid
            cell.delegate = self
            cell.indexSection = indexPath.section
            cell.indexRow = indexPath.row
            cell.itemID = currentItem.itemID
            cell.items = sections[indexPath.section].items
            cell.quantity = ""
            cell.quantity = currentItem.quantity
            cell.fillData(currentItem, profileImage: nil)
            
            
            //MARK: - Profile picture loading
            
            if cell.uid == cell.currentUid {
                cell.profilePicture.isHidden = true
            } else {
                DispatchQueue.global(qos: .background).async() {
                    self.db.collection(K.FStore.users).document(cell.uid!).getDocument { (snapshot, error) in
                        if let e = error {
                            print("Error retrieving profile picture: \(e)")
                        } else {
                            if let imageURL = snapshot?.data()![K.User.profilePicture] as? String {
                                if let realURL = URL(string: imageURL) {
                                    cell.profilePicture.kf.setImage(with: realURL)
                                }
                            }
                        }
                    }
                }
            }
            
            return cell
        }
    }
    
    
    //MARK: - Drag and drop, move tableViewCells
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        for section in sections.enumerated() {
            sections[section.offset].isExpanded = true
        }
        
        return [UIDragItem(itemProvider: NSItemProvider())]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        
    }
    
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {

        if session.localDragSession != nil { // Drag originated from the same app.
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    
    override func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if proposedDestinationIndexPath.section == 0 {
            return sourceIndexPath
        } else {
            
            var indexPath = proposedDestinationIndexPath
            
            if sourceIndexPath.section != proposedDestinationIndexPath.section {
                indexPath.row = sections[indexPath.section].items.count
            } else {
                indexPath.row = sourceIndexPath.row
            }
            
            return indexPath
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
            let movedObject = self.sections[sourceIndexPath.section].items[sourceIndexPath.row]
            movedObject.number = destinationIndexPath.section
            
            sections[sourceIndexPath.section].items.remove(at: sourceIndexPath.row)
            sections[destinationIndexPath.section].items.insert(movedObject, at: sections[destinationIndexPath.section].items.count)
            
            let itemRef = listsRef?.collection(K.FStore.sections).document(String(sourceIndexPath.section)).collection(K.FStore.items).document(movedObject.itemID!)
            
            itemRef!.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    // Get the properties of the item
                    let name = document.data()?[K.Item.name] as? String
                    let quantity = document.data()?[K.Item.quantity] as? String
                    let uid = document.data()?[K.Item.uid] as? String
                    let category = destinationIndexPath.section
                    let isChecked = document.data()?[K.Item.isChecked] as? Bool
                    let dateCreated = document.data()?[K.Item.date] as? Timestamp
                    let date2 = Date(timeIntervalSince1970: TimeInterval(dateCreated!.seconds))
                    let dateChecked = document.data()?[K.Item.dateChecked] as? Timestamp
                    var date3: Date?
                    
                    if let dateChecked = dateChecked {
                        date3 = Date(timeIntervalSince1970: TimeInterval(dateChecked.seconds))
                    }
                    
                    let checkedBy = document.data()?[K.Item.checkedBy] as? String
                    var ref: DocumentReference? = nil
                    
                    // Save the properties of the item in sectionsDeleted
                    ref = self.db.collection(K.lists).document(self.currentListID!).collection(K.FStore.sections).document("\(destinationIndexPath.section)").collection(K.FStore.items).addDocument(data: [
                            K.Item.name: name!,
                            K.Item.quantity: quantity,
                            K.Item.isChecked: isChecked!,
                            K.Item.categoryNumber: category,
                            K.Item.date: date2,
                            K.Item.dateChecked: date3 ?? nil,
                            K.Item.checkedBy: checkedBy,
                            K.Item.uid: uid
                    ]) { err in
                        itemRef!.delete()
                    }
                } else {
                    print("Document does not exist")
                }
        }
    }
    
    
    //MARK: - Adding task (protocol)
    
    func addTask(name: String, uid: String, quantity: String?) {
        print("Adding task...")
        let newTask = Task(name: name, uid: uid)
        
        let thisCategory = newTask.category
        
        self.tableView.backgroundView = nil
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        
        // Check what the position of the category name is, return 17 ('Other') if nothing found
        if thisCategory != "" {
            newTask.number = FoodData.foodCategories.firstIndex(of: thisCategory) ?? FoodData.foodCategories.count - 1
        }
        
        if quantity != nil {
            newTask.quantity = quantity
        }
       
        var sendToTokens2: [String]?
        
        // Remove the device's messaging token from the list's pushTokens so the user that adds the item doesn't receive a notification
        // Push notifications are handled by Firebase Functions in the root document /triggers (JavaScript & node.js)
        if let userTokens = self.userToken {
            if var sendToTokens = self.receiverTokens {
                if let index = sendToTokens.firstIndex(of: userTokens) {
                    sendToTokens.remove(at: index)
                    sendToTokens2 = sendToTokens
                }
            }
        }
        
        // Adding to Firestore
        var ref: DocumentReference? = nil
            ref = db.collection(K.lists).document(currentListID!).collection(K.FStore.sections).document("\(newTask.number)").collection(K.FStore.items).addDocument(data: [
                K.Item.name: newTask.name,
                K.Item.quantity: newTask.quantity ?? "",
                K.Item.isChecked: newTask.checked,
                K.Item.categoryNumber: newTask.number,
                K.Item.date: Date(),
                K.Item.firstName: self.userFirstName ?? NSLocalizedString("Someone", comment: "Used in new item notification"),
                K.Item.uid: currentUserID,
                "language": UserDefaults.standard.string(forKey: K.List.language) ?? "en",
                K.Item.tokens: sendToTokens2
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                if let newItemID = ref?.documentID {
                    newTask.itemID = newItemID
                    newTask.uid = self.currentUserID
                    
                    self.sections[newTask.number].items.append(newTask)
                    self.sections[newTask.number].isExpanded = true
                                        
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    print("Item \(newTask.name) has category of \(newTask.category) with number \(newTask.number) & id \(newTask.itemID!) & quantity \(newTask.quantity ?? "")")
                    
                    self.tableView.reloadData()
    
                }
            }
        }
            
        refreshTable()
    }
    
    
    //MARK: - Change isChecked state & button
    
    func changeButton(state: Bool, indexSection: Int?, indexRow: Int?, itemID: String?) {
        if indexSection != nil && indexRow != nil {
            sections[indexSection ?? 1].items[indexRow ?? 1].checked = state
        }
        
        // tableView.reloadData()
        
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
        if let itemID = itemID {
            let itemRef = db.collection(K.FStore.lists).document(currentListID!).collection(K.FStore.sections).document("\(indexSection!)").collection(K.FStore.items).document(itemID)
            
            if sections[indexSection!].items[indexRow!].checked {
                itemRef.updateData([
                    K.Item.isChecked: true,
                    K.Item.checkedBy: currentUserID!,
                    K.Item.dateChecked: Date()
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                    }
                    
                    if let indexSection = indexSection, let indexRow = indexRow {
                        
                        // Move cell to last in row
                        let lastRow = self.sections[indexSection].items.count - 1
                        self.tableView.moveRow(at: IndexPath(row: indexRow, section: indexSection), to: IndexPath(row: lastRow, section: indexSection))
                        
                        if self.sections[indexSection].items != nil {
                            let item = self.sections[indexSection].items[indexRow]
                            
                            let itemRef = self.db.collection(K.FStore.lists).document(self.currentListID!).collection(K.FStore.sections).document("\(indexSection)").collection(K.FStore.items).document(item.itemID!)
                            
                            itemRef.getDocument { (document, error) in
                                if let document = document, document.exists {
                                    
                                    
                                    // Get the properties of the item
                                    let name = document.data()?[K.Item.name] as? String
                                    let quantity = document.data()?[K.Item.quantity] as? String
                                    let uid = document.data()?[K.Item.uid] as? String
                                    let category = document.data()?[K.Item.categoryNumber] as? Int
                                    let isChecked = document.data()?[K.Item.isChecked] as? Bool
                                    let dateCreated = document.data()?[K.Item.date] as? Date
                                    let dateChecked = document.data()?[K.Item.dateChecked] as? Date
                                    let checkedBy = document.data()?[K.Item.checkedBy] as? String
                                    
                                    self.db.collection(K.lists).document(self.currentListID!).collection(K.FStore.sectionsChecked).document("\(category!)").collection(K.FStore.items).addDocument(data: [
                                        K.Item.name: name!,
                                        K.Item.quantity: quantity ?? "",
                                        K.Item.isChecked: isChecked!,
                                        K.Item.categoryNumber: category!,
                                        K.Item.date: dateCreated,
                                        K.Item.dateChecked: dateChecked,
                                        K.Item.checkedBy: checkedBy,
                                        K.Item.uid: uid!,
                                        K.Item.dateDeleted: Date()
                                    ]) { err in
                                        if let err = err {
                                            print("Error adding document: \(err)")
                                        } else {
//                                            let cell = self.tableView.cellForRow(at: IndexPath(item: indexRow, section: indexSection)) as? TaskCell
//
//                                            if let cell = cell {
//                                                // self.tableView.reloadData()
//                                                cell.progressBar.setProgress(0.0, animated: false)
//                                            }
                                            
              
//                                            let lastRow = self.sections[indexSection].items.count - 1
//                                            self.tableView.moveRow(at: IndexPath(row: indexRow, section: indexSection), to: IndexPath(row: lastRow, section: indexSection))
                                            
                                            // self.sections[indexSection].items.count - 1
                                            // If successful, delete the item in the normal collection
//                                            itemRef.delete() { err in
//                                                if let err = err {
//                                                    print("Error removing document: \(err)")
//                                                } else {
//                                                    print("Document successfully removed!")
//                                                }
//                                            }
                                        }
                                    }
                                }
                            }
                        }
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
                        // self.refreshTable()
                    }
                }
            }
        }
    }
    
    //MARK: - Swipe to delete
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let delete = deleteAction(at: indexPath)
        return UISwipeActionsConfiguration(actions: [delete])
    }
    
    func deleteAction(at indexPath: IndexPath) -> UIContextualAction {
        let item = sections[indexPath.section].items[indexPath.row]
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
            
            self.sections[indexPath.section].items.remove(at: indexPath.row)
            self.emptyTableView()
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            let itemRef = self.db.collection(K.FStore.lists).document(self.currentListID!).collection(K.FStore.sections).document("\(indexPath.section)").collection(K.FStore.items).document(item.itemID!)
            
            itemRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    
                    let cell = self.tableView.cellForRow(at: indexPath) as? TaskCell
                    cell?.quantityLabel.isHidden = false
                    
                    // Get the properties of the item
                    let name = document.data()?[K.Item.name] as? String
                    let uid = document.data()?[K.Item.uid] as? String
                    let category = document.data()?[K.Item.categoryNumber] as? Int
                    let isChecked = document.data()?[K.Item.isChecked] as? Bool
                    let dateCreated = document.data()?[K.Item.date] as? Date
                    let dateChecked = document.data()?[K.Item.dateChecked] as? Date
                    let checkedBy = document.data()?[K.Item.checkedBy] as? String
                    
                    self.db.collection(K.lists).document(self.currentListID!).collection(K.FStore.sectionsDeleted).document("\(category!)").collection(K.FStore.items).addDocument(data: [
                        K.Item.name: name!,
                        K.Item.isChecked: isChecked!,
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
            completion(true)
        }
        
        // Set image of swipe action
        let image = UIImage(systemName: "trash.fill")
        image!.withTintColor(UIColor.white)
        action.image = image!
        
        return action
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
            // Hide the header title for the 'Add Task' section
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
    
    
    //MARK: - Show label when there are no items
    
    func emptyTableView() {
        var index = 0
        
        for section in sections {
            index = index + section.items.count
        }
        
        if index == 0 {
            let emptyLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
            emptyLabel.text = NSLocalizedString("You haven't added any items to your list yet.", comment: "Shown on empty tableView")
            emptyLabel.textColor = UIColor.gray
            emptyLabel.numberOfLines = 0
            emptyLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = emptyLabel
            self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        }
    }
    
    
    //MARK: - Load sections
    func loadSections(listID: String) {
        
        let sectionNames = FoodData.foodCategories
        self.sections.removeAll()
            for (index, item) in sectionNames.enumerated() {
                let newSection = Section(name: item, isExpanded: true, items: [])
                self.sections.append(newSection)
                
                DispatchQueue.main.async {
                    self.loadItems(listID: listID, section: index)
                }
        }
        self.tableView.reloadData()
    }
    
    
    
    //MARK: - Load items (called by loadSections)
    
    func loadItems(listID: String, section: Int) {
        
        var newItems = [Task]()
        let itemRef = db.collection(K.FStore.lists).document(listID).collection(K.FStore.sections).document("\(section)").collection(K.FStore.items).order(by: K.Item.isChecked).order(by: K.Item.date)
        
        itemRef.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                   print("Error fetching documents: \(error!)")
                   return
               }
            // self.items?.removeAll()
            // self.sections[section].items.removeAll()
            newItems.removeAll()
            for document in documents {
                let name = document.data()[K.Item.name] as! String
                let quantity = document.data()[K.Item.quantity] as? String
                let isChecked = document.data()[K.Item.isChecked] as! Bool
                let documentID = document.documentID
                let uid = document.data()[K.Item.uid] as! String
                
                let newTask = Task(name: name, isChecked: isChecked, itemID: documentID, uid: uid, quantity: quantity)
                newItems.append(newTask)
                self.tableView.backgroundView = nil
                self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
            }
            self.sections[section].items.removeAll()
            self.sections[section].items = newItems
            
            self.emptyTableView()
            
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
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    //MARK: - @objc functions for top bar
    
    // Present shareVC modally, called by right bar button
    @objc func shareFunction() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        performSegue(withIdentifier: K.Segues.tableToShare, sender: self)
    }
    
    // Present the bonuskaart modally, called by right bar button
    @objc func showCard() {
        print("SHOWING CARD...")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        performSegue(withIdentifier: K.Segues.tableToCard, sender: self)
    }
    
    @objc func addNewItem() {
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        // self.tableView.setContentOffset(.zero, animated: true)
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? InputCell
        cell?.newTaskField.becomeFirstResponder()
    }
}


//MARK: - Keyboard extension hide/dismiss when tapped
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


