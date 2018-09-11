//
//  SignUpViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-27.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    let backgroundImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "LoginBackground")
        imageView.alpha = 0.7
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Sign Up"
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 50)
        return label
    }()
    
    let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 5
        imageView.isUserInteractionEnabled = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.contentMode = .scaleToFill
        imageView.layer.masksToBounds = true
        imageView.image = #imageLiteral(resourceName: "cuteOwl")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameTextField: inputTextField = {
        let textField = inputTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "First and Last Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return textField
    }()
    
    let emailTextField: inputTextField = {
        let textField = inputTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return textField
    }()
    
    let passwordTextField: inputTextField = {
        let textField = inputTextField()
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        return textField
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.layer.borderWidth = 2.0
        button.layer.borderColor = UIColor.white.cgColor
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.setTitle("Back", for: .normal)
        button.addTarget(self, action: #selector(SignUpViewController.dismissVC), for: .touchDown)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    var bottomConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        super.viewDidLoad()
        view.backgroundColor = .orange
        view.addSubview(backgroundImage)
        view.addSubview(titleLabel)
        view.addSubview(profileView)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(doneButton)
        view.addSubview(backButton)
        doneButton.addTarget(self, action: #selector(SignUpViewController.handleRegister), for: .touchDown)
        
        bottomConstraint = NSLayoutConstraint(item:  self.backButton, attribute: NSLayoutAttribute.bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        setup()
        
        profileView.layer.cornerRadius = view.bounds.width * 0.3 / 2
        profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.handleSelectProfileImage)))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.bottomConstraint?.constant = -(rect.height + 20)
            }
        }
    }

    @objc func handleRegister() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        guard let name = self.nameTextField.text else { return }
        guard let image = profileView.image else { return }
        print("SignUpVC: ", name, email)
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Email Address", message: error?.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("User created!")
                
                guard let uid = user?.uid else {
                    return
                }
                let imageUID = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("profile_images").child("\(imageUID).png")
                if let uploadData = UIImagePNGRepresentation(self.profileView.image!) {
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        
                        if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                            let values = ["name": name, "email": email, "profileImage": profileImageURL]
                            self.registerUserIntoDatabaseUsingUID(uid: uid, values: values)
                            
                        }
                        
                    })
                    
                }
                self.performSegue(withIdentifier: "toHome", sender: self)
            }
        }
        
        
    }
    
    private func registerUserIntoDatabaseUsingUID(uid: String, values: [String:Any]) {
        let ref = Database.database().reference(fromURL: "https://mynwss.firebaseio.com/")
        let usersReference = ref.child("users").child(uid)
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
            // successfully saved user into Firebase Database
            
        })
    }
    
//    func uploadProfileImage(_ image: UIImage, completion: @escaping ((_ url: URL?) -> ())) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("users/\(uid)")
//
//        guard let imageData = UIImageJPEGRepresentation(image, 0.75) else { return }
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "img/jpg"
//        storageRef.putData(imageData, metadata: metaData) { metaData, error in
//            if error != nil {
//                print (error)
//            } else {
//                //success!
//                if let url = metaData?.downloadURL() {
//                    completion(url)
//                } else {
//                    completion(nil)
//                }
//            }
//        }
//    }
    
    func setup() {
        backgroundImage.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImage.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        backgroundImage.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        
        profileView.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        profileView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        
        nameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        nameTextField.topAnchor.constraint(equalTo: profileView.bottomAnchor, constant: 30).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 10).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        backButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        backButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor, constant: 10).isActive = true
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        doneButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.3).isActive = true
        doneButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 50).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
}

extension SignUpViewController {
    var accountFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("AccountData").path
    }
}
