//
//  ProfileVC.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/19/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit

class ProfileVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
    }
    
    @IBAction func deleteAccountTapped(_ sender: UIButton) {
    }
}
