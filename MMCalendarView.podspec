Pod::Spec.new do |s|
  s.name         = "MMCalendarView"
  s.version      = "0.0.1"
  s.summary      = "iOS Customizable calendar view."
  s.homepage     = "https://github.com/mateuszmackowiak/MMCalendarView"
  s.screenshots  = "https://github.com/mateuszmackowiak/MMCalendarView/raw/master/Documentation/screen.png"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Mateusz Maćkowiak" => "m@mateuszmackowiak.art.pl" }
  s.source       = { :git => "https://github.com/mateuszmackowiak/MMCalendarView.git", :branch => "master" }
  s.platform     = :ios, '6.0'
  s.frameworks   = 'UIKit', 'CoreGraphics'
  s.source_files = 'MMCalendarView', 'MMCalendarView/**/*.{h,m}'
  s.requires_arc = true
end
