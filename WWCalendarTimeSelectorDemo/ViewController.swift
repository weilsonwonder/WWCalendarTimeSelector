//
//  ViewController.swift
//  WWCalendarTimeSelectorDemo
//
//  Created by Weilson Wonder on 21/4/16.
//  Copyright © 2016 Wonder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var table: UITableView!
    
    fileprivate var singleDate: Date = Date()
    fileprivate var multipleDates: [Date] = []
    
    fileprivate let demo: [String] = [
        "DateMonth",//0
        "Month",//1
        "Year",//2
        "Time",//3
        "DateMonth + Year",//4
        "Month + Year",//5
        "Year + Time",//6
        "DateMonth + Time",//7
        "DateMonth + Year + Time",//8
        "Month + Year + Time",//9
        "Multiple Selection (Simple)",//10
        "Multiple Selection (Pill)",//11
        "Multiple Selection (LinkedBalls)",//12
        "Date + Year + Time (without Top Panel)",//13
        "Date + Year + Time (without Top Container)",//14
        "Date Range Selection"//15
    ]
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selector = UIStoryboard(name: "WWCalendarTimeSelector", bundle: nil).instantiateInitialViewController() as! WWCalendarTimeSelector
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        
        switch (indexPath as NSIndexPath).row {
            
        case 0:
            selector.optionStyles.showDateMonth(true)
            selector.optionStyles.showMonth(false)
            selector.optionStyles.showYear(false)
            selector.optionStyles.showTime(false)
        case 1:
            selector.optionStyles.showDateMonth(false)
            selector.optionStyles.showMonth(true)
            selector.optionStyles.showYear(false)
            selector.optionStyles.showTime(false)
        case 2:
            selector.optionStyles.showDateMonth(false)
            selector.optionStyles.showMonth(false)
            selector.optionStyles.showYear(true)
            selector.optionStyles.showTime(false)
        case 3:
            selector.optionStyles.showDateMonth(false)
            selector.optionStyles.showMonth(false)
            selector.optionStyles.showYear(false)
            selector.optionStyles.showTime(true)
        case 4:
            selector.optionStyles.showDateMonth(true)
            selector.optionStyles.showMonth(false)
            selector.optionStyles.showYear(true)
            selector.optionStyles.showTime(false)
        case 5:
            selector.optionStyles.showDateMonth(false)
            selector.optionStyles.showMonth(true)
            selector.optionStyles.showYear(true)
            selector.optionStyles.showTime(false)
        case 6:
            selector.optionStyles.showDateMonth(false)
            selector.optionStyles.showMonth(false)
            selector.optionStyles.showYear(true)
            selector.optionStyles.showTime(true)
        case 7:
            selector.optionStyles.showDateMonth(true)
            selector.optionStyles.showMonth(false)
            selector.optionStyles.showYear(false)
            selector.optionStyles.showTime(true)
        case 8:
            break
        case 9:
            selector.optionStyles.showMonth(true)
        case 10:
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.multiple
            selector.optionMultipleSelectionGrouping = .simple
        case 11:
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.multiple
            selector.optionMultipleSelectionGrouping = .pill
        case 12:
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.multiple
            selector.optionMultipleSelectionGrouping = .linkedBalls
        case 13:
            selector.optionShowTopPanel = false
        case 14:
            selector.optionShowTopContainer = false
            selector.optionLayoutHeight = 300
        case 15:
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.range
            
        default:
            break
        }
        
        present(selector, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demo.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            assertionFailure("cell identifier 'cell' not found!")
            return UITableViewCell()
        }
        cell.textLabel?.text = demo[(indexPath as NSIndexPath).row]
        return cell
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, date: Date) {
        print("Selected \n\(date)\n---")
        singleDate = date
        dateLabel.text = date.stringFromFormat("d' 'MMMM' 'yyyy', 'h':'mma")
    }
    
    func WWCalendarTimeSelectorDone(_ selector: WWCalendarTimeSelector, dates: [Date]) {
        print("Selected Multiple Dates \n\(dates)\n---")
        if let date = dates.first {
            singleDate = date
            dateLabel.text = date.stringFromFormat("d' 'MMMM' 'yyyy', 'h':'mma")
        }
        else {
            dateLabel.text = "No Date Selected"
        }
        multipleDates = dates
    }
}

