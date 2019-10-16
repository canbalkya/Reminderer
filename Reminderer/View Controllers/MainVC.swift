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

enum TimeCategory: String {
    case day = "Day"
    case week = "Week"
    case month = "Mounth"
    case year = "Year"
}

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var target: Target!
    private var targets = [Target]()
    private var days = [Target]()
    private var weeks = [Target]()
    private var months = [Target]()
    private var years = [Target]()
    
    private var selectedCategory = TimeCategory.day.rawValue
    private var targetsCollectionRef: CollectionReference!
    private var targetsListener: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for target in targets {
            if target.category == TimeCategory.day.rawValue {
                days.append(target)
            } else if target.category == TimeCategory.week.rawValue {
                weeks.append(target)
            } else if target.category == TimeCategory.month.rawValue {
                months.append(target)
            } else if target.category == TimeCategory.year.rawValue {
                years.append(target)
            }
        }
        
        setupNavBar()
        
        targetsCollectionRef = Firestore.firestore().collection(TARGETS_REF)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        
        if selectedCategory == TimeCategory.day.rawValue {
            count = days.count
        } else if selectedCategory == TimeCategory.week.rawValue {
            count = weeks.count
        } else if selectedCategory == TimeCategory.month.rawValue {
            count = months.count
        } else if selectedCategory == TimeCategory.year.rawValue {
            count = years.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell
        
        if selectedCategory == TimeCategory.day.rawValue {
            cell?.configureCell(target: days[indexPath.row])
        } else if selectedCategory == TimeCategory.week.rawValue {
            cell?.configureCell(target: weeks[indexPath.row])
        } else if selectedCategory == TimeCategory.month.rawValue {
            cell?.configureCell(target: months[indexPath.row])
        } else if selectedCategory == TimeCategory.year.rawValue {
            cell?.configureCell(target: years[indexPath.row])
        }
        
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
    
    func tableView(_tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            Firestore.firestore().collection(TARGETS_REF).document(target!.documentId).delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    self.setListener()
                }
            }
        }
    }
    
    @IBAction func segmentedControllerSelected(_ sender: UISegmentedControl) {
        switch segmentedController.selectedSegmentIndex {
        case 0:
            selectedCategory = TimeCategory.day.rawValue
        case 1:
            selectedCategory = TimeCategory.week.rawValue
        case 2:
            selectedCategory = TimeCategory.month.rawValue
        default:
            selectedCategory = TimeCategory.year.rawValue
        }
    }
    
    @IBAction func addTargetButtonTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add New Target", message: "Write for add a new target.", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "New Target"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            self.targetsCollectionRef.addDocument(data: [TEXT: alert.textFields?.first?.text, NUMBER: 0, TIMESTAMP: FieldValue.serverTimestamp(), CATEGORY: self.selectedCategory, USER_ID: Auth.auth().currentUser?.uid ?? "", USERNAME: Auth.auth().currentUser?.displayName ?? ""], completion: { (error) in
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
