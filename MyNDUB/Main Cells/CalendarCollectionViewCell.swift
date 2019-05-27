//
//  CalendarCollectionViewCell.swift
//  MyNDUB
//
//  Created by Selena Liu on 2018-05-06.
//  Copyright © 2018 Selena Liu. All rights reserved.
//

import UIKit
import JTAppleCalendar
import Firebase

class CalendarCollectionViewCell: UICollectionViewCell, JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource, UITableViewDelegate, UITableViewDataSource {
   
    
    let formatter = DateFormatter()
    let outsideMonthColor = UIColor(displayP3Red: 184/256, green: 184/256, blue: 184/256, alpha: 1)
    let monthColor = UIColor.black
    let dateSelectedTextColor = UIColor.white
    let dateNotSelectedTextColor = UIColor(displayP3Red: 50/256, green: 50/256, blue: 50/256, alpha: 1)
    let selectedCellColor = UIColor.orange
    let eventCellColor = UIColor(displayP3Red: 251/256, green: 199/256, blue: 107/256, alpha: 0.5)
    let notSelectedCellColor = UIColor(displayP3Red: 250/256, green: 250/256, blue: 250/256, alpha: 1)
    
    var eventCounter = 0
    var eventTitles: [String] = []

    var eventFilePath: String {
        let manager = FileManager.default
        let url = manager.urls(for: .documentDirectory, in: .userDomainMask).first
        
        return url!.appendingPathComponent("EventData").path
    }
    
