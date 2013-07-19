Pod::Spec.new do |s|
  s.name         = "RSColorPicker"
  s.version      = "0.6.0"
  s.summary      = "iPhone color picker view with brightness control and delegation support."
  s.description  = <<-DESC
                   iPhone color picker view with brightness control and delegation support. Handles touch events internally. Easy to customize.
                   DESC
  s.homepage     = "https://github.com/RSully/RSColorPicker"
  s.screenshots  = "https://github.com/RSully/RSColorPicker/blob/master/Example01.png", "https://github.com/RSully/RSColorPicker/blob/master/Example02.png", "https://github.com/RSully/RSColorPicker/blob/master/Example03.png", "https://github.com/RSully/RSColorPicker/blob/master/Example04.png"
  s.license      = { :type => 'BSD', :file => "LICENSE.md" }
  s.author       = { "Ryan" => "rsul.dev@me.com" }
  s.source       = { :git => "https://github.com/RSully/RSColorPicker.git", :tag => "v0.6.0" }
  s.platform     = :ios, '5.0'
  s.source_files = 'RSColorPicker/ColorPickerClasses/**/*.{h,m}'
  s.frameworks   = 'QuartzCore', 'CoreGraphics', 'UIKit'
  s.requires_arc = true

  s.public_header_files = "RSColorPicker/ColorPickerClasses/RSBrightnessSlider.h", "RSColorPicker/ColorPickerClasses/RSColorPickerView.h"
end
