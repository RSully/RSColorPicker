# Class Files:

## RSColorPickerView

Square (circle) color-picker that handles touch events, allows for brightness control, and allows for opacity control. Uses delegation to report color selection as-changed

## RSBrightnessSlider, RSOpacitySlider

Basic UISlider subclass that can be used easily with RSColorPickerView. 

# Project:

Inspired by [ANColorPicker](https://github.com/unixpickle/ANColorPicker). 
Also uses [ANImageBitmapRep](https://github.com/unixpickle/ANImageBitmapRep) for easy pixel-level manipulation. 

And of course, thanks to [Wikipedia](http://en.wikipedia.org/wiki/HSL_and_HSV).


# Usage:

See included example project (`TestColorViewController`).

## Requirements:

* Accelerate.framework
* QuartzCore.framework
* CoreGraphics.framework
* UIKit.framework
* Foundation.framework
* ANImageBitmapRep (Included)

## License

This is licensed under the BSD license (see License.md). You know the drill, use at your own risk, this code is given without support, etc. And for good karma link back to this github.com page, [github.com/rsully/rscolorpicker](https://github.com/RSully/RSColorPicker)

***

<img alt="Color Picker - Default" src="https://github.com/RSully/RSColorPicker/raw/master/Example01.png" width="320">
<img alt="Color Picker - Loupe popup" src="https://github.com/RSully/RSColorPicker/raw/master/Example02.png" width="320">
<img alt="Color Picker - Brightness" src="https://github.com/RSully/RSColorPicker/raw/master/Example03.png" width="320">
<img alt="Color Picker - Opacity" src="https://github.com/RSully/RSColorPicker/raw/master/Example04.png" width="320">
<img alt="Color Picker - Square" src="https://github.com/RSully/RSColorPicker/raw/master/Example05.png" width="320">
<img alt="Color Picker - External selection" src="https://github.com/RSully/RSColorPicker/raw/master/Example05.png" width="320">
