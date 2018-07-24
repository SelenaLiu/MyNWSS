//
//  WIPViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-07-22.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class WIPViewController: UIViewController {
    
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
        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 41/255, green: 40/255, blue: 52/255, alpha: 1.0)

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(MapViewController.dismissVC))
        self.navigationItem.title = "Work in Progress"

        view.addSubview(textView)
        textView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.9).isActive = true
        textView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    @objc func dismissVC() {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
