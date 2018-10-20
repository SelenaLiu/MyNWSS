//
//  AddCourseViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-17.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class AddCourseViewController: UIViewController, UITextFieldDelegate {
    
    let currentUserUID = Auth.auth().currentUser?.uid
    let ref = Database.database().reference(fromURL: "https://mynwss.firebaseio.com/")
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Add A Course"
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
        button.addTarget(self, action: #selector(AddCourseViewController.dismissVC), for: .touchDown)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let courseNameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter Course Name"
        tf.layer.borderColor = UIColor.darkGray.cgColor
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 8, height: tf.frame.height))
        tf.leftView = paddingView
        tf.leftViewMode = .always
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 2
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let daySegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.backgroundColor = .white
        segment.insertSegment(withTitle: "Day 1", at: 0, animated: true)
        segment.insertSegment(withTitle: "Day 2", at: 1, animated: true)
        segment.tintColor = UIColor.darkGray
        segment.backgroundColor = .white
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 5
        segment.layer.borderWidth = 2
        segment.layer.borderColor = UIColor.darkGray.cgColor
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let blockSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "A", at: 0, animated: true)
        segment.insertSegment(withTitle: "B", at: 1, animated: true)
        segment.insertSegment(withTitle: "C", at: 2, animated: true)
        segment.insertSegment(withTitle: "D", at: 3, animated: true)
        segment.insertSegment(withTitle: "Z", at: 4, animated: true)
        segment.tintColor = UIColor.darkGray
        segment.backgroundColor = .white
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 5
        segment.layer.borderWidth = 2
        segment.layer.borderColor = UIColor.darkGray.cgColor
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(AddCourseViewController.saveCourse), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Course", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(AddCourseViewController.deleteCourse), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
    
    var isConnectedToInternet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        view.backgroundColor = .orange
        let blocks = ["A", "B", "C", "D", "Z"]
        
        if globalVars.isEditingCourse == true {
            self.navigationItem.title = "Edit Course"
            courseNameTF.text = globalVars.editingCourseName
            let blockIndex = blocks.index(of: globalVars.editingCourseBlock)
            blockSegment.selectedSegmentIndex = blockIndex!
            deleteButton.isHidden = false
        } else {
            self.navigationItem.title = "Add a Course"
            let blockIndex = blocks.index(of: globalVars.editingCourseBlock)
            blockSegment.selectedSegmentIndex = blockIndex!
            deleteButton.isHidden = true
        }
        
        view.addSubview(backView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        titleLabel.layer.shadowColor = UIColor.gray.cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.width * 0.06)
        view.addSubview(courseNameTF)
        courseNameTF.delegate = self
        view.addSubview(daySegment)
        view.addSubview(blockSegment)
        backView.addSubview(doneButton)
        backView.addSubview(deleteButton)
        doneButton.isHidden = false
        
        setup()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        doneButton.isHidden = false
        deleteButton.isHidden = true
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func presentProfileController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let profileVC = mainStoryboard.instantiateViewController(withIdentifier: "MainVC")
        present(profileVC, animated: true, completion: nil)
    }
    
    @objc func saveCourse() {
        if isConnectedToInternet == false {
            let alertVC = UIAlertController(title: "Connection Failure", message: "You are not currently connected to a network. Please reconnect before you change your courses.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        } else {
            let usersReference = ref.child("users").child(currentUserUID!)
            
            loadData()
            
            
            var alertController: UIAlertController = UIAlertController()
            var alertVCTriggered = false
            
            let blocks = ["A", "B", "C", "D", "Z"]
            let name = courseNameTF.text!
            let day = daySegment.selectedSegmentIndex + 1
            let block = blocks[blockSegment.selectedSegmentIndex]
            print("The day: \(day)")
            
            if courseNameTF.text == "" || courseNameTF.text == nil {
                alertController = UIAlertController(title: "Error", message: "Please enter a course name", preferredStyle: .alert)
                let OK = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                alertController.addAction(OK)
                alertVCTriggered = true
            }
            
            if globalVars.isEditingCourse == true {
                
                for course in globalVars.courses {
                    if course.Name == name {
                        alertController = UIAlertController(title: "Error", message: "You already have this class registered in another block. Please delete or edit that course first before proceeding.", preferredStyle: .alert)
                        let OK = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(OK)
                        alertVCTriggered = true
                    }
                }
                
                if alertVCTriggered == false {
                    let course = Course(name: name, day: day, block: block, notes: [])
                    print("COURSE NAME: ", globalVars.editingCourseName)
                    var courses: [String: [String: Any]] = [:]
                    for course in globalVars.courses {
                        if course.Name != globalVars.editingCourseName {
                            courses[course.Name] = ["block": course.Block, "day": course.Day, "notes": course.Notes]
                        }
                    }
                    usersReference.child("courses").setValue(courses)
                    usersReference.child("courses").child(name).setValue(["block": block, "day": day, "notes": []])
                    print("before: \(globalVars.courses[globalVars.editingCourseIndex].Name)")
                    globalVars.courses[globalVars.editingCourseIndex] = course
                    print("after: \(globalVars.courses[globalVars.editingCourseIndex].Name)")
                    globalVars.justAddedCourse = true
                    backToProfileVC()
                } else {
                    present(alertController, animated: true, completion: nil)
                    alertVCTriggered = false
                }
                
            } else {
                
                for course in globalVars.courses {
                    if day == course.Day && block == course.Block {
                        alertController = UIAlertController(title: "Error", message: "You already have another class during this block", preferredStyle: .alert)
                        let OK = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(OK)
                        alertVCTriggered = true
                    } else if course.Name == name {
                        alertController = UIAlertController(title: "Error", message: "You already have this class registered in another block. Please delete or edit that course first before proceeding.", preferredStyle: .alert)
                        let OK = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                        alertController.addAction(OK)
                        alertVCTriggered = true
                    }
                }
                
                if alertVCTriggered == false {
                    let course = Course(name: name, day: Int(day), block: block, notes: [])
                    usersReference.child("courses").child(name).setValue(["block": block, "day": day, "notes": []])
                    print("AddCourseVC: \(course.Day)")
                    globalVars.courses.append(course)
                    //usersReference.setValue(["courses":globalVars.courses])
                    globalVars.justAddedCourse = true
                    backToProfileVC()
                } else {
                    present(alertController, animated: true, completion: nil)
                    alertVCTriggered = false
                }
            }
        }
        
    }
    
    @objc func backToProfileVC() {
        NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: filePath)
        globalVars.loadProfileCell = true

        let notesVC = NotesCollectionViewCell()
        notesVC.notesTableView.reloadData()
        presentProfileController()
    }
    
    @objc func deleteCourse() {
        if isConnectedToInternet == false {
            let alertVC = UIAlertController(title: "Connection Failure", message: "You are not currently connected to a network. Please reconnect before you change your courses.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        } else {
            let usersReference = ref.child("users").child(currentUserUID!)
            
            usersReference.child("courses").child(globalVars.editingCourseName).removeValue { (error, ref) in
                if error != nil {
                    print(error)
                } else {
                    print(ref)
                }
            }
            loadData()
            for course in globalVars.courses {
                if course.Name == globalVars.editingCourseName {
                    let index = globalVars.courses.index(of: course)
                    globalVars.courses.remove(at: index!)
                    backToProfileVC()
                }
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
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
    
    func setup() {
        
        backView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        backView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        backView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        backView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.2).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        courseNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        courseNameTF.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        courseNameTF.heightAnchor.constraint(equalToConstant: 30).isActive = true
        courseNameTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        daySegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        daySegment.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        daySegment.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.09).isActive = true
        daySegment.topAnchor.constraint(equalTo: courseNameTF.bottomAnchor, constant: 30).isActive = true
        
        blockSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blockSegment.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        blockSegment.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.09).isActive = true
        blockSegment.topAnchor.constraint(equalTo: daySegment.bottomAnchor, constant: 30).isActive = true
        
//        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        doneButton.topAnchor.constraint(equalTo: blockSegment.bottomAnchor, constant: 30).isActive = true
//        
//        
//        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        deleteButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 30).isActive = true
        
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.09).isActive = true
        doneButton.topAnchor.constraint(equalTo: blockSegment.bottomAnchor, constant: 30).isActive = true
        
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.09).isActive = true
        deleteButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 10).isActive = true
       
    }
    
    
}
