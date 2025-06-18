Allows widgets to break out of their padded area and ignore the padding set by the parent widget.

![Screenshot](screenshot.png)

# Disclaimer
This package is still early in development. The API may change in the future, and there may be bugs or missing features. I don't really like that you have to manually wrap each widget that should not break out, but I haven't found a better solution yet. Another one i was considering in the previous versions (1.0.0-dev.0 and 1.0.0-dev.1) didn't need the manual wrapping, but was making use of overflows which is not recommended by the Flutter team and can lead to unexpected behavior. So I decided to go with this approach for now. If you have any suggestions for alternative approaches, please open an issue.

# Getting Started
To make a widget breakout you simply need to not wrap it in a `Bounded` widget. For example:
```dart
Widget build(BuildContext context) {
  return SliverList.list(
    children: [
      Bounded(child: Text('some text')),
      Text('breakout text'),
      Bounded(child: Text('some more text')),
    ],
  );
}
```

But the `Bounded` widget needs to know what padding to apply to the children. You can do this by passing a `Breakoutable` widget with the desired insets. For example, if you want to break out of 40 pixels on the left and right sides, you can do it like this:
```dart
Widget build(BuildContext context) {
  return BreakoutArea(
    insets: BreakoutInsets.horizontal(40),
    child: /* your content ... */,
  );
}
```
