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
    
    private var singleDate: NSDate = NSDate()
    private var multipleDates: [NSDate] = []
    
    private let demo: [String] = [
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        selector.optionCurrentDateRange.setStartDate(multipleDates.first ?? singleDate)
        selector.optionCurrentDateRange.setEndDate(multipleDates.last ?? singleDate)
        
        switch indexPath.row {
            
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
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.Multiple
            selector.optionMultipleSelectionGrouping = .Simple
        case 11:
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.Multiple
            selector.optionMultipleSelectionGrouping = .Pill
        case 12:
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.Multiple
            selector.optionMultipleSelectionGrouping = .LinkedBalls
        case 13:
            selector.optionShowTopPanel = false
        case 14:
            selector.optionShowTopContainer = false
            selector.optionLayoutHeight = 300
        case 15:
            selector.optionSelectionType = WWCalendarTimeSelectorSelection.Range
            
        default:
            break
        }
        
        presentViewController(selector, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demo.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") else {
            assertionFailure("cell identifier 'cell' not found!")
            return UITableViewCell()
        }
        cell.textLabel?.text = demo[indexPath.row]
        return cell
    }
    
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        print("Selected \n\(date)\n---")
        singleDate = date
        dateLabel.text = date.stringFromFormat("d' 'MMMM' 'yyyy', 'h':'mma")
    }
    
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, dates: [NSDate]) {
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

