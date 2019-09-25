//
//  ProfileVC.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/19/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    var bool = Bool()
    var tapped = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTextFields(enabled: false, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        saveButton.alpha = 0.0
        textFields[0].text = Auth.auth().currentUser?.displayName
        textFields[1].text = Auth.auth().currentUser?.email
        
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func setTextFields(enabled: Bool, color: UIColor) {
        textFields[0].isUserInteractionEnabled = enabled
        textFields[1].isUserInteractionEnabled = enabled
        
        textFields[0].backgroundColor = color
        textFields[1].backgroundColor = color
    }
    
    @IBAction func editTapped(_ sender: UIBarButtonItem) {
        tapped += 1
        
        if tapped.isMultiple(of: 2) {
            setTextFields(enabled: true, color: #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1))
            saveButton.isEnabled = true
            saveButton.alpha = 1
        } else {
            setTextFields(enabled: false, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
            saveButton.isEnabled = false
            saveButton.alpha = 0
        }
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to change them?", message: "If you change these, you have to use your new email or username.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            self.textFields[0].text = Auth.auth().currentUser?.displayName
            Auth.auth().currentUser?.updateEmail(to: self.textFields[1].text!, completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
        
        setTextFields(enabled: false, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        saveButton.isEnabled = false
        saveButton.alpha = 0
        tapped += 1
    }
    
    @IBAction func logoutButtonTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to logout your account?", message: "If you logout your account, you have to sign for use your account.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            let auth = Auth.auth()
            
            do {
                try auth.signOut()
            } catch let signoutError as NSError {
                debugPrint("Error signing out: \(signoutError)")
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountTapped(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to delete your account?", message: "If you delete your account, your datas will delete.", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            Auth.auth().currentUser?.delete(completion: { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
