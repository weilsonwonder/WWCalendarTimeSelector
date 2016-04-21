//
//  WWCalendarTimeSelector.swift
//  WWCalendarTimeSelector
//
//  Created by Weilson Wonder on 18/4/16.
//  Copyright © 2016 Wonder. All rights reserved.
//

import UIKit

public enum WWCalendarTimeSelectorStyle {
    case Date, Year, Time
}

public enum WWCalendarTimeSelectorTimeStep: Int {
    case OneMinute = 1
    case FiveMinutes = 5
    case TenMinutes = 10
    case FifteenMinutes = 15
    case ThirtyMinutes = 30
    case SixthMinutes = 60
}

@objc public protocol WWCalendarTimeSelectorProtocol {
    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate)
    optional func WWCalendarTimeSelectorCancel(selector: WWCalendarTimeSelector, date: NSDate)
    optional func WWCalendarTimeSelectorWillDismiss(selector: WWCalendarTimeSelector)
    optional func WWCalendarTimeSelectorDidDismiss(selector: WWCalendarTimeSelector)
}

public class WWCalendarTimeSelector: UIViewController, UITableViewDelegate, UITableViewDataSource, WWCalendarRowProtocol, WWClockProtocol {
    
    public var delegate: WWCalendarTimeSelectorProtocol?
    public var optionColorBackgroundDay = UIColor.brownColor()
    public var optionColorBackgroundSelector = UIColor.brownColor().colorWithAlphaComponent(0.8)
    public var optionColorBackgroundContent = UIColor.whiteColor()
    public var optionColorBackgroundContentHighlight = UIColor.brownColor().colorWithAlphaComponent(0.8)
    public var optionColorBackgroundContentShade = UIColor.lightGrayColor().colorWithAlphaComponent(0.5)
    public var optionColorTextDay = UIColor.whiteColor()
    public var optionColorTextSelectorActive = UIColor.whiteColor()
    public var optionColorTextSelectorInactive = UIColor.whiteColor().colorWithAlphaComponent(0.4)
    public var optionColorTextContentHeadline = UIColor.blackColor()
    public var optionColorTextContentSubheadline = UIColor.darkGrayColor()
    public var optionColorTextContentBody = UIColor.grayColor()
    public var optionColorTextContentHighlight = UIColor.whiteColor()
    public var optionColorButtonBackgroundCancel = UIColor.clearColor()
    public var optionColorButtonBackgroundDone = UIColor.clearColor()
    public var optionColorButtonTextCancel = UIColor.brownColor().colorWithAlphaComponent(0.8)
    public var optionColorButtonTextDone = UIColor.brownColor().colorWithAlphaComponent(0.8)
    
    public var optionFontContentBigHeadline = UIFont.boldSystemFontOfSize(20)
    public var optionFontContentBigThinHeadline = UIFont.systemFontOfSize(20)
    public var optionFontContentHeadline = UIFont.boldSystemFontOfSize(14)
    public var optionFontContentBigThinSubheadline = UIFont.systemFontOfSize(18)
    public var optionFontContentSubheadline = UIFont.boldSystemFontOfSize(12)
    public var optionFontContentBigThinBody = UIFont.systemFontOfSize(14)
    public var optionFontContentBody = UIFont.systemFontOfSize(12)
    
    public var optionPickerStyle: Set<WWCalendarTimeSelectorStyle> = [.Date, .Year, .Time]
    public var optionTimeStep: WWCalendarTimeSelectorTimeStep = .OneMinute
    public var optionCurrentDate = NSDate().minute < 30 ? NSDate().beginningOfHour : NSDate().beginningOfHour + 1.hour
    public var optionShowDay = true
    
    @IBOutlet private weak var topContainerView: UIView!
    @IBOutlet private weak var bottomContainerView: UIView!
    
    @IBOutlet private weak var backgroundDayView: UIView!
    @IBOutlet private weak var backgroundSelView: UIView!
    @IBOutlet private weak var backgroundContentView: UIView!
    
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var selDateView: UIView!
    @IBOutlet private weak var selYearView: UIView!
    @IBOutlet private weak var selTimeView: UIView!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var calendarTable: UITableView!
    @IBOutlet private weak var yearTable: UITableView!
    @IBOutlet private weak var clockView: WWClock!
    
    @IBOutlet weak var dayViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var topContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomContainerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var selMonthXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selMonthYConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selDateXConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selDateYConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var selDateTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selDateLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selDateRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selDateHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var selYearTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selYearLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selYearRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selYearHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var selTimeTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selTimeLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selTimeRightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var selTimeHeightConstraint: NSLayoutConstraint!
    
    private let selMonthScale: CGFloat = 2.5
    private let selDateScale: CGFloat = 4.5
    private let selYearScale: CGFloat = 4
    private let selTimeScale: CGFloat = 2.75
    private let selAnimationDuration: NSTimeInterval = 0.4
    private let selInactiveHeight: CGFloat = 48
    private var selActiveHeight: CGFloat { return CGRectGetHeight(backgroundSelView.frame) - selInactiveHeight }
    private var selInactiveWidth: CGFloat { return CGRectGetWidth(backgroundSelView.frame) / 2 }
    private var selActiveWidth: CGFloat { return CGRectGetHeight(backgroundSelView.frame) - selInactiveHeight }
    private var selCurrrent: WWCalendarTimeSelectorStyle = .Date
    private var isFirstLoad = true
    private var selTimeStateHour = true
    
    private var calRow1Type: WWCalendarRowType = WWCalendarRowType.Date
    private var calRow2Type: WWCalendarRowType = WWCalendarRowType.Date
    private var calRow3Type: WWCalendarRowType = WWCalendarRowType.Date
    private var calRow1StartDate: NSDate = NSDate()
    private var calRow2StartDate: NSDate = NSDate()
    private var calRow3StartDate: NSDate = NSDate()
    
    private var yearRow1: Int = 2016
    
