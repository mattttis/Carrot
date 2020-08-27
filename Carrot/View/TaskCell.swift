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
    func moveItem(indexSection: Int?, indexRow: Int?)
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
        self.startAnimation()
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
        
        startAnimation()

        if uid == currentUid {
            profilePicture.isHidden = true
        } else {
            profilePicture.isHidden = false
        }
    }
    
    func startAnimation() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        if items![indexRow!].checked {
            self.delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID!)
            self.progressBar.setProgress(0.0, animated: false)
            self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: .normal)
        } else {
            self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: .normal)
            UIView.animate(withDuration: 4.0, animations: {
                // self.delegate?.updateModel(state: false, indexSection: self.indexSection, indexRow: self.indexRow)
                self.progressBar.setProgress(1.0, animated: true)
          }) { (finished: Bool) in
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.3) {
                    self.delegate?.changeButton(state: true, indexSection: self.indexSection!, indexRow: self.indexRow!, itemID: self.itemID)
                }
            }
        }
    }
    
    func startActionII() {
        
        print("Doing logic...")
        
        if items![indexRow!].checked {
            delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
        } else {
            delegate?.changeButton(state: true, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID)
        }
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    
    
}
