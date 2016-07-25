# WWCalendarTimeSelector

#### Try out the [Demo (powered by appetize)](https://appetize.io/app/0n12eyb1g2j2n08unffhxn44ww)!


## Screenshots

![WWCalendarTimeSelector](https://github.com/weilsonwonder/WWCalendarTimeSelector/blob/master/Screenshots/ss1.png)
![WWCalendarTimeSelector](https://github.com/weilsonwonder/WWCalendarTimeSelector/blob/master/Screenshots/ss2.png)
![WWCalendarTimeSelector](https://github.com/weilsonwonder/WWCalendarTimeSelector/blob/master/Screenshots/ss3.png)
![WWCalendarTimeSelector](https://github.com/weilsonwonder/WWCalendarTimeSelector/blob/master/Screenshots/ss4.png)
![WWCalendarTimeSelector](https://github.com/weilsonwonder/WWCalendarTimeSelector/blob/master/Screenshots/ss5.png)
![WWCalendarTimeSelector](https://github.com/weilsonwonder/WWCalendarTimeSelector/blob/master/Screenshots/ss6.png)


## Description

An Android themed date-time selector. Select date and time with this highly customizable selector. **WWCalendarTimeSelector** is a component that will make help your users select date or dates intuitively.


## Features

- Simple usage
- Single date selection
- Multiple dates selection
- Range dates selection
- Portrait and Landscape orientation support
- Font, Color, Size customization
- 3 styles of grouping for multiple dates selection (Simple, Pill, LinkedBalls)
- Infinite dates selection
- Simple restriction of date selection (through protocol)


## Installation

**WWCalendarTimeSelector** is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WWCalendarTimeSelector'
```


## Usage

**WWCalendarTimeSelector** is dead simple to use. It comes with easy usage and simple protocols, and you can get started with simply a few lines of code!

```swift
// 1. You must instantiate with the class function instantiate()
let selector = WWCalendarTimeSelector.instantiate()

// 2. You can then set delegate, and any customization options
selector.delegate = self
selector.optionTopPanelTitle = "Awesome Calendar!"

// 3. Then you simply present it from your view controller when necessary!
self.presentViewController(selector, animated: true, completion: nil)
```

Below is an example of how it looks like!

```swift
import WWCalendarTimeSelector

class YourViewController: UIViewController, WWCalendarTimeSelectorProtocol {
    func showCalendar() {
        let selector = WWCalendarTimeSelector.instantiate()
        selector.delegate = self
        /*
          Any other options are to be set before presenting selector!
        */
        presentViewController(selector, animated: true, completion: nil)
    }

    func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate) {
        print(date)
    }
}
```

#### Options

Naturally, everybody would want a selector with their own theme colours and fonts! Hence, below are options that you may customize! Do set the options *before* presenting the selector! Any options set *after* presenting the selector will result in unexpected behaviors.

Protocols:

```swift
@objc public protocol WWCalendarTimeSelectorProtocol {
    optional public func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, dates: [NSDate])
    optional public func WWCalendarTimeSelectorDone(selector: WWCalendarTimeSelector, date: NSDate)
    optional public func WWCalendarTimeSelectorCancel(selector: WWCalendarTimeSelector, dates: [NSDate])
    optional public func WWCalendarTimeSelectorCancel(selector: WWCalendarTimeSelector, date: NSDate)
    optional public func WWCalendarTimeSelectorWillDismiss(selector: WWCalendarTimeSelector)
    optional public func WWCalendarTimeSelectorDidDismiss(selector: WWCalendarTimeSelector)
    optional public func WWCalendarTimeSelectorShouldSelectDate(selector: WWCalendarTimeSelector, date: NSDate) -> Bool
}
```

Enumerations:

```swift
@objc public enum WWCalendarTimeSelectorSelection : Int {
    case Single
    case Multiple
    case Range
}

@objc public enum WWCalendarTimeSelectorMultipleSelectionGrouping : Int {
    case Simple
    case Pill
    case LinkedBalls
}

@objc public enum WWCalendarTimeSelectorTimeStep : Int {
    case OneMinute
    case FiveMinutes
    case TenMinutes
    case FifteenMinutes
    case ThirtyMinutes
    case SixtyMinutes
}
```

Helper Classes:

```swift
@objc public final class WWCalendarTimeSelectorStyle : NSObject {
    private(set) public var showDateMonth: Bool
    private(set) public var showMonth: Bool
    private(set) public var showYear: Bool
    private(set) public var showTime: Bool
    public func showDateMonth(show: Bool)
    public func showMonth(show: Bool)
    public func showYear(show: Bool)
    public func showTime(show: Bool)
}

@objc public class WWCalendarTimeSelectorDateRange : NSObject {
    private(set) public var start: NSDate
    private(set) public var end: NSDate
    public var array: [NSDate] { get }
    public func setStartDate(date: NSDate)
    public func setEndDate(date: NSDate)
}
```

Below are the available options:

```swift
delegate: WWCalendarTimeSelectorProtocol?
optionIdentifier: AnyObject?
optionStyles: WWCalendarTimeSelectorStyle
optionTimeStep: WWCalendarTimeSelectorTimeStep
optionShowTopContainer: Bool
optionShowTopPanel: Bool
optionTopPanelTitle: String?
optionSelectionType: WWCalendarTimeSelectorSelection
optionCurrentDate: NSDate
optionCurrentDates: Set<NSDate>
optionCurrentDateRange: WWCalendarTimeSelectorDateRange
optionStyleBlurEffect: UIBlurEffectStyle
optionMultipleSelectionGrouping: WWCalendarTimeSelectorMultipleSelectionGrouping
optionCalendarFontMonth: UIFont
optionCalendarFontDays: UIFont
optionCalendarFontToday: UIFont
optionCalendarFontTodayHighlight: UIFont
optionCalendarFontPastDates: UIFont
optionCalendarFontPastDatesHighlight: UIFont
optionCalendarFontFutureDates: UIFont
optionCalendarFontFutureDatesHighlight: UIFont
optionCalendarFontColorMonth: UIColor
optionCalendarFontColorDays: UIColor
optionCalendarFontColorToday: UIColor
optionCalendarFontColorTodayHighlight: UIColor
optionCalendarBackgroundColorTodayHighlight: UIColor
optionCalendarBackgroundColorTodayFlash: UIColor
optionCalendarFontColorPastDates: UIColor
optionCalendarFontColorPastDatesHighlight: UIColor
optionCalendarBackgroundColorPastDatesHighlight: UIColor
optionCalendarBackgroundColorPastDatesFlash: UIColor
optionCalendarFontColorFutureDates: UIColor
optionCalendarFontColorFutureDatesHighlight: UIColor
optionCalendarBackgroundColorFutureDatesHighlight: UIColor
optionCalendarBackgroundColorFutureDatesFlash: UIColor
optionCalendarFontCurrentYear: UIFont
optionCalendarFontCurrentYearHighlight: UIFont
optionCalendarFontColorCurrentYear: UIColor
optionCalendarFontColorCurrentYearHighlight: UIColor
optionCalendarFontPastYears: UIFont
optionCalendarFontPastYearsHighlight: UIFont
optionCalendarFontColorPastYears: UIColor
optionCalendarFontColorPastYearsHighlight: UIColor
optionCalendarFontFutureYears: UIFont
optionCalendarFontFutureYearsHighlight: UIFont
optionCalendarFontColorFutureYears: UIColor
optionCalendarFontColorFutureYearsHighlight: UIColor
optionClockFontAMPM: UIFont
optionClockFontAMPMHighlight: UIFont
optionClockFontColorAMPM: UIColor
optionClockFontColorAMPMHighlight: UIColor
optionClockBackgroundColorAMPMHighlight: UIColor
optionClockFontHour: UIFont
optionClockFontHourHighlight: UIFont
optionClockFontColorHour: UIColor
optionClockFontColorHourHighlight: UIColor
optionClockBackgroundColorHourHighlight: UIColor
optionClockBackgroundColorHourHighlightNeedle: UIColor
optionClockFontMinute: UIFont
optionClockFontMinuteHighlight: UIFont
optionClockFontColorMinute: UIColor
optionClockFontColorMinuteHighlight: UIColor
optionClockBackgroundColorMinuteHighlight: UIColor
optionClockBackgroundColorMinuteHighlightNeedle: UIColor
optionClockBackgroundColorFace: UIColor
optionClockBackgroundColorCenter: UIColor
optionButtonTitleDone: String
optionButtonTitleCancel: String
optionButtonFontCancel: UIFont
optionButtonFontDone: UIFont
optionButtonFontColorCancel: UIColor
optionButtonFontColorDone: UIColor
optionButtonFontColorCancelHighlight: UIColor
optionButtonFontColorDoneHighlight: UIColor
optionButtonBackgroundColorCancel: UIColor
optionButtonBackgroundColorDone: UIColor
optionTopPanelBackgroundColor: UIColor
optionTopPanelFont: UIFont
optionTopPanelFontColor: UIColor
optionSelectorPanelFontMonth: UIFont
optionSelectorPanelFontDate: UIFont
optionSelectorPanelFontYear: UIFont
optionSelectorPanelFontTime: UIFont
optionSelectorPanelFontMultipleSelection: UIFont
optionSelectorPanelFontMultipleSelectionHighlight: UIFont
optionSelectorPanelFontColorMonth: UIColor
optionSelectorPanelFontColorMonthHighlight: UIColor
optionSelectorPanelFontColorDate: UIColor
optionSelectorPanelFontColorDateHighlight: UIColor
optionSelectorPanelFontColorYear: UIColor
optionSelectorPanelFontColorYearHighlight: UIColor
optionSelectorPanelFontColorTime: UIColor
optionSelectorPanelFontColorTimeHighlight: UIColor
optionSelectorPanelFontColorMultipleSelection: UIColor
optionSelectorPanelFontColorMultipleSelectionHighlight: UIColor
optionSelectorPanelBackgroundColor: UIColor
optionMainPanelBackgroundColor: UIColor
optionBottomPanelBackgroundColor: UIColor
optionSelectorPanelOffsetHighlightMonth: CGFloat
optionSelectorPanelOffsetHighlightDate: CGFloat
optionSelectorPanelScaleMonth: CGFloat
optionSelectorPanelScaleDate: CGFloat
optionSelectorPanelScaleYear: CGFloat
optionSelectorPanelScaleTime: CGFloat
optionLayoutTopPanelHeight: CGFloat
optionLayoutHeight: CGFloat?
optionLayoutWidth: CGFloat?
optionLayoutHeightRatio: CGFloat
optionLayoutWidthRatio: CGFloat
optionLayoutPortraitRatio: CGFloat
optionLayoutLandscapeRatio: CGFloat
```

## Author

Weilson Wonder


## License
**WWCalendarTimeSelector** is available under the MIT license. See the [LICENSE](https://github.com/weilsonwonder/WWCalendarTimeSelector/blob/master/LICENSE) file for more info.