    private let dayViewDefaultHeight: CGFloat = 28
    private let portraitContainerWidth: CGFloat = 280
    private let portraitTopContainerHeight: CGFloat = 184
    private let portraitBottomContainerHeight: CGFloat = 344
    private let landscapeContainerHeight: CGFloat = 280
    private let landscapeTopContainerWidth: CGFloat = 198
    private let landscapeBottomContainerWidth: CGFloat = 330
    private var deviceOrientation: UIDeviceOrientation { return UIDevice.currentDevice().orientation }
    
    public static func instantiate() -> WWCalendarTimeSelector {
        
        let bundleURL = NSBundle.mainBundle().URLForResource("WWCalendarTimeSelectorStoryboardBundle", withExtension: "bundle")
        let bundle = NSBundle(URL: bundleURL!)
        let picker = UIStoryboard(name: "WWCalendarTimeSelector", bundle: bundle).instantiateInitialViewController() as! WWCalendarTimeSelector
        
        picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        picker.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        return picker
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        if optionPickerStyle.count == 0 {
            optionPickerStyle = [.Date, .Year, .Time]
        }
        
        let seventhRowStartDate = optionCurrentDate.beginningOfMonth
        calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
        calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
        calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
        
        yearRow1 = optionCurrentDate.year - 5
        
        dayViewHeightConstraint.constant = optionShowDay ? dayViewDefaultHeight : 0
        view.layoutIfNeeded()
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WWCalendarTimeSelector.didRotate), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        backgroundDayView.backgroundColor = optionColorBackgroundDay
        backgroundSelView.backgroundColor = optionColorBackgroundSelector
        backgroundContentView.backgroundColor = optionColorBackgroundContent
        
        cancelButton.backgroundColor = optionColorButtonBackgroundCancel
        doneButton.backgroundColor = optionColorButtonBackgroundDone
        cancelButton.setTitleColor(optionColorButtonTextCancel, forState: UIControlState.Normal)
        doneButton.setTitleColor(optionColorButtonTextDone, forState: UIControlState.Normal)
        
        dayLabel.textColor = optionColorTextDay
        
        clockView.delegate = self
        clockView.faceColor = optionColorBackgroundContentShade
        clockView.ampmColor = optionColorBackgroundContentShade
        clockView.ampmColorHighlight = optionColorBackgroundContentHighlight
        clockView.numberSelectorColor = optionColorBackgroundContentHighlight
        clockView.numberSelectorLineColor = optionColorBackgroundContentHighlight
        clockView.centerPieceColor = optionColorTextContentHeadline
        clockView.textColor = optionColorTextContentHeadline
        clockView.textColorHighlight = optionColorTextContentHighlight
        clockView.numbersFont = optionFontContentBigThinSubheadline
        clockView.ampmFont = optionFontContentBigThinHeadline
        clockView.minuteStep = optionTimeStep
        clockView.numbersFontSmaller = optionFontContentBigThinBody
        
        updateDate()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            calendarTable.reloadData()
            yearTable.reloadData()
            clockView.setNeedsDisplay()
            didRotate()
            
