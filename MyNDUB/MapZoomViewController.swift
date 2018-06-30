//
//  MapZoomViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-08.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class MapZoomViewController: UIViewController {
    
    let image: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(image)
        setup()
    }
    
    func setup() {
        image.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        image.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        image.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

}
