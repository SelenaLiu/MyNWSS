//
//  BellTableView.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-23.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class BellTableView: UITableView, UITableViewDataSource {
    
    override func didMoveToWindow() {
        self.isScrollEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        //self.delegate = self
        self.dataSource = self
    }
    
    var didClickDelegate: didClickCell?
    
    
    @objc func presentAddCourse() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let navVC = UINavigationController(rootViewController: storyboard.instantiateViewController(withIdentifier: "AddEditCourseVC"))
        if let topController = UIApplication.shared.keyWindow?.rootViewController {
            topController.present(navVC, animated: true, completion: nil)
        }
        
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let blocks = ["A", "B", "C", "D", "Z"]
//        let cell = tableView.cellForRow(at: indexPath) as! bellTableCell
//        if cell.courseTextView.text == "Tap to edit/add a course" {
//            globalVars.editingCourseName = ""
//            globalVars.isEditingCourse = false
//            globalVars.editingCourseBlock = blocks[indexPath.row]
//        } else {
//            globalVars.editingCourseName = cell.courseTextView.text
//            globalVars.isEditingCourse = true
//
//            for course in globalVars.courses {
//                if course.Name == cell.courseTextView.text {
//                    globalVars.editingCourseBlock = blocks[indexPath.row]
//                }
//            }
//            //set editing course block and day
//        }
//        //presentAddCourse()
//        tableView.deselectRow(at: indexPath, animated: true)
//        didClickDelegate?.didClick(segue: "toAccountVC")
//    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.bounds.height/5)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("Data").path
    }
    
    
    func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Course] {
            globalVars.courses = ourData
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! bellTableCell
        loadData()
        let bellScheduleLabels = ["Block A: 8:35 - 10:00", "Block B: 10:08 - 11:26", "Block C: 12:15 - 1:36", "Block D: 1:42 - 3:05", "Block Z",]
        
        
        for course in globalVars.courses {
            if course.Day == 1 {
                if course.Block == "A" {
                    if indexPath.row == 0 {
                        cell.courseTextView.text = course.Name
                    }
                } else if course.Block == "B" {
                    if indexPath.row == 1 {
                        cell.courseTextView.text = course.Name
                    }
                } else if course.Block == "C" {
                    if indexPath.row == 2 {
                        cell.courseTextView.text = course.Name
                    }
                } else if course.Block == "D" {
                    if indexPath.row == 3 {
                        cell.courseTextView.text = course.Name
                    }
                } else if course.Block == "Z" {
                    if indexPath.row == 4 {
                        cell.courseTextView.text = course.Name
                    }
                }
            } else {
                cell.courseTextView.text = "Tap to edit/add a course"
                cell.courseTextView.font = UIFont.italicSystemFont(ofSize: 13)
                cell.courseTextView.textColor = .lightGray
            }
            
            
            if cell.courseTextView.text == "" || cell.courseTextView.text == nil || cell.courseTextView.text == "Tap to edit/add a course" {
                cell.courseTextView.text = "Tap to edit/add a course"
                cell.courseTextView.font = UIFont.italicSystemFont(ofSize: 13)
                cell.courseTextView.textColor = .lightGray
            } else {
                cell.courseTextView.font = UIFont.boldSystemFont(ofSize: 17)
                cell.courseTextView.textColor = .black
            }
        }
        cell.timeTextView.text = bellScheduleLabels[indexPath.row]
        //cell.courseTextView.text = courseScheduleLabels[indexPath.row]
        
        return cell
    }
}
