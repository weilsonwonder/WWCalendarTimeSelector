Pod::Spec.new do |s|
  s.name         = "LaserCalendarTimeSelector"
  s.version      = "1.5.0"
  s.summary      = "Customizable iOS View Controller in Android style for picking date and time."
  s.homepage     = "https://github.com/LaserSrl/LaserCalendarTimeSelector"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Patrick Laser" => "patrick.negretto@laser-group.com" }

  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/LaserSrl/LaserCalendarTimeSelector.git", :tag => s.version }
  s.source_files  = "Classes", "Sources/*.swift"
  s.resource_bundles = {
    'WWCalendarTimeSelectorStoryboardBundle' => ['Sources/*.storyboard']
  }
end
