//
//  CalendarCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-23.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCell: JTAppleCell {
    
    let label: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setup() {
        
        label.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: rightAnchor, constant: -2).isActive = true
        label.topAnchor.constraint(equalTo: topAnchor).isActive = true
    }
    
    
}
