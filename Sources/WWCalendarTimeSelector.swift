//
//  WWCalendarTimeSelector.swift
//  WWCalendarTimeSelector
//
//  Created by Weilson Wonder on 18/4/16.
//  Copyright © 2016 Wonder. All rights reserved.
//

import UIKit

@objc public final class WWCalendarTimeSelectorStyle: NSObject {
    private(set) public var showDateMonth: Bool = true
    private(set) public var showMonth: Bool = false
    private(set) public var showYear: Bool = true
    private(set) public var showTime: Bool = true
    private var isSingular = false
    
    public func showDateMonth(show: Bool) {
        showDateMonth = show
        showMonth = show ? false : showMonth
        if show && isSingular {
            showMonth = false
            showYear = false
            showTime = false
        }
    }
    
    public func showMonth(show: Bool) {
        showMonth = show
        showDateMonth = show ? false : showDateMonth
        if show && isSingular {
            showDateMonth = false
            showYear = false
            showTime = false
        }
    }
    
    public func showYear(show: Bool) {
        showYear = show
        if show && isSingular {
            showDateMonth = false
            showMonth = false
            showTime = false
        }
    }
    
    public func showTime(show: Bool) {
        showTime = show
        if show && isSingular {
            showDateMonth = false
            showMonth = false
            showYear = false
        }
    }
    
    private func countComponents() -> Int {
        return (showDateMonth ? 1 : 0) +
            (showMonth ? 1 : 0) +
            (showYear ? 1 : 0) +
            (showTime ? 1 : 0)
    }
    
    private convenience init(isSingular: Bool) {
        self.init()
        self.isSingular = isSingular
        showDateMonth = true
        showMonth = false
        showYear = false
        showTime = false
    }
}

/// Set `optionSelectionType` with one of the following:
///
/// `Single`: This will only allow the selection of a single date. If applicable, this also allows selection of year and time.
///
/// `Multiple`: This will allow the selection of multiple dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
///
/// `Range`: This will allow the selection of a range of dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
///
/// - Note:
/// Selection styles will only affect date selection. It is currently not possible to select multiple/range
@objc public enum WWCalendarTimeSelectorSelection: Int {
    /// Single Selection.
    case Single
    /// Multiple Selection. Year and Time interface not available.
    case Multiple
    /// Range Selection. Year and Time interface not available.
    case Range
}

/// Set `optionMultipleSelectionGrouping` with one of the following:
///
/// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
///
/// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
///
/// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
@objc public enum WWCalendarTimeSelectorMultipleSelectionGrouping: Int {
    /// Displayed as individual circular selection
    case Simple
    /// Rounded rectangular grouping
    case Pill
    /// Individual circular selection with a bar between adjacent dates
    case LinkedBalls
}

/// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
///
/// - Note:
/// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
/// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
///
/// - Note: 
/// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
@objc public enum WWCalendarTimeSelectorTimeStep: Int {
    /// 1 Minute interval, but clock will display intervals of 5 minutes.
    case OneMinute = 1
    /// 5 Minutes interval.
    case FiveMinutes = 5
    /// 10 Minutes interval.
    case TenMinutes = 10
    /// 15 Minutes interval.
    case FifteenMinutes = 15
    /// 30 Minutes interval.
    case ThirtyMinutes = 30
    /// Disables the selection of minutes.
    case SixtyMinutes = 60
}

@objc public class WWCalendarTimeSelectorDateRange: NSObject {
    private(set) public var start: NSDate = NSDate().beginningOfDay
    private(set) public var end: NSDate = NSDate().beginningOfDay
    public var array: [NSDate] {
        var dates: [NSDate] = []
        var i = start.beginningOfDay
        let j = end.beginningOfDay
        while i.compare(j) != .OrderedDescending {
            dates.append(i)
            i = i + 1.day
        }
        return dates
    }
    
    public func setStartDate(date: NSDate) {
        start = date.beginningOfDay
        if start.compare(end) == .OrderedDescending {
            end = start
        }
    }
    
    public func setEndDate(date: NSDate) {
        end = date.beginningOfDay
        if start.compare(end) == .OrderedDescending {
            start = end
        }
    }
}

/// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
///
/// `WWCalendarTimeSelectorDone:selector:dates:`
/// `WWCalendarTimeSelectorDone:selector:date:`
/// `WWCalendarTimeSelectorCancel:selector:dates:`
/// `WWCalendarTimeSelectorCancel:selector:date:`
/// `WWCalendarTimeSelectorWillDismiss:selector:`
/// `WWCalendarTimeSelectorDidDismiss:selector:`
@objc public protocol WWCalendarTimeSelectorProtocol {
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    optional func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, dates: [NSDate])
    
    /// Method called before the selector is dismissed, and when user is Done with the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    optional func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate)
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `true`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected dates.
    optional func WWCalendarTimeSelectorCancel(selector: WWCalendarTimeSelector, dates: [NSDate])
    
    /// Method called before the selector is dismissed, and when user Cancel the selector.
    ///
    /// This method is only called when `optionMultipleSelection` is `false`.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    ///     - dates: Selected date.
    optional func WWCalendarTimeSelectorCancel(selector: WWCalendarTimeSelector, date: NSDate)
    
    /// Method called before the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that will be dismissed.
    optional func WWCalendarTimeSelectorWillDismiss(selector: WWCalendarTimeSelector)
    
    /// Method called after the selector is dismissed.
    ///
    /// - SeeAlso:
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    ///
    /// - Parameters:
    ///     - selector: The selector that has been dismissed.
    optional func WWCalendarTimeSelectorDidDismiss(selector: WWCalendarTimeSelector)
    
    /// Method if implemented, will be used to determine if a particular date should be selected.
    ///
    /// - Parameters:
    ///     - selector: The selector that is checking for selectablity of date.
    ///     - date: The date that user tapped, but have not yet given feedback to determine if should be selected.
    optional func WWCalendarTimeSelectorShouldSelectDate(selector: WWCalendarTimeSelector, date: NSDate) -> Bool
}

public class WWCalendarTimeSelector: UIViewController, UITableViewDelegate, UITableViewDataSource, WWCalendarRowProtocol, WWClockProtocol {
    
    /// The delegate of `WWCalendarTimeSelector` can adopt the `WWCalendarTimeSelectorProtocol` optional methods. The following Optional methods are available:
    ///
    /// `WWCalendarTimeSelectorDone:selector:dates:`
    /// `WWCalendarTimeSelectorDone:selector:date:`
    /// `WWCalendarTimeSelectorCancel:selector:dates:`
    /// `WWCalendarTimeSelectorCancel:selector:date:`
    /// `WWCalendarTimeSelectorWillDismiss:selector:`
    /// `WWCalendarTimeSelectorDidDismiss:selector:`
    public var delegate: WWCalendarTimeSelectorProtocol?
    
    /// A convenient identifier object. Not used by `WWCalendarTimeSelector`.
    public var optionIdentifier: AnyObject?
    
    /// Set `optionPickerStyle` with one or more of the following:
    ///
    /// `DateMonth`: This shows the the date and month.
    ///
    /// `Year`: This shows the year.
    ///
    /// `Time`: This shows the clock, users will be able to select hour and minutes as well as am or pm.
    ///
    /// - Note:
    /// `optionPickerStyle` should contain at least 1 of the following style. It will default to all styles should there be none in the option specified.
    ///
    /// - Note:
    /// Defaults to all styles.
    public var optionStyles: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle()
    
    /// Set `optionTimeStep` to customise the period of time which the users will be able to choose. The step will show the user the available minutes to select (with exception of `OneMinute` step, see *Note*).
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `OneMinute` will show the clock face with minutes on intervals of 5 minutes.
    /// In between the intervals will be empty space. Users will however be able to adjust the minute hand into the intervals of those 5 minutes.
    ///
    /// - Note:
    /// Setting `optionTimeStep` to `SixtyMinutes` will disable the minutes selection entirely.
    ///
    /// - Note:
    /// Defaults to `OneMinute`.
    public var optionTimeStep: WWCalendarTimeSelectorTimeStep = .OneMinute
    
    /// Set to `true` will show the entire selector at the top. If you only wish to hide the *title bar*, see `optionShowTopPanel`. Set to `false` will hide the entire top container.
    ///
    /// - Note:
    /// Defaults to `true`.
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`.
    public var optionShowTopContainer: Bool = true
    
    /// Set to `true` to show the weekday name *or* `optionTopPanelTitle` if specified at the top of the selector. Set to `false` will hide the entire panel.
    ///
    /// - Note:
    /// Defaults to `true`.
    public var optionShowTopPanel = true
    
    /// Set to nil to show default title. Depending on `privateOptionStyles`, default titles are either **Select Multiple Dates**, **(Capitalized Weekday Full Name)** or **(Capitalized Month Full Name)**.
    ///
    /// - Note:
    /// Defaults to `nil`.
    public var optionTopPanelTitle: String? = nil
    
    /// Set `optionSelectionType` with one of the following:
    ///
    /// `Single`: This will only allow the selection of a single date. If applicable, this also allows selection of year and time.
    ///
    /// `Multiple`: This will allow the selection of multiple dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
    ///
    /// `Range`: This will allow the selection of a range of dates. This automatically ignores the attribute of `optionPickerStyle`, hence selection of multiple year and time is currently not available.
    ///
    /// - Note:
    /// Selection styles will only affect date selection. It is currently not possible to select multiple/range
    public var optionSelectionType: WWCalendarTimeSelectorSelection = .Single
    
    /// Set to default date when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDates`
    ///
    /// - Note:
    /// Defaults to current date and time, with time rounded off to the nearest hour.
    public var optionCurrentDate = NSDate().minute < 30 ? NSDate().beginningOfHour : NSDate().beginningOfHour + 1.hour
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    public var optionCurrentDates: Set<NSDate> = []
    
