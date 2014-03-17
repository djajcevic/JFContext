# JFContext

## Usage

To run the example project; clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

JFContext is available through [CocoaPods](http://cocoapods.org), to install
it simply add the following line to your Podfile:

    pod "JFContext"

To your main *.pch add these lines
```
#ifndef JF_ACTIVE_PROFILE
#define JF_ACTIVE_PROFILE @"prod" // or any other profile
#endif

#import "JFContext.h"
```

Create ```context.plist``` file and populate it.

See example for more details.

## Author

Denis Jajčević, denis.jajcevic@gmail.com

## License

JFContext is available under the MIT license. See the LICENSE file for more info.

