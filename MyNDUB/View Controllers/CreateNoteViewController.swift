//
//  CreateNoteViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-27.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class CreateNoteViewController: UIViewController, UITextViewDelegate {
    
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
    
//    let backgroundImage: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = #imageLiteral(resourceName: "linedPaper")
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        return imageView
//    }()
    
    let titleTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Title"
        tf.font = UIFont.boldSystemFont(ofSize: 17)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let noteTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.text = "Add Note..."
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create a Note"

        
        if globalVars.isViewingNote {
            titleTF.text = globalVars.viewingNote.Title
            noteTextView.text = globalVars.viewingNote.Text
        } else {
            noteTextView.textColor = .lightGray
            noteTextView.font = UIFont.italicSystemFont(ofSize: 17)
        }
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(CreateNoteViewController.saveNote))
        self.navigationItem.rightBarButtonItem = doneButton
        doneButton.isEnabled = false
        
        //view.addSubview(backgroundImage)
        view.addSubview(titleTF)
        view.addSubview(noteTextView)
        noteTextView.delegate = self
        
        setup()
    }
    
    
    @objc func saveNote() {
        print("save note")
        loadData()
        let title = titleTF.text!
        let text = noteTextView.text!
        
        let newNote = Notes(title: title, text: text)
        
        if globalVars.isViewingNote {
            for course in globalVars.courses {
                if course.Name == globalVars.notes {
                    let index = globalVars.setCourse.Notes.index(of: globalVars.viewingNote)
                    course.Notes[index!].Title = title
                    course.Notes[index!].Text = text
                }
            }
        } else {
            for course in globalVars.courses {
                if course.Name == globalVars.notes {
                    course.Notes.append(newNote)
                }
            }
        }
        
        

        NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: filePath)
                
        let notesVC = NotesViewController()
        notesVC.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.font = UIFont.systemFont(ofSize: 17)
            textView.textColor = .black
        }
    }

    
    func setup() {
        let margins = view.layoutMarginsGuide
        
//        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
//        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        titleTF.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        titleTF.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleTF.topAnchor.constraint(equalTo: margins.topAnchor, constant: 10).isActive = true
        titleTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        noteTextView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        noteTextView.heightAnchor.constraint(equalToConstant: 500).isActive = true
        noteTextView.topAnchor.constraint(equalTo: titleTF.bottomAnchor, constant: 10).isActive = true
        noteTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
}