    /// Set the default dates when selector is presented.
    ///
    /// - SeeAlso:
    /// `optionCurrentDate`
    ///
    /// - Note:
    /// Selector will show the earliest selected date's month by default.
    public var optionCurrentDateRange: WWCalendarTimeSelectorDateRange = WWCalendarTimeSelectorDateRange()
    
    /// Set the background blur effect, where background is a `UIVisualEffectView`. Available options are as `UIBlurEffectStyle`:
    ///
    /// `Dark`
    ///
    /// `Light`
    ///
    /// `ExtraLight`
    public var optionStyleBlurEffect: UIBlurEffectStyle = .Dark
    
    /// Set `optionMultipleSelectionGrouping` with one of the following:
    ///
    /// `Simple`: No grouping for multiple selection. Selected dates are displayed as individual circles.
    ///
    /// `Pill`: This is the default. Pill-like grouping where dates are grouped only if they are adjacent to each other (+- 1 day).
    ///
    /// `LinkedBalls`: Smaller circular selection, with a bar connecting adjacent dates.
    public var optionMultipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping = .Pill
    
    
    // Fonts & Colors
    public var optionCalendarFontMonth = UIFont.systemFontOfSize(14)
    public var optionCalendarFontDays = UIFont.systemFontOfSize(13)
    public var optionCalendarFontToday = UIFont.boldSystemFontOfSize(13)
    public var optionCalendarFontTodayHighlight = UIFont.boldSystemFontOfSize(14)
    public var optionCalendarFontPastDates = UIFont.systemFontOfSize(12)
    public var optionCalendarFontPastDatesHighlight = UIFont.systemFontOfSize(13)
    public var optionCalendarFontFutureDates = UIFont.systemFontOfSize(12)
    public var optionCalendarFontFutureDatesHighlight = UIFont.systemFontOfSize(13)
    
    public var optionCalendarFontColorMonth = UIColor.blackColor()
    public var optionCalendarFontColorDays = UIColor.blackColor()
    public var optionCalendarFontColorToday = UIColor.darkGrayColor()
    public var optionCalendarFontColorTodayHighlight = UIColor.whiteColor()
    public var optionCalendarBackgroundColorTodayHighlight = UIColor.brownColor()
    public var optionCalendarBackgroundColorTodayFlash = UIColor.whiteColor()
    public var optionCalendarFontColorPastDates = UIColor.darkGrayColor()
    public var optionCalendarFontColorPastDatesHighlight = UIColor.whiteColor()
    public var optionCalendarBackgroundColorPastDatesHighlight = UIColor.brownColor()
    public var optionCalendarBackgroundColorPastDatesFlash = UIColor.whiteColor()
    public var optionCalendarFontColorFutureDates = UIColor.darkGrayColor()
    public var optionCalendarFontColorFutureDatesHighlight = UIColor.whiteColor()
    public var optionCalendarBackgroundColorFutureDatesHighlight = UIColor.brownColor()
    public var optionCalendarBackgroundColorFutureDatesFlash = UIColor.whiteColor()
    
    public var optionCalendarFontCurrentYear = UIFont.boldSystemFontOfSize(18)
    public var optionCalendarFontCurrentYearHighlight = UIFont.boldSystemFontOfSize(20)
    public var optionCalendarFontColorCurrentYear = UIColor.darkGrayColor()
    public var optionCalendarFontColorCurrentYearHighlight = UIColor.blackColor()
    public var optionCalendarFontPastYears = UIFont.boldSystemFontOfSize(18)
    public var optionCalendarFontPastYearsHighlight = UIFont.boldSystemFontOfSize(20)
    public var optionCalendarFontColorPastYears = UIColor.darkGrayColor()
    public var optionCalendarFontColorPastYearsHighlight = UIColor.blackColor()
    public var optionCalendarFontFutureYears = UIFont.boldSystemFontOfSize(18)
    public var optionCalendarFontFutureYearsHighlight = UIFont.boldSystemFontOfSize(20)
    public var optionCalendarFontColorFutureYears = UIColor.darkGrayColor()
    public var optionCalendarFontColorFutureYearsHighlight = UIColor.blackColor()
    
    public var optionClockFontAMPM = UIFont.systemFontOfSize(18)
    public var optionClockFontAMPMHighlight = UIFont.systemFontOfSize(20)
    public var optionClockFontColorAMPM = UIColor.blackColor()
    public var optionClockFontColorAMPMHighlight = UIColor.whiteColor()
    public var optionClockBackgroundColorAMPMHighlight = UIColor.brownColor()
    public var optionClockFontHour = UIFont.systemFontOfSize(16)
    public var optionClockFontHourHighlight = UIFont.systemFontOfSize(18)
    public var optionClockFontColorHour = UIColor.blackColor()
    public var optionClockFontColorHourHighlight = UIColor.whiteColor()
    public var optionClockBackgroundColorHourHighlight = UIColor.brownColor()
    public var optionClockBackgroundColorHourHighlightNeedle = UIColor.brownColor()
    public var optionClockFontMinute = UIFont.systemFontOfSize(12)
    public var optionClockFontMinuteHighlight = UIFont.systemFontOfSize(14)
    public var optionClockFontColorMinute = UIColor.blackColor()
    public var optionClockFontColorMinuteHighlight = UIColor.whiteColor()
    public var optionClockBackgroundColorMinuteHighlight = UIColor.brownColor()
    public var optionClockBackgroundColorMinuteHighlightNeedle = UIColor.brownColor()
    public var optionClockBackgroundColorFace = UIColor(white: 0.9, alpha: 1)
    public var optionClockBackgroundColorCenter = UIColor.blackColor()
    
    public var optionButtonTitleDone: String = "Done"
    public var optionButtonTitleCancel: String = "Cancel"
    public var optionButtonFontCancel = UIFont.systemFontOfSize(16)
    public var optionButtonFontDone = UIFont.boldSystemFontOfSize(16)
    public var optionButtonFontColorCancel = UIColor.brownColor()
    public var optionButtonFontColorDone = UIColor.brownColor()
    public var optionButtonFontColorCancelHighlight = UIColor.brownColor().colorWithAlphaComponent(0.25)
    public var optionButtonFontColorDoneHighlight = UIColor.brownColor().colorWithAlphaComponent(0.25)
    public var optionButtonBackgroundColorCancel = UIColor.clearColor()
    public var optionButtonBackgroundColorDone = UIColor.clearColor()
    
    public var optionTopPanelBackgroundColor = UIColor.brownColor()
    public var optionTopPanelFont = UIFont.systemFontOfSize(16)
    public var optionTopPanelFontColor = UIColor.whiteColor()
    
    public var optionSelectorPanelFontMonth = UIFont.systemFontOfSize(16)
    public var optionSelectorPanelFontDate = UIFont.systemFontOfSize(16)
    public var optionSelectorPanelFontYear = UIFont.systemFontOfSize(16)
    public var optionSelectorPanelFontTime = UIFont.systemFontOfSize(16)
    public var optionSelectorPanelFontMultipleSelection = UIFont.systemFontOfSize(16)
    public var optionSelectorPanelFontMultipleSelectionHighlight = UIFont.systemFontOfSize(17)
    public var optionSelectorPanelFontColorMonth = UIColor(white: 1, alpha: 0.5)
    public var optionSelectorPanelFontColorMonthHighlight = UIColor.whiteColor()
    public var optionSelectorPanelFontColorDate = UIColor(white: 1, alpha: 0.5)
    public var optionSelectorPanelFontColorDateHighlight = UIColor.whiteColor()
    public var optionSelectorPanelFontColorYear = UIColor(white: 1, alpha: 0.5)
    public var optionSelectorPanelFontColorYearHighlight = UIColor.whiteColor()
    public var optionSelectorPanelFontColorTime = UIColor(white: 1, alpha: 0.5)
    public var optionSelectorPanelFontColorTimeHighlight = UIColor.whiteColor()
    public var optionSelectorPanelFontColorMultipleSelection = UIColor.whiteColor()
    public var optionSelectorPanelFontColorMultipleSelectionHighlight = UIColor.whiteColor()
    public var optionSelectorPanelBackgroundColor = UIColor.brownColor().colorWithAlphaComponent(0.9)
    
    public var optionMainPanelBackgroundColor = UIColor.whiteColor()
    public var optionBottomPanelBackgroundColor = UIColor.whiteColor()
    
    /// This is the month's offset when user is in selection of dates mode. A positive number will adjusts the month higher, while a negative number will adjust the month lower.
    ///
    /// - Note:
    /// Defaults to 30.
    public var optionSelectorPanelOffsetHighlightMonth: CGFloat = 30
    
    /// This is the date's offset when user is in selection of dates mode. A positive number will adjusts the date lower, while a negative number will adjust the date higher.
    ///
    /// - Note:
    /// Defaults to 24.
    public var optionSelectorPanelOffsetHighlightDate: CGFloat = 24
    
    /// This is the scale of the month when it is in active view.
    public var optionSelectorPanelScaleMonth: CGFloat = 2.5
    public var optionSelectorPanelScaleDate: CGFloat = 4.5
    public var optionSelectorPanelScaleYear: CGFloat = 4
    public var optionSelectorPanelScaleTime: CGFloat = 2.75
    
    /// This is the height calendar's "title bar". If you wish to hide the Top Panel, consider `optionShowTopPanel`
    ///
    /// - SeeAlso:
    /// `optionShowTopPanel`
    public var optionLayoutTopPanelHeight: CGFloat = 28
    
    /// The height of the calendar in portrait mode. This will be translated automatically into the width in landscape mode.
    public var optionLayoutHeight: CGFloat?
    
