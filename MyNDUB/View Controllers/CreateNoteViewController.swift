//
//  CreateNoteViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-27.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class CreateNoteViewController: UIViewController, UITextViewDelegate {
    
    let currentUserUID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(fromURL: "https://mynwss.firebaseio.com/")
    
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
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Note"
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
        button.addTarget(self, action: #selector(CreateNoteViewController.dismissVC), for: .touchDown)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.addTarget(self, action: #selector(CreateNoteViewController.saveNote), for: .touchDown)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    var isConnectedToInternet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        if globalVars.isViewingNote {
            titleTF.text = globalVars.viewingNote.Title
            noteTextView.text = globalVars.viewingNote.Text
        } else {
            noteTextView.textColor = .lightGray
            noteTextView.font = UIFont.italicSystemFont(ofSize: 17)
        }
        view.addSubview(backView)
        view.addSubview(titleLabel)
        
        titleLabel.layer.shadowColor = UIColor.gray.cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.width * 0.06)
        
        view.addSubview(backButton)
        view.addSubview(doneButton)
        doneButton.isEnabled = false
        
        //view.addSubview(backgroundImage)
        view.addSubview(titleTF)
        view.addSubview(noteTextView)
        noteTextView.delegate = self
        
        
        setup()
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func saveNote() {
        if isConnectedToInternet == false {
            let alertVC = UIAlertController(title: "Connection Failure", message: "You are not currently connected to a network. Please reconnect before you change your courses.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        } else {
            let usersReference = ref.child("users").child(currentUserUID!)
            
            print("save note")
            loadData()
            let title = titleTF.text!
            let text = noteTextView.text!
            
            let newNote = Notes(title: title, text: text)
            
            if globalVars.isViewingNote {
                var notes: [String: [String: Any]] = [:]
                for course in globalVars.courses {
                    if course.Name == globalVars.notes {
                        for note in course.Notes {
                            if note.Title != globalVars.viewingNote.Title {
                                notes[course.Name] = ["block": course.Block, "day": course.Day, "notes": course.Notes]
                            }
                        }
                    }
                }
                usersReference.child("courses").child(globalVars.notes).child("notes").setValue(notes)
                usersReference.child("courses").child(globalVars.notes).child("notes").child(title).setValue(text)
                for course in globalVars.courses {
                    if course.Name == globalVars.notes {
                        let index = globalVars.setCourse.Notes.index(of: globalVars.viewingNote)
                        globalVars.setCourse.Notes[index!].Title = title
                        globalVars.setCourse.Notes[index!].Text = text
                        course.Notes[index!].Title = title
                        course.Notes[index!].Text = text
                    }
                }
            } else {
                usersReference.child("courses").child(globalVars.notes).child("notes").child(title).setValue(text)
                for course in globalVars.courses {
                    if course.Name == globalVars.notes {
                        course.Notes.append(newNote)
                        globalVars.setCourse.Notes.append(newNote)
                    }
                }
            }
            
            NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: filePath)
            
            loadData()
            dismissVC()
        }
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        doneButton.isEnabled = true
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
        
        doneButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        titleTF.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        titleTF.heightAnchor.constraint(equalToConstant: 30).isActive = true
        titleTF.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
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
