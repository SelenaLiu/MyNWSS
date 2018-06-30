//
//  MenuBar.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-05-05.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellID = "cellID"
    
    var viewController: ViewController?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .orange
        return cv
    }()
    
    let centerButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "centerButton"), for: .normal)
        button.addTarget(self, action: #selector(ViewController.triggerBlurEffect), for: .touchDown)
        button.tintColor = .black
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHighlighted = false
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView.isScrollEnabled = false

        addSubview(collectionView)
        addSubview(centerButton)
        
        backgroundColor = .orange
        
        setup()
        let selectedIndexPath = IndexPath(item: 0, section: 0)

        collectionView.cellForItem(at: selectedIndexPath)?.isSelected = true
        self.collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: UICollectionViewScrollPosition(rawValue: 0))
    }
    
    func setup() {
        
        collectionView.widthAnchor.constraint(equalToConstant: 375).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        centerButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        centerButton.topAnchor.constraint(equalTo: topAnchor, constant: 7).isActive = true
        centerButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        centerButton.widthAnchor.constraint(equalToConstant: 40).isActive = true

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    let icons = [#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "calendar-with-spring-binder-and-date-blocks"), #imageLiteral(resourceName: "mapIcon"), #imageLiteral(resourceName: "NotesIcon"), #imageLiteral(resourceName: "man-user")]
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 3 || indexPath.item == 4 {
            viewController?.scrollToMenuIndex(menuIndex: indexPath.item - 1)
        } else if indexPath.item == 0 || indexPath.item == 1 {
            viewController?.scrollToMenuIndex(menuIndex: indexPath.item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 24
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = icons[indexPath.row].withRenderingMode(.alwaysTemplate)
        cell.imageView.tintColor = .black
        
        if indexPath.row == 2 {
            cell.imageView.isHidden = true
        }
//        if indexPath.row == 0 {
//                cell.backgroundColor = .blue
//            return cell
//        } else if indexPath.row == 1 {
//            cell.backgroundColor = .red
//
//            return cell
//        } else if indexPath.row == 2 {
//            cell.backgroundColor = .green
//
//            return cell
//        } else {
//            cell.backgroundColor = .black
//
//            return cell
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let length = 375/7
        return CGSize(width: CGFloat(length), height: CGFloat(length))
    }
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override var isSelected: Bool {
        didSet {
            imageView.tintColor = isSelected ? UIColor.white : UIColor.black
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        
        
        
        imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 375/7).isActive = true //375/7
        imageView.widthAnchor.constraint(equalToConstant: 375/11).isActive = true //375/11
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
















