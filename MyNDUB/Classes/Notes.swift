//
//  Notes.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-17.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import Foundation

class Notes: NSObject, NSCoding {
    
    struct Keys {
        static let Title = "title"
        static let Text = "text"
    }
    
    private var _title = ""
    private var _text = ""
    
    init(title: String, text: String) {
        _title = title
        _text = text
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let titleObj = aDecoder.decodeObject(forKey: Keys.Title) as? String {
            self._title = titleObj
        }
        
        if let textObj = aDecoder.decodeObject(forKey: Keys.Text) as? String {
            self._text = textObj
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_title, forKey: Keys.Title)
        aCoder.encode(_text, forKey: Keys.Text)
    }
    
    var Title: String {
        get {
            return _title
        }
        set {
            _title = newValue
        }
    }
    
    var Text: String {
        get {
            return _text
        }
        set {
            _text = newValue
        }
    }
    
}
