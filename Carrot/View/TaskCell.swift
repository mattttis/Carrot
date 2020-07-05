//
//  TaskCell.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit

protocol ChangeButton {
    func changeButton(state: Bool, index: Int?)
}

class TaskCell: UITableViewCell {
    
    @IBAction func checkBoxAction(_ sender: Any) {
       if tasks![indexP!].checked {
            delegate?.changeButton(state: false, index: indexP!)
        } else {
            delegate?.changeButton(state: true, index: indexP!)
        }
    }
    
    
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    
    var delegate: ChangeButton?
    var indexP: Int?
    var tasks: [Task]?
}