    /// The width of the calendar in portrait mode. This will be translated automatically into the height in landscape mode.
    public var optionLayoutWidth: CGFloat?
    
    /// If optionLayoutHeight is not defined, this ratio is used on the screen's height.
    public var optionLayoutHeightRatio: CGFloat = 0.9
    
    /// If optionLayoutWidth is not defined, this ratio is used on the screen's width.
    public var optionLayoutWidthRatio: CGFloat = 0.85
    
    /// When calendar is in portrait mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 7 / 20
    public var optionLayoutPortraitRatio: CGFloat = 7/20
    
    /// When calendar is in landscape mode, the ratio of *Top Container* to *Bottom Container*.
    ///
    /// - Note: Defaults to 3 / 8
    public var optionLayoutLandscapeRatio: CGFloat = 3/8
    
    // All Views
    @IBOutlet private weak var topContainerView: UIView!
    @IBOutlet private weak var bottomContainerView: UIView!
    @IBOutlet private weak var backgroundDayView: UIView!
    @IBOutlet private weak var backgroundSelView: UIView!
    @IBOutlet private weak var backgroundRangeView: UIView!
    @IBOutlet private weak var backgroundContentView: UIView!
    @IBOutlet private weak var backgroundButtonsView: UIView!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var selDateView: UIView!
    @IBOutlet private weak var selYearView: UIView!
    @IBOutlet private weak var selTimeView: UIView!
    @IBOutlet private weak var selMultipleDatesTable: UITableView!
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var monthLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var rangeStartLabel: UILabel!
    @IBOutlet private weak var rangeToLabel: UILabel!
    @IBOutlet private weak var rangeEndLabel: UILabel!
    @IBOutlet private weak var calendarTable: UITableView!
    @IBOutlet private weak var yearTable: UITableView!
    @IBOutlet private weak var clockView: WWClock!
    @IBOutlet private weak var monthsView: UIView!
    @IBOutlet private var monthsButtons: [UIButton]!
    
    // All Constraints
    @IBOutlet private weak var dayViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var topContainerHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomContainerTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomContainerLeftConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomContainerWidthConstraint: NSLayoutConstraint!
    @IBOutlet private weak var bottomContainerHeightConstraint: NSLayoutConstraint!
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
    
