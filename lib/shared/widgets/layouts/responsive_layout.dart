import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget? desktop;
  final double mobileBreakpoint;
  final double tabletBreakpoint;
  final double desktopBreakpoint;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.mobileBreakpoint = 600.0,
    this.tabletBreakpoint = 900.0,
    this.desktopBreakpoint = 1200.0,
  });

  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600.0;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 600.0 &&
      MediaQuery.of(context).size.width < 900.0;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 900.0;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width >= desktopBreakpoint && desktop != null) {
      return desktop!;
    } else if (width >= tabletBreakpoint && tablet != null) {
      return tablet!;
    } else {
      return mobile;
    }
  }
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;
  final double mobileBreakpoint;
  final double tabletBreakpoint;
  final double desktopBreakpoint;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobileBreakpoint = 600.0,
    this.tabletBreakpoint = 900.0,
    this.desktopBreakpoint = 1200.0,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final width = mediaQuery.size.width;
    final height = mediaQuery.size.height;
    final orientation = mediaQuery.orientation;

    DeviceType deviceType;
    if (width >= desktopBreakpoint) {
      deviceType = DeviceType.desktop;
    } else if (width >= tabletBreakpoint) {
      deviceType = DeviceType.tablet;
    } else {
      deviceType = DeviceType.mobile;
    }

    final info = ResponsiveInfo(
      deviceType: deviceType,
      screenSize: Size(width, height),
      orientation: orientation,
      isMobile: deviceType == DeviceType.mobile,
      isTablet: deviceType == DeviceType.tablet,
      isDesktop: deviceType == DeviceType.desktop,
    );

    return builder(context, info);
  }
}

class ResponsiveInfo {
  final DeviceType deviceType;
  final Size screenSize;
  final Orientation orientation;
  final bool isMobile;
  final bool isTablet;
  final bool isDesktop;

  const ResponsiveInfo({
    required this.deviceType,
    required this.screenSize,
    required this.orientation,
    required this.isMobile,
    required this.isTablet,
    required this.isDesktop,
  });

  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;
  double get width => screenSize.width;
  double get height => screenSize.height;
}

enum DeviceType {
  mobile,
  tablet,
  desktop,
}

class ResponsiveConstraints extends StatelessWidget {
  final Widget child;
  final double maxWidthMobile;
  final double maxWidthTablet;
  final double maxWidthDesktop;
  final EdgeInsetsGeometry padding;
  final Alignment alignment;

  const ResponsiveConstraints({
    super.key,
    required this.child,
    this.maxWidthMobile = 600.0,
    this.maxWidthTablet = 800.0,
    this.maxWidthDesktop = 1200.0,
    this.padding = EdgeInsets.zero,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        double maxWidth;
        if (info.isDesktop) {
          maxWidth = maxWidthDesktop;
        } else if (info.isTablet) {
          maxWidth = maxWidthTablet;
        } else {
          maxWidth = maxWidthMobile;
        }

        return Align(
          alignment: alignment,
          child: Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            padding: padding,
            child: child,
          ),
        );
      },
    );
  }
}