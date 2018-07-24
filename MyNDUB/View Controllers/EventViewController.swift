//
//  EventViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-24.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "EventBackground-1")
        imageView.alpha = 0.5
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 10
        imageView.layer.shadowOpacity = 1
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .orange
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = globalVars.eventTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.sizeToFit()
        tv.isEditable = false
        tv.isScrollEnabled = true
        tv.text = globalVars.eventDescription
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.isUserInteractionEnabled = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    

    override func viewDidLayoutSubviews() {
        backgroundView.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height * 0.3).isActive = true
        backgroundImage.heightAnchor.constraint(equalToConstant: view.safeAreaLayoutGuide.layoutFrame.height * 0.3).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: (view.safeAreaLayoutGuide.layoutFrame.height * 0.7) - 15).isActive = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 41/255, green: 40/255, blue: 52/255, alpha: 1.0)

        self.navigationItem.title = "Event Details"
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(EventViewController.dismissVC))
        self.navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(backgroundView)
        view.addSubview(backgroundImage)
        view.addSubview(eventTitleLabel)
        view.addSubview(descriptionTextView)

        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func setup() {
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true

        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        eventTitleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        eventTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventTitleLabel.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor).isActive = true
        

        
        descriptionTextView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: backgroundImage.bottomAnchor, constant: 15).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        

    }

}






