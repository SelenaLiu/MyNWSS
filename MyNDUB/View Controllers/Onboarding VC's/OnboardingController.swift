//
//  LoginViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-21.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class OnboardingViewController: UIViewController {
    
    let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Welcome to"
        label.textAlignment = .center
        label.textColor = .orange
        return label
    }()
    
    let logoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "My NWSS"
        label.textAlignment = .center
        label.textColor = .orange
        return label
    }()
    
    let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(OnboardingViewController.toLogin), for: .touchDown)
        button.setTitleColor(.white, for: .normal)
        
        button.layer.cornerRadius = 10
        return button
    }()
    
    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .orange
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(OnboardingViewController.toSignUp), for: .touchDown)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    @objc func toLogin() {
        performSegue(withIdentifier: "toLogin", sender: self)
    }
    
    @objc func toSignUp() {
        performSegue(withIdentifier: "toSignUp", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "toMainVC", sender: self)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(welcomeLabel)
        view.addSubview(logoLabel)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        
        setup()
        setupFonts()
    }
    
    func setupFonts() {
        welcomeLabel.font = UIFont.boldSystemFont(ofSize: view.bounds.width * 0.05)
        logoLabel.font = UIFont.systemFont(ofSize: view.bounds.width * 0.15)
        loginButton.titleLabel?.font = UIFont.systemFont(ofSize: view.bounds.width * 0.05)
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: view.bounds.width * 0.05)
    }
    
    func setup() {
        
        logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        logoLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        logoLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor).isActive = true
        
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.04).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        
        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        loginButton.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.09).isActive = true
        loginButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: view.bounds.width * 0.09).isActive = true
        signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
