//
//  Duration.swift
//  Timepiece
//
//  Created by Naoto Kaneko on 2014/08/17.
//  Copyright (c) 2014年 Naoto Kaneko. All rights reserved.
//

import Foundation

prefix func - (duration: Duration) -> (Duration) {
    return Duration(value: -duration.value, unit: duration.unit)
}

class Duration {
    let value: Int
    let unit: NSCalendarUnit
    private let calendar = NSCalendar.currentCalendar()
    
    /**
        Initialize a date before a duration.
    */
    var ago: NSDate {
        return ago(from: NSDate())
    }
    
    func ago(from date: NSDate) -> NSDate {
        return calendar.dateByAddingDuration(-self, toDate: date, options: .SearchBackwards)!
    }
    
    /**
        Initialize a date after a duration.
    */
    var later: NSDate {
        return later(from: NSDate())
    }
    
    func later(from date: NSDate) -> NSDate {
        return calendar.dateByAddingDuration(self, toDate: date, options: .SearchBackwards)!
    }
    
    init(value: Int, unit: NSCalendarUnit) {
        self.value = value
        self.unit = unit
    }
}
