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
    func addTask(name: String, uid: String, quantity: String?)
}

class InputCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var saveNewTaskOutlet: UIImageView!
    @IBOutlet weak var newTaskField: UITextField!
    @IBOutlet weak var quantityField: UITextField!
    @IBOutlet weak var newTaskView: UIView!
    
    
    var delegate: AddTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newTaskField.addTarget(self, action: #selector(nextField), for: .editingDidEndOnExit)
        quantityField.addTarget(self, action: #selector(saveNewTaskAction), for: .editingDidEndOnExit)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(firstField))
        newTaskView.isUserInteractionEnabled = true
        newTaskView.addGestureRecognizer(tap)
        
//        let tap = UIGestureRecognizer(target: self, action: #selector(saveNewTaskAction))
//        saveNewTaskOutlet.isUserInteractionEnabled = true
//        saveNewTaskOutlet.addGestureRecognizer(tap)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(InputCell.saveNewTaskAction))
        saveNewTaskOutlet.addGestureRecognizer(tapGesture)
        
        quantityField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("QUANTITY", comment: "Quantity text field placeholder"),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        newTaskField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("Item name", comment: "New item name field placeholder"),
        attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
        newTaskField.delegate = self
        quantityField.delegate = self
    }
    
//    @objc func firstResponder() {
//        quantityField.becomeFirstResponder()
//    }
    
    @objc func saveNewTaskAction() {
        if newTaskField.text != "" {
            delegate?.addTask(name: newTaskField.text!, uid: Auth.auth().currentUser!.uid, quantity: quantityField.text)
            newTaskField.text = ""
            quantityField.text = ""
            newTaskField.resignFirstResponder()
            quantityField.resignFirstResponder()
        }
    }
    
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == quantityField {
            if string == "" {
                // User presses backspace
                textField.deleteBackward()
            } else {
                // User presses a key or pastes
                textField.insertText(string.uppercased())
            }
            // Do not let specified text range to be changed
            return false
        }

        return true
    }
    
    @objc func firstField() {
        newTaskField.becomeFirstResponder()
    }
    
    @objc func nextField() {
        quantityField.becomeFirstResponder()
    }
}
