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
    var uid: String?
    var imageURL: String?
    var currentUid = Auth.auth().currentUser!.uid
    
    @IBAction func checkBoxAction(_ sender: Any) {
        // startActionII()
        startActionII()
        startAnimation()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TaskCell.tapFunction))
        taskNameLabel.addGestureRecognizer(tap)
        taskNameLabel.isUserInteractionEnabled = true
        
        // profilePicture.layer.cornerRadius = 20
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

//        if uid == currentUid {
//            profilePicture.isHidden = true
//        } else {
//            profilePicture.isHidden = false
//        }
    }

    
    @objc func tapFunction(sender:UITapGestureRecognizer) {

        if uid == currentUid {
            profilePicture.isHidden = true
        } else {
            profilePicture.isHidden = false
        }
        
        if items![indexRow!].checked {
            delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
            self.progressBar.setProgress(0, animated: true)
            
        } else {
            delegate?.changeButton(state: true, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
//            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.taskNameLabel.text!)
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            self.taskNameLabel.attributedText = attributeString
        }
    }
    
    @IBAction func startAction(_ sender: Any) {
        // startActionII()
        UIView.animate(withDuration: 10.0) {
            self.progressBar.setProgress(1.0, animated: true)
            
            DispatchQueue.global(qos: .background).async {
                self.startActionII()
            }
        }
        
        
    }
    
    func startAnimation() {
        UIView.animate(withDuration: 6.0) {
            self.progressBar.setProgress(1.0, animated: true)
        }
    }
    
    func startActionII() {
        
        print("Doing logic...")
        
        if items![indexRow!].checked {
            delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
        } else {
            delegate?.changeButton(state: true, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
        }
        
        
            // self.progressBar.setProgress(1.0, animated: true)
//            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: self.taskNameLabel.text!)
//            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
//            self.taskNameLabel.attributedText = attributeString
        
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
}
