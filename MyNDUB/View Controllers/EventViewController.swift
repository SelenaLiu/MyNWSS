//
//  EventViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-24.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class EventViewController: UIViewController {
    
    var inspectingEvent: Event = Event(title: "", description: "", date: "", isBookmarked: false)
    
    var eventFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("EventData").path
    }
    
    func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: eventFilePath) as? [Event] {
            globalVars.pastAndFutureEvents = ourData
        }
    }
    
    let backView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "xButton"), for: .normal)
        button.addTarget(self, action: #selector(EventViewController.handleDismiss), for: .touchDown)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.text = globalVars.eventDate
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
        descriptionTextView.heightAnchor.constraint(equalToConstant: (view.safeAreaLayoutGuide.layoutFrame.height * 0.7) - 15).isActive = true
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        view.backgroundColor = .orange
        navigationController?.navigationBar.tintColor = .orange
        
        for event in globalVars.pastAndFutureEvents {
            if event.Title == globalVars.eventTitle {
                inspectingEvent = event
            }
        }
        
        print("EventVC: inpecting event", inspectingEvent.Title, inspectingEvent.IsBookmarked)
        view.addSubview(backView)
        view.addSubview(backgroundView)
        backgroundView.layer.shadowColor = UIColor.gray.cgColor
        backgroundView.layer.shadowOpacity = 1
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 4)
        backgroundView.layer.shadowRadius = 2
        view.addSubview(backButton)
        view.addSubview(eventTitleLabel)
        view.addSubview(dateLabel)
        view.addSubview(descriptionTextView)
        
        print(inspectingEvent.IsBookmarked)
        
        setup()
    }
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    @objc func dismissVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.present(storyboard.instantiateViewController(withIdentifier: "MainVC"), animated: true, completion: nil)
        //dismiss(animated: true, completion: nil)
    }
    
    func setup() {
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        
        backButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.1).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.1).isActive = true
        backButton.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true

        backView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        backView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        backView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor).isActive = true
        backView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        eventTitleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        eventTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventTitleLabel.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        
        dateLabel.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        dateLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.1).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        
        descriptionTextView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 15).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        

    }

}






