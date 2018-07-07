//
//  ViewController.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-05-05.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, didClickCell {
    
    func didClick(segue: String) {
        performSegue(withIdentifier: segue, sender: self)
    }
    
    
    
    let cellIDs = ["homeCellID", "calendarCellID", "notesCellID", "profileCellID"]
    
    override open var shouldAutorotate: Bool {
        return false
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let centerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "xButton"), for: .normal)
        button.layer.cornerRadius = button.bounds.height/2
        button.addTarget(self, action: #selector(ViewController.triggerBlurEffect), for: .touchDown)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let galleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "gallery"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let directoryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "documentsIcon"), for: .normal)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let mapButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "mapIcon"), for: .normal)
        button.addTarget(self, action: #selector(ViewController.presentMapVC), for: .touchDown)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "restaurant"), for: .normal)
        button.addTarget(self, action: #selector(ViewController.presentMenuVC), for: .touchDown)
        button.contentMode = .scaleAspectFit
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.alpha = 0
        return blurEffectView
    }()
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    //BUTTON FUNCTIONS
    func handleBlurView() {
        UIView.animate(withDuration: 0.3) {
            self.menuBar.centerButton.setImage(#imageLiteral(resourceName: "centerButton"), for: .normal)
            self.blurEffectView.alpha = 0
            
            self.galleryButton.center = self.centerButton.center
            self.directoryButton.center = self.centerButton.center
            self.mapButton.center = self.centerButton.center
            self.menuButton.center = self.centerButton.center
        }
    }
    
    @objc func presentMapVC() {
        handleBlurView()
        
        let mapVC = mainStoryboard.instantiateViewController(withIdentifier: "MapVC")
        let navVC = UINavigationController(rootViewController: mapVC)
        present(navVC, animated: true, completion: nil)
    }
    
    @objc func presentMenuVC() {
        handleBlurView()
        
        let menuVC = mainStoryboard.instantiateViewController(withIdentifier: "CafVC")
        let navVC = UINavigationController(rootViewController: menuVC)
        present(navVC, animated: true, completion: nil)
    }
    var galleryCenter: CGPoint!
    var directoryCenter: CGPoint!
    var mapCenter: CGPoint!
    var menuCenter: CGPoint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(menuBar)
        view.addSubview(collectionView)
        menuBar.addSubview(centerButton)
        
        //view.backgroundColor = .white

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: cellIDs[0])
        collectionView.register(CalendarCollectionViewCell.self, forCellWithReuseIdentifier: cellIDs[1])
        collectionView.register(NotesCollectionViewCell.self, forCellWithReuseIdentifier: cellIDs[2])
        collectionView.register(ProfileCollectionViewCell.self, forCellWithReuseIdentifier: cellIDs[3])
        
        view.addSubview(blurEffectView)
        blurEffectView.contentView.addSubview(centerButton)
        blurEffectView.contentView.addSubview(galleryButton)
        blurEffectView.contentView.addSubview(directoryButton)
        blurEffectView.contentView.addSubview(mapButton)
        blurEffectView.contentView.addSubview(menuButton)
        

        blurEffectView.frame = view.bounds

        setup()
        
        setupMenuBar()
        setupBlurEffect()
        print("\(galleryButton.center)")
        
        galleryCenter = galleryButton.center
        directoryCenter = directoryButton.center
        mapCenter = mapButton.center
        menuCenter = menuButton.center
        
        galleryButton.center = centerButton.center
        directoryButton.center = centerButton.center
        mapButton.center = centerButton.center
        menuButton.center = centerButton.center
        
        menuBar.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        
    }
    
    
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.viewController = self
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    func setupBlurEffect() {
        centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerButton.topAnchor.constraint(equalTo: menuBar.topAnchor, constant: 10).isActive = true
        centerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        centerButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        galleryButton.rightAnchor.constraint(equalTo: directoryButton.leftAnchor, constant: -20).isActive = true
        galleryButton.bottomAnchor.constraint(equalTo: menuBar.topAnchor, constant: -10).isActive = true
        galleryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        galleryButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        galleryButton.center.x = view.bounds.width/2 - 100
        galleryButton.center.y = view.bounds.height - 100
        
        directoryButton.rightAnchor.constraint(equalTo: centerButton.centerXAnchor, constant: -10).isActive = true
        directoryButton.bottomAnchor.constraint(equalTo: galleryButton.topAnchor, constant: 10).isActive = true
        directoryButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        directoryButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        directoryButton.center.x = view.bounds.width/2 - 30
        directoryButton.center.y = view.bounds.height - 150
        
        mapButton.leftAnchor.constraint(equalTo: centerButton.centerXAnchor, constant: 10).isActive = true
        mapButton.bottomAnchor.constraint(equalTo: directoryButton.bottomAnchor).isActive = true
        mapButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        mapButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        mapButton.center.x = view.bounds.width/2 + 30
        mapButton.center.y = view.bounds.height - 150
        
        menuButton.leftAnchor.constraint(equalTo: mapButton.rightAnchor, constant: 20).isActive = true
        menuButton.bottomAnchor.constraint(equalTo: menuBar.topAnchor, constant: -10).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        menuButton.center.x = view.bounds.width/2 + 100
        menuButton.center.y = view.bounds.height - 100
        
        print("setup: \(galleryButton.center)")
    }
    
    @objc func triggerBlurEffect() {
        
        //blur screen, highlight button, animate buttons rolling out
        if blurEffectView.alpha == 0 {
            UIView.animate(withDuration: 0.3) {
                self.menuBar.centerButton.setImage(#imageLiteral(resourceName: "xButton"), for: .normal)
                self.blurEffectView.alpha = 1
                
                print("\(self.galleryCenter)")
                self.galleryButton.center = self.galleryCenter
                self.directoryButton.center = self.directoryCenter
                self.mapButton.center = self.mapCenter
                self.menuButton.center = self.menuCenter

            }
        } else {
            UIView.animate(withDuration: 0.3) {
                self.menuBar.centerButton.setImage(#imageLiteral(resourceName: "centerButton"), for: .normal)
                self.blurEffectView.alpha = 0
                
                self.galleryButton.center = self.centerButton.center
                self.directoryButton.center = self.centerButton.center
                self.mapButton.center = self.centerButton.center
                self.menuButton.center = self.centerButton.center
            }
        }
    }
    

    
    func setupMenuBar() {
        let margins = view.layoutMarginsGuide
        let height = view.bounds.height * 0.153
        menuBar.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: margins.layoutFrame.height * 0.088).isActive = true //80
        menuBar.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuBar.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
        
    }
    
    func setup() {
        let margins = view.layoutMarginsGuide
        collectionView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.88).isActive = true //0.88 0.847 margins.layoutFrame.height - (margins.layoutFrame.height * 0.08)
        collectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        centerButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerButton.topAnchor.constraint(equalTo: menuBar.topAnchor).isActive = true
        centerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        centerButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath, at: [], animated: true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        if index == 2 || index == 3 {
            let indexPath = IndexPath(item: Int(index + 1), section: 0)
            menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        } else if index == 0 || index == 1 {
            let indexPath = IndexPath(item: Int(index), section: 0)
            menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        }
        
    }
    
    @objc func presentAlertControllers() {
        let alertController = UIAlertController(title: "Add a course", message: "What course do you have in this block?", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Course Name"
        }
        
        present(alertController, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDs[indexPath.row], for: indexPath) as! HomeCollectionViewCell
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDs[1], for: indexPath) as! CalendarCollectionViewCell

            return cell
        } else if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDs[2], for: indexPath) as! NotesCollectionViewCell
            cell.delegate = self
            
            return cell
        } else if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDs[indexPath.row], for: indexPath) as! ProfileCollectionViewCell
            cell.bellTableView.reloadData()
            cell.delegate = self

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDs[1], for: indexPath) as! CalendarCollectionViewCell

            return cell
        }
        
        
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.bounds.height * 0.88)
    }
    
    
}

















