//
//  MapCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-08.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class MapViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //COLLECTIONVIEW SETUP
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    
    //VIEWDIDLOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //SETUP NAVIGATION CONTROLLER
        navigationController?.navigationBar.tintColor = .orange
        
        self.navigationItem.title = "School Map"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(MapViewController.dismissVC))
        
        
        view.addSubview(collectionView)
        collectionView.register(SideCollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        collectionView.isPagingEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        view.backgroundColor = .white
        
        setup()
    }
    
    //FUNCTIONS
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath) as! SideCollectionViewCell
        
        if indexPath.row == 0 {
            cell.topImage.image = #imageLiteral(resourceName: "MasseyUpper")
            cell.bottomImage.image = #imageLiteral(resourceName: "MasseyLower")
            cell.label.text = "Swipe left for Pearson Wing"
        } else {
            cell.topImage.image = #imageLiteral(resourceName: "PearsonUpper")
            cell.bottomImage.image = #imageLiteral(resourceName: "PearsonLower")
            cell.label.text = "Swipe right for Massey Wing"

        }
        
        return cell
    }
    
    func setup() {
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.bounds.height).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

class SideCollectionViewCell: UICollectionViewCell {
    let topImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let bottomImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SideCollectionViewCell.showPicture))
        addSubview(topImage)
        topImage.addGestureRecognizer(tapGesture)
        addSubview(bottomImage)
        bottomImage.addGestureRecognizer(tapGesture)
        
        addSubview(label)
        
        setup()
    }
    
    func setup() {
        topImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImage.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        topImage.heightAnchor.constraint(equalToConstant: bounds.height/2).isActive = true
        topImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bottomImage.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        bottomImage.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bottomImage.heightAnchor.constraint(equalToConstant: bounds.height/2).isActive = true
        bottomImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    @objc func showPicture() {
        let singleViewMapController = MapZoomViewController()
        let viewController = ViewController()
        let navController = UINavigationController(rootViewController: singleViewMapController)
        viewController.present(navController, animated: true, completion: nil)
        print("this Happened")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
