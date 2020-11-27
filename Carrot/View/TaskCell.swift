//
//  TaskCell.swift
//  Carrot
//
//  Created by Matthijs on 29/06/2020.
//  Copyright © 2020 Matthijs Tolmeijer. All rights reserved.
//

import UIKit
import FirebaseAuth

protocol ChangeButton {
    func changeButton(state: Bool, indexSection: Int?, indexRow: Int?, itemID: String?)
    // func moveItem(indexSection: Int?, indexRow: Int?)
}

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    @IBOutlet weak var quantityLabel: UILabel!

    var delegate: ChangeButton?
    
    var indexSection: Int?
    var indexRow: Int?
    
    var items: [Task]?
    var itemID: String?
    var uid: String?
    var imageURL: String?
    var currentUid = Auth.auth().currentUser!.uid
    var tempState: Bool? = false
    var quantity: String?
    
    private var workItem: DispatchWorkItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TaskCell.tapFunction))
        taskNameLabel.addGestureRecognizer(tap)
        taskNameLabel.isUserInteractionEnabled = true
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.clipsToBounds = true
        
    }
    
    func fillData(_ task: Task, profileImage: UIImage?) -> Void {
            
            let sysName: String = task.checked ? "largecircle.fill.circle" : "circle"
            if let img = UIImage(systemName: sysName, withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)) {
                checkBoxOutlet.setBackgroundImage(img, for: .normal)
            }
            
            if task.checked {
                checkBoxOutlet.tintColor = .systemBlue
                taskNameLabel.textColor = .darkGray
            } else {
                checkBoxOutlet.tintColor = .systemGray2
                taskNameLabel.textColor = .label
            }
            
        taskNameLabel.text = task.name
            
            
            // Make sure quantity is not " "
            let q = task.quantity?.trimmingCharacters(in: .whitespacesAndNewlines)
            quantityLabel.text = q?.uppercased()
            quantityLabel.isHidden = q == ""
        }
    
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if tempState == false {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        
        if tempState == false {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    func stopAnimation() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        workItem?.cancel()
        // self.progressBar.setProgress(0.0, animated: false)
        // self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: .normal)
        self.tempState = false
    }
    
    func startAnimation() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if items![indexRow!].checked {
            self.delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID!)
            self.checkBoxOutlet.tintColor = .systemGray2
            self.textLabel?.textColor = .systemGray2
            // self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: .normal)
        } else {
            self.delegate?.changeButton(state: true, indexSection: self.indexSection!, indexRow: self.indexRow!, itemID: self.itemID)
            // self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: .normal)
            self.checkBoxOutlet.tintColor = .systemBlue
            self.textLabel?.textColor = .white
        }
    }
}
