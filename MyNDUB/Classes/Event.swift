//
//  Event.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-25.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import Foundation

class Event: NSObject, NSCoding {
    
    struct Keys {
        static let Title = "title"
        static let Description = "description"
        static let Date = "date"
        static let IsBookmarked = "isBookmarked"
    }
    
    private var _title = ""
    private var _description = ""
    private var _date = ""
    private var _isBookmarked: Bool
    
    init(title: String, description: String, date: String, isBookmarked: Bool) {
        _title = title
        _description = description
        _date = date
        _isBookmarked = isBookmarked
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let titleObj = aDecoder.decodeObject(forKey: Keys.Title) as? String {
            self._title = titleObj
        }
        
        if let descriptionObj = aDecoder.decodeObject(forKey: Keys.Description) as? String {
            self._description = descriptionObj
        }
        
        if let dateObj = aDecoder.decodeObject(forKey: Keys.Date) as? String {
            self._date = dateObj
        }
        
        if let isBookmarkedObj = aDecoder.decodeObject(forKey: Keys.IsBookmarked) as? Bool {
            self._isBookmarked = isBookmarkedObj
        } else {
            self._isBookmarked = false
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_title, forKey: Keys.Title)
        aCoder.encode(_description, forKey: Keys.Description)
        aCoder.encode(_date, forKey: Keys.Date)
        aCoder.encode(_isBookmarked, forKey: Keys.IsBookmarked)

    }
    
    var Title: String {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var Description: String {
        get {
            return _description
        }
        set {
            _description = newValue
        }
    }
    
    var Date: String {
        get {
            return _date
        }
        set {
            _date = newValue
        }
    }
    
    var IsBookmarked: Bool {
        get {
            return _isBookmarked
        }
        set {
            _isBookmarked = newValue
        }
    }
    
}

