//
//  ProfileVC.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/19/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ProfileVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = Auth.auth().currentUser
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        user?.reload(completion: { (error) in
            self.usernameLabel.text = user?.displayName
            self.emailLabel.text = user?.email
            
            switch user?.isEmailVerified {
            case true:
                print("Users email is verified.")
            default:
                user?.sendEmailVerification(completion: { (error) in
                    guard let error = error else {
                        return print("User email verification sent.")
                    }
                })
                
                self.emailLabel.text = "\((user!.email)!) - Verify!"
            }
        })
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
                
//                let auth = Auth.auth()
//
//                do {
//                    try auth.signOut()
//                } catch let signoutError as NSError {
//                    debugPrint("Error signing out: \(signoutError)")
//                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
