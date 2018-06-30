//
//  NotesCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-14.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

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
    
    let titleLabel: UITextView = {
        let label = UITextView()
        label.text = "Notes"
        label.textContainerInset = UIEdgeInsetsMake(0, 30, 0, 0)
        label.isUserInteractionEnabled = false
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 20)
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

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = "Notes"
        return title
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
        addSubview(titleLabel)
        notesTableView.register(UITableViewCell.self, forCellReuseIdentifier: notesCellID)
        addSubview(notesTableView)
        notesTableView.dataSource = self
        notesTableView.delegate = self
        
        setup()
    }
    
    func setup() {
        let margins = layoutMarginsGuide
        
        notesTableView.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        notesTableView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        notesTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        notesTableView.topAnchor.constraint(equalTo: margins.topAnchor, constant: 13).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

protocol PresentNotesVC: NSObjectProtocol {
    func presentNotesController()
}



