import 'package:flutter/material.dart';

enum DeviceScreenType { compact, medium, expanded }

class ResponsiveBody extends StatelessWidget {
  final Widget child;
  final bool scrollable;
  final EdgeInsetsGeometry? padding;

  const ResponsiveBody({
    super.key,
    required this.child,
    this.scrollable = false,
    this.padding,
  });

  static DeviceScreenType getScreenType(double width) {
    if (width < 600) return DeviceScreenType.compact;
    if (width <= 900) return DeviceScreenType.medium;
    return DeviceScreenType.expanded;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenType = getScreenType(constraints.maxWidth);
        final double maxWidth = screenType == DeviceScreenType.expanded
            ? 1100.0
            : (screenType == DeviceScreenType.medium ? 600.0 : double.infinity);

        Widget content = Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: padding != null ? Padding(padding: padding!, child: child) : child,
          ),
        );

        if (scrollable) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: content,
          );
        }

        return content;
      },
    );
  }
}
