
# Project:

[![Build Status](https://travis-ci.org/RSully/RSColorPicker.png?branch=master)](https://travis-ci.org/RSully/RSColorPicker)

iOS color picker that is resolution independent.

Inspired by [ANColorPicker](https://github.com/unixpickle/ANColorPicker).
Also uses [ANImageBitmapRep](https://github.com/unixpickle/ANImageBitmapRep) for easy pixel-level manipulation.

And of course, thanks to [Wikipedia](http://en.wikipedia.org/wiki/HSL_and_HSV).

## Class Files:

### `RSColorPickerView`

Square (circle) color-picker that handles touch events, allows for brightness control, and allows for opacity control. Uses delegation to report color selection as-changed

## Usage:

See included example project (`TestColorViewController`).

### Requirements:

* Accelerate.framework
* QuartzCore.framework
* CoreGraphics.framework
* UIKit.framework
* Foundation.framework
* ANImageBitmapRep (included)

## License

See [LICENSE.md](LICENSE.md). You know the drill, use at your own risk, this code is given without support, etc. And for good karma link back to this github.com page, [github.com/rsully/rscolorpicker](https://github.com/RSully/RSColorPicker)

***

<img alt="Color Picker - Default" src="./Example01.png" width="320">
<img alt="Color Picker - Loupe" src="./Example02.png" width="320">
<img alt="Color Picker - Opacity" src="./Example03.png" width="320">
<img alt="Color Picker - Circle" src="./Example04.png" width="320">
<img alt="Color Picker - Resize" src="./Example05.png" width="320">

## Contributing

Pull requests are welcome for bug fixes or feature additions. If you contribute code, make sure you stick to the [contibution guidelines](CONTRIBUTING.md).
