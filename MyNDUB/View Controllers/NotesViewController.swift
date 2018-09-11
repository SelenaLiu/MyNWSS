//
//  NotesViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-23.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

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
    
    func reloadingTableView() {
        self.tableView.reloadData()
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
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 41/255, green: 40/255, blue: 52/255, alpha: 1.0)

        self.navigationItem.title = "\(globalVars.notes) Notes"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AddCourseViewController.dismissVC))
        let addNoteButton = UIBarButtonItem(title: "+ Note", style: .plain, target: self, action: #selector(NotesViewController.presentAddNote))
        self.navigationItem.rightBarButtonItem = addNoteButton
        
        view.addSubview(tableView)
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
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .default, title: "Delete", handler: { action, index in
            for course in globalVars.courses {
                if course.Name == globalVars.notes {
                    course.Notes.remove(at: indexPath.row)
                }
            }
            NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: self.filePath)
            tableView.reloadData()
            print("deletePressed")
        })
        return [delete]
    }
    
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            for course in globalVars.courses {
//                if course.Name == globalVars.notes {
//                    course.Notes.remove(at: indexPath.row)
//                }
//            }
//            //reload data still not working
//            DispatchQueue.main.async{
//                self.tableView.reloadData()
//            }
//            NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: filePath)
//        }
//
//    }
    
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
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

protocol ReloadNotesTableView {
    func reloadingTableView()
}


