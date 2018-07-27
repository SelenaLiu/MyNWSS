//
//  ProfileCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-03.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    var delegate: didClickCell?

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == bellTableView || tableView == bell2TableView {
            
            let blocks = ["A", "B", "C", "D", "Z"]
            let cell = tableView.cellForRow(at: indexPath) as! bellTableCell
            if cell.courseTextView.text == "Tap to edit/add a course" {
                globalVars.editingCourseName = ""
                globalVars.isEditingCourse = false
                globalVars.editingCourseBlock = blocks[indexPath.row]
            } else {
                globalVars.editingCourseName = cell.courseTextView.text
                globalVars.isEditingCourse = true
                
                for course in globalVars.courses {
                    if course.Name == cell.courseTextView.text {
                        globalVars.editingCourseBlock = blocks[indexPath.row]
                    }
                }
                //set editing course block and day
            }
            //presentAddCourse()
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.didClick(segue: "toAddCourseVC")
        } else if tableView == bookMarkedTableView {
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.didClick(segue: "toEventsDescription")
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.bounds.height/5)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == bellTableView || tableView == bell2TableView {
            return 5
        } else {
            return 5
        }
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("Data").path
    }
    var accountFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("AccountData").path
    }
    
    func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Course] {
            globalVars.courses = ourData
        }
    }
    func loadAccountData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: accountFilePath) as? Account {
            globalVars.accountInfo = ourData
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadData()

        if tableView == bellTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1ID", for: indexPath) as! bellTableCell
            let bellScheduleLabels = ["Block A: 8:35 - 10:00", "Block B: 10:08 - 11:26", "Block C: 12:15 - 1:36", "Block D: 1:42 - 3:05", "Block Z",]


            for course in globalVars.courses {

                if course.Day == 1 {
                    print("If Day == 1 : Course: \(course.Name), Day: \(course.Day), block: \(course.Block)")
                    if course.Block == "A" && indexPath.row == 0 {
                        print("First: course.block == A")
                        cell.courseTextView.text = course.Name
                    } else if course.Block == "B" && indexPath.row == 1 {
                        cell.courseTextView.text = course.Name
                    } else if course.Block == "C" && indexPath.row == 2 {
                        cell.courseTextView.text = course.Name
                    } else if course.Block == "D" && indexPath.row == 3 {
                        cell.courseTextView.text = course.Name
                    } else if course.Block == "Z" && indexPath.row == 4 {
                        cell.courseTextView.text = course.Name
                    }

                }


            }
            setFontsForBellSchedule(cell: cell)
            cell.timeTextView.text = bellScheduleLabels[indexPath.row]

            return cell
        } else if tableView == bell2TableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2ID", for: indexPath) as! bellTableCell
            let bellScheduleLabels = ["Block A: 8:35 - 10:00", "Block B: 10:08 - 11:26", "Block C: 12:15 - 1:36", "Block D: 1:42 - 3:05", "Block Z",]

            for course in globalVars.courses {
                if course.Day == 2 {
                    if course.Block == "A" && indexPath.row == 0 {
                        cell.courseTextView.text = course.Name
                    } else if course.Block == "B" && indexPath.row == 1 {
                        cell.courseTextView.text = course.Name
                    } else if course.Block == "C" && indexPath.row == 2 {
                        cell.courseTextView.text = course.Name
                    } else if course.Block == "D" && indexPath.row == 3 {
                        cell.courseTextView.text = course.Name
                    } else if course.Block == "Z" && indexPath.row == 4 {
                        cell.courseTextView.text = course.Name
                    }
                }

            }

            setFontsForBellSchedule(cell: cell)

            cell.timeTextView.text = bellScheduleLabels[indexPath.row]

            return cell
        } else if tableView == bookMarkedTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3ID", for: indexPath) as! EventsCell
            cell.nameTextView.text = globalVars.pastAndFutureEvents[indexPath.row].Title
            cell.messagetextView.text = globalVars.pastAndFutureEvents[indexPath.row].Description
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell4ID", for: indexPath)
            return cell
        }
    }
    
    func setFontsForBellSchedule(cell: bellTableCell) {
        if cell.courseTextView.text == "" || cell.courseTextView.text == nil || cell.courseTextView.text == "Tap to edit/add a course" {
            cell.courseTextView.text = "Tap to edit/add a course"
            cell.courseTextView.font = UIFont.italicSystemFont(ofSize: 13)
            cell.courseTextView.textColor = .lightGray
        } else {
            cell.courseTextView.font = UIFont.boldSystemFont(ofSize: 17)
            cell.courseTextView.textColor = .black
        }
    }
    
    
    let profileBackgroundColor = UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)

    let profileBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(displayP3Red: 29/255, green: 60/255, blue: 80/255, alpha: 1.0)//UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
        return view
    }()
    
    let roundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.contentMode = .scaleToFill
        imageView.image = #imageLiteral(resourceName: "cuteOwl")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let addEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        button.tintColor = .orange //UIColor(displayP3Red: 186, green: 226, blue: 227, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Tracy Zhou"
        textView.textAlignment = .center
        textView.backgroundColor = UIColor(displayP3Red: 29/255, green: 60/255, blue: 80/255, alpha: 1.0) //UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let gradeTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Student # / Grade"
        textView.textAlignment = .center
        textView.backgroundColor = UIColor(displayP3Red: 29/255, green: 60/255, blue: 80/255, alpha: 1.0) //UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.italicSystemFont(ofSize: 14)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.tintColor = .white
        segment.backgroundColor = UIColor(displayP3Red: 29/255, green: 60/255, blue: 80/255, alpha: 1.0)//UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
        segment.insertSegment(withTitle: "Bell Schedule", at: 0, animated: true)
        segment.insertSegment(withTitle: "School Info", at: 1, animated: true)
        segment.insertSegment(withTitle: "My Events", at: 2, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 0
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let daySegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.tintColor = .white
        segment.backgroundColor = .orange//UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
        segment.insertSegment(withTitle: "Day 1", at: 0, animated: true)
        segment.insertSegment(withTitle: "Day 2", at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 0
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let bookMarkedTableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    @objc func changeViews() {
        if segment.selectedSegmentIndex == 0 {
            self.schoolInfoView.isHidden = true
            if daySegment.selectedSegmentIndex == 0 {
                bellTableView.isHidden = false
                bell2TableView.isHidden = false
            } else {
                bellTableView.isHidden = true
                bell2TableView.isHidden = false
            }
            daySegment.isHidden = false
            bookMarkedTableView.isHidden = true

        } else if segment.selectedSegmentIndex == 1 {
            self.schoolInfoView.isHidden = false
            bellTableView.isHidden = true
            bell2TableView.isHidden = true
            daySegment.isHidden = true
            bookMarkedTableView.isHidden = true
        } else {
            self.schoolInfoView.isHidden = true
            bellTableView.isHidden = true
            bell2TableView.isHidden = true
            daySegment.isHidden = true
            bookMarkedTableView.isHidden = false
        }
    }
    
    
    //Subviews Setup
    let schoolInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let visitLabel: UITextView = {
        let tv = UITextView()
        tv.textContainer.lineBreakMode = .byWordWrapping
        tv.sizeToFit()
        tv.text = "Connect to NWSS's Social Media"
        tv.font = UIFont(name: "Superclarendon-Light", size: 20)
        tv.textAlignment = .center
        tv.isUserInteractionEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    let instagramButton = mediaButton()
    let twitterButton = mediaButton()
    let websiteButton = mediaButton()
    
    let schoolWebsiteTextView: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let schoolInstagram: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let schoolTwitter: UITextView = {
        let textView = UITextView()
        textView.textAlignment = .left
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 10
        stackView.backgroundColor = .orange
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let bellTableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()

    let bell2TableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
//    let bellTableView = BellTableView()
//    let bell2TableView = BellTableView2()
    
    @objc func changeTableViews() {
        if daySegment.selectedSegmentIndex == 0 {
            self.bell2TableView.isHidden = true
            self.bellTableView.isHidden = false
            globalVars.day = 1
        } else {
            self.bell2TableView.isHidden = false
            self.bellTableView.isHidden = true
            globalVars.day = 2
        }
    }
    
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    
    @objc func presentAddCourse() {
        delegate?.didClick(segue: "toAddCourseVC")
        
    }
    
    @objc func presentSettings() {
        delegate?.didClick(segue: "toSettings")
        
    }
    
    override func layoutSubviews() {
        loadAccountData()
        profileView.image = globalVars.accountInfo.ProfileImage
    }
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        addSubview(profileBackView)
        profileBackView.addSubview(nameTextView)
        //profileBackView.addSubview(gradeTextView)
        profileBackView.addSubview(roundView)
        
        addSubview(profileView)
        profileView.image = globalVars.accountInfo.ProfileImage
        addSubview(addEditButton)
        addEditButton.layer.shadowColor = UIColor.black.cgColor
        addEditButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        addEditButton.layer.shadowOpacity = 1.0
        addEditButton.layer.shadowRadius = 3
        addEditButton.addTarget(self, action: #selector(ProfileCollectionViewCell.presentSettings), for: .touchUpInside)

        segment.addTarget(self, action: #selector(ProfileCollectionViewCell.changeViews), for: .valueChanged)

        daySegment.addTarget(self, action: #selector(ProfileCollectionViewCell.changeTableViews), for: .valueChanged)
        addSubview(bell2TableView)
        bell2TableView.delegate = self
        bell2TableView.dataSource = self
        bellTableView.delegate = self
        bellTableView.dataSource = self
        addSubview(bellTableView)
        bellTableView.register(bellTableCell.self, forCellReuseIdentifier: "cell1ID")
        
        
        bell2TableView.register(bellTableCell.self, forCellReuseIdentifier: "cell2ID")
        
        addSubview(bookMarkedTableView)
        bookMarkedTableView.delegate = self
        bookMarkedTableView.dataSource = self
        bookMarkedTableView.register(EventsCell.self, forCellReuseIdentifier: "cell3ID")
        addSubview(schoolInfoView)
        addSubview(daySegment)
        addSubview(segment)
        segment.layer.shadowColor = UIColor.gray.cgColor
        segment.layer.shadowOffset = CGSize(width: 0, height: 3)
        segment.layer.shadowOpacity = 0.5
        segment.layer.shadowRadius = 3
        
        schoolInfoView.addSubview(visitLabel)
        schoolInfoView.addSubview(stackView)
        
        stackView.addArrangedSubview(websiteButton)
        stackView.addArrangedSubview(twitterButton)
        stackView.addArrangedSubview(instagramButton)
        
        instagramButton.setBackgroundImage(#imageLiteral(resourceName: "instagram"), for: .normal)
        twitterButton.setBackgroundImage(#imageLiteral(resourceName: "twitter logo"), for: .normal)
        websiteButton.setBackgroundImage(#imageLiteral(resourceName: "sd-40-logo"), for: .normal)
        
        instagramButton.addTarget(self, action: #selector(ProfileCollectionViewCell.handleInstagram), for: .touchDown)
        websiteButton.addTarget(self, action: #selector(ProfileCollectionViewCell.handleWebsite), for: .touchDown)
        twitterButton.addTarget(self, action: #selector(ProfileCollectionViewCell.handleTwitter), for: .touchDown)

        
        for course in globalVars.courses {
            print("Course Name: \(course.Name), Course Day: \(course.Day), Course Block: \(course.Block)")
        }


        schoolInfoView.isHidden = true
        self.profileView.layer.cornerRadius = bounds.width * 0.3/2
        self.roundView.layer.cornerRadius = bounds.width * 0.3/2
        self.roundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.roundView.layer.shadowRadius = 5
        self.roundView.layer.shadowColor = UIColor.gray.cgColor
        self.roundView.layer.shadowOpacity = 1
        self.roundView.layer.masksToBounds = false
        segment.layer.cornerRadius = 0
        setupLinks()
        setup()
    }
    
    @objc func handleInstagram() {
        UIApplication.shared.open(URL(string: "https://www.instagram.com/hyackfootball/")!, options: [:], completionHandler: nil)
    }
    
    @objc func handleTwitter() {
        UIApplication.shared.open(URL(string: "https://twitter.com/newwestschools?lang=en")!, options: [:], completionHandler: nil)
    }
    
    @objc func handleWebsite() {
        UIApplication.shared.open(URL(string: "https://nwss.ca/")!, options: [:], completionHandler: nil)
    }
    
    func setupLinks() {
        let link1Attributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: "https://nwss.ca/")!,
            .foregroundColor: UIColor.blue,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let link2Attributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: "https://www.instagram.com/nwssculinaryarts/")!,
            .foregroundColor: UIColor.blue,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        
        let link3Attributes: [NSAttributedStringKey: Any] = [
            .link: NSURL(string: "https://twitter.com/mrjtyler/")!,
            .foregroundColor: UIColor.blue,
            .font: UIFont.systemFont(ofSize: 17)
        ]
        let attributedString1 = NSMutableAttributedString(string: "school website")
        attributedString1.setAttributes(link1Attributes, range: NSMakeRange(0, 14))
        
        let attributedString2 = NSMutableAttributedString(string: "cafeteria's Instagram")
        attributedString2.setAttributes(link2Attributes, range: NSMakeRange(0, 21))
        
        let attributedString3 = NSMutableAttributedString(string: "Principle's Twitter")
        attributedString3.setAttributes(link3Attributes, range: NSMakeRange(0, 19))
        
        self.schoolWebsiteTextView.delegate = self
        self.schoolWebsiteTextView.attributedText = attributedString1
        self.schoolWebsiteTextView.isUserInteractionEnabled = true
        self.schoolWebsiteTextView.isEditable = false
        
        self.schoolInstagram.delegate = self
        self.schoolInstagram.attributedText = attributedString2
        self.schoolInstagram.isUserInteractionEnabled = true
        self.schoolInstagram.isEditable = false
        
        self.schoolTwitter.delegate = self
        self.schoolTwitter.attributedText = attributedString3
        self.schoolTwitter.isUserInteractionEnabled = true
        self.schoolTwitter.isEditable = false
    }
    
    func setup() {
        profileBackView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        profileBackView.heightAnchor.constraint(equalToConstant: bounds.height * 0.3).isActive = true
        profileBackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        profileBackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addEditButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addEditButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addEditButton.topAnchor.constraint(equalTo: profileBackView.topAnchor, constant: 10).isActive = true
        addEditButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        nameTextView.widthAnchor.constraint(equalToConstant: bounds.width/2).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameTextView.topAnchor.constraint(equalTo: profileView.bottomAnchor).isActive = true
        nameTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        
        profileView.widthAnchor.constraint(equalToConstant: bounds.width * 0.3).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: bounds.width * 0.3).isActive = true
        profileView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileView.centerYAnchor.constraint(equalTo: profileBackView.centerYAnchor).isActive = true
        
        roundView.widthAnchor.constraint(equalToConstant: bounds.width * 0.3).isActive = true
        roundView.heightAnchor.constraint(equalToConstant: bounds.width * 0.3).isActive = true
        roundView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        roundView.centerYAnchor.constraint(equalTo: profileBackView.centerYAnchor).isActive = true
        
        segment.topAnchor.constraint(equalTo: profileBackView.bottomAnchor).isActive = true
        segment.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        segment.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segment.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        daySegment.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        daySegment.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        daySegment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        daySegment.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bellTableView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bellTableView.topAnchor.constraint(equalTo: daySegment.bottomAnchor).isActive = true
        bellTableView.heightAnchor.constraint(equalToConstant: bounds.height * 0.7 - 70).isActive = true
        bellTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bell2TableView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bell2TableView.topAnchor.constraint(equalTo: daySegment.bottomAnchor).isActive = true
        bell2TableView.heightAnchor.constraint(equalToConstant: bounds.height * 0.7 - 70).isActive = true
        bell2TableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        visitLabel.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 10).isActive = true
        visitLabel.widthAnchor.constraint(equalToConstant: bounds.width - 20).isActive = true
        visitLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        visitLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        stackView.topAnchor.constraint(equalTo: visitLabel.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: bounds.width * 0.7).isActive = true
        stackView.centerXAnchor.constraint(equalTo: schoolInfoView.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: (80 * 3) + (10 * 3)).isActive = true
        
        schoolInfoView.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        schoolInfoView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        schoolInfoView.heightAnchor.constraint(equalToConstant: bounds.height / 3 * 2).isActive = true
        schoolInfoView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
        bookMarkedTableView.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        bookMarkedTableView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bookMarkedTableView.heightAnchor.constraint(equalToConstant: bounds.height / 3 * 2).isActive = true
        bookMarkedTableView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

class bellTableCell: UITableViewCell {
    
    
    let timeTextView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let courseTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Tap to edit/add a course"
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.italicSystemFont(ofSize: 13)
        textView.textColor = .lightGray
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(timeTextView)
        addSubview(courseTextView)
        
        setup()
    }
    
    func setup() {
        timeTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        timeTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        timeTextView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        timeTextView.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
        
        courseTextView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        courseTextView.leftAnchor.constraint(equalTo: centerXAnchor, constant: 10).isActive = true
        courseTextView.widthAnchor.constraint(equalToConstant: bounds.width/2).isActive = true
        courseTextView.heightAnchor.constraint(equalToConstant: bounds.height).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class mediaButton: UIButton {
    override func didMoveToWindow() {
        self.layer.cornerRadius = 5
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowRadius = 3
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 1
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}











