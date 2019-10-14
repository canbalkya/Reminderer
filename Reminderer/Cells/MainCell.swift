//
//  MainCell.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/19/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit
import Firebase

class MainCell: UITableViewCell {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    
//    var number = Firestore.firestore().document("targets/\(target.documentId!)").updateData([NUMBER: target.number])

    var target: Target!
    
    var number = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(target: Target) {
        targetLabel.text = target.text
        
        number = target.number
        
        if target.number.isMultiple(of: 2) {
            markButton.imageView?.image = UIImage(named: "square.fill")
        } else {
            markButton.imageView?.image = UIImage(named: "square.fill")
        }
    }
    
    @IBAction func markButtonTapped(_ sender: UIButton) {
        number += 1
//        Firestore.firestore().document("targets/\(Target.documentId!)").updateData([NUMBER: target.number + 1])
    }
}