            if optionPickerStyle.contains(.Date) {
                showDate(true)
            }
            else if optionPickerStyle.contains(.Year) {
                showYear(true)
            }
            else if optionPickerStyle.contains(.Time) {
                showTime(true)
            }
        }
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        isFirstLoad = false
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    func didRotate() {
        if deviceOrientation == .LandscapeLeft || deviceOrientation == .LandscapeRight || deviceOrientation == .Portrait {
            let isPortrait = deviceOrientation.isPortrait
            let size = view.bounds.size
            
            topContainerWidthConstraint.constant = isPortrait ? portraitContainerWidth : landscapeTopContainerWidth
            topContainerHeightConstraint.constant = isPortrait ? portraitTopContainerHeight : landscapeContainerHeight
            bottomContainerWidthConstraint.constant = isPortrait ? portraitContainerWidth : landscapeBottomContainerWidth
            bottomContainerHeightConstraint.constant = isPortrait ? portraitBottomContainerHeight : landscapeContainerHeight
            
            if isPortrait {
                let width = min(size.width, size.height)
                let height = max(size.width, size.height)
                
                topContainerLeftConstraint.constant = (width - topContainerWidthConstraint.constant) / 2
                topContainerTopConstraint.constant = (height - (topContainerHeightConstraint.constant + bottomContainerHeightConstraint.constant)) / 2
                bottomContainerLeftConstraint.constant = topContainerLeftConstraint.constant
                bottomContainerTopConstraint.constant = topContainerTopConstraint.constant + topContainerHeightConstraint.constant
            }
            else {
                let width = max(size.width, size.height)
                let height = min(size.width, size.height)
                
                topContainerLeftConstraint.constant = (width - (topContainerWidthConstraint.constant + bottomContainerWidthConstraint.constant)) / 2
                topContainerTopConstraint.constant = (height - topContainerHeightConstraint.constant) / 2
                bottomContainerLeftConstraint.constant = topContainerLeftConstraint.constant + topContainerWidthConstraint.constant
                bottomContainerTopConstraint.constant = topContainerTopConstraint.constant
            }
            
            UIView.animateWithDuration(
                selAnimationDuration,
                delay: 0,
                usingSpringWithDamping: 0.8,
                initialSpringVelocity: 0,
                options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction],
                animations: {
                    self.view.layoutIfNeeded()
                },
                completion: nil
            )
            
            if selCurrrent == .Time {
                showTime(false)
            }
            else if selCurrrent == .Year {
                showYear(false)
            }
            else {
                showDate(false)
            }
        }
    }
    
    @IBAction func showDate() {
        showDate(true)
    }
    
    @IBAction func showYear() {
        showYear(true)
    }
    
    @IBAction func showTime() {
        showTime(true)
    }
    
    @IBAction func cancel() {
        let picker = self
        let del = delegate
        del?.WWCalendarTimeSelectorCancel?(picker, date: optionCurrentDate)
        del?.WWCalendarTimeSelectorWillDismiss?(picker)
        dismissViewControllerAnimated(true) { 
            del?.WWCalendarTimeSelectorDidDismiss?(picker)
        }
    }
    
    @IBAction func done() {
        let picker = self
        let del = delegate
        del?.WWCalendarTimeSelectorDone(picker, date: optionCurrentDate)
        del?.WWCalendarTimeSelectorWillDismiss?(picker)
        dismissViewControllerAnimated(true) {
            del?.WWCalendarTimeSelectorDidDismiss?(picker)
        }
    }
    
    
    
    
    
    
    private func showDate(userTap: Bool) {
        changeSelDate()
        
        if userTap {
            let seventhRowStartDate = optionCurrentDate.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            calendarTable.reloadData()
            calendarTable.scrollToRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        else {
            calendarTable.reloadData()
        }
        
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.CurveEaseOut],
            animations: {
                self.calendarTable.alpha = 1
                self.yearTable.alpha = 0
                self.clockView.alpha = 0
            },
            completion: nil
        )
    }
    
    private func showYear(userTap: Bool) {
        changeSelYear()
        
        if userTap {
            yearRow1 = optionCurrentDate.year - 5
            yearTable.reloadData()
            yearTable.scrollToRowAtIndexPath(NSIndexPath(forRow: 3, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        else {
            yearTable.reloadData()
        }
        
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.CurveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.yearTable.alpha = 1
                self.clockView.alpha = 0
            },
            completion: nil
        )
    }
    
    private func showTime(userTap: Bool) {
        if userTap {
            if selCurrrent == .Time {
                selTimeStateHour = !selTimeStateHour
            }
            else {
                selTimeStateHour = true
            }
        }
        changeSelTime()
        
        if userTap {
            clockView.showingHour = selTimeStateHour
        }
        clockView.setNeedsDisplay()
        
        UIView.transitionWithView(
            clockView,
            duration: selAnimationDuration / 2,
            options: [UIViewAnimationOptions.TransitionCrossDissolve],
            animations: {
                self.clockView.layer.displayIfNeeded()
            },
            completion: nil
        )
        
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.CurveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.yearTable.alpha = 0
                self.clockView.alpha = 1
            },
            completion: nil
        )
    }
    
    
    
    
    
    
    
    private func updateDate() {
        dayLabel.text = optionCurrentDate.stringFromFormat("EEEE")
        monthLabel.text = optionCurrentDate.stringFromFormat("MMM")
        dateLabel.text = optionCurrentDate.stringFromFormat("d")
        yearLabel.text = optionCurrentDate.stringFromFormat("yyyy")
        
        let timeText = optionCurrentDate.stringFromFormat("h':'mma").lowercaseString
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.Center
        let attrText = NSMutableAttributedString(string: timeText, attributes: [NSFontAttributeName: timeLabel.font, NSForegroundColorAttributeName: optionColorTextSelectorInactive, NSParagraphStyleAttributeName: paragraph])
        
        if selCurrrent == .Date {
            monthLabel.textColor = optionColorTextSelectorActive
            dateLabel.textColor = optionColorTextSelectorActive
            yearLabel.textColor = optionColorTextSelectorInactive
        }
        else if selCurrrent == .Year {
            monthLabel.textColor = optionColorTextSelectorInactive
            dateLabel.textColor = optionColorTextSelectorInactive
            yearLabel.textColor = optionColorTextSelectorActive
        }
        else if selCurrrent == .Time {
            
            monthLabel.textColor = optionColorTextSelectorInactive
            dateLabel.textColor = optionColorTextSelectorInactive
            yearLabel.textColor = optionColorTextSelectorInactive
            
            let colonIndex = timeText.startIndex.distanceTo(timeText.rangeOfString(":")!.startIndex)
            let hourRange = NSRange(location: 0, length: colonIndex)
            let minuteRange = NSRange(location: colonIndex + 1, length: 2)
            
            if selTimeStateHour {
                attrText.setAttributes([NSForegroundColorAttributeName: optionColorTextSelectorActive], range: hourRange)
            }
            else {
                attrText.setAttributes([NSForegroundColorAttributeName: optionColorTextSelectorActive], range: minuteRange)
            }
        }
        timeLabel.attributedText = attrText
    }
    
    private func changeSelDate() {
        let selActiveHeight = self.selActiveHeight
        let selInactiveHeight = self.selInactiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = CGRectGetHeight(backgroundSelView.frame)
        
        backgroundSelView.sendSubviewToBack(selYearView)
        backgroundSelView.sendSubviewToBack(selTimeView)
        
        // adjust date view (because it's complicated)
        selMonthXConstraint.constant = 0
        selMonthYConstraint.constant = -30
        selDateXConstraint.constant = 0
        selDateYConstraint.constant = 24
        
        // adjust positions
        selDateTopConstraint.constant = 0
        selDateLeftConstraint.constant = 0
        selDateRightConstraint.constant = 0
        selDateHeightConstraint.constant = optionPickerStyle.count > 1 ? selActiveHeight : selActiveHeightFull
        
        selYearLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        if optionPickerStyle.contains(.Year) {
            selYearTopConstraint.constant = selActiveHeight
            selYearHeightConstraint.constant = selInactiveHeight
            if optionPickerStyle.contains(.Time) {
                selYearRightConstraint.constant = selInactiveWidth
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = selInactiveWidth
            }
            else {
                selYearRightConstraint.constant = 0
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        else {
            selYearTopConstraint.constant = 0
            selYearHeightConstraint.constant = 0
            selYearRightConstraint.constant = selInactiveWidthDouble
            if optionPickerStyle.contains(.Time) {
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = 0
            }
            else {
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        
        monthLabel.contentScaleFactor = UIScreen.mainScreen().scale * selMonthScale
        dateLabel.contentScaleFactor = UIScreen.mainScreen().scale * selDateScale
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                self.monthLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.selMonthScale, self.selMonthScale)
                self.dateLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.selDateScale, self.selDateScale)
                self.yearLabel.transform = CGAffineTransformIdentity
                self.timeLabel.transform = CGAffineTransformIdentity
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if self.selCurrrent == .Date {
                    self.yearLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.timeLabel.contentScaleFactor = UIScreen.mainScreen().scale
                }
            }
        )
        selCurrrent = .Date
        updateDate()
    }
    
    private func changeSelYear() {
        let selInactiveHeight = self.selInactiveHeight
        let selActiveHeight = self.selActiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selMonthX: CGFloat = 12
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = CGRectGetHeight(backgroundSelView.frame)
        
        backgroundSelView.sendSubviewToBack(selDateView)
        backgroundSelView.sendSubviewToBack(selTimeView)
        
        selMonthXConstraint.constant = -selMonthX
        selMonthYConstraint.constant = 0
        selDateXConstraint.constant = selMonthX
        selDateYConstraint.constant = 0
        
        selYearTopConstraint.constant = 0
        selYearLeftConstraint.constant = 0
        selYearRightConstraint.constant = 0
        selYearHeightConstraint.constant = optionPickerStyle.count > 1 ? selActiveHeight : selActiveHeightFull
        
        selDateLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        if optionPickerStyle.contains(.Date) {
            selDateHeightConstraint.constant = selInactiveHeight
            selDateTopConstraint.constant = selActiveHeight
            if optionPickerStyle.contains(.Time) {
                selDateRightConstraint.constant = selInactiveWidth
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = selInactiveWidth
            }
            else {
                selDateRightConstraint.constant = 0
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        else {
            selDateHeightConstraint.constant = 0
            selDateTopConstraint.constant = 0
            selDateRightConstraint.constant = selInactiveWidthDouble
            if optionPickerStyle.contains(.Time) {
                selTimeHeightConstraint.constant = selInactiveHeight
                selTimeTopConstraint.constant = selActiveHeight
                selTimeLeftConstraint.constant = 0
            }
            else {
                selTimeHeightConstraint.constant = 0
                selTimeTopConstraint.constant = 0
                selTimeLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        
        yearLabel.contentScaleFactor = UIScreen.mainScreen().scale * selYearScale
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                self.yearLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.selYearScale, self.selYearScale)
                self.monthLabel.transform = CGAffineTransformIdentity
                self.dateLabel.transform = CGAffineTransformIdentity
                self.timeLabel.transform = CGAffineTransformIdentity
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if self.selCurrrent == .Year {
                    self.monthLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.dateLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.timeLabel.contentScaleFactor = UIScreen.mainScreen().scale
                }
            }
        )
        selCurrrent = .Year
        updateDate()
    }
    
    private func changeSelTime() {
        let selInactiveHeight = self.selInactiveHeight
        let selActiveHeight = self.selActiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selMonthX: CGFloat = 12
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = CGRectGetHeight(backgroundSelView.frame)
        
        backgroundSelView.sendSubviewToBack(selYearView)
        backgroundSelView.sendSubviewToBack(selDateView)
        
        selMonthXConstraint.constant = -selMonthX
        selMonthYConstraint.constant = 0
        selDateXConstraint.constant = selMonthX
        selDateYConstraint.constant = 0
        
        selTimeTopConstraint.constant = 0
        selTimeLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        selTimeHeightConstraint.constant = optionPickerStyle.count > 1 ? selActiveHeight : selActiveHeightFull
        
        selDateLeftConstraint.constant = 0
        selYearRightConstraint.constant = 0
        if optionPickerStyle.contains(.Date) {
            selDateHeightConstraint.constant = selInactiveHeight
            selDateTopConstraint.constant = selActiveHeight
            if optionPickerStyle.contains(.Year) {
                selDateRightConstraint.constant = selInactiveWidth
                selYearHeightConstraint.constant = selInactiveHeight
                selYearTopConstraint.constant = selActiveHeight
                selYearLeftConstraint.constant = selInactiveWidth
            }
            else {
                selDateRightConstraint.constant = 0
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
                selYearLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        else {
            selDateHeightConstraint.constant = 0
            selDateTopConstraint.constant = 0
            selDateRightConstraint.constant = selInactiveWidthDouble
            if optionPickerStyle.contains(.Year) {
                selYearHeightConstraint.constant = selInactiveHeight
                selYearTopConstraint.constant = selActiveHeight
                selYearLeftConstraint.constant = 0
            }
            else {
                selYearHeightConstraint.constant = 0
                selYearTopConstraint.constant = 0
                selYearLeftConstraint.constant = selInactiveWidthDouble
            }
        }
        
        timeLabel.contentScaleFactor = UIScreen.mainScreen().scale * selTimeScale
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                self.timeLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.selTimeScale, self.selTimeScale)
                self.monthLabel.transform = CGAffineTransformIdentity
                self.dateLabel.transform = CGAffineTransformIdentity
                self.yearLabel.transform = CGAffineTransformIdentity
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if self.selCurrrent == .Time {
                    self.monthLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.dateLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.yearLabel.contentScaleFactor = UIScreen.mainScreen().scale
                }
            }
        )
        selCurrrent = .Time
        updateDate()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return tableView == calendarTable ? tableView.frame.height / 8 : tableView.frame.height / 5
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == calendarTable ? 16 : 11
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell
        
        if tableView == calendarTable {
            if let c = tableView.dequeueReusableCellWithIdentifier("cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
                let calRow = WWCalendarRow()
                calRow.translatesAutoresizingMaskIntoConstraints = false
                calRow.delegate = self
                calRow.backgroundColor = optionColorBackgroundContent
                calRow.monthColor = optionColorTextContentHeadline
                calRow.monthFont = optionFontContentHeadline
                calRow.dayColor = optionColorTextContentSubheadline
                calRow.dayFont = optionFontContentSubheadline
                calRow.dateFont = optionFontContentBody
                calRow.dateColor = optionColorTextContentBody
                calRow.dateColorHighlight = optionColorTextContentHighlight
                calRow.dateBackgroundHighlight = optionColorBackgroundContentHighlight
                cell.contentView.addSubview(calRow)
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
            }
            
            for sv in cell.contentView.subviews {
                if let calRow = sv as? WWCalendarRow {
                    calRow.tag = indexPath.row + 1
                    calRow.selectedDates = [optionCurrentDate]
                    calRow.setNeedsDisplay()
                }
            }
        }
        else { // yearTable
            if let c = tableView.dequeueReusableCellWithIdentifier("cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.textLabel?.font = optionFontContentBigHeadline
            }
            
            let displayYear = yearRow1 + indexPath.row
            cell.textLabel?.textColor = optionCurrentDate.year == displayYear ? optionColorTextContentHeadline : optionColorTextContentBody
            cell.textLabel?.text = "\(displayYear)"
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == yearTable {
            let displayYear = yearRow1 + indexPath.row
            optionCurrentDate = optionCurrentDate.change(year: displayYear)
            updateDate()
            tableView.reloadData()
        }
    }
    
    public func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        
        if scrollView == calendarTable {
            let twoRow = backgroundContentView.frame.height / 4
            if offsetY < twoRow {
                // every row shift by 4 to the back, recalculate top 3 towards earlier dates
                
                let detail1 = WWCalendarRowGetDetails(-3)
                let detail2 = WWCalendarRowGetDetails(-2)
                let detail3 = WWCalendarRowGetDetails(-1)
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + twoRow * 2)
                calendarTable.reloadData()
            }
            else if offsetY > twoRow * 3 {
                // every row shift by 4 to the front, recalculate top 3 towards later dates
                
                let detail1 = WWCalendarRowGetDetails(5)
                let detail2 = WWCalendarRowGetDetails(6)
                let detail3 = WWCalendarRowGetDetails(7)
                calRow1Type = detail1.type
                calRow1StartDate = detail1.startDate
                calRow2Type = detail2.type
                calRow2StartDate = detail2.startDate
                calRow3Type = detail3.type
                calRow3StartDate = detail3.startDate
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - twoRow * 2)
                calendarTable.reloadData()
            }
        }
        else {
            let triggerPoint = backgroundContentView.frame.height / 10 * 3
            if offsetY < triggerPoint {
                yearRow1 = yearRow1 - 3
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY + triggerPoint * 2)
                yearTable.reloadData()
            }
            else if offsetY > triggerPoint * 3 {
                yearRow1 = yearRow1 + 3
                
                scrollView.contentOffset = CGPoint(x: 0, y: offsetY - triggerPoint * 2)
                yearTable.reloadData()
            }
        }
    }
    
    // CAN DO BETTER! TOO MANY LOOPS!
    internal func WWCalendarRowGetDetails(row: Int) -> (type: WWCalendarRowType, startDate: NSDate) {
        if row == 1 {
            return (calRow1Type, calRow1StartDate)
        }
        else if row == 2 {
            return (calRow2Type, calRow2StartDate)
        }
        else if row == 3 {
            return (calRow3Type, calRow3StartDate)
        }
        else if row > 3 {
            var startRow: Int
            var startDate: NSDate
            var rowType: WWCalendarRowType
            if calRow3Type == .Date {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            else if calRow2Type == .Date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            }
            else {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            
            for _ in startRow..<row {
                if rowType == .Month {
                    rowType = .Day
                }
                else if rowType == .Day {
                    rowType = .Date
                    startDate = startDate.beginningOfMonth
                }
                else {
                    let newStartDate = startDate.endOfWeek + 1.day
                    if newStartDate.month != startDate.month {
                        rowType = .Month
                    }
                    startDate = newStartDate
                }
            }
            return (rowType, startDate)
        }
        else {
            // row <= 0
            var startRow: Int
            var startDate: NSDate
            var rowType: WWCalendarRowType
            if calRow1Type == .Date {
                startRow = 1
                startDate = calRow1StartDate
                rowType = calRow1Type
            }
            else if calRow2Type == .Date {
                startRow = 2
                startDate = calRow2StartDate
                rowType = calRow2Type
            }
            else {
                startRow = 3
                startDate = calRow3StartDate
                rowType = calRow3Type
            }
            
            for _ in row..<startRow {
                if rowType == .Date {
                    if startDate.day == 1 {
                        rowType = .Day
                    }
                    else {
                        let newStartDate = (startDate - 1.day).beginningOfWeek
                        if newStartDate.month != startDate.month {
                            startDate = startDate.beginningOfMonth
                        }
                        else {
                            startDate = newStartDate
                        }
                    }
                }
                else if rowType == .Day {
                    rowType = .Month
                }
                else {
                    rowType = .Date
                    startDate = (startDate - 1.day).beginningOfWeek
                }
            }
            return (rowType, startDate)
        }
    }
    
    internal func WWCalendarRowDidSelect(date: NSDate) {
        optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day)
        updateDate()
        calendarTable.reloadData()
    }
    
    internal func WWClockGetTime() -> NSDate {
        return optionCurrentDate
    }
    
    internal func WWClockSwitchAMPM(isAM isAM: Bool, isPM: Bool) {
        var newHour = optionCurrentDate.hour
        if isAM && newHour >= 12 {
            newHour = newHour - 12
        }
        if isPM && newHour < 12 {
            newHour = newHour + 12
        }
        
        optionCurrentDate = optionCurrentDate.change(hour: newHour)
        updateDate()
        clockView.setNeedsDisplay()
        UIView.transitionWithView(
            clockView,
            duration: selAnimationDuration / 2,
            options: [UIViewAnimationOptions.TransitionCrossDissolve],
            animations: { 
                self.clockView.layer.displayIfNeeded()
            },
            completion: nil
        )
    }
    
    internal func WWClockSetHourMilitary(hour: Int) {
        optionCurrentDate = optionCurrentDate.change(hour: hour)
        updateDate()
        clockView.setNeedsDisplay()
    }
    
    internal func WWClockSetMinute(minute: Int) {
        optionCurrentDate = optionCurrentDate.change(minute: minute)
        updateDate()
        clockView.setNeedsDisplay()
    }
}

