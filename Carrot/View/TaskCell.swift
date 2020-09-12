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
    // func moveItem(indexSection: Int?, indexRow: Int?)
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
    var tempState: Bool? = false
    var quantity: String?
    
    private var workItem: DispatchWorkItem?
    
    @IBAction func checkBoxAction(_ sender: Any) {
        if tempState == false {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
    override func prepareForReuse() {
        reset()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(TaskCell.tapFunction))
        taskNameLabel.addGestureRecognizer(tap)
        taskNameLabel.isUserInteractionEnabled = true
        
        profilePicture.layer.cornerRadius = profilePicture.frame.height / 2
        profilePicture.clipsToBounds = true
    }
    
    func reset() {
        print(quantityLabel.text)
        profilePicture.isHidden = false
        quantityLabel.isHidden = true
        
        self.translatesAutoresizingMaskIntoConstraints = true
        NSLayoutConstraint.deactivate([
            taskNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    
    func noQuantity() {
        self.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            taskNameLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
    

    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        
        if tempState == false {
            startAnimation()
        } else {
            stopAnimation()
        }
    }
    
//    func stopAnimation() {
//        let generator = UIImpactFeedbackGenerator(style: .medium)
//        generator.impactOccurred()
//        workItem?.cancel()
//        self.progressBar.setProgress(0.0, animated: false)
//        self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: .normal)
//        self.tempState = false
//    }
    
    func stopAnimation() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        workItem?.cancel()
        self.progressBar.setProgress(0.0, animated: false)
        self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: .normal)
        self.tempState = false
    }
    
    func startAnimation() {
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        if items![indexRow!].checked {
            self.delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID!)
            // self.progressBar.setProgress(0.0, animated: false)
            
            self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: .normal)
        } else {
            self.delegate?.changeButton(state: true, indexSection: self.indexSection!, indexRow: self.indexRow!, itemID: self.itemID)
            self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: .normal)
//            self.tempState = true
//            UIView.animate(withDuration: 4.0, animations: {
//                self.progressBar.setProgress(1.0, animated: true)
//          }) { (finished: Bool) in
//            
//                self.workItem = DispatchWorkItem {
//                    self.delegate?.changeButton(state: true, indexSection: self.indexSection!, indexRow: self.indexRow!, itemID: self.itemID)
//                }
//                
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.3, execute: self.workItem!)
//            
//            
//            }
        }
        
//        func startAnimation() {
//        let generator = UIImpactFeedbackGenerator(style: .medium)
//        generator.impactOccurred()
//
//        if items![indexRow!].checked {
//            self.delegate?.changeButton(state: false, indexSection: indexSection!, indexRow: indexRow!, itemID: itemID!)
//            self.progressBar.setProgress(0.0, animated: false)
//            self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxOUTLINE "), for: .normal)
//        } else {
//
//            self.checkBoxOutlet.setBackgroundImage(#imageLiteral(resourceName: "checkBoxFILLED "), for: .normal)
//            self.tempState = true
//            UIView.animate(withDuration: 4.0, animations: {
//                self.progressBar.setProgress(1.0, animated: true)
//          }) { (finished: Bool) in
//
//                self.workItem = DispatchWorkItem {
//                    self.delegate?.changeButton(state: true, indexSection: self.indexSection!, indexRow: self.indexRow!, itemID: self.itemID)
//                }
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3.3, execute: self.workItem!)
//
//
//            }
//        }
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var checkBoxOutlet: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var quantityLabel: UILabel!
    
    
}
