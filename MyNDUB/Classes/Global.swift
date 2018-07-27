//
//  Global.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-14.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import Foundation
import UIKit

let globalVars = Global()

@IBDesignable
class Global {
    
    var accountInfo = Account(profileImage: UIImage(named: "cuteOwl")!, email: "")
    
    var eventTitle = ""
    var eventDescription = ""
    
    var pastAndFutureEvents: [Event]
    
    var notes = ""
    var day = 1
    var courses: [Course]
    var refreshNow = true
    
    var setCourse: Course
    
    var isEditingCourse: Bool = false
    var isViewingNote: Bool = false
    
    var viewingNote: Notes
    
    var editingCourseName: String = ""
    var editingCourseBlock: String = ""
    var editingCourseDay: Int = 1
    var editingCourseIndex: Int = 0
    var justAddedCourse: Bool = false
    
    var courseNotesName: String = ""
    
    init() {
        pastAndFutureEvents = []
        courses = []
        setCourse = Course(name: "", day: 0, block: "", notes: [])
        viewingNote = Notes(title: "", text: "")
    }

}

