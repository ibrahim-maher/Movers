import 'package:flutter/material.dart';
import 'shimmer_loading.dart';

class SkeletonLoader extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final Widget? loadingWidget;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration shimmerDuration;
  final ShimmerDirection shimmerDirection;

  const SkeletonLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.loadingWidget,
    this.baseColor,
    this.highlightColor,
    this.shimmerDuration = const Duration(milliseconds: 1500),
    this.shimmerDirection = ShimmerDirection.ltr,
  });

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      return child;
    }

    final Widget skeletonWidget = loadingWidget ?? child;

    return ShimmerLoading(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: shimmerDuration,
      direction: shimmerDirection,
      child: skeletonWidget,
    );
  }

  /// Create a skeleton loader for a list
  static Widget listView({
    required int itemCount,
    required bool isLoading,
    required IndexedWidgetBuilder itemBuilder,
    IndexedWidgetBuilder? skeletonItemBuilder,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Color? baseColor,
    Color? highlightColor,
    Duration shimmerDuration = const Duration(milliseconds: 1500),
    ShimmerDirection shimmerDirection = ShimmerDirection.ltr,
  }) {
    if (!isLoading) {
      return ListView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
      );
    }

    return ShimmerLoading(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: shimmerDuration,
      direction: shimmerDirection,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: skeletonItemBuilder ?? (context, index) => const ShimmerListTile(),
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
      ),
    );
  }

  /// Create a skeleton loader for a grid
  static Widget gridView({
    required int itemCount,
    required bool isLoading,
    required IndexedWidgetBuilder itemBuilder,
    IndexedWidgetBuilder? skeletonItemBuilder,
    required SliverGridDelegate gridDelegate,
    ScrollPhysics? physics,
    EdgeInsetsGeometry? padding,
    bool shrinkWrap = false,
    Color? baseColor,
    Color? highlightColor,
    Duration shimmerDuration = const Duration(milliseconds: 1500),
    ShimmerDirection shimmerDirection = ShimmerDirection.ltr,
  }) {
    if (!isLoading) {
      return GridView.builder(
        itemCount: itemCount,
        itemBuilder: itemBuilder,
        gridDelegate: gridDelegate,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
      );
    }

    return ShimmerLoading(
      baseColor: baseColor,
      highlightColor: highlightColor,
      duration: shimmerDuration,
      direction: shimmerDirection,
      child: GridView.builder(
        itemCount: itemCount,
        itemBuilder: skeletonItemBuilder ?? (context, index) => _buildGridItemPlaceholder(context),
        gridDelegate: gridDelegate,
        physics: physics,
        padding: padding,
        shrinkWrap: shrinkWrap,
      ),
    );
  }

  static Widget _buildGridItemPlaceholder(BuildContext context) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: double.infinity,
                    height: 12.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: 80.0,
                    height: 12.0,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}