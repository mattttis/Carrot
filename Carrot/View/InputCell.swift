//
//  InputCell.swift
//  Carrot
//
//  Created by Matthijs on 30/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

protocol AddTask {
    func addTask(name: String, uid: String)
}

class InputCell: UITableViewCell {

    @IBAction func saveNewTaskAction(_ sender: Any) {
        if newTaskField.text != "" {
            delegate?.addTask(name: newTaskField.text!, uid: Auth.auth().currentUser!.uid)
            newTaskField.text = ""
            newTaskField.resignFirstResponder()
        }
    }
    
    @IBOutlet weak var saveNewTaskOutlet: UIButton!
    @IBOutlet weak var newTaskField: UITextField!
    
    var delegate: AddTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newTaskField.addTarget(self, action: #selector(saveNewTaskAction), for: .editingDidEndOnExit)
    }
}
