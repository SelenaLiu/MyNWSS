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
        imageView.image = #imageLiteral(resourceName: "eventBackground")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleBlurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 1
        return blurEffectView
    }()
    
    let descriptionBlurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.translatesAutoresizingMaskIntoConstraints = false
        blurEffectView.alpha = 1
        return blurEffectView
    }()
    
    let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "TITLE OF EVENT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.text = "This would be where the description of the event shows up. HAOSLDFIE ;alksjdf TIS THAIS DFJK ALSIJ AMAASIN IAHS JALSIDJF IAJ SDIFSI Is it wrapping yet?"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descriptionTextView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.textContainer.lineBreakMode = .byCharWrapping
        tv.sizeToFit()
        tv.text = "This would be where the description of the event shows up. HAOSLDFIE ;alksjdf TIS THAIS DFJK ALSIJ AMAASIN IAHS JALSIDJF IAJ SDIFSI Is it wrapping yet?"
        tv.font = UIFont.systemFont(ofSize: 17)
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .orange
        
        self.navigationItem.title = "Group"
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(EventViewController.dismissVC))
        self.navigationItem.leftBarButtonItem = backButton
        
        view.addSubview(backgroundImage)
        view.addSubview(descriptionBlurEffectView)
        view.addSubview(titleBlurEffectView)
        descriptionBlurEffectView.layer.cornerRadius = 10
        titleBlurEffectView.layer.cornerRadius = 10
        descriptionBlurEffectView.clipsToBounds = true
        titleBlurEffectView.clipsToBounds = true

        titleBlurEffectView.contentView.addSubview(eventTitleLabel)
        descriptionBlurEffectView.contentView.addSubview(descriptionTextView)
        descriptionBlurEffectView.contentView.addSubview(descriptionLabel)
        
        setup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func setup() {
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        backgroundImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        eventTitleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 50).isActive = true
        eventTitleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        eventTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        eventTitleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        titleBlurEffectView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        titleBlurEffectView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        titleBlurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleBlurEffectView.centerYAnchor.constraint(equalTo: eventTitleLabel.centerYAnchor).isActive = true
        
        descriptionTextView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        descriptionTextView.heightAnchor.constraint(equalToConstant: descriptionTextView.contentSize.height).isActive = true
        descriptionTextView.topAnchor.constraint(equalTo: titleBlurEffectView.bottomAnchor, constant: 15).isActive = true
        descriptionTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        descriptionLabel.heightAnchor.constraint(equalToConstant: descriptionTextView.contentSize.height).isActive = true
        descriptionLabel.topAnchor.constraint(equalTo: titleBlurEffectView.bottomAnchor, constant: 15).isActive = true
        descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionBlurEffectView.widthAnchor.constraint(equalToConstant: view.bounds.width - 40).isActive = true
        descriptionBlurEffectView.heightAnchor.constraint(equalToConstant: descriptionTextView.contentSize.height).isActive = true
        descriptionBlurEffectView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        descriptionBlurEffectView.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 15).isActive = true
    }

}