@objc internal enum WWCalendarRowType: Int {
    case Month, Day, Date
}

internal protocol WWCalendarRowProtocol {
    func WWCalendarRowGetDetails(row: Int) -> (type: WWCalendarRowType, startDate: NSDate)
    func WWCalendarRowDidSelect(date: NSDate)
}

internal class WWCalendarRow: UIView {
    
    internal var delegate: WWCalendarRowProtocol!
    internal var monthColor: UIColor!
    internal var monthFont: UIFont!
    internal var dayColor: UIColor!
    internal var dayFont: UIFont!
    internal var dateFont: UIFont!
    internal var dateColor: UIColor!
    internal var dateColorHighlight: UIColor!
    internal var dateBackgroundHighlight: UIColor!
    internal var selectedDates: Set<NSDate> {
        set {
            originalDates = newValue
            comparisonDates = []
            for date in newValue {
                comparisonDates.insert(date.beginningOfDay)
            }
        }
        get {
            return originalDates
        }
    }
    
    private var originalDates: Set<NSDate> = []
    private var comparisonDates: Set<NSDate> = []
    
    private let days = ["S", "M", "T", "W", "T", "F", "S"]
    
    internal override func drawRect(rect: CGRect) {
        let detail = delegate.WWCalendarRowGetDetails(tag)
        let startDate = detail.startDate.beginningOfDay
        
        let ctx = UIGraphicsGetCurrentContext()
        let boxHeight = rect.height
        let boxWidth = rect.width / 7
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.Center
        
        if detail.type == .Month {
            let monthName = startDate.stringFromFormat("MMMM yyyy").capitalizedString
            let monthHeight = ceil(monthFont.lineHeight)
            
            let str = NSAttributedString(string: monthName, attributes: [NSFontAttributeName: monthFont, NSForegroundColorAttributeName: monthColor, NSParagraphStyleAttributeName: paragraph])
            str.drawInRect(CGRect(x: 0, y: boxHeight - monthHeight, width: rect.width, height: monthHeight))
        }
        else if detail.type == .Day {
            let dayHeight = ceil(dayFont.lineHeight)
            let y = (boxHeight - dayHeight) / 2
            
            for i in days.enumerate() {
                let str = NSAttributedString(string: i.element, attributes: [NSFontAttributeName: dayFont, NSForegroundColorAttributeName: dayColor, NSParagraphStyleAttributeName: paragraph])
                str.drawInRect(CGRect(x: CGFloat(i.index) * boxWidth, y: y, width: boxWidth, height: dayHeight))
            }
        }
        else {
            let dateHeight = ceil(dateFont.lineHeight)
            let y = (boxHeight - dateHeight) / 2
            var date = startDate

            for i in 1...7 {
                if date.weekday == i {
                    var str: NSAttributedString
                    if comparisonDates.contains(date) {
                        let size = min(boxHeight, boxWidth)
                        let x = CGFloat(i - 1) * boxWidth + (boxWidth - size) / 2
                        let y = (boxHeight - size) / 2
                        CGContextSetFillColorWithColor(ctx, dateBackgroundHighlight.CGColor)
                        CGContextFillEllipseInRect(ctx, CGRect(x: x, y: y, width: size, height: size))
                        str = NSAttributedString(string: "\(date.day)", attributes: [NSFontAttributeName: dateFont, NSForegroundColorAttributeName: dateColorHighlight, NSParagraphStyleAttributeName: paragraph])
                    }
                    else {
                        str = NSAttributedString(string: "\(date.day)", attributes: [NSFontAttributeName: dateFont, NSForegroundColorAttributeName: dateColor, NSParagraphStyleAttributeName: paragraph])
                    }
                    
                    str.drawInRect(CGRect(x: CGFloat(i - 1) * boxWidth, y: y, width: boxWidth, height: dateHeight))
                    date = date + 1.day
                    if date.month != startDate.month {
                        break
                    }
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let detail = delegate.WWCalendarRowGetDetails(tag)
        if detail.type == .Date {
            let boxWidth = bounds.width / 7
            if let touch = touches.sort({ $0.timestamp < $1.timestamp }).last {
                let boxIndex = Int(floor(touch.locationInView(self).x / boxWidth))
                let dateTapped = detail.startDate + boxIndex.days - (detail.startDate.weekday - 1).days
                if dateTapped.month == detail.startDate.month {
                    delegate.WWCalendarRowDidSelect(dateTapped)
                }
            }
        }
    }
}

internal protocol WWClockProtocol {
    func WWClockGetTime() -> NSDate
    func WWClockSwitchAMPM(isAM isAM: Bool, isPM: Bool)
    func WWClockSetHourMilitary(hour: Int)
    func WWClockSetMinute(minute: Int)
}

internal class WWClock: UIView {
    
    internal var delegate: WWClockProtocol!
    internal var faceColor: UIColor!
    internal var ampmColor: UIColor!
    internal var ampmColorHighlight: UIColor!
    internal var ampmFont: UIFont!
    internal var numberSelectorColor: UIColor!
    internal var numberSelectorLineColor: UIColor!
    internal var numbersFont: UIFont!
    internal var numbersFontSmaller: UIFont!
    internal var centerPieceColor: UIColor!
    internal var textColor: UIColor!
    internal var textColorHighlight: UIColor!
    
    internal var showingHour = true
    internal var minuteStep: WWCalendarTimeSelectorTimeStep! {
        didSet {
            minutes = []
            let iter = 60 / minuteStep.rawValue
            for i in 0..<iter {
                minutes.append(i * minuteStep.rawValue)
            }
        }
    }
    
    private let border: CGFloat = 8
    private let ampmSize: CGFloat = 52
    private var faceSize: CGFloat = 0
    private var faceX: CGFloat = 0
    private let faceY: CGFloat = 8
    private let amX: CGFloat = 8
    private var pmX: CGFloat = 0
    private var ampmY: CGFloat = 0
    private let numberCircleBorder: CGFloat = 12
    private let centerPieceSize = 4
    private let hours = [12, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]
    private var minutes: [Int] = []
    
    internal override func drawRect(rect: CGRect) {
        // update frames
        faceSize = min(rect.width - border * 2, rect.height - border * 2 - ampmSize / 3 * 2)
        faceX = (rect.width - faceSize) / 2
        pmX = rect.width - border - ampmSize
        ampmY = rect.height - border - ampmSize
        
        let time = delegate.WWClockGetTime()
        let ctx = UIGraphicsGetCurrentContext()
        let ampmHeight = ceil(ampmFont.lineHeight)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.Center
        
        CGContextSetFillColorWithColor(ctx, faceColor.CGColor)
        CGContextFillEllipseInRect(ctx, CGRect(x: faceX, y: faceY, width: faceSize, height: faceSize))
        
        CGContextSetFillColorWithColor(ctx, ampmColorHighlight.CGColor)
        if time.hour < 12 {
            CGContextFillEllipseInRect(ctx, CGRect(x: amX, y: ampmY, width: ampmSize, height: ampmSize))
            var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: ampmFont, NSForegroundColorAttributeName: textColorHighlight, NSParagraphStyleAttributeName: paragraph])
            str.drawInRect(CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
            str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: ampmFont, NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: paragraph])
            str.drawInRect(CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
        }
        else {
            CGContextFillEllipseInRect(ctx, CGRect(x: pmX, y: ampmY, width: ampmSize, height: ampmSize))
            var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: ampmFont, NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: paragraph])
            str.drawInRect(CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
            str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: ampmFont, NSForegroundColorAttributeName: textColorHighlight, NSParagraphStyleAttributeName: paragraph])
            str.drawInRect(CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
        }
        
