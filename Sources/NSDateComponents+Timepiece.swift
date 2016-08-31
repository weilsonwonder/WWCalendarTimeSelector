//
//  NSDateComponents+Timepiece.swift
//  Timepiece
//
//  Created by Mattijs on 25/04/15.
//  Copyright (c) 2015 Naoto Kaneko. All rights reserved.
//

import Foundation

extension NSDateComponents {
    convenience init(_ duration: Duration) {
        self.init()
        switch duration.unit{
        case NSCalendar.Unit.day:
            day = duration.value
        case NSCalendar.Unit.weekday:
            weekday = duration.value
        case NSCalendar.Unit.weekOfMonth:
            weekOfMonth = duration.value
        case NSCalendar.Unit.weekOfYear:
            weekOfYear = duration.value
        case NSCalendar.Unit.hour:
            hour = duration.value
        case NSCalendar.Unit.minute:
            minute = duration.value
        case NSCalendar.Unit.month:
            month = duration.value
        case NSCalendar.Unit.second:
            second = duration.value
        case NSCalendar.Unit.year:
            year = duration.value
        default:
            () // unsupported / ignore
        }
    }
}
