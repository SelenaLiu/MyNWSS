//
//  HomeCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-05-05.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    
    
    let cellID = "cellID"
    
    let headlinePageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
        pageControl.tintColor = .white
        pageControl.pageIndicatorTintColor = .black
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let headlineCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .horizontal
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        let images: [UIImage] = [#imageLiteral(resourceName: "Heading"), #imageLiteral(resourceName: "Heading2"), #imageLiteral(resourceName: "Heading3"), #imageLiteral(resourceName: "Heading4")]
        cell.backgroundColor = UIColor(patternImage: images[indexPath.row])
        //cell.view.backgroundColor = UIColor(patternImage: images[indexPath.row])
        
        return cell
    }
    
    
    let logo: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "SchoolLogo")
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "#GoHyacks!"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dateTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Day 1 | Monday June 3rd, 2018"//"May 7th, 2018 \nDay 1"
        textView.textColor = .white
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 10)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    let eventsLabel: UITextView = {
        let label = UITextView()
        label.text = "Recent"
        label.isUserInteractionEnabled = false
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.backgroundColor = UIColor(displayP3Red: 236/255, green: 236/255, blue: 236/255, alpha: 1)
        label.textContainerInset = UIEdgeInsetsMake(13, 30, 10, 0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventsTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(headlineCollectionView)
        headlineCollectionView.addSubview(headlinePageControl)
        addSubview(dateTextView)
        addSubview(eventsLabel)
        addSubview(eventsTableView)
        
        
        headlineCollectionView.delegate = self
        headlineCollectionView.dataSource = self
        headlineCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        headlineCollectionView.isPagingEnabled = true
        
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventsTableView.register(EventsCell.self, forCellReuseIdentifier: cellID)
        
        setup()
        setupTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupTableView() {
        eventsTableView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        eventsTableView.heightAnchor.constraint(equalToConstant: bounds.height - 190).isActive = true
        eventsTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        eventsTableView.topAnchor.constraint(equalTo: eventsLabel.bottomAnchor).isActive = true
    }
    
    func setup() {
        headlineCollectionView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        headlineCollectionView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        headlineCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headlineCollectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        headlinePageControl.widthAnchor.constraint(equalToConstant: 100).isActive = true
        headlinePageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        headlinePageControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        headlinePageControl.bottomAnchor.constraint(equalTo: headlineCollectionView.bottomAnchor, constant: 10).isActive = true
        
//        logo.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        logo.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        logo.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
//        logo.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//
        dateTextView.widthAnchor.constraint(equalToConstant: 180).isActive = true
        dateTextView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        dateTextView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        dateTextView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//
//        titleLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        titleLabel.centerYAnchor.constraint(equalTo: logo.centerYAnchor).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: logo.rightAnchor, constant: 30).isActive = true
        
        eventsLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        eventsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        eventsLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        eventsLabel.topAnchor.constraint(equalTo: headlineCollectionView.bottomAnchor).isActive = true
    }
    
    var delegate: didClickCell?
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didClick(segue: "toEventsDescription")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let heights = [130, 100, 100, 130, 100, 100, 120]
        return CGFloat(heights[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    let nameTextViews = ["Music Department", "Hyack Football", "Math Department", "Honour Society Club", "NWSS Model UN Club", "Debate Club", "NWSS Interact Club"]
    let descriptionViews = ["Come and join us for an evening of jazz at Heretage Grill for NWSS's jazz night! Featuring award-winning senior jazz students!", "Players prepare for practices on Tuesday's and Thursday's after school", "Come by room 227 for reimbursments for 2017-2018 math contests", "Let your parents know about the HS Gala on May 30th in the school's library! Tickets are 8$ pre-order and 10$ at the door!", "Register for Prince of Wales MUN by May 25th, late fees are 25$", "Meetings Tuesdays at lunch and Thursday's after school", "Bubble tea sale on Thursday! Come by the pearson foyer for 5$ bubble tea, and help support our cause!"]
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! EventsCell
        
        cell.nameTextView.text = nameTextViews[indexPath.row]
        cell.messagetextView.text = descriptionViews[indexPath.row]
        
        return cell
    }
}

class EventsCell: UITableViewCell {
    
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "ProfileIcon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let messagetextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .gray
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        addSubview(nameTextView)
        addSubview(messagetextView)
        
        setup()
    }
    
    func setup() {
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        nameTextView.widthAnchor.constraint(equalToConstant: bounds.width - 70).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameTextView.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameTextView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        
        messagetextView.widthAnchor.constraint(equalToConstant: bounds.width - 30).isActive = true
        messagetextView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        messagetextView.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 8).isActive = true
        messagetextView.topAnchor.constraint(equalTo: nameTextView.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class ImageCell: UICollectionViewCell {
    let view: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(view)
        
        setup()
    }
    
    func setup() {
        view.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        view.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        view.topAnchor.constraint(equalTo: topAnchor).isActive = true
        view.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

protocol didClickCell {
    func didClick(segue: String)
}














