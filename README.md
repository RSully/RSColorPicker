# Class Files:

## RSColorPickerView

Square (circle) color-picker that handles touch events, allows for brightness control, and allows for opacity control. Uses delegation to report color selection as-changed

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

# Contributing

Pull requests are welcome for bug fixes or feature additions. If you contribute code, make sure you stick to the following syntax guidelines:

 * Indentation should be done with 4 spaces, not `\t`.
 * For Objective-C method implementations, the opening curly brace `{` should appear on the same line as the method name: `- (void)foobar {`.
 * For Objective-C methods, there should be a space after the `-` or `+`, as in the example above.
 * For C function implementations, the `{` should appear immediately on the next line after the function name & arguments.
 * For pointers, declare variables such as `NSArray *myVar`, with the `*` touching the variable name. For Objective-C arguments, put a space before the `*`: `- (NSArray *)myMethod`.
 * For C functions that return a pointer, put a space before *and* after the `*`: `void * getBuffer()`.