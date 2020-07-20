//
//  TaskCell.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import Firebase

protocol ChangeButton {
    func changeButton(state: Bool, indexSection: Int?, indexRow: Int?, itemID: String?)
}

class TaskCell: UITableViewCell {
    
    var delegate: ChangeButton?
    var indexSection: Int?
    var indexRow: Int?
    var items: [Task]?
    var itemID: String?
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if items![indexRow!].checked {
            // print("Line 22 \(itemID)")
            delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
        } else {
            delegate?.changeButton(state: true, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
            // print("Line 25 \(itemID)")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TaskCell.tapFunction))
        taskNameLabel.addGestureRecognizer(tap)
        taskNameLabel.isUserInteractionEnabled = true
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        if items![indexRow!].checked {
            delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
        } else {
            delegate?.changeButton(state: true, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
        }
    }
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    
    // var tasks: [[Task]]?
    
    
}
