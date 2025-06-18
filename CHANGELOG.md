## 1.0.0-dev.0
* Initial release of the package. API and implementation may change in future releases.

## 1.0.0-dev.1
* Fixed README.md

## 1.0.0-dev.2
* Switched to a less hacky approach that doesn't use overflows.
* Renamed `Breakoutable` to `BreakoutArea`.
* Simplified `BreakoutInsets`. Try `BreakoutInsets.horizontal(40)` or `BreakoutInsets.vertical(40)`.
* Breakouting is now dont the other way around. You need to wrap the widgets that should not break out in a `Bounded` widget.
