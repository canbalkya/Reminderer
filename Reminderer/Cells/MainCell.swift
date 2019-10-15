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

    var targett: Target!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(target: Target) {
        self.targett = target
        
        targetLabel.text = target.text
        
        if target.number.isMultiple(of: 2) {
            markButton.imageView?.image = UIImage(named: "square.fill")
        } else {
            markButton.imageView?.image = UIImage(named: "square")
        }
    }
    
    @IBAction func markButtonTapped(_ sender: UIButton) {
//        Firestore.firestore().document("targets/\(targett.documentId!)").updateData([NUMBER: targett.number + 1])
        targett.number += 1
        markButton.imageView?.image = UIImage(named: "square.fill")
    }
}
