//
//  WIPViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-22.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class WIPViewController: UIViewController {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Work in Progress"
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
        button.addTarget(self, action: #selector(WIPViewController.dismissVC), for: .touchDown)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.sizeToFit()
        tv.text = "Hello fellow user, as you may know, myNDUB is still in its developing stages. This page is currently still under construction. Please check back in the next update!"
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        titleLabel.layer.shadowColor = UIColor.gray.cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.width * 0.06)
        
        view.addSubview(backView)
        view.addSubview(titleLabel)
        view.addSubview(backButton)
        view.addSubview(textView)
        setup()
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setup() {
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        backView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        backView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        backView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        backView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.2).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        backButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        
        
    }
    


}