    func loadData() {
        if let ourData = NSKeyedUnarchiver.unarchiveObject(withFile: eventFilePath) as? [Event] {
            globalVars.pastAndFutureEvents = ourData
        }
    }
    
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
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM dd"
        label.text = formatter.string(from: Date())
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let eventTableView: UITableView = {
        let tv = UITableView()
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
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
        
//        let connectedRef = Database.database().reference(withPath: ".info/connected")
//        connectedRef.observe(.value, with: { snapshot in
//            if let connected = snapshot.value as? Bool, connected {
//                print("Connected")
//                self.getEventData()
//            }
//        })
        
        addSubview(calendarCollectionView)
        calendarCollectionView.calendarDelegate = self
        calendarCollectionView.calendarDataSource = self
        calendarCollectionView.register(CalendarCell.self, forCellWithReuseIdentifier: "cellID")
        
        calendarCollectionView.selectDates([Date()], triggerSelectionDelegate: false)
        calendarCollectionView.scrollToDate(Date(), animateScroll: false)
        calendarCollectionView.scrollingMode = .stopAtEachCalendarFrame
        let date = self.formatter.string(from: Date())
        print("Date: ", date)
        
        addSubview(schoolDayLabel)
        addSubview(eventTableView)
        eventTableView.delegate = self
        eventTableView.dataSource = self
        eventTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        setupCalendarView()
        setup()
    }
    
//    @objc func getEventData() {
//        loadData()
//        globalVars.pastAndFutureEvents = []
//        eventTitles = []
//
//        // adds the new event to the top of the tableView
//        Database.database().reference().child("Events").queryOrderedByKey().observe(.childAdded) { (snapshot) in
//            self.calendarCollectionView.reloadData()
//        }
//
//        // deletes the event from the tableView
//        Database.database().reference().child("Events").observe(.childRemoved) { (snapshot) in
//            self.calendarCollectionView.reloadData()
//        }
//
//    }
    
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
            var eventDates: [String] = []
            for event in globalVars.pastAndFutureEvents {
                formatter.dateFormat = "MM/dd/yyyy"
                let date1 = formatter.date(from: event.Date)
                let stringDate = formatter.string(from: date1!)
                eventDates.append(stringDate)
            }
            //formatter.dateFormat = "yyyy-MM-dd"
            let cellDate = formatter.string(from: cellState.date)
            let today = formatter.string(from: Date())
            if cellDate == today {
                validCell.backgroundColor = .gray
            } else if eventDates.contains(cellDate) {
                validCell.backgroundColor = eventCellColor

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
            self.eventCounter = 0
            self.eventTitles = []
            var labelText = ""
            for event in globalVars.pastAndFutureEvents {
                formatter.dateFormat = "MM/dd/yyyy"
                let date1 = formatter.date(from: event.Date)
                formatter.dateFormat = "MMMM dd"
                let eventDate = formatter.string(from: date1!)
                if eventDate == date {
                    eventCounter += 1
                    eventTitles.append(event.Title)
                    labelText = "\(event.Title)"
                } else {
                    print(event.Date, date)
                    
                }
            }
            
            if labelText == "" {
                self.schoolDayLabel.text = "\(date): No events on this date."
            } else {
                if eventCounter == 1 {
                    self.schoolDayLabel.text = "\(date): There is 1 event"
                } else {
                    self.schoolDayLabel.text = "\(date): There are \(self.eventCounter) events"
                }
            }
            self.eventTableView.reloadData()
        }
        
    }
    
    
    func setup() {
        
        let margins = layoutMarginsGuide
        monthYearLabel.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        monthYearLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        monthYearLabel.heightAnchor.constraint(equalToConstant: bounds.width * 0.05).isActive = true
        monthYearLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        stackView.widthAnchor.constraint(equalToConstant: bounds.width - 30).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: bounds.width * 0.05).isActive = true
        stackView.topAnchor.constraint(equalTo: monthYearLabel.bottomAnchor).isActive = true
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true

        calendarCollectionView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
        calendarCollectionView.widthAnchor.constraint(equalToConstant: bounds.width - 30).isActive = true
        calendarCollectionView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        calendarCollectionView.heightAnchor.constraint(equalToConstant: bounds.height/1.5).isActive = true
        
        schoolDayLabel.leftAnchor.constraint(equalTo: calendarCollectionView.leftAnchor).isActive = true
        schoolDayLabel.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        schoolDayLabel.heightAnchor.constraint(equalToConstant: bounds.width * 0.05).isActive = true
        schoolDayLabel.topAnchor.constraint(equalTo: calendarCollectionView.bottomAnchor, constant: 10).isActive = true
        
        eventTableView.widthAnchor.constraint(equalToConstant: bounds.width).isActive = true
        eventTableView.heightAnchor.constraint(equalToConstant: bounds.height - (20 + bounds.width * 0.15 + bounds.height/1.5)).isActive = true
        eventTableView.topAnchor.constraint(equalTo: schoolDayLabel.bottomAnchor).isActive = true
        eventTableView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
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
        var eventDates: [String] = []
        for event in globalVars.pastAndFutureEvents {
            formatter.dateFormat = "MM/dd/yyyy"
            let date1 = formatter.date(from: event.Date)
            let stringDate = formatter.string(from: date1!)
            eventDates.append(stringDate)
        }
        
        let cellDate = formatter.string(from: date)
        let today = formatter.string(from: Date())
        if cellDate == today {
            cell.backgroundColor = .gray
        } else if eventDates.contains(cellDate) {
            cell.backgroundColor = eventCellColor
        }

        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        loadData()
        print(globalVars.pastAndFutureEvents.count)
        
        handleColorChanges(cell: cell, cellState: cellState)
        handleTextChanges(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleColorChanges(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupViewsFromCalendar(from: visibleDates)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = eventTitles[indexPath.row]
        return cell
    }
    
    var delegate: didClickCell?

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let currentCell = tableView.cellForRow(at: indexPath)
        
        for event in globalVars.pastAndFutureEvents {
            if event.Title == currentCell?.textLabel?.text {
                globalVars.eventDescription = event.Description
                globalVars.eventTitle = event.Title
            }
        }
        
        
        delegate?.didClick(segue: "toEventsDescription")
    }
    
}








