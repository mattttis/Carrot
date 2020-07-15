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
    
    var sections = FoodData.foodCategories
    let db = Firestore.firestore()
    var currentListID: String?
    
    var twoDArray = [
        Section(isExpanded: true, items: [Task(name: "No items yet")]), Section(isExpanded: true, items: [Task(name: "No items yet")]), Section(isExpanded: true, items: [Task(name: "No items yet")]), Section(isExpanded: true, items: [Task(name: "No items yet")]), Section(isExpanded: true, items: [Task(name: "No items yet")]), Section(isExpanded: true, items: [Task(name: "No items yet")]), Section(isExpanded: true, items: [Task(name: "No items yet")]), Section(isExpanded: true, items: [Task(name: "No items yet")]), Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")]),
            Section(isExpanded: true, items: [Task(name: "No items yet")])
        ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Groceries"
        
        //MARK: - Database setup
        
        let listRef = self.db.collection(K.lists)
        let someData = [
            "date": Date(),
            "name": "List 1",
            "sections": FoodData.foodCategories
            ] as [String : Any]
        
        let aDoc = listRef.document()
        currentListID = aDoc.documentID
        aDoc.setData(someData)
    }

    // MARK: - TableView data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        if !twoDArray[section].isExpanded {
            return 0
        }
        
        return twoDArray[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
//            let current = tasks[indexPath.row]
            let current = twoDArray[indexPath.section].items[indexPath.row]
            cell.taskNameLabel.text = current.name
            
            if current.checked {
                cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: UIControl.State.normal)
            } else {
                cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: UIControl.State.normal)
            }
            
            cell.delegate = self
//            cell.tasks = twoDArray
            cell.items = twoDArray[indexPath.section].items
            cell.indexSection = indexPath.section
            cell.indexRow = indexPath.row
            
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
        
        print("Item \(newTask.name) has category of \(newTask.category) with number \(newTask.number)")
        twoDArray[newTask.number].items.append(Task(name: name))
        twoDArray[newTask.number].isExpanded = true
        tableView.reloadData()
        
        //MARK: - Database setup
        var ref: DocumentReference? = nil
        ref = db.collection(K.lists).document(currentListID!).collection("items").addDocument(data: [
            "name": newTask.name,
            "isChecked": newTask.checked,
            "categoryNumber": newTask.number,
            "date": Date()
        ])
    }
    
    //MARK: - Change button protocol
    
    func changeButton(state: Bool, indexSection: Int?, indexRow: Int?) {
        twoDArray[indexSection!].items[indexRow!].checked = state
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
        label.text = "   \(sections[section])"
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
        
//        return tableView.sectionHeaderHeight
        return 40
    }
    
    //MARK: - Closing a section
    
    @objc func handleExpandClose(button: UIButton) {
    
        // Deleting the rows
        var indexPaths = [IndexPath]()
        let section = button.tag
        
        for row in twoDArray[section].items.indices {
            let indexPath = IndexPath(row: row, section: section)
            indexPaths.append(indexPath)
        }
        
        let isExpanded = twoDArray[section].isExpanded
        twoDArray[section].isExpanded = !isExpanded
        
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
    
}
