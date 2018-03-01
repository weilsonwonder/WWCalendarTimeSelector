//
//  NSCalendar+Timepiece.swift
//  Timepiece
//
//  Created by Mattijs on 25/04/15.
//  Copyright (c) 2015 Naoto Kaneko. All rights reserved.
//

import Foundation

private let supportsDateByAddingUnit = (NSCalendar.autoupdatingCurrent as NSCalendar).responds(to: #selector(NSCalendar.date(byAdding:value:to:options:)))

extension NSCalendar {
    func dateByAddingDuration(_ duration: Duration, toDate date: Date, options opts: NSCalendar.Options) -> Date? {
        if supportsDateByAddingUnit {
            return self.date(byAdding: duration.unit, value: duration.value, to: date, options: .searchBackwards)!
        }
        else {
            // otherwise fallback to NSDateComponents
            return self.date(byAdding: NSDateComponents(duration) as DateComponents, to: date, options: .searchBackwards)!
        }
    }
}
