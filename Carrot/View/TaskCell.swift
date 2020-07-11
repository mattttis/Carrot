//
//  TaskCell.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

protocol ChangeButton {
    func changeButton(state: Bool, indexSection: Int?, indexRow: Int?)
}

class TaskCell: UITableViewCell {
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if items![indexRow!].checked {
            delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!)
        } else {
            delegate?.changeButton(state: true, indexSection: indexSection!, indexRow: indexRow!)
        }
    }
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    var delegate: ChangeButton?
    var indexSection: Int?
    var indexRow: Int?
    var tasks: [[Task]]?
    var items: [Task]?
}
