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
    @IBOutlet weak var markButton: UIButton!
    
    override func awakeFromNib() {        super.awakeFromNib()
    }
    
    func configureCell(target: Target) {
        targetLabel.text = target.text
    }
    
    @IBAction func markButtonTapped(_ sender: UIButton) {
    }
}