        if showingHour {
            let textAttr = [NSFontAttributeName: numbersFont, NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: paragraph]
            let textAttrHighlight = [NSFontAttributeName: numbersFont, NSForegroundColorAttributeName: textColorHighlight, NSParagraphStyleAttributeName: paragraph]
            let templateSize = NSAttributedString(string: "12", attributes: textAttr).size()
            let maxSize = max(templateSize.width, templateSize.height)
            let highlightCircleSize = maxSize + numberCircleBorder
            let radius: CGFloat = faceSize / 2 - maxSize
            
            CGContextSaveGState(ctx)
            CGContextTranslateCTM(ctx, faceX + faceSize / 2, faceY + faceSize / 2) // everything starts at clock face center
            
            let degreeIncrement = 360 / CGFloat(hours.count)
            let currentHour = get12Hour(time)
            
            for h in hours.enumerate() {
                let angle = getClockRad(CGFloat(h.index) * degreeIncrement)
                var attr = textAttr
                
                if h.element == currentHour {
                    attr = textAttrHighlight
                    
                    // leading line
                    CGContextSaveGState(ctx)
                    CGContextSetStrokeColorWithColor(ctx, ampmColorHighlight.CGColor)
                    CGContextSetLineWidth(ctx, 1)
                    CGContextMoveToPoint(ctx, 0, 0)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextAddLineToPoint(ctx, (radius - highlightCircleSize / 2) * cos(angle), -((radius - highlightCircleSize / 2) * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextStrokePath(ctx)
                    CGContextRestoreGState(ctx)
                    
                    // highlight
                    CGContextSaveGState(ctx)
                    CGContextSetFillColorWithColor(ctx, ampmColorHighlight.CGColor)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, radius * cos(angle), -(radius * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextFillEllipseInRect(ctx, CGRect(x: -highlightCircleSize / 2, y: -highlightCircleSize / 2, width: highlightCircleSize, height: highlightCircleSize))
                    CGContextRestoreGState(ctx)
                }
                
                // numbers
                let hour = NSAttributedString(string: "\(h.element)", attributes: attr)
                CGContextSaveGState(ctx)
                CGContextScaleCTM(ctx, -1, 1)
                CGContextTranslateCTM(ctx, radius * cos(angle), -(radius * sin(angle)))
                CGContextScaleCTM(ctx, -1, 1)
                CGContextTranslateCTM(ctx, -hour.size().width / 2, -hour.size().height / 2)
                hour.drawAtPoint(CGPoint.zero)
                CGContextRestoreGState(ctx)
            }
            
            // center piece
            CGContextSetFillColorWithColor(ctx, textColor.CGColor)
            CGContextFillEllipseInRect(ctx, CGRect(x: -centerPieceSize / 2, y: -centerPieceSize / 2, width: centerPieceSize, height: centerPieceSize))
            
            CGContextRestoreGState(ctx)
        }
        else {
            let textAttr = [NSFontAttributeName: numbersFontSmaller, NSForegroundColorAttributeName: textColor, NSParagraphStyleAttributeName: paragraph]
            let textAttrHighlight = [NSFontAttributeName: numbersFontSmaller, NSForegroundColorAttributeName: textColorHighlight, NSParagraphStyleAttributeName: paragraph]
            let templateSize = NSAttributedString(string: "60", attributes: textAttr).size()
            let maxSize = max(templateSize.width, templateSize.height)
            let minSize: CGFloat = 0
            let highlightCircleMaxSize = maxSize + numberCircleBorder
            let highlightCircleMinSize = minSize + numberCircleBorder
            let radius: CGFloat = faceSize / 2 - maxSize
            
            CGContextSaveGState(ctx)
            CGContextTranslateCTM(ctx, faceX + faceSize / 2, faceY + faceSize / 2) // everything starts at clock face center
            
            let degreeIncrement = 360 / CGFloat(minutes.count)
            let currentMinute = get60Minute(time)
            
            for m in minutes.enumerate() {
                let angle = getClockRad(CGFloat(m.index) * degreeIncrement)
                var attr = textAttr
                
                if m.element == currentMinute {
                    attr = textAttrHighlight
                    
                    // leading line
                    CGContextSaveGState(ctx)
                    CGContextSetStrokeColorWithColor(ctx, ampmColorHighlight.CGColor)
                    CGContextSetLineWidth(ctx, 1)
                    CGContextMoveToPoint(ctx, 0, 0)
                    CGContextScaleCTM(ctx, -1, 1)
                    if minuteStep.rawValue < 5 && m.element % 5 != 0 {
                        CGContextAddLineToPoint(ctx, (radius - highlightCircleMinSize / 2) * cos(angle), -((radius - highlightCircleMinSize / 2) * sin(angle)))
                    }
                    else {
                        CGContextAddLineToPoint(ctx, (radius - highlightCircleMaxSize / 2) * cos(angle), -((radius - highlightCircleMaxSize / 2) * sin(angle)))
                    }
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextStrokePath(ctx)
                    CGContextRestoreGState(ctx)
                    
                    // highlight
                    CGContextSaveGState(ctx)
                    CGContextSetFillColorWithColor(ctx, ampmColorHighlight.CGColor)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, radius * cos(angle), -(radius * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    if minuteStep.rawValue < 5 && m.element % 5 != 0 {
                        CGContextFillEllipseInRect(ctx, CGRect(x: -highlightCircleMinSize / 2, y: -highlightCircleMinSize / 2, width: highlightCircleMinSize, height: highlightCircleMinSize))
                    }
                    else {
                        CGContextFillEllipseInRect(ctx, CGRect(x: -highlightCircleMaxSize / 2, y: -highlightCircleMaxSize / 2, width: highlightCircleMaxSize, height: highlightCircleMaxSize))
                    }
                    CGContextRestoreGState(ctx)
                }
                
                // numbers
                if minuteStep.rawValue < 5 {
                    if m.element % 5 == 0 {
                        let min = NSAttributedString(string: "\(m.element)", attributes: attr)
                        CGContextSaveGState(ctx)
                        CGContextScaleCTM(ctx, -1, 1)
                        CGContextTranslateCTM(ctx, radius * cos(angle), -(radius * sin(angle)))
                        CGContextScaleCTM(ctx, -1, 1)
                        CGContextTranslateCTM(ctx, -min.size().width / 2, -min.size().height / 2)
                        min.drawAtPoint(CGPoint.zero)
                        CGContextRestoreGState(ctx)
                    }
                }
                else {
                    let min = NSAttributedString(string: "\(m.element)", attributes: attr)
                    CGContextSaveGState(ctx)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, radius * cos(angle), -(radius * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, -min.size().width / 2, -min.size().height / 2)
                    min.drawAtPoint(CGPoint.zero)
                    CGContextRestoreGState(ctx)
                }
            }
            
            // center piece
            CGContextSetFillColorWithColor(ctx, textColor.CGColor)
            CGContextFillEllipseInRect(ctx, CGRect(x: -centerPieceSize / 2, y: -centerPieceSize / 2, width: centerPieceSize, height: centerPieceSize))
            
            CGContextRestoreGState(ctx)
        }
    }
    
    private func get60Minute(date: NSDate) -> Int {
        return date.minute
    }
    
    private func get12Hour(date: NSDate) -> Int {
        let hr = date.hour
        return hr == 0 || hr == 12 ? 12 : hr < 12 ? hr : hr - 12
    }
    
    private func getClockRad(degrees: CGFloat) -> CGFloat {
        let radOffset = 90.degreesToRadians // add this number to get 12 at top, 3 at right
        return degrees.degreesToRadians + radOffset
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.sort({ $0.timestamp < $1.timestamp }).last {
            let pt = touch.locationInView(self)
            
            // see if tap on AM or PM, making the boundary bigger
            let amRect = CGRect(x: 0, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
            let pmRect = CGRect(x: bounds.width - ampmSize - border, y: ampmY, width: ampmSize + border * 2, height: ampmSize + border)
            
            if amRect.contains(pt) {
                delegate.WWClockSwitchAMPM(isAM: true, isPM: false)
            }
            else if pmRect.contains(pt) {
                delegate.WWClockSwitchAMPM(isAM: false, isPM: true)
            }
            else {
                touchClock(pt: pt)
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.sort({ $0.timestamp < $1.timestamp }).last {
            let pt = touch.locationInView(self)
            touchClock(pt: pt)
        }
    }
    
    private func touchClock(pt pt: CGPoint) {
        let touchPoint = CGPoint(x: pt.x - faceX - faceSize / 2, y: pt.y - faceY - faceSize / 2) // this means centerpoint will be 0, 0
        
        if showingHour {
            let degreeIncrement = 360 / CGFloat(hours.count)
            
            var angle = 180 - atan2(touchPoint.x, touchPoint.y).radiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
            if angle < 0 {
                angle = 0
            }
            angle = angle - degreeIncrement / 2
            var index = Int(floor(angle / degreeIncrement)) + 1
            
            if index < 0 || index > (hours.count - 1) {
                index = 0
            }
            
            let hour = hours[index]
            let time = delegate.WWClockGetTime()
            if hour == 12 {
                delegate.WWClockSetHourMilitary(time.hour < 12 ? 0 : 12)
            }
            else {
                delegate.WWClockSetHourMilitary(time.hour < 12 ? hour : 12 + hour)
            }
        }
        else {
            let degreeIncrement = 360 / CGFloat(minutes.count)
            
            var angle = 180 - atan2(touchPoint.x, touchPoint.y).radiansToDegrees // with respect that 12 o'clock position is 0 degrees, and 3 o'clock position is 90 degrees
            if angle < 0 {
                angle = 0
            }
            angle = angle - degreeIncrement / 2
            var index = Int(floor(angle / degreeIncrement)) + 1
            
            if index < 0 || index >= (minutes.count - 1) {
                index = 0
            }
            
            let minute = minutes[index]
            delegate.WWClockSetMinute(minute)
        }
    }
}

private extension CGFloat {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}

private extension Int {
    var doubleValue:      Double  { return Double(self) }
    var degreesToRadians: CGFloat { return CGFloat(doubleValue * M_PI / 180) }
    var radiansToDegrees: CGFloat { return CGFloat(doubleValue * 180 / M_PI) }
}





















