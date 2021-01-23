# UIKitWrapCombine

UIKit を Combine Framework で使うためのラッパーです。

## Installation

```swift
// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "MyLibrary",
    products: [
        .library(name: "MyLibrary", targets: ["MyLibrary"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nisin/UIKitWrapCombine.git", .branch("main")),
    ],
    targets: [
        .target(name: "MyLibrary", dependencies: ["CombineAction"]),
    ]
)
```

## Usage

```swift
import UIKitWrapCombine

var cancellables: [AnyCancellable] = []

// toggle button
let button = UIButton()
button.wrap.publisher(for: \.isSelected, events: .primaryActionTriggered)
    .map { !$0 }
    .assign(to: \.isEnabled, on: button)
    .store(in: &cancellables)
```

this module support classes is UIControl and UIBarButtonItem.
