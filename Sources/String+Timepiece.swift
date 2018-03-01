//
//  String+Timepiece.swift
//  Timepiece
//
//  Created by Naoto Kaneko on 2015/03/01.
//  Copyright (c) 2015年 Naoto Kaneko. All rights reserved.
//

import Foundation

extension String {
    // MARK - Parse into NSDate
    
    func dateFromFormat(_ format: String) -> Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.calendar = Calendar.autoupdatingCurrent
        formatter.dateFormat = format
        return formatter.date(from: self)
    }
}
