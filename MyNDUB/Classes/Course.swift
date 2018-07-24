//
//  Course.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-17.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import Foundation
import os.log

class Course: NSObject, NSCoding {
    struct Keys {
        static let Name = "name"
        static let Day = "day"
        static let Block = "block"
        static let Notes = "notes"
    }
    
    private var _name = ""
    private var _day: Int
    private var _block = ""
    private var _notes: [Notes]
    
    init(name: String, day: Int, block: String, notes: [Notes]) {
        _name = name
        _day = day
        _block = block
        _notes = notes
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let nameObj = aDecoder.decodeObject(forKey: Keys.Name) as? String {
            _name = nameObj
        }
        
        if let dayObj = aDecoder.decodeInteger(forKey: Keys.Day) as? Int {
            _day = dayObj
        } else {
            self._day = 1
        }
        
        if let blockObj = aDecoder.decodeObject(forKey: Keys.Block) as? String {
            _block = blockObj
        }
        
        if let notesObj = aDecoder.decodeObject(forKey: Keys.Notes) as? [Notes] {
            _notes = notesObj
        } else {
            _notes = []
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_name, forKey: Keys.Name)
        aCoder.encode(_day, forKey: Keys.Day)
        aCoder.encode(_block, forKey: Keys.Block)
        aCoder.encode(_notes, forKey: Keys.Notes)
    }
    
    var Name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    var Day: Int {
        get {
            return _day
        }
        set {
            _day = newValue
        }
    }
    
    var Block: String {
        get {
            return _block
        }
        set {
            _block = newValue
        }
    }
    
    var Notes: [Notes] {
        get {
            return _notes
        }
        set {
            _notes = newValue
        }
    }
}






