//
//  DayCell.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/19/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var markButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func markButtonTapped(_ sender: UIButton) {
    }
}
