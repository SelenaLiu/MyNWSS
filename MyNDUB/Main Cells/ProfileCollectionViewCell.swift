//
//  ProfileCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-06-03.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    let profileBackgroundColor = UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)

    let profileBackView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .orange//UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
        return view
    }()
    
    let profileView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.orange.cgColor
        imageView.contentMode = .scaleToFill
        imageView.image = #imageLiteral(resourceName: "cuteOwl")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let addEditButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Add Courses", for: .normal)
        button.layer.cornerRadius = 5
        button.backgroundColor = .orange
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nameTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Tracy Zhou"
        textView.textAlignment = .center
        textView.backgroundColor = .orange //UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
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
        textView.backgroundColor = .orange //UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.italicSystemFont(ofSize: 14)
        textView.textColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.tintColor = .white
        segment.backgroundColor = .orange//UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
        segment.insertSegment(withTitle: "Bell Schedule", at: 0, animated: true)
        segment.insertSegment(withTitle: "School Info", at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.layer.cornerRadius = 0
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    @objc func changeViews() {
        if segment.selectedSegmentIndex == 0 {
            self.schoolInfoView.isHidden = true
            bellScheduleView.isHidden = false
        } else {
            self.schoolInfoView.isHidden = false
            bellScheduleView.isHidden = true
        }
    }
    
    //Subviews Setup
    
    let bellTextView: UITextView = {
        let textView = UITextView()
        textView.text = "BELL SCHEDULE IN PROGRESS"
        textView.textAlignment = .center
        textView.isUserInteractionEnabled = false
        textView.font = UIFont.boldSystemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let bellScheduleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let schoolInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
//    let goCardBackgroundBorder: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(displayP3Red: 180/256, green: 74/256, blue: 35/256, alpha: 1.0)
//        view.layer.cornerRadius = 5
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    let visitLabel: UILabel = {
        let label = UILabel()
        label.text = "Visit our school's websites:"
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
    
//    let editGoCardButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.setTitle("Edit", for: .normal)
//        button.setTitleColor(.darkGray, for: .normal)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
//    let goCardInfoView: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor(displayP3Red: 236/256, green: 236/256, blue: 236/256, alpha: 1)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
    
    let bellTableView: UITableView = {
        let tv = UITableView()
        tv.isScrollEnabled = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
//    let dateOfBirthLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Date of Birth"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let phoneNumberLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Phone Number"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let studentIDLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Student Identification Number"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
//
//    let addressLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Address"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        return label
//    }()
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        presentAddCourse()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(tableView.bounds.height/5)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    var filePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("Data").path
    }
    
    private func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: filePath) as? [Course] {
            globalVars.courses = ourData
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath) as! bellTableCell
        loadData()
        let bellScheduleLabels = ["Block A: 8:35 - 10:00", "Block B: 10:08 - 11:26", "Block C: 12:15 - 1:36", "Block D: 1:42 - 3:05", "Block Z",]
        
        for course in globalVars.courses {
            if course.Block == "A" {
                if indexPath.row == 0 {
                    cell.courseTextView.text = course.Name
                }
            } else if course.Block == "B" {
                if indexPath.row == 1 {
                    cell.courseTextView.text = course.Name
                }
            } else if course.Block == "C" {
                if indexPath.row == 2 {
                    cell.courseTextView.text = course.Name
                }
            } else if course.Block == "D" {
                if indexPath.row == 3 {
                    cell.courseTextView.text = course.Name
                }
            } else if course.Block == "Z" {
                if indexPath.row == 4 {
                    cell.courseTextView.text = course.Name
                }
            }
            
            if cell.courseTextView.text == "" || cell.courseTextView.text == nil || cell.courseTextView.text == "Tap to edit/add a course" {
                cell.courseTextView.text = "Tap to edit/add a course"
                cell.courseTextView.font = UIFont.italicSystemFont(ofSize: 13)
                cell.courseTextView.textColor = .lightGray
            } else {
                cell.courseTextView.font = UIFont.boldSystemFont(ofSize: 17)
                cell.courseTextView.textColor = .black
            }
        }
        cell.timeTextView.text = bellScheduleLabels[indexPath.row]
        //cell.courseTextView.text = courseScheduleLabels[indexPath.row]

        return cell
    }
    
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    
    var delegate: didClickCell?
    
    @objc func presentAddCourse() {
        delegate?.didClick(segue: "toAddCourseVC")
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileBackView)
        profileBackView.addSubview(nameTextView)
        profileBackView.addSubview(gradeTextView)
        addSubview(profileView)
        addSubview(addEditButton)
        addEditButton.addTarget(self, action: #selector(ProfileCollectionViewCell.presentAddCourse), for: .touchUpInside)

        addSubview(segment)
        segment.addTarget(self, action: #selector(ProfileCollectionViewCell.changeViews), for: .valueChanged)
        
        addSubview(bellScheduleView)
        bellScheduleView.addSubview(bellTextView)
        
        bellScheduleView.addSubview(bellTableView)
        bellTableView.register(bellTableCell.self, forCellReuseIdentifier: "cellID")
        bellTableView.delegate = self
        bellTableView.dataSource = self
        
        addSubview(schoolInfoView)
        schoolInfoView.addSubview(visitLabel)
        schoolInfoView.addSubview(stackView)
        stackView.addArrangedSubview(schoolWebsiteTextView)
        stackView.addArrangedSubview(schoolInstagram)
        stackView.addArrangedSubview(schoolTwitter)

        
        
//        schoolInfoView.addSubview(goCardBackgroundBorder)
//        schoolInfoView.addSubview(editGoCardButton)
//        goCardBackgroundBorder.addSubview(goCardInfoView)
    
        
        // Set the 'click here' substring to be the link
        
//        goCardInfoView.addSubview(dateOfBirthLabel)
//        goCardInfoView.addSubview(phoneNumberLabel)
//        goCardInfoView.addSubview(studentIDLabel)
//        goCardInfoView.addSubview(addressLabel)

        schoolInfoView.isHidden = true
        self.profileView.layer.cornerRadius = 50
        //addSubview(collectionView)
        //collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        
//        collectionView.delegate = self
//        collectionView.dataSource = self
        segment.layer.cornerRadius = 0
        setupLinks()
        setup()
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
        profileBackView.heightAnchor.constraint(equalToConstant: 210).isActive = true
        profileBackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        profileBackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        addEditButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        addEditButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        addEditButton.topAnchor.constraint(equalTo: profileBackView.topAnchor, constant: 20).isActive = true
        addEditButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        
        nameTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        nameTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameTextView.bottomAnchor.constraint(equalTo: gradeTextView.topAnchor).isActive = true
        nameTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        gradeTextView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        gradeTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        gradeTextView.bottomAnchor.constraint(equalTo: profileBackView.bottomAnchor).isActive = true
        gradeTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        profileView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        profileView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileView.centerYAnchor.constraint(equalTo: profileBackView.centerYAnchor).isActive = true
        
        segment.topAnchor.constraint(equalTo: profileBackView.bottomAnchor).isActive = true
        segment.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        segment.heightAnchor.constraint(equalToConstant: 30).isActive = true
        segment.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bellScheduleView.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        bellScheduleView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bellScheduleView.heightAnchor.constraint(equalToConstant: bounds.height - 240).isActive = true
        bellScheduleView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bellTableView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bellTableView.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        bellTableView.heightAnchor.constraint(equalToConstant: bounds.height - 250).isActive = true
        bellTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        bellTextView.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        bellTextView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        bellTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        bellTextView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
//        schoolWebsiteTextView.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
//        schoolWebsiteTextView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
//        schoolWebsiteTextView.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        schoolWebsiteTextView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        visitLabel.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        visitLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        visitLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        visitLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        stackView.topAnchor.constraint(equalTo: visitLabel.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: bounds.width - 20).isActive = true
        stackView.centerXAnchor.constraint(equalTo: schoolInfoView.centerXAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: (30 * 3) + (10 * 3)).isActive = true
        
        schoolInfoView.topAnchor.constraint(equalTo: segment.bottomAnchor).isActive = true
        schoolInfoView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        schoolInfoView.heightAnchor.constraint(equalToConstant: bounds.height / 3 * 2).isActive = true
        schoolInfoView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        
//        goCardBackgroundBorder.widthAnchor.constraint(equalToConstant: bounds.width - 30).isActive = true
//        goCardBackgroundBorder.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        goCardBackgroundBorder.heightAnchor.constraint(equalToConstant: bounds.height/3).isActive = true
//        goCardBackgroundBorder.topAnchor.constraint(equalTo: schoolInfoView.bottomAnchor, constant: 20).isActive = true
        
//        goCardInfoView.widthAnchor.constraint(equalToConstant: bounds.width - 30).isActive = true
//        goCardInfoView.heightAnchor.constraint(equalToConstant: bounds.height/3 - 30).isActive = true
//        goCardInfoView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
//        goCardInfoView.centerYAnchor.constraint(equalTo: goCardBackgroundBorder.centerYAnchor).isActive = true
        
//        editGoCardButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        editGoCardButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        editGoCardButton.rightAnchor.constraint(equalTo: goCardInfoView.rightAnchor).isActive = true
//        editGoCardButton.bottomAnchor.constraint(equalTo: goCardBackgroundBorder.topAnchor).isActive = true
        
//        dateOfBirthLabel.topAnchor.constraint(equalTo: goCardInfoView.topAnchor, constant: 20).isActive = true
//        dateOfBirthLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
//        dateOfBirthLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        dateOfBirthLabel.leftAnchor.constraint(equalTo: goCardInfoView.leftAnchor, constant: 10).isActive = true
//
//        phoneNumberLabel.topAnchor.constraint(equalTo: dateOfBirthLabel.topAnchor, constant: 20).isActive = true
//        phoneNumberLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        phoneNumberLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        phoneNumberLabel.leftAnchor.constraint(equalTo: goCardInfoView.leftAnchor, constant: 10).isActive = true
//
//        studentIDLabel.topAnchor.constraint(equalTo: phoneNumberLabel.topAnchor, constant: 20).isActive = true
//        studentIDLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        studentIDLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        studentIDLabel.leftAnchor.constraint(equalTo: goCardInfoView.leftAnchor, constant: 10).isActive = true
//
//        addressLabel.topAnchor.constraint(equalTo: studentIDLabel.topAnchor, constant: 20).isActive = true
//        addressLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        addressLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
//        addressLabel.leftAnchor.constraint(equalTo: goCardInfoView.leftAnchor, constant: 10).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}

class bellTableCell: UITableViewCell {
    
//    let addEditButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
//        button.setTitle("+ Course", for: .normal)
//        button.backgroundColor = .orange
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
    
    
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
        //addSubview(addEditButton)
        addSubview(timeTextView)
        addSubview(courseTextView)
        
        setup()
    }
    
    func setup() {
//        addEditButton.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
//        addEditButton.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        addEditButton.widthAnchor.constraint(equalToConstant: bounds.width/4).isActive = true
//        addEditButton.heightAnchor.constraint(equalToConstant: bounds.height/2).isActive = true
//
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










