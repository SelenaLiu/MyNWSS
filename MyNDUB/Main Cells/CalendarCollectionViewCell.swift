//
//  CalendarCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-05-06.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarCollectionViewCell: UICollectionViewCell, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    
    let formatter = DateFormatter()
    let outsideMonthColor = UIColor(displayP3Red: 184/256, green: 184/256, blue: 184/256, alpha: 1)
    let monthColor = UIColor.black
    let dateSelectedTextColor = UIColor.white
    let dateNotSelectedTextColor = UIColor(displayP3Red: 50/256, green: 50/256, blue: 50/256, alpha: 1)
    let selectedCellColor = UIColor.orange
    let notSelectedCellColor = UIColor(displayP3Red: 250/256, green: 250/256, blue: 250/256, alpha: 1)

    
    
    //Day Subviews
    let dayLabel1: UILabel = {
        let label = UILabel()
        label.text = "Sun"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayLabel2: UILabel = {
        let label = UILabel()
        label.text = "Mon"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayLabel3: UILabel = {
        let label = UILabel()
        label.text = "Tue"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayLabel4: UILabel = {
        let label = UILabel()
        label.text = "Wed"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let dayLabel5: UILabel = {
        let label = UILabel()
        label.text = "Thu"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let dayLabel6: UILabel = {
        let label = UILabel()
        label.text = "Fri"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let dayLabel7: UILabel = {
        let label = UILabel()
        label.text = "Sat"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    //Other Subviews
    let monthYearLabel: UILabel = {
        let label = UILabel()
        label.text = "May 2018"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.semanticContentAttribute = .forceLeftToRight
        stackView.backgroundColor = .orange
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let calendarCollectionView: JTAppleCalendarView = {
        let cv = JTAppleCalendarView(frame: .zero)
        cv.scrollDirection = .horizontal
        cv.backgroundColor = UIColor(displayP3Red: 236/256, green: 236/256, blue: 236/256, alpha: 1)
        cv.isPagingEnabled = true
        cv.layer.cornerRadius = 5
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let schoolDayLabel: UILabel = {
        let label = UILabel()
        label.text = "Day 1"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(monthYearLabel)
        addSubview(stackView)
        stackView.addArrangedSubview(dayLabel1)
        stackView.addArrangedSubview(dayLabel2)
        stackView.addArrangedSubview(dayLabel3)
        stackView.addArrangedSubview(dayLabel4)
        stackView.addArrangedSubview(dayLabel5)
        stackView.addArrangedSubview(dayLabel6)
        stackView.addArrangedSubview(dayLabel7)
        
        addSubview(calendarCollectionView)
        calendarCollectionView.calendarDelegate = self
        calendarCollectionView.calendarDataSource = self
        calendarCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "cellID")
        
        calendarCollectionView.selectDates([Date()], triggerSelectionDelegate: false)
        
        addSubview(schoolDayLabel)
        setupCalendarView()
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func setupCalendarView() {
        calendarCollectionView.minimumLineSpacing = 1
        calendarCollectionView.minimumInteritemSpacing = 1
        
        calendarCollectionView.visibleDates { (visibleDates) in
            self.setupViewsFromCalendar(from: visibleDates)
        }
    }
    
    func setupViewsFromCalendar(from visibleDates: DateSegmentInfo) {
        let date = visibleDates.monthDates.first!.date
        
        self.formatter.dateFormat = "MMM yyyy"
        
        self.monthYearLabel.text = self.formatter.string(from: date)
    }
    
    func handleColorChanges(cell: JTAppleCell?, cellState: CellState) {
        guard let validCell = cell as? CalendarCell else { return }
        
        if validCell.isSelected {
            validCell.backgroundColor = selectedCellColor
            validCell.label.textColor = dateSelectedTextColor
        } else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.label.textColor = monthColor
            } else {
                validCell.label.textColor = outsideMonthColor
            }
            
            formatter.dateFormat = "yyyy-MM-dd"
            let cellDate = formatter.string(from: cellState.date)
            let today = formatter.string(from: Date())
            if cellDate == today {
                validCell.backgroundColor = .gray
            } else {
                validCell.backgroundColor = notSelectedCellColor

            }
        }
    }
    
    func handleTextChanges(cell: JTAppleCell?, cellState: CellState) {
        //change schoolDayLabel text here
        guard let validCell = cell as? CalendarCell else { return }
        
        formatter.dateFormat = "MMMM dd"
        let date = formatter.string(from: cellState.date)
        if validCell.isSelected == true {
            schoolDayLabel.text = "\(date): ____ events"
        }
        
    }
    
    
    func setup() {
        
        let margins = layoutMarginsGuide
        monthYearLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        monthYearLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        monthYearLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        monthYearLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalToConstant: bounds.width - 30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stackView.topAnchor.constraint(equalTo: monthYearLabel.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        calendarCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        calendarCollectionView.widthAnchor.constraint(equalToConstant: bounds.width - 30).isActive = true
        calendarCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        calendarCollectionView.heightAnchor.constraint(equalToConstant: bounds.height/1.5).isActive = true
        
        schoolDayLabel.leftAnchor.constraint(equalTo: calendarCollectionView.leftAnchor).isActive = true
        schoolDayLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        schoolDayLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        schoolDayLabel.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor, constant: 10).isActive = true
    }

    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let cell = cell as! CalendarCell
        print("calendar")

        sharedFunction(myCell: cell, cellState: cellState, date: date)
    }
    

    func sharedFunction(myCell: CalendarCell, cellState: CellState, date: Date) {
        myCell.label.text = cellState.text
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        print("configureCalendar")
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        
        let startDate = formatter.date(from: "2018-06-04")
        let endDate = formatter.date(from: "2019-06-21")
        
        let parameters = ConfigurationParameters(startDate: startDate!, endDate: endDate!)
        return parameters
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        formatter.dateFormat = "yyyy-MM-dd"
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cellID", for: indexPath) as! CalendarCell
        cell.backgroundColor = UIColor(displayP3Red: 250/256, green: 250/256, blue: 250/256, alpha: 1)
        sharedFunction(myCell: cell, cellState: cellState, date: date)
        handleColorChanges(cell: cell, cellState: cellState)
        
        let cellDate = formatter.string(from: date)
        let today = formatter.string(from: Date())
        if cellDate == today {
            cell.backgroundColor = .gray
        }

        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleColorChanges(cell: cell, cellState: cellState)
        handleTextChanges(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleColorChanges(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsFromCalendar(from: visibleDates)
    }
    
    
}







