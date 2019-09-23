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

enum HistoryCategory: String {
    case day = "Day"
    case week = "Week"
    case mounth = "Mounth"
    case year = "Year"
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    let textField = UITextField()
    
    private var targets = [Target]()
    private var selectedCategory = HistoryCategory.day.rawValue
    private var targetsCollectionRef: CollectionReference!
    private var targetsListener: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setupNavBar()
        
        targetsCollectionRef = Firestore.firestore().collection(TARGETS_REF)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginVC = storyboard.instantiateViewController(withIdentifier: "loginVC")
                
                self.present(loginVC, animated: true, completion: nil)
            }
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return targets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell
        cell?.configureCell(target: targets[indexPath.row])
        
        return cell!
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
    }
    
    func setListener() {
        targetsListener = targetsCollectionRef.whereField(CATEGORY, isEqualTo: selectedCategory).order(by: TIMESTAMP, descending: true).addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.targets.removeAll()
                self.targets = Target.parseData(snapshot: snapshot)
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func segmentedControllerSelected(_ sender: UISegmentedControl) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            selectedCategory = HistoryCategory.day.rawValue
        case 1:
            selectedCategory = HistoryCategory.week.rawValue
        case 2:
            selectedCategory = HistoryCategory.mounth.rawValue
        default:
            selectedCategory = HistoryCategory.year.rawValue
        }
        
        setListener()
    }
    
    @IBAction func addTargetButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Target", message: "Write for add a new target.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "New Target"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            Firestore.firestore().collection(TARGETS_REF).addDocument(data: [TEXT: alert.textFields?.first?.text, STATUS: false, TIMESTAMP: FieldValue.serverTimestamp(), CATEGORY: self.selectedCategory, USER_ID: Auth.auth().currentUser?.uid ?? "", USERNAME: Auth.auth().currentUser?.displayName ?? ""], completion: { (error) in
                if let error = error {
                    debugPrint("Error adding document: \(error)")
                } else {
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
