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
    
    let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.contentMode = .scaleToFill
        //imageView.image = #imageLiteral(resourceName: "cuteOwl")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let changePictureButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("change profile picture", for: .normal)
        button.addTarget(self, action: #selector(SettingsViewController.handleSelectProfileImage), for: .touchDown)
        button.setTitleColor(.lightGray, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Trazy Zhou"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "tzhou@gmail.com"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let editEmailButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit", for: .normal)
        button.setTitleColor(.orange, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 7
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(SettingsViewController.handleEdit), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.backgroundColor = .orange
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout >", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.setTitleColor(.orange, for: .normal)
        button.backgroundColor = .clear
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func handleLoadAccountData() {
        let user = Auth.auth().currentUser?.uid
        var imageURL = ""
        Database.database().reference().child("users").child(user!).observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String:AnyObject] {
                self.nameLabel.text = dictionary["name"] as? String
                imageURL = dictionary["profileImage"] as! String
                self.emailLabel.text = dictionary["email"] as? String
            }
            
            
            let url = URL(string: imageURL)

            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error!)
                    return
                }
                DispatchQueue.main.sync {
                    self.profileView.image = UIImage(data: data!)
                    print("NewMessagesVC: CELLIMAGE = \(UIImage(data: data!)?.size)")
                    
                }
                
            }).resume()
        }, withCancel: nil)
    }
    
    func handleEmailData() {
        //change email data
//        let user = Auth.auth().currentUser?.uid
//        Database.database().reference().child("users").child(user!).chil
//        let ref = Database.database().reference(fromURL: "https://mynwss.firebaseio.com/").child("users")
//        var usernameRef = ref.child((Auth.auth().currentUser?.uid)!)
//        usernameRef.
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 41/255, green: 40/255, blue: 52/255, alpha: 1.0)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(SettingsViewController.dismissVC))
        self.navigationItem.title = "Settings"
        
        view.backgroundColor = UIColor(displayP3Red: 29/255, green: 60/255, blue: 80/255, alpha: 1.0)
        view.addSubview(profileView)
        profileView.image = globalVars.accountInfo.ProfileImage
        view.addSubview(changePictureButton)
        view.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        //handleLoadAccountData()

        
        stackView.addArrangedSubview(emailLabel)
        view.addSubview(editEmailButton)
        view.addSubview(logoutButton)
        logoutButton.addTarget(self, action: #selector(SettingsViewController.handleLogout), for: .touchDown)
        //view.addSubview(daySwitch)
        
        setup()
        profileView.layer.cornerRadius = view.bounds.width * 0.3/2
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
        profileView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        
        changePictureButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        changePictureButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        changePictureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        changePictureButton.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 10).isActive = true
        
        stackView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.2).isActive = true
        stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        stackView.topAnchor.constraint(equalTo: changePictureButton.bottomAnchor, constant: 10).isActive = true
        
        editEmailButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        editEmailButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        editEmailButton.centerYAnchor.constraint(equalTo: emailLabel.centerYAnchor).isActive = true
        editEmailButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        logoutButton.widthAnchor.constraint(equalToConstant: view.bounds.width/2).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        logoutButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoutButton.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true

    }
    
    @objc func handleEdit() {
        let alertController = UIAlertController(title: "Email Address", message: "Please enter your new email address", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {(alertAction: UIAlertAction) in
            let emailAddress = alertController.textFields?[0].text
            self.handleEmailData()
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            
            if emailTest.evaluate(with: emailAddress) {
                self.emailLabel.text = emailAddress!
                let alertController = UIAlertController(title: "New Email Address", message: "This new email address will now be used for your login authentication.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction: UIAlertAction) in
                    
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Invalid email address", message: "Please try again", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (alertAction: UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAction)
                self.present(alertController, animated: true, completion: nil)
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addTextField(configurationHandler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    @objc func handleSelectProfileImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
        picker.allowsEditing = true
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(info)
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] {
            selectedImageFromPicker = editedImage as! UIImage
            globalVars.accountInfo.ProfileImage = selectedImageFromPicker!
            NSKeyedArchiver.archiveRootObject(globalVars.accountInfo, toFile: filePath)
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] {
            selectedImageFromPicker = originalImage as! UIImage
            globalVars.accountInfo.ProfileImage = selectedImageFromPicker!
            NSKeyedArchiver.archiveRootObject(globalVars.accountInfo, toFile: filePath)
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileView.image = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleLogout() {
        try! Auth.auth().signOut()
        self.performSegue(withIdentifier: "toLoginVC", sender: self)
    }

}
