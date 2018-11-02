//
//  ProfileCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-03.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import Firebase

class ProfileCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    var delegate: didClickCell?
    
    let profileBackgroundColor = UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
    
    
    let addEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        button.tintColor = UIColor.black
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Profile"
        label.backgroundColor = .orange
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.tintColor = .white
        segment.backgroundColor = UIColor.darkGray
        segment.insertSegment(withTitle: "Bell Schedule", at: 0, animated: true)
        segment.insertSegment(withTitle: "School Info", at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 0
        segment.layer.masksToBounds = true
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    let daySegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.tintColor = .white
        segment.backgroundColor = UIColor.darkGray//UIColor(displayP3Red: 228/255, green: 56/255, blue: 57/255, alpha: 1.0)
        segment.insertSegment(withTitle: "Day 1", at: 0, animated: true)
        segment.insertSegment(withTitle: "Day 2", at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 0
        segment.layer.masksToBounds = true
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    
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
        tv.font = UIFont.systemFont(ofSize: 20)
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
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    let bell2TableView: UITableView = {
        let tv = UITableView()
        tv.isHidden = true
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    var courseFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("Data").path
    }
    
    func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: courseFilePath) as? [Course] {
            globalVars.courses = ourData
        }
    }
    
    func getCourseData() {
        loadData()
        globalVars.courses = []
        
        // retreives course data from Firebase
        let currentUserUID = Auth.auth().currentUser?.uid

        Database.database().reference().child("users").child(currentUserUID!).child("courses").observeSingleEvent(of: .value, with: { (snapshot) in
            let courseDict = snapshot.value as? [String : [String:Any]]
            print("COURSE DICT: ", courseDict)
            if courseDict != nil {
                for value in courseDict! {
                    let name = value.key
                    let block = value.value["block"] as! String
                    let day = value.value["day"] as! Int
                    let notesValue = value.value["notes"] as? [String:String]
                    var notes: [Notes] = []
                    if notesValue != nil {
                        for note in notesValue! {
                            let noteTitle = note.key
                            let noteText = note.value
                            notes.append(Notes(title: noteTitle, text: noteText))
                        }
                    }

                    let course = Course(name: name, day: day, block: block, notes: notes)
                    globalVars.courses.append(course)
                    NSKeyedArchiver.archiveRootObject(globalVars.courses, toFile: self.courseFilePath)
                    self.bellTableView.reloadData()
                    self.bell2TableView.reloadData()
                }
            }

        })
    }
    
    
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
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.bounds.height/5)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    var accountFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("AccountData").path
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
            cell.selectionStyle = .none
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
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell2ID", for: indexPath) as! bellTableCell
            cell.selectionStyle = .none
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
        }
    }
    
    func setFontsForBellSchedule(cell: bellTableCell) {
        if cell.courseTextView.text == "" || cell.courseTextView.text == nil || cell.courseTextView.text == "Tap to edit/add a course" {
            cell.courseTextView.text = "Tap to edit/add a course"
            cell.courseTextView.font = UIFont.italicSystemFont(ofSize: cell.frame.width * 0.04)
            cell.courseTextView.textColor = .lightGray
        } else {
            cell.courseTextView.font = UIFont.boldSystemFont(ofSize: cell.frame.width * 0.045)
            cell.courseTextView.textColor = .black
        }
        
        cell.timeTextView.font = UIFont.systemFont(ofSize: cell.frame.width * 0.045)
    }
    
    
    
    
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

        } else if segment.selectedSegmentIndex == 1 {
            self.schoolInfoView.isHidden = false
            bellTableView.isHidden = true
            bell2TableView.isHidden = true
            daySegment.isHidden = true
        } else {
            self.schoolInfoView.isHidden = true
            bellTableView.isHidden = true
            bell2TableView.isHidden = true
            daySegment.isHidden = true
        }
    }
    
    
    
    
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
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        loadData()
        print("ProfileVC: ", globalVars.accountInfo.Name, globalVars.accountInfo.Email, globalVars.accountInfo.ProfileImage)
        
        //Checks for connection to internet to see what to load for courses
        let connectedRef = Database.database().reference(withPath: ".info/connected")
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                print("Connected")
                self.getCourseData()
            } else {
                print("Not connected")
                self.loadData()
                self.bellTableView.reloadData()
                self.bell2TableView.reloadData()
            }
        })
        
        addSubview(daySegment)
        addSubview(segment)
        addSubview(titleLabel)
        titleLabel.layer.shadowColor = UIColor.black.cgColor
        titleLabel.layer.shadowOpacity = 0.5
        titleLabel.layer.shadowOffset = CGSize(width: 0, height: 3)
        titleLabel.layer.shadowRadius = 3
        titleLabel.font = UIFont.boldSystemFont(ofSize: bounds.width * 0.06)
        addSubview(addEditButton)
        
//        addEditButton.layer.shadowColor = UIColor.black.cgColor
//        addEditButton.layer.shadowOffset = CGSize(width: 0, height: 0)
//        addEditButton.layer.shadowOpacity = 1.0
//        addEditButton.layer.shadowRadius = 3
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
        
        addSubview(schoolInfoView)
        
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

        

        schoolInfoView.isHidden = true
        segment.layer.cornerRadius = 0
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
    
    func setup() {
        
        addEditButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        addEditButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        addEditButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        addEditButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        titleLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: bounds.width * 0.2).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        
        segment.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        segment.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        segment.heightAnchor.constraint(equalToConstant: bounds.width * 0.15).isActive = true
        segment.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        daySegment.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        daySegment.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        daySegment.heightAnchor.constraint(equalToConstant: bounds.width * 0.1).isActive = true
        daySegment.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bellTableView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bellTableView.topAnchor.constraint(equalTo: daySegment.bottomAnchor).isActive = true
        bellTableView.heightAnchor.constraint(equalToConstant: bounds.height - (bounds.width * 0.45)).isActive = true
        bellTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bell2TableView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bell2TableView.topAnchor.constraint(equalTo: daySegment.bottomAnchor).isActive = true
        bell2TableView.heightAnchor.constraint(equalToConstant: bounds.height - (bounds.width * 0.45)).isActive = true
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
        timeTextView.font = UIFont.systemFont(ofSize: frame.height * 0.35)
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











