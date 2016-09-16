Pod::Spec.new do |s|
  s.name         = "WWCalendarTimeSelector"
  s.version      = "1.3.13"
  s.summary      = "Customizable iOS View Controller in Android style for picking date and time."
  s.homepage     = "https://github.com/weilsonwonder/WWCalendarTimeSelector"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Weilson Wonder" => "weilson@live.com" }

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/weilsonwonder/WWCalendarTimeSelector.git", :tag => s.version }
  s.source_files  = "Classes", "Sources/*.swift"
  s.resource_bundles = {
    'WWCalendarTimeSelectorStoryboardBundle' => ['Sources/*.storyboard']
  }
end
