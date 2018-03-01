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
    let unit: NSCalendar.Unit
    fileprivate let calendar = (Calendar.autoupdatingCurrent as NSCalendar)
    
    /**
     Initialize a date before a duration.
     */
    var ago: Date {
        return ago(from: Date())
    }
    
    func ago(from date: Date) -> Date {
        return calendar.dateByAddingDuration(-self, toDate: date, options: .searchBackwards)!
    }
    
    /**
     Initialize a date after a duration.
     */
    var later: Date {
        return later(from: Date())
    }
    
    func later(from date: Date) -> Date {
        return calendar.dateByAddingDuration(self, toDate: date, options: .searchBackwards)!
    }
    
    init(value: Int, unit: NSCalendar.Unit) {
        self.value = value
        self.unit = unit
    }
}
