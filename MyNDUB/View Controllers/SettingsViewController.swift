//
//  SettingsViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-23.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let daySwitch: UISwitch = {
        let s = UISwitch()
        s.isOn = true
        s.translatesAutoresizingMaskIntoConstraints = false
        s.tintColor = .orange
        return s
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Settings"
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
        button.addTarget(self, action: #selector(SettingsViewController.handleDismiss), for: .touchDown)
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = ""//UserDefaults.value(forKey: "userEmail") as! String
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let turnOnLabel: UILabel = {
        let label = UILabel()
        label.text = "Turn on your thinking cap"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let capSwitch: UISwitch = {
        let cswitch = UISwitch()
        cswitch.isOn = false
        cswitch.tintColor = UIColor.orange
        cswitch.onTintColor = .orange
        cswitch.translatesAutoresizingMaskIntoConstraints = false
        return cswitch
    }()
    
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .orange
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func handleDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        view.backgroundColor = .orange
        view.addSubview(backView)
        view.addSubview(titleLabel)
        titleLabel.layer.shadowColor = UIColor.gray.cgColor
        titleLabel.layer.shadowOpacity = 1
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 4)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.width * 0.06)
        view.addSubview(backButton)
        view.addSubview(emailLabel)
        view.addSubview(turnOnLabel)
        view.addSubview(capSwitch)
        view.addSubview(logoutButton)

        let currentUserUID = Auth.auth().currentUser?.uid
        let ref = Database.database().reference(fromURL: "https://mynwss.firebaseio.com/")
        let usersReference = ref.child("users").child(currentUserUID!)
        
        usersReference.child("email").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? String
            print(value)
            self.emailLabel.text = "Email: \(value!)"
            print(self.emailLabel.text)
        }
        
        logoutButton.addTarget(self, action: #selector(SettingsViewController.handleLogout), for: .touchDown)
        
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
        
        emailLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        emailLabel.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.2).isActive = true
        emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 30).isActive = true
        emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        turnOnLabel.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        turnOnLabel.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.2).isActive = true
        turnOnLabel.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 15).isActive = true
        turnOnLabel.leftAnchor.constraint(equalTo: emailLabel.leftAnchor).isActive = true
        
        capSwitch.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.2).isActive = true
        capSwitch.centerYAnchor.constraint(equalTo: turnOnLabel.centerYAnchor).isActive = true
        capSwitch.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        logoutButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

    }
    
    
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("AccountData").path
    }
    
    
    func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? Account {
            globalVars.accountInfo = ourData
        }
    }
    
    var courseFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("Data").path
    }
    
    private func loadCourseData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Course] {
            globalVars.courses = ourData
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        try! Auth.auth().signOut()
        globalVars.courses = []
        NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: courseFilePath)
        self.performSegue(withIdentifier: "toLoginVC", sender: self)
    }

}
