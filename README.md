# MusicApp

A simple showcase App which is based on TCA from [pointfree](https://www.pointfree.co).

It makes use of Swift Packages to modularize Features from the beginning. For now 2 modules are implempented (see `Packages` directory).

1. `BrowserFeature`
Provides possibility browsing and searching through a music collections fetched from a Server. It includes some Unit tests as well.

2. `Networking`
Provides base Networking possibilities.

## Preview Apps
Preview Apps are used to showcase Features in specific scenarios with live or mocked data. They can speed up development as it's no longer needed starting the full application (doing so typically requires authentication etc. as well).

* see `BrowserFeaturePrevievApp`

## General

Additional topics which should be added/thought off in general before releasing/scaling it:

* Health/Performance monitoring (e.g. Firebase)
* Coding rules
* ...

## Used Tech stack

* SwiftUI
* Swift Concurrency
* TCA


## External Dependency

* https://github.com/pointfreeco/swift-composable-architecture
* https://github.com/realm/SwiftLint

