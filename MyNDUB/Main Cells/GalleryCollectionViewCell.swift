//
//  GalleryCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-05-05.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let cellID = "cellID"
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "NDUB's Gallery"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let cv: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 1.0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(titleLabel)
        addSubview(cv)
        
        cv.delegate = self
        cv.dataSource = self
        cv.register(GalleryImageCollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        cv.backgroundColor = .white
        
        setup()
        setupCollectionView()
    }
    
    func setupCollectionView() {
        cv.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        cv.heightAnchor.constraint(equalToConstant: bounds.height - 115).isActive = true
        cv.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        cv.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
    
    func setup() {
        titleLabel.widthAnchor.constraint(equalToConstant: bounds.width - 30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 50).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (bounds.width/3) - 2
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! GalleryImageCollectionViewCell
        cell.backgroundColor = .black
        
        if indexPath.row % 2 == 0 {
            cell.imageView.image = #imageLiteral(resourceName: "MUN1")
            
        } else if indexPath.row % 3 == 0 {
            cell.imageView.image = #imageLiteral(resourceName: "MUN2")
        } else {
            cell.imageView.image = #imageLiteral(resourceName: "MUN3")
        }
        return cell
    }
}

class GalleryImageCollectionViewCell: UICollectionViewCell {
    
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
        imageView.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}