    // Private Variables
    private let selAnimationDuration: NSTimeInterval = 0.4
    private let selInactiveHeight: CGFloat = 48
    private var portraitContainerWidth: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    private var portraitTopContainerHeight: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutPortraitRatio : 0 }
    private var portraitBottomContainerHeight: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - portraitTopContainerHeight }
    private var landscapeContainerHeight: CGFloat { return optionLayoutWidth ?? optionLayoutWidthRatio * portraitWidth }
    private var landscapeTopContainerWidth: CGFloat { return optionShowTopContainer ? (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) * optionLayoutLandscapeRatio : 0 }
    private var landscapeBottomContainerWidth: CGFloat { return (optionLayoutHeight ?? optionLayoutHeightRatio * portraitHeight) - landscapeTopContainerWidth }
    private var selActiveHeight: CGFloat { return CGRectGetHeight(backgroundSelView.frame) - selInactiveHeight }
    private var selInactiveWidth: CGFloat { return CGRectGetWidth(backgroundSelView.frame) / 2 }
    private var selActiveWidth: CGFloat { return CGRectGetHeight(backgroundSelView.frame) - selInactiveHeight }
    private var selCurrrent: WWCalendarTimeSelectorStyle = WWCalendarTimeSelectorStyle(isSingular: true)
    private var isFirstLoad = false
    private var selTimeStateHour = true
    private var calRow1Type: WWCalendarRowType = WWCalendarRowType.Date
    private var calRow2Type: WWCalendarRowType = WWCalendarRowType.Date
    private var calRow3Type: WWCalendarRowType = WWCalendarRowType.Date
    private var calRow1StartDate: NSDate = NSDate()
    private var calRow2StartDate: NSDate = NSDate()
    private var calRow3StartDate: NSDate = NSDate()
    private var yearRow1: Int = 2016
    private var multipleDates: [NSDate] { return optionCurrentDates.sort({ $0.compare($1) == NSComparisonResult.OrderedAscending }) }
    private var multipleDatesLastAdded: NSDate?
    private var flashDate: NSDate?
    private let defaultTopPanelTitleForMultipleDates = "Select Multiple Dates"
    private let portraitHeight: CGFloat = max(UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width)
    private let portraitWidth: CGFloat = min(UIScreen.mainScreen().bounds.height, UIScreen.mainScreen().bounds.width)
    private var isSelectingStartRange: Bool = true { didSet { rangeStartLabel.textColor = isSelectingStartRange ? optionSelectorPanelFontColorDateHighlight : optionSelectorPanelFontColorDate; rangeEndLabel.textColor = isSelectingStartRange ? optionSelectorPanelFontColorDate : optionSelectorPanelFontColorDateHighlight } }
    private var shouldResetRange: Bool = true
    
    /// Only use this method to instantiate the selector. All customization should be done before presenting the selector to the user. 
    /// To receive callbacks from selector, set the `delegate` of selector and implement `WWCalendarTimeSelectorProtocol`.
    ///
    ///     let selector = WWCalendarTimeSelector.instantiate()
    ///     selector.delegate = self
    ///     presentViewController(selector, animated: true, completion: nil)
    ///
    public static func instantiate() -> WWCalendarTimeSelector {
        let podBundle = NSBundle(forClass: self.classForCoder())
        let bundleURL = podBundle.URLForResource("WWCalendarTimeSelectorStoryboardBundle", withExtension: "bundle")
        var bundle: NSBundle? = nil
        if let bundleURL = bundleURL {
            bundle = NSBundle(URL: bundleURL)
        }
        let picker = UIStoryboard(name: "WWCalendarTimeSelector", bundle: bundle).instantiateInitialViewController() as! WWCalendarTimeSelector
        
        picker.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        picker.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        
        return picker
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add background
        let background = UIVisualEffectView(effect: UIBlurEffect(style: optionStyleBlurEffect))
        background.translatesAutoresizingMaskIntoConstraints = false
        view.insertSubview(background, atIndex: 0)
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[bg]|", options: [], metrics: nil, views: ["bg": background]))
        view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[bg]|", options: [], metrics: nil, views: ["bg": background]))
        
        let seventhRowStartDate = optionCurrentDate.beginningOfMonth
        calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
        calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
        calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
        
        yearRow1 = optionCurrentDate.year - 5
        
        selMultipleDatesTable.hidden = optionSelectionType != .Multiple
        backgroundSelView.hidden = optionSelectionType != .Single
        backgroundRangeView.hidden = optionSelectionType != .Range

        dayViewHeightConstraint.constant = optionShowTopPanel ? optionLayoutTopPanelHeight : 0
        view.layoutIfNeeded()
        
        UIDevice.currentDevice().beginGeneratingDeviceOrientationNotifications()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(WWCalendarTimeSelector.didRotate), name: UIDeviceOrientationDidChangeNotification, object: nil)
        
        backgroundDayView.backgroundColor = optionTopPanelBackgroundColor
        backgroundSelView.backgroundColor = optionSelectorPanelBackgroundColor
        backgroundRangeView.backgroundColor = optionSelectorPanelBackgroundColor
        backgroundContentView.backgroundColor = optionMainPanelBackgroundColor
        backgroundButtonsView.backgroundColor = optionBottomPanelBackgroundColor
        selMultipleDatesTable.backgroundColor = optionSelectorPanelBackgroundColor
        
        doneButton.backgroundColor = optionButtonBackgroundColorDone
        cancelButton.backgroundColor = optionButtonBackgroundColorCancel
        doneButton.setAttributedTitle(NSAttributedString(string: optionButtonTitleDone, attributes: [NSFontAttributeName: optionButtonFontDone, NSForegroundColorAttributeName: optionButtonFontColorDone]), forState: UIControlState.Normal)
        cancelButton.setAttributedTitle(NSAttributedString(string: optionButtonTitleCancel, attributes: [NSFontAttributeName: optionButtonFontCancel, NSForegroundColorAttributeName: optionButtonFontColorCancel]), forState: UIControlState.Normal)
        doneButton.setAttributedTitle(NSAttributedString(string: optionButtonTitleDone, attributes: [NSFontAttributeName: optionButtonFontDone, NSForegroundColorAttributeName: optionButtonFontColorDoneHighlight]), forState: UIControlState.Highlighted)
        cancelButton.setAttributedTitle(NSAttributedString(string: optionButtonTitleCancel, attributes: [NSFontAttributeName: optionButtonFontCancel, NSForegroundColorAttributeName: optionButtonFontColorCancelHighlight]), forState: UIControlState.Highlighted)
        
        dayLabel.textColor = optionTopPanelFontColor
        dayLabel.font = optionTopPanelFont
        monthLabel.font = optionSelectorPanelFontMonth
        dateLabel.font = optionSelectorPanelFontDate
        yearLabel.font = optionSelectorPanelFontYear
        rangeStartLabel.font = optionSelectorPanelFontDate
        rangeEndLabel.font = optionSelectorPanelFontDate
        rangeToLabel.font = optionSelectorPanelFontDate
        
        let firstMonth = NSDate().beginningOfYear
        for button in monthsButtons {
            button.setTitle((firstMonth + button.tag.month).stringFromFormat("MMM"), forState: .Normal)
            button.titleLabel?.font = optionCalendarFontMonth
            button.tintColor = optionCalendarFontColorMonth
        }
        
        clockView.delegate = self
        clockView.minuteStep = optionTimeStep
        clockView.backgroundColorClockFace = optionClockBackgroundColorFace
        clockView.backgroundColorClockFaceCenter = optionClockBackgroundColorCenter
        clockView.fontAMPM = optionClockFontAMPM
        clockView.fontAMPMHighlight = optionClockFontAMPMHighlight
        clockView.fontColorAMPM = optionClockFontColorAMPM
        clockView.fontColorAMPMHighlight = optionClockFontColorAMPMHighlight
        clockView.backgroundColorAMPMHighlight = optionClockBackgroundColorAMPMHighlight
        clockView.fontHour = optionClockFontHour
        clockView.fontHourHighlight = optionClockFontHourHighlight
        clockView.fontColorHour = optionClockFontColorHour
        clockView.fontColorHourHighlight = optionClockFontColorHourHighlight
        clockView.backgroundColorHourHighlight = optionClockBackgroundColorHourHighlight
        clockView.backgroundColorHourHighlightNeedle = optionClockBackgroundColorHourHighlightNeedle
        clockView.fontMinute = optionClockFontMinute
        clockView.fontMinuteHighlight = optionClockFontMinuteHighlight
        clockView.fontColorMinute = optionClockFontColorMinute
        clockView.fontColorMinuteHighlight = optionClockFontColorMinuteHighlight
        clockView.backgroundColorMinuteHighlight = optionClockBackgroundColorMinuteHighlight
        clockView.backgroundColorMinuteHighlightNeedle = optionClockBackgroundColorMinuteHighlightNeedle
        
        updateDate()
        
        isFirstLoad = true
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if isFirstLoad {
            isFirstLoad = false // Temp fix for i6s+ bug?
            calendarTable.reloadData()
            yearTable.reloadData()
            clockView.setNeedsDisplay()
            selMultipleDatesTable.reloadData()
            didRotate()
            
            if optionStyles.showDateMonth {
                showDate(true)
            }
            else if optionStyles.showMonth {
                showMonth(true)
            }
            else if optionStyles.showYear {
                showYear(true)
            }
            else if optionStyles.showTime {
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
    
    internal func didRotate() {
        let orientation = UIApplication.sharedApplication().statusBarOrientation
        if orientation == .LandscapeLeft || orientation == .LandscapeRight || orientation == .Portrait || orientation == .PortraitUpsideDown {
            let isPortrait = orientation == .Portrait || orientation == .PortraitUpsideDown
            let size = view.bounds.size
            
            topContainerWidthConstraint.constant = isPortrait ? optionShowTopContainer ? portraitContainerWidth : 0 : landscapeTopContainerWidth
            topContainerHeightConstraint.constant = isPortrait ? portraitTopContainerHeight : optionShowTopContainer ? landscapeContainerHeight : 0
            bottomContainerWidthConstraint.constant = isPortrait ? portraitContainerWidth : landscapeBottomContainerWidth
            bottomContainerHeightConstraint.constant = isPortrait ? portraitBottomContainerHeight : landscapeContainerHeight
            
            if isPortrait {
                let width = min(size.width, size.height)
                let height = max(size.width, size.height)
                
                topContainerLeftConstraint.constant = (width - topContainerWidthConstraint.constant) / 2
                topContainerTopConstraint.constant = (height - (topContainerHeightConstraint.constant + bottomContainerHeightConstraint.constant)) / 2
                bottomContainerLeftConstraint.constant = optionShowTopContainer ? topContainerLeftConstraint.constant : (width - bottomContainerWidthConstraint.constant) / 2
                bottomContainerTopConstraint.constant = topContainerTopConstraint.constant + topContainerHeightConstraint.constant
            }
            else {
                let width = max(size.width, size.height)
                let height = min(size.width, size.height)
                
                topContainerLeftConstraint.constant = (width - (topContainerWidthConstraint.constant + bottomContainerWidthConstraint.constant)) / 2
                topContainerTopConstraint.constant = (height - topContainerHeightConstraint.constant) / 2
                bottomContainerLeftConstraint.constant = topContainerLeftConstraint.constant + topContainerWidthConstraint.constant
                bottomContainerTopConstraint.constant = optionShowTopContainer ? topContainerTopConstraint.constant : (height - bottomContainerHeightConstraint.constant) / 2
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
            
            if selCurrrent.showDateMonth {
                showDate(false)
            }
            else if selCurrrent.showMonth {
                showMonth(false)
            }
            else if selCurrrent.showYear {
                showYear(false)
            }
            else if selCurrrent.showTime {
                showTime(false)
            }
        }
    }
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.All]
    }
    
    public override func shouldAutorotate() -> Bool {
        return true
    }
    
    @IBAction func selectMonth(sender: UIButton) {
        let date = (optionCurrentDate.beginningOfYear + sender.tag.months).beginningOfDay
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day).beginningOfDay
            updateDate()
        }
    }
    
    @IBAction func selectStartRange() {
        if isSelectingStartRange == true {
            let date = optionCurrentDateRange.start
            
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        else {
            isSelectingStartRange = true
            shouldResetRange = false
        }
        updateDate()
    }
    
    @IBAction func selectEndRange() {
        if isSelectingStartRange == false {
            let date = optionCurrentDateRange.end
            
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
        }
        else {
            isSelectingStartRange = false
            shouldResetRange = false
        }
        updateDate()
    }
    
    @IBAction func showDate() {
        if optionStyles.showDateMonth {
            showDate(true)
        }
        else {
            showMonth(true)
        }
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
        if optionSelectionType == .Single {
            del?.WWCalendarTimeSelectorCancel?(picker, date: optionCurrentDate)
        }
        else {
            del?.WWCalendarTimeSelectorCancel?(picker, dates: multipleDates)
        }
        del?.WWCalendarTimeSelectorWillDismiss?(picker)
        dismissViewControllerAnimated(true) { 
            del?.WWCalendarTimeSelectorDidDismiss?(picker)
        }
    }
    
    @IBAction func done() {
        let picker = self
        let del = delegate
        switch optionSelectionType {
        case .Single:
            del?.WWCalendarTimeSelectorDone?(picker, date: optionCurrentDate)
        case .Multiple:
            del?.WWCalendarTimeSelectorDone?(picker, dates: multipleDates)
        case .Range:
            del?.WWCalendarTimeSelectorDone?(picker, dates: optionCurrentDateRange.array)
        }
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
                self.monthsView.alpha = 0
                self.yearTable.alpha = 0
                self.clockView.alpha = 0
            },
            completion: nil
        )
    }
    
    private func showMonth(userTap: Bool) {
        changeSelMonth()
        
        if userTap {
            
        }
        else {
            
        }
        
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.CurveEaseOut],
            animations: {
                self.calendarTable.alpha = 0
                self.monthsView.alpha = 1
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
                self.monthsView.alpha = 0
                self.yearTable.alpha = 1
                self.clockView.alpha = 0
            },
            completion: nil
        )
    }
    
    private func showTime(userTap: Bool) {
        if userTap {
            if selCurrrent.showTime {
                selTimeStateHour = !selTimeStateHour
            }
            else {
                selTimeStateHour = true
            }
        }
        
        if optionTimeStep == .SixtyMinutes {
            selTimeStateHour = true
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
                self.monthsView.alpha = 0
                self.yearTable.alpha = 0
                self.clockView.alpha = 1
            },
            completion: nil
        )
    }
    
    private func updateDate() {
        if let topPanelTitle = optionTopPanelTitle {
            dayLabel.text = topPanelTitle
        }
        else {
            if optionSelectionType == .Single {
                if optionStyles.showMonth {
                    dayLabel.text = optionCurrentDate.stringFromFormat("MMMM")
                }
                else {
                    dayLabel.text = optionCurrentDate.stringFromFormat("EEEE")
                }
            }
            else {
                dayLabel.text = defaultTopPanelTitleForMultipleDates
            }
        }
        
        monthLabel.text = optionCurrentDate.stringFromFormat("MMM")
        dateLabel.text = optionStyles.showDateMonth ? optionCurrentDate.stringFromFormat("d") : nil
        yearLabel.text = optionCurrentDate.stringFromFormat("yyyy")
        rangeStartLabel.text = optionCurrentDateRange.start.stringFromFormat("d' 'MMM' 'yyyy")
        rangeEndLabel.text = optionCurrentDateRange.end.stringFromFormat("d' 'MMM' 'yyyy")
        rangeToLabel.textColor = optionSelectorPanelFontColorDate
        if shouldResetRange {
            rangeStartLabel.textColor = optionSelectorPanelFontColorDateHighlight
            rangeEndLabel.textColor = optionSelectorPanelFontColorDateHighlight
        }
        else {
            rangeStartLabel.textColor = isSelectingStartRange ? optionSelectorPanelFontColorDateHighlight : optionSelectorPanelFontColorDate
            rangeEndLabel.textColor = isSelectingStartRange ? optionSelectorPanelFontColorDate : optionSelectorPanelFontColorDateHighlight
        }
        
        let timeText = optionCurrentDate.stringFromFormat("h':'mma").lowercaseString
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.Center
        let attrText = NSMutableAttributedString(string: timeText, attributes: [NSFontAttributeName: optionSelectorPanelFontTime, NSForegroundColorAttributeName: optionSelectorPanelFontColorTime, NSParagraphStyleAttributeName: paragraph])
        
        if selCurrrent.showDateMonth {
            monthLabel.textColor = optionSelectorPanelFontColorMonthHighlight
            dateLabel.textColor = optionSelectorPanelFontColorDateHighlight
            yearLabel.textColor = optionSelectorPanelFontColorYear
        }
        else if selCurrrent.showMonth {
            monthLabel.textColor = optionSelectorPanelFontColorMonthHighlight
            dateLabel.textColor = optionSelectorPanelFontColorDateHighlight
            yearLabel.textColor = optionSelectorPanelFontColorYear
        }
        else if selCurrrent.showYear {
            monthLabel.textColor = optionSelectorPanelFontColorMonth
            dateLabel.textColor = optionSelectorPanelFontColorDate
            yearLabel.textColor = optionSelectorPanelFontColorYearHighlight
        }
        else if selCurrrent.showTime {
            monthLabel.textColor = optionSelectorPanelFontColorMonth
            dateLabel.textColor = optionSelectorPanelFontColorDate
            yearLabel.textColor = optionSelectorPanelFontColorYear
            
            let colonIndex = timeText.startIndex.distanceTo(timeText.rangeOfString(":")!.startIndex)
            let hourRange = NSRange(location: 0, length: colonIndex)
            let minuteRange = NSRange(location: colonIndex + 1, length: 2)
            
            if selTimeStateHour {
                attrText.addAttributes([NSForegroundColorAttributeName: optionSelectorPanelFontColorTimeHighlight], range: hourRange)
            }
            else {
                attrText.addAttributes([NSForegroundColorAttributeName: optionSelectorPanelFontColorTimeHighlight], range: minuteRange)
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
        selMonthYConstraint.constant = -optionSelectorPanelOffsetHighlightMonth
        selDateXConstraint.constant = 0
        selDateYConstraint.constant = optionSelectorPanelOffsetHighlightDate
        
        // adjust positions
        selDateTopConstraint.constant = 0
        selDateLeftConstraint.constant = 0
        selDateRightConstraint.constant = 0
        selDateHeightConstraint.constant = optionStyles.countComponents() > 1 ? selActiveHeight : selActiveHeightFull
        
        selYearLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        if optionStyles.showYear {
            selYearTopConstraint.constant = selActiveHeight
            selYearHeightConstraint.constant = selInactiveHeight
            if optionStyles.showTime {
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
            if optionStyles.showTime {
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
        
        monthLabel.contentScaleFactor = UIScreen.mainScreen().scale * optionSelectorPanelScaleMonth
        dateLabel.contentScaleFactor = UIScreen.mainScreen().scale * optionSelectorPanelScaleDate
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                self.monthLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.optionSelectorPanelScaleMonth, self.optionSelectorPanelScaleMonth)
                self.dateLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.optionSelectorPanelScaleDate, self.optionSelectorPanelScaleDate)
                self.yearLabel.transform = CGAffineTransformIdentity
                self.timeLabel.transform = CGAffineTransformIdentity
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if self.selCurrrent.showDateMonth {
                    self.yearLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.timeLabel.contentScaleFactor = UIScreen.mainScreen().scale
                }
            }
        )
        selCurrrent.showDateMonth(true)
        updateDate()
    }
    
    private func changeSelMonth() {
        let selActiveHeight = self.selActiveHeight
        let selInactiveHeight = self.selInactiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = CGRectGetHeight(backgroundSelView.frame)
        
        backgroundSelView.sendSubviewToBack(selYearView)
        backgroundSelView.sendSubviewToBack(selTimeView)
        
        // adjust date view
        selMonthXConstraint.constant = 0
        selMonthYConstraint.constant = 0
        selDateXConstraint.constant = 0
        selDateYConstraint.constant = 0
        
        // adjust positions
        selDateTopConstraint.constant = 0
        selDateLeftConstraint.constant = 0
        selDateRightConstraint.constant = 0
        selDateHeightConstraint.constant = optionStyles.countComponents() > 1 ? selActiveHeight : selActiveHeightFull
        
        selYearLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        if optionStyles.showYear {
            selYearTopConstraint.constant = selActiveHeight
            selYearHeightConstraint.constant = selInactiveHeight
            if optionStyles.showTime {
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
            if optionStyles.showTime {
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
        
        monthLabel.contentScaleFactor = UIScreen.mainScreen().scale * optionSelectorPanelScaleMonth
        dateLabel.contentScaleFactor = UIScreen.mainScreen().scale * optionSelectorPanelScaleDate
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                self.monthLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.optionSelectorPanelScaleMonth, self.optionSelectorPanelScaleMonth)
                self.dateLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.optionSelectorPanelScaleDate, self.optionSelectorPanelScaleDate)
                self.yearLabel.transform = CGAffineTransformIdentity
                self.timeLabel.transform = CGAffineTransformIdentity
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if self.selCurrrent.showMonth {
                    self.yearLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.timeLabel.contentScaleFactor = UIScreen.mainScreen().scale
                }
            }
        )
        selCurrrent.showDateMonth(true)
        updateDate()
    }
    
    private func changeSelYear() {
        let selInactiveHeight = self.selInactiveHeight
        let selActiveHeight = self.selActiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selMonthX = monthLabel.bounds.width / 2
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = CGRectGetHeight(backgroundSelView.frame)
        
        backgroundSelView.sendSubviewToBack(selDateView)
        backgroundSelView.sendSubviewToBack(selTimeView)
        
        selDateXConstraint.constant = optionStyles.showDateMonth ? -selMonthX : 0
        selDateYConstraint.constant = 0
        selMonthXConstraint.constant = optionStyles.showDateMonth ? selMonthX : 0
        selMonthYConstraint.constant = 0
        
        selYearTopConstraint.constant = 0
        selYearLeftConstraint.constant = 0
        selYearRightConstraint.constant = 0
        selYearHeightConstraint.constant = optionStyles.countComponents() > 1 ? selActiveHeight : selActiveHeightFull
        
        selDateLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        
        if optionStyles.showDateMonth || optionStyles.showMonth {
            selDateHeightConstraint.constant = selInactiveHeight
            selDateTopConstraint.constant = selActiveHeight
            if optionStyles.showTime {
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
            if optionStyles.showTime {
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
        
        yearLabel.contentScaleFactor = UIScreen.mainScreen().scale * optionSelectorPanelScaleYear
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                self.yearLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.optionSelectorPanelScaleYear, self.optionSelectorPanelScaleYear)
                self.monthLabel.transform = CGAffineTransformIdentity
                self.dateLabel.transform = CGAffineTransformIdentity
                self.timeLabel.transform = CGAffineTransformIdentity
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if self.selCurrrent.showYear {
                    self.monthLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.dateLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.timeLabel.contentScaleFactor = UIScreen.mainScreen().scale
                }
            }
        )
        selCurrrent.showYear(true)
        updateDate()
    }
    
    private func changeSelTime() {
        let selInactiveHeight = self.selInactiveHeight
        let selActiveHeight = self.selActiveHeight
        let selInactiveWidth = self.selInactiveWidth
        let selMonthX = monthLabel.bounds.width / 2
        let selInactiveWidthDouble = selInactiveWidth * 2
        let selActiveHeightFull = CGRectGetHeight(backgroundSelView.frame)
        
        backgroundSelView.sendSubviewToBack(selYearView)
        backgroundSelView.sendSubviewToBack(selDateView)
        
        selDateXConstraint.constant = optionStyles.showDateMonth ? -selMonthX : 0
        selDateYConstraint.constant = 0
        selMonthXConstraint.constant = optionStyles.showDateMonth ? selMonthX : 0
        selMonthYConstraint.constant = 0
        
        selTimeTopConstraint.constant = 0
        selTimeLeftConstraint.constant = 0
        selTimeRightConstraint.constant = 0
        selTimeHeightConstraint.constant = optionStyles.countComponents() > 1 ? selActiveHeight : selActiveHeightFull
        
        selDateLeftConstraint.constant = 0
        selYearRightConstraint.constant = 0
        if optionStyles.showDateMonth || optionStyles.showMonth {
            selDateHeightConstraint.constant = selInactiveHeight
            selDateTopConstraint.constant = selActiveHeight
            if optionStyles.showYear {
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
            if optionStyles.showYear {
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
        
        timeLabel.contentScaleFactor = UIScreen.mainScreen().scale * optionSelectorPanelScaleTime
        UIView.animateWithDuration(
            selAnimationDuration,
            delay: 0,
            usingSpringWithDamping: 0.8,
            initialSpringVelocity: 0,
            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction],
            animations: {
                self.timeLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, self.optionSelectorPanelScaleTime, self.optionSelectorPanelScaleTime)
                self.monthLabel.transform = CGAffineTransformIdentity
                self.dateLabel.transform = CGAffineTransformIdentity
                self.yearLabel.transform = CGAffineTransformIdentity
                self.view.layoutIfNeeded()
            },
            completion: { _ in
                if self.selCurrrent.showTime {
                    self.monthLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.dateLabel.contentScaleFactor = UIScreen.mainScreen().scale
                    self.yearLabel.contentScaleFactor = UIScreen.mainScreen().scale
                }
            }
        )
        selCurrrent.showTime(true)
        updateDate()
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if tableView == calendarTable {
            return tableView.frame.height / 8
        }
        else if tableView == yearTable {
            return tableView.frame.height / 5
        }
        return tableView.frame.height / 5
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == calendarTable {
            return 16
        }
        else if tableView == yearTable {
            return 11
        }
        return multipleDates.count
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
                calRow.backgroundColor = UIColor.clearColor()
                calRow.monthFont = optionCalendarFontMonth
                calRow.monthFontColor = optionCalendarFontColorMonth
                calRow.dayFont = optionCalendarFontDays
                calRow.dayFontColor = optionCalendarFontColorDays
                calRow.datePastFont = optionCalendarFontPastDates
                calRow.datePastFontHighlight = optionCalendarFontPastDatesHighlight
                calRow.datePastFontColor = optionCalendarFontColorPastDates
                calRow.datePastHighlightFontColor = optionCalendarFontColorPastDatesHighlight
                calRow.datePastHighlightBackgroundColor = optionCalendarBackgroundColorPastDatesHighlight
                calRow.datePastFlashBackgroundColor = optionCalendarBackgroundColorPastDatesFlash
                calRow.dateTodayFont = optionCalendarFontToday
                calRow.dateTodayFontHighlight = optionCalendarFontTodayHighlight
                calRow.dateTodayFontColor = optionCalendarFontColorToday
                calRow.dateTodayHighlightFontColor = optionCalendarFontColorTodayHighlight
                calRow.dateTodayHighlightBackgroundColor = optionCalendarBackgroundColorTodayHighlight
                calRow.dateTodayFlashBackgroundColor = optionCalendarBackgroundColorTodayFlash
                calRow.dateFutureFont = optionCalendarFontFutureDates
                calRow.dateFutureFontHighlight = optionCalendarFontFutureDatesHighlight
                calRow.dateFutureFontColor = optionCalendarFontColorFutureDates
                calRow.dateFutureHighlightFontColor = optionCalendarFontColorFutureDatesHighlight
                calRow.dateFutureHighlightBackgroundColor = optionCalendarBackgroundColorFutureDatesHighlight
                calRow.dateFutureFlashBackgroundColor = optionCalendarBackgroundColorFutureDatesFlash
                calRow.flashDuration = selAnimationDuration
                calRow.multipleSelectionGrouping = optionMultipleSelectionGrouping
                calRow.multipleSelectionEnabled = optionSelectionType != .Single
                cell.contentView.addSubview(calRow)
                cell.backgroundColor = UIColor.clearColor()
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
                cell.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[cr]|", options: [], metrics: nil, views: ["cr": calRow]))
            }
            
            for sv in cell.contentView.subviews {
                if let calRow = sv as? WWCalendarRow {
                    calRow.tag = indexPath.row + 1
                    switch optionSelectionType {
                    case .Single:
                        calRow.selectedDates = [optionCurrentDate]
                    case .Multiple:
                        calRow.selectedDates = optionCurrentDates
                    case .Range:
                        calRow.selectedDates = Set(optionCurrentDateRange.array)
                    }
                    calRow.setNeedsDisplay()
                    if let fd = flashDate {
                        if calRow.flashDate(fd) {
                            flashDate = nil
                        }
                    }
                }
            }
        }
        else if tableView == yearTable {
            if let c = tableView.dequeueReusableCellWithIdentifier("cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
                cell.backgroundColor = UIColor.clearColor()
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            
            let currentYear = NSDate().year
            let displayYear = yearRow1 + indexPath.row
            if displayYear > currentYear {
                cell.textLabel?.font = optionCurrentDate.year == displayYear ? optionCalendarFontFutureYearsHighlight : optionCalendarFontFutureYears
                cell.textLabel?.textColor = optionCurrentDate.year == displayYear ? optionCalendarFontColorFutureYearsHighlight : optionCalendarFontColorFutureYears
            }
            else if displayYear < currentYear {
                cell.textLabel?.font = optionCurrentDate.year == displayYear ? optionCalendarFontPastYearsHighlight : optionCalendarFontPastYears
                cell.textLabel?.textColor = optionCurrentDate.year == displayYear ? optionCalendarFontColorPastYearsHighlight : optionCalendarFontColorPastYears
            }
            else {
                cell.textLabel?.font = optionCurrentDate.year == displayYear ? optionCalendarFontCurrentYearHighlight : optionCalendarFontCurrentYear
                cell.textLabel?.textColor = optionCurrentDate.year == displayYear ? optionCalendarFontColorCurrentYearHighlight : optionCalendarFontColorCurrentYear
            }
            cell.textLabel?.text = "\(displayYear)"
        }
        else { // multiple dates table
            if let c = tableView.dequeueReusableCellWithIdentifier("cell") {
                cell = c
            }
            else {
                cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
                cell.textLabel?.textAlignment = NSTextAlignment.Center
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.backgroundColor = UIColor.clearColor()
            }
            
            let date = multipleDates[indexPath.row]
            cell.textLabel?.font = date == multipleDatesLastAdded ? optionSelectorPanelFontMultipleSelectionHighlight : optionSelectorPanelFontMultipleSelection
            cell.textLabel?.textColor = date == multipleDatesLastAdded ? optionSelectorPanelFontColorMultipleSelectionHighlight : optionSelectorPanelFontColorMultipleSelection
            cell.textLabel?.text = date.stringFromFormat("EEE', 'd' 'MMM' 'yyyy")
        }
        
        return cell
    }
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if tableView == yearTable {
            let displayYear = yearRow1 + indexPath.row
            let newDate = optionCurrentDate.change(year: displayYear)
            if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: newDate) ?? true {
                optionCurrentDate = newDate
                updateDate()
                tableView.reloadData()
            }
        }
        else if tableView == selMultipleDatesTable {
            let date = multipleDates[indexPath.row]
            multipleDatesLastAdded = date
            selMultipleDatesTable.reloadData()
            let seventhRowStartDate = date.beginningOfMonth
            calRow3StartDate = ((seventhRowStartDate - 1.day).beginningOfWeek - 1.day).beginningOfWeek
            calRow2StartDate = (calRow3StartDate - 1.day).beginningOfWeek
            calRow1StartDate = (calRow2StartDate - 1.day).beginningOfWeek
            
            flashDate = date
            calendarTable.reloadData()
            calendarTable.scrollToRowAtIndexPath(NSIndexPath(forRow: 4, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
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
        else if scrollView == yearTable {
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
        if delegate?.WWCalendarTimeSelectorShouldSelectDate?(self, date: date) ?? true {
            switch optionSelectionType {
            case .Single:
                optionCurrentDate = optionCurrentDate.change(year: date.year, month: date.month, day: date.day)
                updateDate()
                
            case .Multiple:
                var indexPath: NSIndexPath
                var indexPathToReload: NSIndexPath? = nil
                
                if let d = multipleDatesLastAdded {
                    let indexToReload = multipleDates.indexOf(d)!
                    indexPathToReload = NSIndexPath(forRow: indexToReload, inSection: 0)
                }
                
                if let indexToDelete = multipleDates.indexOf(date) {
                    // delete...
                    indexPath = NSIndexPath(forRow: indexToDelete, inSection: 0)
                    optionCurrentDates.remove(date)
                    
                    selMultipleDatesTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
                    
                    multipleDatesLastAdded = nil
                    selMultipleDatesTable.beginUpdates()
                    selMultipleDatesTable.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)
                    if let ip = indexPathToReload where ip != indexPath {
                        selMultipleDatesTable.reloadRowsAtIndexPaths([ip], withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                    selMultipleDatesTable.endUpdates()
                }
                else {
                    // insert...
                    var shouldScroll = false
                    
                    optionCurrentDates.insert(date)
                    let indexToAdd = multipleDates.indexOf(date)!
                    indexPath = NSIndexPath(forRow: indexToAdd, inSection: 0)
                    
                    if indexPath.row < optionCurrentDates.count - 1 {
                        selMultipleDatesTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
                    }
                    else {
                        shouldScroll = true
                    }
                    
                    multipleDatesLastAdded = date
                    selMultipleDatesTable.beginUpdates()
                    selMultipleDatesTable.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Right)
                    if let ip = indexPathToReload {
                        selMultipleDatesTable.reloadRowsAtIndexPaths([ip], withRowAnimation: UITableViewRowAnimation.Fade)
                    }
                    selMultipleDatesTable.endUpdates()
                    
                    if shouldScroll {
                        selMultipleDatesTable.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Middle, animated: true)
                    }
                }
                
            case .Range:
                
                let rangeDate = date.beginningOfDay
                if shouldResetRange {
                    optionCurrentDateRange.setStartDate(rangeDate)
                    optionCurrentDateRange.setEndDate(rangeDate)
                    isSelectingStartRange = false
                    shouldResetRange = false
                }
                else {
                    if isSelectingStartRange {
                        optionCurrentDateRange.setStartDate(rangeDate)
                        isSelectingStartRange = false
                    }
                    else {
                        optionCurrentDateRange.setEndDate(rangeDate)
                        shouldResetRange = true
                    }
                }
                updateDate()
            }
            calendarTable.reloadData()
        }
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
            options: [UIViewAnimationOptions.TransitionCrossDissolve, UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.BeginFromCurrentState],
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
    internal var monthFont: UIFont!
    internal var monthFontColor: UIColor!
    internal var dayFont: UIFont!
    internal var dayFontColor: UIColor!
    internal var datePastFont: UIFont!
    internal var datePastFontHighlight: UIFont!
    internal var datePastFontColor: UIColor!
    internal var datePastHighlightFontColor: UIColor!
    internal var datePastHighlightBackgroundColor: UIColor!
    internal var datePastFlashBackgroundColor: UIColor!
    internal var dateTodayFont: UIFont!
    internal var dateTodayFontHighlight: UIFont!
    internal var dateTodayFontColor: UIColor!
    internal var dateTodayHighlightFontColor: UIColor!
    internal var dateTodayHighlightBackgroundColor: UIColor!
    internal var dateTodayFlashBackgroundColor: UIColor!
    internal var dateFutureFont: UIFont!
    internal var dateFutureFontHighlight: UIFont!
    internal var dateFutureFontColor: UIColor!
    internal var dateFutureHighlightFontColor: UIColor!
    internal var dateFutureHighlightBackgroundColor: UIColor!
    internal var dateFutureFlashBackgroundColor: UIColor!
    internal var flashDuration: NSTimeInterval!
    internal var multipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping = .Pill
    internal var multipleSelectionEnabled: Bool = false
    
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
    private let multipleSelectionBorder: CGFloat = 12
    private let multipleSelectionBar: CGFloat = 8
    
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
            
            let str = NSAttributedString(string: monthName, attributes: [NSFontAttributeName: monthFont, NSForegroundColorAttributeName: monthFontColor, NSParagraphStyleAttributeName: paragraph])
            str.drawInRect(CGRect(x: 0, y: boxHeight - monthHeight, width: rect.width, height: monthHeight))
        }
        else if detail.type == .Day {
            let dayHeight = ceil(dayFont.lineHeight)
            let y = (boxHeight - dayHeight) / 2
            
            for i in days.enumerate() {
                let str = NSAttributedString(string: i.element, attributes: [NSFontAttributeName: dayFont, NSForegroundColorAttributeName: dayFontColor, NSParagraphStyleAttributeName: paragraph])
                str.drawInRect(CGRect(x: CGFloat(i.index) * boxWidth, y: y, width: boxWidth, height: dayHeight))
            }
        }
        else {
            let today = NSDate().beginningOfDay
            var date = startDate
            var str: NSMutableAttributedString
            
            for i in 1...7 {
                if date.weekday == i {
                    var font = comparisonDates.contains(date) ? dateFutureFontHighlight : dateFutureFont
                    var fontColor = dateFutureFontColor
                    var fontHighlightColor = dateFutureHighlightFontColor
                    var backgroundHighlightColor = dateFutureHighlightBackgroundColor.CGColor
                    if date == today {
                        font = comparisonDates.contains(date) ? dateTodayFontHighlight : dateTodayFont
                        fontColor = dateTodayFontColor
                        fontHighlightColor = dateTodayHighlightFontColor
                        backgroundHighlightColor = dateTodayHighlightBackgroundColor.CGColor
                    }
                    else if date.compare(today) == NSComparisonResult.OrderedAscending {
                        font = comparisonDates.contains(date) ? datePastFontHighlight : datePastFont
                        fontColor = datePastFontColor
                        fontHighlightColor = datePastHighlightFontColor
                        backgroundHighlightColor = datePastHighlightBackgroundColor.CGColor
                    }
                    
                    let dateHeight = ceil(font.lineHeight)
                    let y = (boxHeight - dateHeight) / 2
                    
                    if comparisonDates.contains(date) {
                        CGContextSetFillColorWithColor(ctx, backgroundHighlightColor)
                        
                        if multipleSelectionEnabled {
                            var testStringSize = NSAttributedString(string: "00", attributes: [NSFontAttributeName: dateTodayFontHighlight, NSParagraphStyleAttributeName: paragraph]).size()
                            var dateMaxWidth = testStringSize.width
                            var dateMaxHeight = testStringSize.height
                            if dateFutureFontHighlight.lineHeight > dateTodayFontHighlight.lineHeight {
                                testStringSize = NSAttributedString(string: "00", attributes: [NSFontAttributeName: dateFutureFontHighlight, NSParagraphStyleAttributeName: paragraph]).size()
                                dateMaxWidth = testStringSize.width
                                dateMaxHeight = testStringSize.height
                            }
                            if datePastFontHighlight.lineHeight > dateFutureFontHighlight.lineHeight {
                                testStringSize = NSAttributedString(string: "00", attributes: [NSFontAttributeName: datePastFontHighlight, NSParagraphStyleAttributeName: paragraph]).size()
                                dateMaxWidth = testStringSize.width
                                dateMaxHeight = testStringSize.height
                            }
                            
                            let size = min(max(dateHeight, dateMaxWidth) + multipleSelectionBorder, min(boxHeight, boxWidth))
                            let maxConnectorSize = min(max(dateMaxHeight, dateMaxWidth) + multipleSelectionBorder, min(boxHeight, boxWidth))
                            let x = CGFloat(i - 1) * boxWidth + (boxWidth - size) / 2
                            let y = (boxHeight - size) / 2
                            
                            // connector
                            switch multipleSelectionGrouping {
                            case .Simple:
                                break
                            case .Pill:
                                if comparisonDates.contains(date - 1.day) {
                                    CGContextFillRect(ctx, CGRect(x: CGFloat(i - 1) * boxWidth, y: y, width: boxWidth / 2 + 1, height: maxConnectorSize))
                                }
                                if comparisonDates.contains(date + 1.day) {
                                    CGContextFillRect(ctx, CGRect(x: CGFloat(i - 1) * boxWidth + boxWidth / 2, y: y, width: boxWidth / 2 + 1, height: maxConnectorSize))
                                }
                            case .LinkedBalls:
                                if comparisonDates.contains(date - 1.day) {
                                    CGContextFillRect(ctx, CGRect(x: CGFloat(i - 1) * boxWidth, y: (boxHeight - multipleSelectionBar) / 2, width: boxWidth / 2 + 1, height: multipleSelectionBar))
                                }
                                if comparisonDates.contains(date + 1.day) {
                                    CGContextFillRect(ctx, CGRect(x: CGFloat(i - 1) * boxWidth + boxWidth / 2, y: (boxHeight - multipleSelectionBar) / 2, width: boxWidth / 2 + 1, height: multipleSelectionBar))
                                }
                            }
                            
                            // ball
                            CGContextFillEllipseInRect(ctx, CGRect(x: x, y: y, width: size, height: size))
                        }
                        else {
                            let size = min(boxHeight, boxWidth)
                            let x = CGFloat(i - 1) * boxWidth + (boxWidth - size) / 2
                            let y = (boxHeight - size) / 2
                            CGContextFillEllipseInRect(ctx, CGRect(x: x, y: y, width: size, height: size))
                        }
                        
                        str = NSMutableAttributedString(string: "\(date.day)", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: fontHighlightColor, NSParagraphStyleAttributeName: paragraph])
                    }
                    else {
                        str = NSMutableAttributedString(string: "\(date.day)", attributes: [NSFontAttributeName: font, NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: paragraph])
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
    
    private func flashDate(date: NSDate) -> Bool {
        let detail = delegate.WWCalendarRowGetDetails(tag)
        
        if detail.type == .Date {
            let today = NSDate().beginningOfDay
            let startDate = detail.startDate.beginningOfDay
            let flashDate = date.beginningOfDay
            let boxHeight = bounds.height
            let boxWidth = bounds.width / 7
            var date = startDate
            
            for i in 1...7 {
                if date.weekday == i {
                    if date == flashDate {
                        var flashColor = dateFutureFlashBackgroundColor
                        if flashDate == today {
                            flashColor = dateTodayFlashBackgroundColor
                        }
                        else if flashDate.compare(today) == NSComparisonResult.OrderedAscending {
                            flashColor = datePastFlashBackgroundColor
                        }
                        
                        let flashView = UIView(frame: CGRect(x: CGFloat(i - 1) * boxWidth, y: 0, width: boxWidth, height: boxHeight))
                        flashView.backgroundColor = flashColor
                        flashView.alpha = 0
                        addSubview(flashView)
                        UIView.animateWithDuration(
                            flashDuration / 2,
                            delay: 0,
                            options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseOut],
                            animations: { 
                                flashView.alpha = 0.75
                            },
                            completion: { _ in
                                UIView.animateWithDuration(
                                    self.flashDuration / 2,
                                    delay: 0,
                                    options: [UIViewAnimationOptions.AllowAnimatedContent, UIViewAnimationOptions.AllowUserInteraction, UIViewAnimationOptions.BeginFromCurrentState, UIViewAnimationOptions.CurveEaseIn],
                                    animations: {
                                        flashView.alpha = 0
                                    },
                                    completion: { _ in
                                        flashView.removeFromSuperview()
                                    }
                                )
                            }
                        )
                        return true
                    }
                    date = date + 1.day
                    if date.month != startDate.month {
                        break
                    }
                }
            }
        }
        return false
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
    internal var backgroundColorClockFace: UIColor!
    internal var backgroundColorClockFaceCenter: UIColor!
    internal var fontAMPM: UIFont!
    internal var fontAMPMHighlight: UIFont!
    internal var fontColorAMPM: UIColor!
    internal var fontColorAMPMHighlight: UIColor!
    internal var backgroundColorAMPMHighlight: UIColor!
    internal var fontHour: UIFont!
    internal var fontHourHighlight: UIFont!
    internal var fontColorHour: UIColor!
    internal var fontColorHourHighlight: UIColor!
    internal var backgroundColorHourHighlight: UIColor!
    internal var backgroundColorHourHighlightNeedle: UIColor!
    internal var fontMinute: UIFont!
    internal var fontMinuteHighlight: UIFont!
    internal var fontColorMinute: UIColor!
    internal var fontColorMinuteHighlight: UIColor!
    internal var backgroundColorMinuteHighlight: UIColor!
    internal var backgroundColorMinuteHighlightNeedle: UIColor!
    
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
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = NSTextAlignment.Center
        
        CGContextSetFillColorWithColor(ctx, backgroundColorClockFace.CGColor)
        CGContextFillEllipseInRect(ctx, CGRect(x: faceX, y: faceY, width: faceSize, height: faceSize))
        
        CGContextSetFillColorWithColor(ctx, backgroundColorAMPMHighlight.CGColor)
        if time.hour < 12 {
            CGContextFillEllipseInRect(ctx, CGRect(x: amX, y: ampmY, width: ampmSize, height: ampmSize))
            var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: fontAMPMHighlight, NSForegroundColorAttributeName: fontColorAMPMHighlight, NSParagraphStyleAttributeName: paragraph])
            var ampmHeight = fontAMPMHighlight.lineHeight
            str.drawInRect(CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
            str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: fontAMPM, NSForegroundColorAttributeName: fontColorAMPM, NSParagraphStyleAttributeName: paragraph])
            ampmHeight = fontAMPM.lineHeight
            str.drawInRect(CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
        }
        else {
            CGContextFillEllipseInRect(ctx, CGRect(x: pmX, y: ampmY, width: ampmSize, height: ampmSize))
            var str = NSAttributedString(string: "AM", attributes: [NSFontAttributeName: fontAMPM, NSForegroundColorAttributeName: fontColorAMPM, NSParagraphStyleAttributeName: paragraph])
            var ampmHeight = fontAMPM.lineHeight
            str.drawInRect(CGRect(x: amX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
            str = NSAttributedString(string: "PM", attributes: [NSFontAttributeName: fontAMPMHighlight, NSForegroundColorAttributeName: fontColorAMPMHighlight, NSParagraphStyleAttributeName: paragraph])
            ampmHeight = fontAMPMHighlight.lineHeight
            str.drawInRect(CGRect(x: pmX, y: ampmY + (ampmSize - ampmHeight) / 2, width: ampmSize, height: ampmHeight))
        }
        
        if showingHour {
            let textAttr = [NSFontAttributeName: fontHour, NSForegroundColorAttributeName: fontColorHour, NSParagraphStyleAttributeName: paragraph]
            let textAttrHighlight = [NSFontAttributeName: fontHourHighlight, NSForegroundColorAttributeName: fontColorHourHighlight, NSParagraphStyleAttributeName: paragraph]
            
            let templateSize = NSAttributedString(string: "12", attributes: textAttr).size()
            let templateSizeHighlight = NSAttributedString(string: "12", attributes: textAttrHighlight).size()
            let maxSize = max(templateSize.width, templateSize.height)
            let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
            let highlightCircleSize = maxSizeHighlight + numberCircleBorder
            let radius = faceSize / 2 - maxSize
            let radiusHighlight = faceSize / 2 - maxSizeHighlight
            
            CGContextSaveGState(ctx)
            CGContextTranslateCTM(ctx, faceX + faceSize / 2, faceY + faceSize / 2) // everything starts at clock face center
            
            let degreeIncrement = 360 / CGFloat(hours.count)
            let currentHour = get12Hour(time)
            
            for h in hours.enumerate() {
                let angle = getClockRad(CGFloat(h.index) * degreeIncrement)
                
                if h.element == currentHour {
                    // needle
                    CGContextSaveGState(ctx)
                    CGContextSetStrokeColorWithColor(ctx, backgroundColorHourHighlightNeedle.CGColor)
                    CGContextSetLineWidth(ctx, 1)
                    CGContextMoveToPoint(ctx, 0, 0)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextAddLineToPoint(ctx, (radiusHighlight - highlightCircleSize / 2) * cos(angle), -((radiusHighlight - highlightCircleSize / 2) * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextStrokePath(ctx)
                    CGContextRestoreGState(ctx)
                    
                    // highlight
                    CGContextSaveGState(ctx)
                    CGContextSetFillColorWithColor(ctx, backgroundColorHourHighlight.CGColor)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, radiusHighlight * cos(angle), -(radiusHighlight * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextFillEllipseInRect(ctx, CGRect(x: -highlightCircleSize / 2, y: -highlightCircleSize / 2, width: highlightCircleSize, height: highlightCircleSize))
                    CGContextRestoreGState(ctx)
                    
                    // numbers
                    let hour = NSAttributedString(string: "\(h.element)", attributes: textAttrHighlight)
                    CGContextSaveGState(ctx)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, radiusHighlight * cos(angle), -(radiusHighlight * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, -hour.size().width / 2, -hour.size().height / 2)
                    hour.drawAtPoint(CGPoint.zero)
                    CGContextRestoreGState(ctx)
                }
                else {
                    // numbers
                    let hour = NSAttributedString(string: "\(h.element)", attributes: textAttr)
                    CGContextSaveGState(ctx)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, radius * cos(angle), -(radius * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, -hour.size().width / 2, -hour.size().height / 2)
                    hour.drawAtPoint(CGPoint.zero)
                    CGContextRestoreGState(ctx)
                }
            }
        }
        else {
            let textAttr = [NSFontAttributeName: fontMinute, NSForegroundColorAttributeName: fontColorMinute, NSParagraphStyleAttributeName: paragraph]
            let textAttrHighlight = [NSFontAttributeName: fontMinuteHighlight, NSForegroundColorAttributeName: fontColorMinuteHighlight, NSParagraphStyleAttributeName: paragraph]
            let templateSize = NSAttributedString(string: "60", attributes: textAttr).size()
            let templateSizeHighlight = NSAttributedString(string: "60", attributes: textAttrHighlight).size()
            let maxSize = max(templateSize.width, templateSize.height)
            let maxSizeHighlight = max(templateSizeHighlight.width, templateSizeHighlight.height)
            let minSize: CGFloat = 0
            let highlightCircleMaxSize = maxSizeHighlight + numberCircleBorder
            let highlightCircleMinSize = minSize + numberCircleBorder
            let radius = faceSize / 2 - maxSize
            let radiusHighlight = faceSize / 2 - maxSizeHighlight
            
            CGContextSaveGState(ctx)
            CGContextTranslateCTM(ctx, faceX + faceSize / 2, faceY + faceSize / 2) // everything starts at clock face center
            
            let degreeIncrement = 360 / CGFloat(minutes.count)
            let currentMinute = get60Minute(time)
            
            for m in minutes.enumerate() {
                let angle = getClockRad(CGFloat(m.index) * degreeIncrement)
                
                if m.element == currentMinute {
                    // needle
                    CGContextSaveGState(ctx)
                    CGContextSetStrokeColorWithColor(ctx, backgroundColorMinuteHighlightNeedle.CGColor)
                    CGContextSetLineWidth(ctx, 1)
                    CGContextMoveToPoint(ctx, 0, 0)
                    CGContextScaleCTM(ctx, -1, 1)
                    if minuteStep.rawValue < 5 && m.element % 5 != 0 {
                        CGContextAddLineToPoint(ctx, (radiusHighlight - highlightCircleMinSize / 2) * cos(angle), -((radiusHighlight - highlightCircleMinSize / 2) * sin(angle)))
                    }
                    else {
                        CGContextAddLineToPoint(ctx, (radiusHighlight - highlightCircleMaxSize / 2) * cos(angle), -((radiusHighlight - highlightCircleMaxSize / 2) * sin(angle)))
                    }
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextStrokePath(ctx)
                    CGContextRestoreGState(ctx)
                    
                    // highlight
                    CGContextSaveGState(ctx)
                    CGContextSetFillColorWithColor(ctx, backgroundColorMinuteHighlight.CGColor)
                    CGContextScaleCTM(ctx, -1, 1)
                    CGContextTranslateCTM(ctx, radiusHighlight * cos(angle), -(radiusHighlight * sin(angle)))
                    CGContextScaleCTM(ctx, -1, 1)
                    if minuteStep.rawValue < 5 && m.element % 5 != 0 {
                        CGContextFillEllipseInRect(ctx, CGRect(x: -highlightCircleMinSize / 2, y: -highlightCircleMinSize / 2, width: highlightCircleMinSize, height: highlightCircleMinSize))
                    }
                    else {
                        CGContextFillEllipseInRect(ctx, CGRect(x: -highlightCircleMaxSize / 2, y: -highlightCircleMaxSize / 2, width: highlightCircleMaxSize, height: highlightCircleMaxSize))
                    }
                    CGContextRestoreGState(ctx)
                    
                    // numbers
                    if minuteStep.rawValue < 5 {
                        if m.element % 5 == 0 {
                            let min = NSAttributedString(string: "\(m.element)", attributes: textAttrHighlight)
                            CGContextSaveGState(ctx)
                            CGContextScaleCTM(ctx, -1, 1)
                            CGContextTranslateCTM(ctx, radiusHighlight * cos(angle), -(radiusHighlight * sin(angle)))
                            CGContextScaleCTM(ctx, -1, 1)
                            CGContextTranslateCTM(ctx, -min.size().width / 2, -min.size().height / 2)
                            min.drawAtPoint(CGPoint.zero)
                            CGContextRestoreGState(ctx)
                        }
                    }
                    else {
                        let min = NSAttributedString(string: "\(m.element)", attributes: textAttrHighlight)
                        CGContextSaveGState(ctx)
                        CGContextScaleCTM(ctx, -1, 1)
                        CGContextTranslateCTM(ctx, radiusHighlight * cos(angle), -(radiusHighlight * sin(angle)))
                        CGContextScaleCTM(ctx, -1, 1)
                        CGContextTranslateCTM(ctx, -min.size().width / 2, -min.size().height / 2)
                        min.drawAtPoint(CGPoint.zero)
                        CGContextRestoreGState(ctx)
                    }
                }
                else {
                    // numbers
                    if minuteStep.rawValue < 5 {
                        if m.element % 5 == 0 {
                            let min = NSAttributedString(string: "\(m.element)", attributes: textAttr)
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
                        let min = NSAttributedString(string: "\(m.element)", attributes: textAttr)
                        CGContextSaveGState(ctx)
                        CGContextScaleCTM(ctx, -1, 1)
                        CGContextTranslateCTM(ctx, radius * cos(angle), -(radius * sin(angle)))
                        CGContextScaleCTM(ctx, -1, 1)
                        CGContextTranslateCTM(ctx, -min.size().width / 2, -min.size().height / 2)
                        min.drawAtPoint(CGPoint.zero)
                        CGContextRestoreGState(ctx)
                    }
                }
            }
        }
        
        // center piece
        CGContextSetFillColorWithColor(ctx, backgroundColorClockFaceCenter.CGColor)
        CGContextFillEllipseInRect(ctx, CGRect(x: -centerPieceSize / 2, y: -centerPieceSize / 2, width: centerPieceSize, height: centerPieceSize))
        CGContextRestoreGState(ctx)
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
            
            if index < 0 || index > (minutes.count - 1) {
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
