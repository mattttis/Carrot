//
//  InputCell.swift
//  Carrot
//
//  Created by Matthijs on 30/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

protocol AddTask {
    func addTask(name: String)
}

class InputCell: UITableViewCell {

    @IBAction func saveNewTaskAction(_ sender: Any) {
        if newTaskField.text != "" {
            delegate?.addTask(name: newTaskField.text!)
            // print("New item added: \(newTaskField.text!)")
            newTaskField.text = ""
        }
    }
    @IBOutlet weak var saveNewTaskOutlet: UIButton!
    @IBOutlet weak var newTaskField: UITextField!
    
    var delegate: AddTask?
}
