//
//  Account.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-24.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import Foundation
import UIKit

class Account: NSObject, NSCoding {
    
    struct Keys {
        static let ProfileImage = "profileImage"
        static let Name = "name"
        static let Email = "email"
    }
    
    private var _profileImage: UIImage
    private var _name = ""
    private var _email = ""
    
    init(profileImage: UIImage, name: String, email: String) {
        _profileImage = profileImage
        _name = name
        _email = email
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let profileImageObj = aDecoder.decodeObject(forKey: Keys.ProfileImage) as? UIImage {
            self._profileImage = profileImageObj
        } else {
            self._profileImage = UIImage(named: "cuteOwl")!
        }
        
        if let nameObj = aDecoder.decodeObject(forKey: Keys.Name) as? String {
            self._name = nameObj
        }
        
        if let emailObj = aDecoder.decodeObject(forKey: Keys.Email) as? String {
            self._email = emailObj
        }
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(_profileImage, forKey: Keys.ProfileImage)
        aCoder.encode(_name, forKey: Keys.Name)
        aCoder.encode(_email, forKey: Keys.Email)
    }
    
    var ProfileImage: UIImage {
        get {
            return _profileImage
        }
        set {
            _profileImage = newValue
        }
    }
    
    var Name: String {
        get {
            return _name
        }
        set {
            _name = newValue
        }
    }
    
    var Email: String {
        get {
            return _email
        }
        set {
            _email = newValue
        }
    }
    
}
