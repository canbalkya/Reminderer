//
//  MainCell.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/19/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit

class MainCell: UITableViewCell {
    @IBOutlet weak var targetLabel: UILabel!
    @IBOutlet weak var optionImageView: UIImageView!
    
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
            optionImageView.image = #imageLiteral(resourceName: "Off")
            status = false
        } else {
            optionImageView.image = #imageLiteral(resourceName: "On")
            status = true
        }
    }
    
    func configureCell(target: Target) {
        targetLabel.text = target.text
//        optionImageView = target.image
    }
}
