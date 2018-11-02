//
//  NoUserCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-10-21.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class NoUserCollectionViewCell: UICollectionViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.backgroundColor = .orange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let addEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.tintColor = UIColor.white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let promptLabel: UILabel = {
        let label = UILabel()
        label.text = "Please login to use this page"
        label.textAlignment = .center
        label.font = UIFont.italicSystemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        addSubview(addEditButton)
        addSubview(promptLabel)
        
        addEditButton.addTarget(self, action: #selector(NoUserCollectionViewCell.toLogin), for: .touchUpInside)
        
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.boldSystemFont(ofSize: bounds.width * 0.06)
        
        setup()
    }
    
    var delegate: didClickCell?
    
    @objc func toLogin() {
        delegate?.didClick(segue: "toOnboarding")
    }
    
    func setup() {
        
        addEditButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addEditButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addEditButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        addEditButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        
        titleLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: bounds.width * 0.2).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        promptLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        promptLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        promptLabel.heightAnchor.constraint(equalToConstant: bounds.width * 0.2).isActive = true
        promptLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
