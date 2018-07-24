//
//  CafCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-05-05.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit

class CafViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    let cellID = "cellID"
    let foodImages = [#imageLiteral(resourceName: "pizzaImage"), #imageLiteral(resourceName: "pastaImage"), #imageLiteral(resourceName: "BeefAndRiceImage"), #imageLiteral(resourceName: "burgerImage"), #imageLiteral(resourceName: "chipotleWrapImage"), #imageLiteral(resourceName: "cranberryMuffinsImage"), #imageLiteral(resourceName: "GardenSalad"), #imageLiteral(resourceName: "hummusImage")]
    let foodNames = ["Pepperoni Pizza",
                     "Alfredo Pasta",
                     "Mexican Beef and Rice",
                     "Chicken Burger",
                     "Chipotle Chicken Wrap",
                     "Cranberry Muffins",
                     "Garden Salad",
                     "Hummus and Pita"]
    let foodInfo = ["$2.00/slice",
                    "$3.00/bowl, recommended by cafeteria staff",
                    "$4.00/bowl",
                    "$4.50 - includes fries as a side dish",
                    "$3.50 - crispy chicken with lettuce and chipotle sauce",
                    "$1.50/muffin",
                    "$3.00/plate - vegetarian option",
                    "$2.50 - vegetarian option"]
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Today's Cafeteria Menu"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let menuTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .orange
        self.navigationController?.navigationBar.backgroundColor = UIColor(displayP3Red: 41/255, green: 40/255, blue: 52/255, alpha: 1.0)

        self.navigationItem.title = "Today's Menu"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(CafViewController.dismissVC))
        
        view.backgroundColor = .white
        
        view.addSubview(titleLabel)
        view.addSubview(menuTableView)
        
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.register(FoodCell.self, forCellReuseIdentifier: cellID)
        
        setup()
        setupTableView()
    }
    
    @objc func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupTableView() {
        menuTableView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        menuTableView.heightAnchor.constraint(equalToConstant: view.bounds.height - 115).isActive = true
        menuTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        menuTableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
    }
    
    func setup() {
        titleLabel.widthAnchor.constraint(equalToConstant: view.bounds.width - 30).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! FoodCell
        
        cell.foodImageView.image = foodImages[indexPath.row]
        cell.nameLabel.text = foodNames[indexPath.row]
        cell.infoLabel.text = foodInfo[indexPath.row]
        
        return cell
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

class FoodCell: UITableViewCell {
    
    let foodImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let infoLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textColor = .darkGray
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
        addSubview(foodImageView)
        addSubview(nameLabel)
        addSubview(infoLabel)
        
        
        setup()
    }
    
    func setup() {
        foodImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        foodImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        foodImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        foodImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        
        nameLabel.widthAnchor.constraint(equalToConstant: bounds.width - 70).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: 8).isActive = true
        
        infoLabel.widthAnchor.constraint(equalToConstant: bounds.width - 70).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        infoLabel.leftAnchor.constraint(equalTo: foodImageView.rightAnchor, constant: 8).isActive = true
        infoLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
}















