//
//  NotesViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-23.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class NotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    // retrieving data
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("Data").path
    }
    
    private func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Course] {
            globalVars.courses = ourData
        }
    }
    
    let tableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.tableView.reloadData()
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "School Map"
        label.backgroundColor = .orange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(NotesViewController.dismissVC), for: .touchDown)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+ Note", for: .normal)
        button.addTarget(self, action: #selector(NotesViewController.presentAddNote), for: .touchDown)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    var isConnectedToInternet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        view.backgroundColor = .orange
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                self.isConnectedToInternet = true
            } else {
                print("Not connected")
                self.loadData()
            }
        })
        
        view.addSubview(backView)
        view.addSubview(tableView)
        view.addSubview(titleLabel)
        titleLabel.text = globalVars.notes
        titleLabel.layer.shadowColor = UIColor.gray.cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.width * 0.06)
        
        view.addSubview(backButton)
        view.addSubview(addNoteButton)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        tableView.delegate = self
        tableView.dataSource = self
        setup()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func presentAddNote() {
        globalVars.isViewingNote = false
        performSegue(withIdentifier: "toCreateNote", sender: self)
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    let currentUserUID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(fromURL: "https://mynwss.firebaseio.com/")
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let usersReference = ref.child("users").child(currentUserUID!)

        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: { action, index in
            if self.isConnectedToInternet == false {
                let alertVC = UIAlertController(title: "Connection Failure", message: "You are not currently connected to a network. Please reconnect before you change your courses.", preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.present(alertVC, animated: true, completion: nil)
            } else {
                for course in globalVars.courses {
                    if course.Name == globalVars.notes {
                        usersReference.child("courses").child(globalVars.notes).child("notes").child(course.Notes[indexPath.row].Title).removeValue()
                        course.Notes.remove(at: indexPath.row)
                        globalVars.setCourse.Notes.remove(at: indexPath.row)
                    }
                }
                NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: self.filePath)
                tableView.reloadData()
                print("deletePressed")
            }
        })
        return [delete]
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        globalVars.isViewingNote = true
        globalVars.viewingNote = globalVars.setCourse.Notes[indexPath.row]
        performSegue(withIdentifier: "toCreateNote", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    var course: Course!
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadData()
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")
        cell?.accessoryType = .disclosureIndicator

        cell?.textLabel?.text = globalVars.setCourse.Notes[indexPath.row].Title
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if globalVars.setCourse.Notes.count != 0 {
            return globalVars.setCourse.Notes.count
        } else {
            return 0
        }
    }
    
    
    func setup() {
        
        backView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        backView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        backView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        backView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.2).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        addNoteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        addNoteButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.bounds.height - (view.bounds.width * 0.2)).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}



