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

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedController: UISegmentedControl!
    
    var target: Target!
    private var targets = [Target]()
    var searchTargets = [Target]()
//    private var days = [Target]()
//    private var weeks = [Target]()
//    private var months = [Target]()
//    private var years = [Target]()
    
    let searchController = UISearchController(searchResultsController: nil)
    
    private var selectedCategory = TimeCategory.day.rawValue
    private var targetsCollectionRef: CollectionReference!
    private var targetsListener: ListenerRegistration!
    private var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchTargets = targets
        
        for target in targets {
            if target.category == TimeCategory.day.rawValue {
                targets.append(target)
            } else if target.category == TimeCategory.week.rawValue {
                targets.append(target)
            } else if target.category == TimeCategory.month.rawValue {
                targets.append(target)
            } else if target.category == TimeCategory.year.rawValue {
                targets.append(target)
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
//        if selectedCategory == TimeCategory.day.rawValue {
//            count = targets.count
//        } else if selectedCategory == TimeCategory.week.rawValue {
//            count = targets.count
//        } else if selectedCategory == TimeCategory.month.rawValue {
//            count = targets.count
//        } else if selectedCategory == TimeCategory.year.rawValue {
//            count = targets.count
//        }
        
        return searchTargets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MainCell", for: indexPath) as? MainCell
        cell?.configureCell(target: searchTargets[indexPath.row])
        
//        if selectedCategory == TimeCategory.day.rawValue {
//            cell?.configureCell(target: targets[indexPath.row])
//        } else if selectedCategory == TimeCategory.week.rawValue {
//            cell?.configureCell(target: targets[indexPath.row])
//        } else if selectedCategory == TimeCategory.month.rawValue {
//            cell?.configureCell(target: targets[indexPath.row])
//        } else if selectedCategory == TimeCategory.year.rawValue {
//            cell?.configureCell(target: targets[indexPath.row])
//        }
        
        return cell!
    }
    
    func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.hidesSearchBarWhenScrolling = true
        
        searchController.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Find a target"
        searchController.searchBar.keyboardAppearance = .dark
        navigationItem.searchController = searchController
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTargets = targets.filter({ target -> Bool in
            if searchText.isEmpty { return true }
            return target.text.lowercased().contains(searchText.lowercased())
        })
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        searchTargets = targets
        tableView.reloadData()
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
