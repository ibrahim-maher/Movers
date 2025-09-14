import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final double displacement;
  final double edgeOffset;
  final double strokeWidth;
  final RefreshIndicatorTriggerMode triggerMode;
  final String? semanticsLabel;
  final String? semanticsValue;
  final bool notificationPredicate;

  const CustomRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.strokeWidth = 2.0,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    this.semanticsLabel,
    this.semanticsValue,
    this.notificationPredicate = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;
    final indicatorBackgroundColor = backgroundColor ?? theme.colorScheme.surface;


    return RefreshIndicator(
      onRefresh: onRefresh,
      color: indicatorColor,
      backgroundColor: indicatorBackgroundColor,
      displacement: displacement,
      edgeOffset: edgeOffset,
      strokeWidth: strokeWidth,
      triggerMode: triggerMode,
      semanticsLabel: semanticsLabel,
      semanticsValue: semanticsValue,
      notificationPredicate: notificationPredicate
          ? (_) => true
          : defaultScrollNotificationPredicate, // ✅ correct one
      child: child,


    );
  }
}

class PullToRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final String? refreshText;
  final String? completeText;
  final String? failedText;
  final String? releaseText;
  final String? idleText;
  final TextStyle? textStyle;
  final double height;

  const PullToRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.refreshText = 'Refreshing...',
    this.completeText = 'Refresh complete',
    this.failedText = 'Refresh failed',
    this.releaseText = 'Release to refresh',
    this.idleText = 'Pull to refresh',
    this.textStyle,
    this.height = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;
    final indicatorBackgroundColor = backgroundColor ?? theme.colorScheme.surface;
    final defaultTextStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface,
    );

    return RefreshIndicator(
      onRefresh: onRefresh,
      color: indicatorColor,
      backgroundColor: indicatorBackgroundColor,
      displacement: height,
      child: child,
    );
  }
}

class CustomRefreshControl extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Widget Function(BuildContext, RefreshStatus, double)? headerBuilder;
  final double height;
  final Color? color;
  final Color? backgroundColor;

  const CustomRefreshControl({
    super.key,
    required this.child,
    required this.onRefresh,
    this.headerBuilder,
    this.height = 60.0,
    this.color,
    this.backgroundColor,
  });

  @override
  State<CustomRefreshControl> createState() => _CustomRefreshControlState();
}

class _CustomRefreshControlState extends State<CustomRefreshControl> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: widget.onRefresh,
      color: widget.color ?? Theme.of(context).colorScheme.primary,
      backgroundColor: widget.backgroundColor ?? Theme.of(context).colorScheme.surface,
      displacement: widget.height,
      child: widget.child,
    );
  }
}

enum RefreshStatus {
  idle,
  canRefresh,
  refreshing,
  completed,
  failed,
}