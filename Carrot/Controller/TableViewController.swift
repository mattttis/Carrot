//
//  UITableViewController.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController, AddTask, ChangeButton {

    var tasks: [Task] = []
    
    var sections = FoodData.foodCategories
    
    var twoDArray = [
        [Task(name: "No items yet")], [Task(name: "Apples"), Task(name: "Bananas"), Task(name: "Fruits")], [Task(name: "Beef"), Task(name: "Chicken")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")], [Task(name: "No items yet")]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Groceries"
//        tasks.append(Task(name: "Apples"))
//        tasks.append(Task(name: "Bananas"))
//        tasks.append(Task(name: "Pears"))
//        tasks.append(Task(name: "Bread"))
    }

    // MARK: - TableView data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }
        
        return twoDArray[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 && indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "inputCell", for: indexPath) as! InputCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
//            let current = tasks[indexPath.row]
            let current = twoDArray[indexPath.section][indexPath.row]
            cell.taskNameLabel.text = current.name
            
            if current.checked {
                cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: UIControl.State.normal)
            } else {
                cell.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: UIControl.State.normal)
            }
            
            cell.delegate = self
            cell.tasks = twoDArray
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
        twoDArray[newTask.number].append(Task(name: name))
        tableView.reloadData()
        
        // tasks.append(Task(name: name))
        // print(twoDArray)
        // print(twoDArray)
    }
    
    //MARK: - Change button protocol
    
    func changeButton(state: Bool, indexSection: Int?, indexRow: Int?) {
        twoDArray[indexSection!][indexRow!].checked = state
        tableView.reloadData()
    }
    
    //MARK: - Section title
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
      let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))

        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-5)
        
        label.text = "   \(sections[section])"
        label.font = UIFont .boldSystemFont(ofSize: 24)

        headerView.addSubview(label)
        
        if section == 0 {
            label.text = ""
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
    
}
