# BottomSheet-SwiftUI

BottomSheet view in SwiftUI

Based on: https://gist.github.com/mecid/78eab34d05498d6c60ae0f162bfd81ee

<img src="https://user-images.githubusercontent.com/847165/82734347-c0592680-9d1a-11ea-9c12-df4528d4c05f.gif" width="18%"></img> 

## Usage

```swift
import SwiftUI
import BottomSheet_SwiftUI

struct ContentView: View {
    @State private var bottomSheetOpened = false
    var body: some View {
        GeometryReader { geometry in
            Color.green
                .edgesIgnoringSafeArea(.all)
            BottomSheet(
                isOpen: self.$bottomSheetOpened,
                config: BottomSheetConfig(maxHeight: geometry.size.height * 0.9)
            ) {
                Color.white
            }
        }.edgesIgnoringSafeArea(.all)
    }
}
```

## Default config values
```
minHeightRatio: 0.2,
maxHeight: 300,
radius: 20,
indicatorSize: width: 100, height: 5,
snapRatio: 0.1,
indicatorColor: black,
indicatorBackgroundColor: white
```

## Installation

### Swift Package Manager

BottomSheet-SwiftUI is SwiftPM-compatible. To install, add this package to your `Package.swift` or your Xcode project.
