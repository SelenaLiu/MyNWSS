//
//  SettingsViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-23.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    let daySwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = true
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = .orange
        return s
    }()
    
    let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.contentMode = .scaleToFill
        
        imageView.image = #imageLiteral(resourceName: "cuteOwl")
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 41/255, green: 40/255, blue: 52/255, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(SettingsViewController.dismissVC))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(SettingsViewController.saveSettings))
        self.navigationItem.title = "Settings"
        
        view.backgroundColor = UIColor(displayP3Red: 29/255, green: 60/255, blue: 80/255, alpha: 1.0)
        view.addSubview(daySwitch)
        
        setup()
    }
    
    @objc func saveSettings() {
        if daySwitch.isOn {
            UserDefaults.setValue(true, forKey: "Alternating Day Format")
        } else {
            UserDefaults.setValue(false, forKey: "Alternating Day Format")
        }
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        daySwitch.widthAnchor.constraint(equalToConstant: 50).isActive = true
        daySwitch.heightAnchor.constraint(equalToConstant: 30).isActive = true
        daySwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        daySwitch.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
