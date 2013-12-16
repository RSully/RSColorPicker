
# Contributing

Pull requests are welcome for bug fixes or feature additions. If you contribute code, make sure you stick to the following syntax guidelines:

- Indentation should be done with 4 spaces, not `\t`.
- For Objective-C method implementations, the opening curly brace `{` should appear on the same line as the method name: `- (void)foobar {`.
- For Objective-C methods, there should be a space after the `-` or `+`, as in the example above.
- For C function implementations, the `{` should appear immediately on the next line after the function name & arguments.
- For pointers, declare variables such as `NSArray *myVar`, with the `*` touching the variable name. For Objective-C arguments, put a space before the `*`: `- (NSArray *)myMethod`.
- For C functions that return a pointer, put a space before *and* after the `*`: `void * getBuffer()`.
