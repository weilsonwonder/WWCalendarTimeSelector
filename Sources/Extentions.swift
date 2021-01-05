//
//  Extentions.swift
//  WWCalendarTimeSelector
//
//  Created by Mohannad on 12/31/20.
//  Copyright © 2020 Wonder. All rights reserved.
//

import Foundation
import UIKit



extension UIApplication {
    
    var orientation: UIInterfaceOrientation? {
        
        if #available(iOS 13.0, *) {
            return UIApplication.shared.windows
                        .first?.windowScene?
                        .interfaceOrientation
                      
        }
        else {
            return UIApplication.shared.statusBarOrientation
        }
    }
}
