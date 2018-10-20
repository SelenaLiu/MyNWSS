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
    
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Create an Account"
        label.textAlignment = .center
        label.textColor = .orange
        label.font = UIFont.systemFont(ofSize: 40)
        return label
    }()
    
    let nameTextField: inputTextField = {
        let textField = inputTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "First and Last Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        return textField
    }()
    
    let emailTextField: inputTextField = {
        let textField = inputTextField()
        textField.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        return textField
    }()
    
    let passwordTextField: inputTextField = {
        let textField = inputTextField()
        textField.isSecureTextEntry = true
        textField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        return textField
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle("Continue", for: .normal)
        button.addTarget(self, action: #selector(SignUpViewController.handleDone), for: .touchDown)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle("Back", for: .normal)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(SignUpViewController.dismissVC), for: .touchDown)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    var isConnectedToInternet = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                self.isConnectedToInternet = true
            }
        })

        view.addSubview(titleLabel)
        view.addSubview(nameTextField)
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(doneButton)
        view.addSubview(backButton)
        doneButton.addTarget(self, action: #selector(SignUpViewController.handleRegister), for: .touchDown)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SignUpViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        setup()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    @objc func handleDone() {
        if isConnectedToInternet {
            handleRegister()
        } else {
            let alertVC = UIAlertController(title: "Connection Failure", message: "You are not currently connected to a network. Please reconnect before you change your courses.", preferredStyle: .alert)
            alertVC.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let info = notification.userInfo {
            
            let rect: CGRect = info["UIKeyboardFrameEndUserInfoKey"] as! CGRect
            
            self.view.layoutIfNeeded()
            
            UIView.animate(withDuration: 0.25) {
                self.view.layoutIfNeeded()
                self.backButton.frame.origin.y = (self.view.frame.height - rect.height - self.backButton.frame.height - 10)
                self.doneButton.frame.origin.y = (self.backButton.frame.origin.y - self.doneButton.frame.height - 10)
                self.passwordTextField.frame.origin.y = (self.doneButton.frame.origin.y - self.passwordTextField.frame.height - 10)
                self.emailTextField.frame.origin.y = (self.passwordTextField.frame.origin.y - self.emailTextField.frame.height - 10)
                self.nameTextField.frame.origin.y = (self.emailTextField.frame.origin.y - self.nameTextField.frame.height - 10)
                self.titleLabel.frame.origin.y = (self.nameTextField.frame.origin.y - self.titleLabel.frame.height - 30)
                
            }
        }
    }

    @objc func handleRegister() {
        guard let email = self.emailTextField.text else { return }
        guard let password = self.passwordTextField.text else { return }
        guard let name = self.nameTextField.text else { return }
        print("SignUpVC: ", name, email)
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                let alertController = UIAlertController(title: "Email Address", message: error?.localizedDescription, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                alertController.addAction(cancelAction)
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("User created!")
                
                //guard let uid = user?.uid else {
                let currentUserUID = Auth.auth().currentUser?.uid
                
                let values = ["name": name, "email": email, "courses": []] as [String : Any]
                self.registerUserIntoDatabaseUsingUID(uid: currentUserUID!, values: values)
                
                    return

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
    
    
    func setup() {
        
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.08).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: nameTextField.topAnchor, constant: -30).isActive = true
        
        
        nameTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -10).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.08).isActive = true
        
        emailTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -10).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.08).isActive = true
        
        passwordTextField.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.8).isActive = true
        passwordTextField.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -10).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.08).isActive = true
        
        doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        doneButton.bottomAnchor.constraint(equalTo: backButton.topAnchor, constant: -10).isActive = true
        
        backButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        backButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(view.bounds.height/3)).isActive = true
        
        
    }
}

extension SignUpViewController {
    var accountFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("AccountData").path
    }
}
