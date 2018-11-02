//
//  NotesCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-14.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class NotesCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    let notesCellID = "cellID"
    
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
    
    // subviews
    
    let notesTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.backgroundColor = .orange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addNoteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add Note", for: .normal)
        button.addTarget(self, action: #selector(NotesCollectionViewCell.presentAddNoteVC), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let courseLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    @objc func presentAddNoteVC() {
        print("presentAddNoteVC triggered")
    }
    
    // tableview functions
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    var delegate: didClickCell?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        globalVars.notes = globalVars.courses[indexPath.row].Name
        globalVars.setCourse = globalVars.courses[indexPath.row]
        self.delegate?.didClick(segue: "toNotesVC")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return globalVars.courses.count
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: notesCellID)

        cell?.accessoryType = .disclosureIndicator
        cell?.textLabel?.text = globalVars.courses[indexPath.row].Name

        return cell!
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        addSubview(notesTableView)
        addSubview(titleLabel)
        titleLabel.font = UIFont.boldSystemFont(ofSize: bounds.width * 0.06)
        titleLabel.layer.shadowColor = UIColor.gray.cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleLabel.layer.shadowRadius = 3
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: notesCellID)
        notesTableView.dataSource = self
        notesTableView.delegate = self
        
        setup()
        
        getCourseData()
    }
    
    func getCourseData() {
        loadData()
        globalVars.courses = []
        
        // retreives course data from Firebase
        let currentUserUID = Auth.auth().currentUser?.uid
        
        Database.database().reference().child("users").child(currentUserUID!).child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            let courseDict = snapshot.value as? [String : [String:Any]]
            print("COURSE DICT: ", courseDict)
            if courseDict != nil {
                for value in courseDict! {
                    let name = value.key
                    let block = value.value["block"] as! String
                    let day = value.value["day"] as! Int
                    let notesValue = value.value["notes"] as? [String:String]
                    var notes: [Notes] = []
                    if notesValue != nil {
                        for note in notesValue! {
                            let noteTitle = note.key
                            let noteText = note.value
                            notes.append(Notes(title: noteTitle, text: noteText))
                        }
                    }
                    
                    let course = Course(name: name, day: day, block: block, notes: notes)
                    globalVars.courses.append(course)
                    NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: self.filePath)
                    self.notesTableView.reloadData()
                }
            }
            
        })
    }
    
    func setup() {
        
        titleLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: bounds.width * 0.2).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        notesTableView.heightAnchor.constraint(equalToConstant: bounds.height * 0.8).isActive = true
        notesTableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        notesTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        notesTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

protocol PresentNotesVC: NSObjectProtocol {
    func presentNotesController()
}



