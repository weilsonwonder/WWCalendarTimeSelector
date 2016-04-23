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
        "Date",
        "Year",
        "Time",
        "Date + Year",
        "Year + Time",
        "Date + Time",
        "Date + Year + Time",
        "Multiple Selection (Simple)",
        "Multiple Selection (Pill)",
        "Multiple Selection (LinkedBalls)",
        "Date + Year + Time (without Top Panel)",
        "Date + Year + Time (without Top Container)"
    ]
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        selector.optionCurrentDate = singleDate
        selector.optionCurrentDates = Set(multipleDates)
        
        switch indexPath.row {
            
        case 0:
            selector.optionStyles = [.Date]
        case 1:
            selector.optionStyles = [.Year]
        case 2:
            selector.optionStyles = [.Time]
        case 3:
            selector.optionStyles = [.Date, .Year]
        case 4:
            selector.optionStyles = [.Year, .Time]
        case 5:
            selector.optionStyles = [.Date, .Time]
        case 6:
            break
        case 7:
            selector.optionMultipleSelection = true
            selector.optionMultipleSelectionGrouping = .Simple
        case 8:
            selector.optionMultipleSelection = true
            selector.optionMultipleSelectionGrouping = .Pill
        case 9:
            selector.optionMultipleSelection = true
            selector.optionMultipleSelectionGrouping = .LinkedBalls
        case 10:
            selector.optionShowTopPanel = false
        case 11:
            selector.optionShowTopContainer = false
            selector.optionLayoutHeight = 300
            
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
        singleDate = date
        dateLabel.text = date.stringFromFormat("d' 'MMMM' 'yyyy', 'h':'mma")
    }
    
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, dates: [NSDate]) {
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

