//
//  AddCourseViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-17.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class AddCourseViewController: UIViewController, UITextFieldDelegate {
    
    let courseNameTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Course Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    
    let daySegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "Day 1", at: 0, animated: true)
        segment.insertSegment(withTitle: "Day 2", at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 0
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
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 0
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(AddCourseViewController.saveCourse), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Delete Course", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.addTarget(self, action: #selector(AddCourseViewController.deleteCourse), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 41/255, green: 40/255, blue: 52/255, alpha: 1.0)

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
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(AddCourseViewController.dismissVC))
        
        
        view.addSubview(courseNameTF)
        courseNameTF.delegate = self
        view.addSubview(daySegment)
        view.addSubview(blockSegment)
        view.addSubview(doneButton)
        view.addSubview(deleteButton)
        doneButton.isHidden = true
        
        setup()
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
        loadData()
        
        var alertController: UIAlertController = UIAlertController()
        alertController = UIAlertController(title: "404", message: "IDK what's happening", preferredStyle: .alert)
        let OK = UIAlertAction(title: "FIX IT", style: .cancel, handler: nil)
        alertController.addAction(OK)
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
                } else if day == course.Day && block == course.Block {
                    alertController = UIAlertController(title: "Error", message: "You already have another class during this block", preferredStyle: .alert)
                    let OK = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
                    alertController.addAction(OK)
                    alertVCTriggered = true
                }
            }
            
            if alertVCTriggered == false {
                let course = Course(name: name, day: day, block: block, notes: [])
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
                print("AddCourseVC: \(course.Day)")
                globalVars.courses.append(course)
                globalVars.justAddedCourse = true
                backToProfileVC()
            } else {
                present(alertController, animated: true, completion: nil)
                alertVCTriggered = false
            }
        }
        
    }
    
    @objc func backToProfileVC() {
        NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: filePath)

        let notesVC = NotesCollectionViewCell()
        notesVC.notesTableView.reloadData()
        let profileVC = ProfileCollectionViewCell()
//        profileVC.bellTableView.reloadData()
//        profileVC.bell2TableView.reloadData()
        presentProfileController()
    }
    
    @objc func deleteCourse() {
        loadData()
        for course in globalVars.courses {
            if course.Name == globalVars.editingCourseName {
                let index = globalVars.courses.index(of: course)
                globalVars.courses.remove(at: index!)
                backToProfileVC()
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
        courseNameTF.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        courseNameTF.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        courseNameTF.heightAnchor.constraint(equalToConstant: 30).isActive = true
        courseNameTF.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        
        daySegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        daySegment.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        daySegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        daySegment.topAnchor.constraint(equalTo: courseNameTF.bottomAnchor, constant: 30).isActive = true
        
        blockSegment.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blockSegment.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        blockSegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        blockSegment.topAnchor.constraint(equalTo: daySegment.bottomAnchor, constant: 30).isActive = true
        
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.topAnchor.constraint(equalTo: blockSegment.bottomAnchor, constant: 30).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        deleteButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 30).isActive = true
        deleteButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        deleteButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    
}
