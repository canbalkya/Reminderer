//
//  MainCell.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/19/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit
import FirebaseFirestore

class MainCell: UITableViewCell {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var optionImageView: UIImageView!
    
//    private var target: Target!
    
    @IBInspectable var isChecked: Bool = false {
        didSet {
            self.optionTapped()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(optionTapped))
        optionImageView.addGestureRecognizer(tap)
        optionImageView.isUserInteractionEnabled = true
    }
    
    @objc func optionTapped() {
        if isChecked == true {
//            Firestore.firestore().document("targets/\(Target.documentId!)").updateData([STATUS: true])
            status = false
        } else {
//            Firestore.firestore().document("targets/\(Target.documentId!)").updateData([STATUS: false])
            status = true
        }
    }
    
    func configureCell(target: Target) {
        targetLabel.text = target.text
        
        if status == true {
            optionImageView = UIImageView(image: #imageLiteral(resourceName: "Off"))
        } else {
            optionImageView = UIImageView(image: #imageLiteral(resourceName: "On"))
        }
        
        status = false
    }
}
