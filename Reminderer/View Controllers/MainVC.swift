//
//  ViewController.swift
//  Reminderer
//
//  Created by Can Balkaya on 9/19/19.
//  Copyright © 2019 Can Balkaya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var target: Target!
    private var targets = [Target]()
    
    let searchController = UISearchController(searchResultsController: nil)

    private var targetsCollectionRef: CollectionReference!
    private var targetsListener: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupNavBar()
        
        targetsCollectionRef = Firestore.firestore().collection(USERS_REF).document(Auth.auth().currentUser!.uid).collection(TARGETS_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                
                self.present(loginVC, animated: true, completion: nil)
            } else {
                self.setListener()
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if targetsListener != nil {
            targetsListener.remove()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell
        cell?.configureCell(target: targets[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { (contextualAction, view, actionPerformed: (Bool) -> ()) in
            let alert = UIAlertController(title: "Update Target", message: "Write for update a target.", preferredStyle: .alert)
            alert.addTextField { (textField) in
                textField.placeholder = "Update Target"
                
                self.targetsCollectionRef.document(self.targets[indexPath.row].text).updateData([TEXT: alert.textFields![0].text ?? ""], completion: { (error) in
                    if let error = error {
                        debugPrint("Error adding document: \(error)")
                    } else {
                        self.navigationController?.popViewController(animated: true)
                        self.setListener()
                    }
                })
            }
            
            let updateAction = UIAlertAction(title: "Update", style: .default) { (action) in
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

            alert.addAction(updateAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
        }
        editAction.backgroundColor = #colorLiteral(red: 0.08884030049, green: 0.9007376269, blue: 0.4761832245, alpha: 1)
        
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func setListener() {
        targetsListener = targetsCollectionRef.order(by: TIMESTAMP, descending: true).addSnapshotListener { (snapshot, error) in
        if let error = error {
                print(error.localizedDescription)
            } else {
                self.targets.removeAll()
                self.targets = Target.parseData(snapshot: snapshot)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            targetsCollectionRef.document(targets[indexPath.row].documentId).delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.setListener()
                }
            }
        }
    }
    
    @IBAction func addTargetButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Target", message: "Write for add a new target.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "New Target"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.targetsCollectionRef.addDocument(data: [TEXT: alert.textFields![0].text ?? "", TIMESTAMP: FieldValue.serverTimestamp(), USER_ID: Auth.auth().currentUser?.uid ?? "", USERNAME: Auth.auth().currentUser?.displayName ?? "", IS_DONE: false], completion: { (error) in
                if let error = error {
                    debugPrint("Error adding document: \(error)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                    self.setListener()
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
