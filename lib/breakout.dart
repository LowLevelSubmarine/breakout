import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

sealed class BreakoutInsets {
  const BreakoutInsets._();

  BreakoutInsetsGeometry resolve({required TextDirection textDirection});
}

class HorizontalBreakoutInsets extends BreakoutInsets {
  const HorizontalBreakoutInsets({required this.start, required this.end})
    : super._();

  final double start;
  final double end;

  @override
  BreakoutInsetsGeometry resolve({required TextDirection textDirection}) {
    return BreakoutInsetsGeometry(
      top: 0.0,
      right: textDirection == TextDirection.ltr ? end : start,
      bottom: 0.0,
      left: textDirection == TextDirection.ltr ? start : end,
    );
  }
}

class VerticalBreakoutInset extends BreakoutInsets {
  const VerticalBreakoutInset({required this.top, required this.bottom})
    : super._();

  final double top;
  final double bottom;

  @override
  BreakoutInsetsGeometry resolve({required TextDirection textDirection}) {
    return BreakoutInsetsGeometry(
      top: top,
      right: 0.0,
      bottom: bottom,
      left: 0.0,
    );
  }
}

class BreakoutInsetsGeometry {
  const BreakoutInsetsGeometry({
    required this.top,
    required this.right,
    required this.bottom,
    required this.left,
  });

  final double top;
  final double right;
  final double bottom;
  final double left;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BreakoutInsetsGeometry &&
          top == other.top &&
          right == other.right &&
          bottom == other.bottom &&
          left == other.left;

  @override
  int get hashCode => Object.hash(top, right, bottom, left);
}

class Breakoutable extends StatelessWidget {
  const Breakoutable({super.key, required this.insets, required this.child});

  final BreakoutInsets insets;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final resolvedInsets = insets.resolve(textDirection: textDirection);
    return BreakoutableContext(insets: resolvedInsets, child: child);
  }
}

class BreakoutableContext extends InheritedWidget {
  const BreakoutableContext({
    super.key,
    required this.insets,
    required super.child,
  });

  final BreakoutInsetsGeometry insets;

  static BreakoutInsetsGeometry insetsOf(BuildContext context) {
    final BreakoutableContext? breakoutable =
        context.dependOnInheritedWidgetOfExactType<BreakoutableContext>();
    if (breakoutable == null) {
      throw FlutterError('BreakoutableContext not found in this scope.');
    }
    return breakoutable.insets;
  }

  @override
  bool updateShouldNotify(covariant BreakoutableContext oldWidget) {
    return insets != oldWidget.insets;
  }
}

Widget Function(BuildContext context, BreakoutInsetsGeometry insets)
_createDefaultBreakoutBuilder(Widget child) {
  return (_, _) => child;
}

class Breakout extends StatelessWidget {
  Breakout({super.key, required Widget child})
    : builder = _createDefaultBreakoutBuilder(child);

  const Breakout.builder({super.key, required this.builder});

  final Widget Function(BuildContext context, BreakoutInsetsGeometry insets)
  builder;

  @override
  Widget build(BuildContext context) {
    final insets = BreakoutableContext.insetsOf(context);
    return BreakoutOverflowBox(insets: insets, child: builder(context, insets));
  }
}

class BreakoutOverflowBox extends SingleChildRenderObjectWidget {
  const BreakoutOverflowBox({super.key, required this.insets, super.child});

  final BreakoutInsetsGeometry insets;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      RenderBreakoutOverflowBox(insets: insets);

  @override
  void updateRenderObject(
    BuildContext context,
    RenderBreakoutOverflowBox renderObject,
  ) {
    renderObject.insets = insets;
  }
}

class RenderBreakoutOverflowBox extends RenderShiftedBox {
  RenderBreakoutOverflowBox({
    required BreakoutInsetsGeometry insets,
    RenderBox? child,
  }) : _insets = insets,
       super(child);

  BreakoutInsetsGeometry _insets;
  BreakoutInsetsGeometry get insets => _insets;
  set insets(BreakoutInsetsGeometry value) {
    if (_insets == value) return;
    _insets = value;
    markNeedsLayout();
  }

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    if (child == null) {
      size = constraints.biggest;
      return;
    }

    final BoxConstraints innerConstraints = BoxConstraints(
      minWidth: constraints.minWidth + insets.left + insets.right,
      maxWidth: constraints.maxWidth + insets.left + insets.right,
      minHeight: constraints.minHeight + insets.top + insets.bottom,
      maxHeight: constraints.maxHeight + insets.top + insets.bottom,
    );
    print('inner constraints: $innerConstraints');
    print('constraints: $constraints');

    child!.layout(innerConstraints, parentUsesSize: true);
    final BoxParentData childParentData = child!.parentData! as BoxParentData;
    childParentData.offset = Offset(-insets.left, -insets.top);
    size = constraints.constrain(
      Size(
        child!.size.width - insets.left - insets.right,
        child!.size.height - insets.top - insets.bottom,
      ),
    );
  }
}
