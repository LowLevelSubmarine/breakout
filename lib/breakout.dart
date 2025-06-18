import 'package:flutter/widgets.dart';

class BreakoutInsets {
  final EdgeInsetsGeometry geometry;

  BreakoutInsets.horizontal(double horizontal)
    : geometry = EdgeInsets.symmetric(horizontal: horizontal);

  BreakoutInsets.vertical(double vertical)
    : geometry = EdgeInsets.symmetric(vertical: vertical);

  BreakoutInsets.startEnd(double start, double end)
    : geometry = EdgeInsetsDirectional.only(start: start, end: end);

  BreakoutInsets.topBottom(double top, double bottom)
    : geometry = EdgeInsets.only(top: top, bottom: bottom);
}

class BreakoutArea extends StatelessWidget {
  const BreakoutArea({super.key, required this.insets, required this.child});

  final BreakoutInsets insets;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    // we resolve the insets based on the text direction here,
    // so that in case LTR/RTL changes in the subtree,
    // the BreakoutAreaContext will still have the correct insets.
    final resolvedInsets = insets.geometry.resolve(textDirection);
    return BreakoutAreaContext(insets: resolvedInsets, child: child);
  }
}

class BreakoutAreaContext extends InheritedWidget {
  const BreakoutAreaContext({
    super.key,
    required this.insets,
    required super.child,
  });

  final EdgeInsets insets;

  static EdgeInsets insetsOf(BuildContext context) {
    final BreakoutAreaContext? breakoutable =
        context.dependOnInheritedWidgetOfExactType<BreakoutAreaContext>();
    if (breakoutable == null) {
      throw FlutterError('BreakoutableContext not found in this scope.');
    }
    return breakoutable.insets;
  }

  @override
  bool updateShouldNotify(covariant BreakoutAreaContext oldWidget) {
    return insets != oldWidget.insets;
  }
}

class BoundedBuilder extends StatelessWidget {
  const BoundedBuilder({super.key, required this.builder});

  final Widget Function(BuildContext context, EdgeInsets insets) builder;

  @override
  Widget build(BuildContext context) {
    final insets = BreakoutAreaContext.insetsOf(context);
    return builder(context, insets);
  }
}

class Bounded extends StatelessWidget {
  const Bounded({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final insets = BreakoutAreaContext.insetsOf(context);
    return Padding(padding: insets, child: child);
  }
}

class SliverBounded extends StatelessWidget {
  const SliverBounded({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final insets = BreakoutAreaContext.insetsOf(context);
    return SliverPadding(padding: insets, sliver: child);
  }
}
