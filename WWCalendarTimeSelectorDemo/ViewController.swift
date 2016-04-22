//
//  ViewController.swift
//  WWCalendarTimeSelectorDemo
//
//  Created by Weilson Wonder on 21/4/16.
//  Copyright © 2016 Wonder. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WWCalendarTimeSelectorProtocol {
    
    @IBOutlet weak var dateLabel: UILabel!
    private var multipleDates: [NSDate] = []
    
    @IBAction func showPicker(sender: UIButton) {
        let picker = WWCalendarTimeSelector.instantiate()
        
        switch sender.tag {
        case 1:
            picker.optionStyles = [.Date]
        case 2:
            picker.optionStyles = [.Year]
        case 3:
            picker.optionStyles = [.Time]
        case 4:
            picker.optionStyles = [.Date, .Year]
        case 5:
            picker.optionStyles = [.Year, .Time]
        case 6:
            picker.optionStyles = [.Date, .Time]
        case 7:
            picker.optionStyles = [.Date, .Year, .Time]
        case 8:
            picker.optionMultipleSelection = true
            picker.optionCurrentDates = Set(multipleDates)
            picker.optionMultipleSelectionGrouping = .Pill
        default:
            picker.optionStyles = [.Date, .Year, .Time]
        }
        picker.delegate = self
        if let t = dateLabel.text {
            if let date = t.dateFromFormat("d' 'MMMM' 'yyyy', 'h':'mma") {
                picker.optionCurrentDate = date
            }
        }
        presentViewController(picker, animated: true, completion: nil)
    }
    
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, dates: [NSDate]) {
        if let date = dates.first {
            dateLabel.text = date.stringFromFormat("d' 'MMMM' 'yyyy', 'h':'mma")
        }
        
        if selector.optionMultipleSelection {
            multipleDates = dates
        }
    }
}
