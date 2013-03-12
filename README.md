# Class Files:

## RSColorPickerView

Square (circle) color-picker that handles touch events and allows for brightness control. Uses delegation to report color selection as-changed

## BGRSLoupeLayer

Loupe used by RSColorPickerView for selection

## RSBrightnessSlider

Basic UISlider subclass that can be used easily with RSColorPickerView. 

# Project:

Inspired by [ANColorPicker](https://github.com/unixpickle/ANColorPicker). 
Also uses [ANImageBitmapRep](https://github.com/unixpickle/ANImageBitmapRep) for easy pixel-level manipulation. 

And of course, thanks to [Wikipedia](http://en.wikipedia.org/wiki/HSL_and_HSV).


# Usage:

See included example project (application delegate).

## Requirements:

* QuartzCore.framework
* CoreGraphics.framework
* UIKit.framework
* Foundation.framework
* ANImageBitmapRep (Included)

## License

This is licensed under the BSD license (found at the bottom of this file). You know the drill, use at your own risk, this code is given without support, etc. And for good karma link back to this github.com page, [github.com/rsully/rscolorpicker](https://github.com/RSully/RSColorPicker)

***

<img alt="Color Picker - Circle" src="https://github.com/RSully/RSColorPicker/raw/master/Example01.png" width="320">

<img alt="Color Picker - Loupe popup" src="https://github.com/RSully/RSColorPicker/raw/master/Example02.png" width="320">

<img alt="Color Picker - Square" src="https://github.com/RSully/RSColorPicker/raw/master/Example03.png" width="320">

<img alt="Color Picker - Square, default slider style" src="https://github.com/RSully/RSColorPicker/raw/master/Example04.png" width="320">

***

Copyright (c) 2011, Ryan (RSully)
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

