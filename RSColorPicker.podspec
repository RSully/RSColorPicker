Pod::Spec.new do |s|
  s.name         = "RSColorPicker"
  s.version      = "0.9.2"
  s.summary      = "iOS color picker view"
  s.description  = "iOS color picker view with brightness control, opacity control, and delegation support."
  s.homepage     = "https://github.com/RSully/RSColorPicker"
  s.screenshots  = "https://raw.github.com/RSully/RSColorPicker/v0.9.2/Example01.png", "https://raw.github.com/RSully/RSColorPicker/v0.9.2/Example02.png", "https://raw.github.com/RSully/RSColorPicker/v0.9.2/Example03.png", "https://raw.github.com/RSully/RSColorPicker/v0.9.2/Example04.png", "https://raw.github.com/RSully/RSColorPicker/v0.9.2/Example05.png"
  s.license      = { :type => 'BSD', :file => "LICENSE.md" }
  s.author       = { "Ryan" => "rsul.dev@me.com" }
  s.source       = { :git => "https://github.com/RSully/RSColorPicker.git", :tag => "v0.9.2" }
  s.platform     = :ios, '6.0'
  s.source_files = 'RSColorPicker/ColorPickerClasses/**/*.{h,m}'
  s.frameworks   = 'QuartzCore', 'CoreGraphics', 'UIKit', 'Accelerate'
  s.requires_arc = true

  s.public_header_files = "RSColorPicker/ColorPickerClasses/RSColorPickerView.h"
end
