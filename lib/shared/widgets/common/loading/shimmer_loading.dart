import 'package:flutter/material.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final Duration duration;
  final bool enabled;
  final ShimmerDirection direction;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.duration = const Duration(milliseconds: 1500),
    this.enabled = true,
    this.direction = ShimmerDirection.ltr,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled) {
      if (widget.enabled) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child;
    }

    final theme = Theme.of(context);
    final baseColor = widget.baseColor ?? theme.colorScheme.surfaceVariant;
    final highlightColor = widget.highlightColor ?? theme.colorScheme.surface;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: <Color>[baseColor, highlightColor, baseColor],
              stops: const <double>[0.0, 0.5, 1.0],
              begin: widget.direction == ShimmerDirection.ltr
                  ? Alignment.centerLeft
                  : (widget.direction == ShimmerDirection.rtl
                      ? Alignment.centerRight
                      : (widget.direction == ShimmerDirection.ttb
                          ? Alignment.topCenter
                          : Alignment.bottomCenter)),
              end: widget.direction == ShimmerDirection.ltr
                  ? Alignment.centerRight
                  : (widget.direction == ShimmerDirection.rtl
                      ? Alignment.centerLeft
                      : (widget.direction == ShimmerDirection.ttb
                          ? Alignment.bottomCenter
                          : Alignment.topCenter)),
              tileMode: TileMode.clamp,
              transform: _SlidingGradientTransform(
                slidePercent: _animation.value,
              ),
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}

enum ShimmerDirection {
  ltr,
  rtl,
  ttb,
  btt,
}

/// Shimmer placeholder widgets
class ShimmerPlaceholder extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? color;

  const ShimmerPlaceholder({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final placeholderColor = color ?? theme.colorScheme.surfaceVariant;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: placeholderColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  final double height;
  final bool hasLeading;
  final bool hasTrailing;
  final int lineCount;
  final double lineHeight;
  final double lineSpacing;
  final double? leadingSize;
  final double? trailingSize;

  const ShimmerListTile({
    super.key,
    this.height = 80.0,
    this.hasLeading = true,
    this.hasTrailing = false,
    this.lineCount = 2,
    this.lineHeight = 16.0,
    this.lineSpacing = 8.0,
    this.leadingSize = 48.0,
    this.trailingSize = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Row(
        children: [
          if (hasLeading) ...[  
            ShimmerPlaceholder(
              width: leadingSize!,
              height: leadingSize!,
              borderRadius: leadingSize! / 2,
            ),
            const SizedBox(width: 16.0),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                lineCount,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index < lineCount - 1 ? lineSpacing : 0.0,
                  ),
                  child: ShimmerPlaceholder(
                    width: index == 0 ? double.infinity : 150.0,
                    height: lineHeight,
                  ),
                ),
              ),
            ),
          ),
          if (hasTrailing) ...[  
            const SizedBox(width: 16.0),
            ShimmerPlaceholder(
              width: trailingSize!,
              height: trailingSize!,
              borderRadius: 4.0,
            ),
          ],
        ],
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final bool hasHeader;
  final bool hasFooter;
  final int contentLineCount;
  final double lineHeight;
  final double lineSpacing;

  const ShimmerCard({
    super.key,
    this.width = double.infinity,
    this.height = 200.0,
    this.borderRadius = 12.0,
    this.hasHeader = true,
    this.hasFooter = true,
    this.contentLineCount = 3,
    this.lineHeight = 16.0,
    this.lineSpacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasHeader) ...[  
            Row(
              children: [
                ShimmerPlaceholder(
                  width: 40.0,
                  height: 40.0,
                  borderRadius: 20.0,
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerPlaceholder(
                        width: 120.0,
                        height: lineHeight,
                      ),
                      const SizedBox(height: 8.0),
                      ShimmerPlaceholder(
                        width: 80.0,
                        height: lineHeight * 0.8,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                contentLineCount,
                (index) => Padding(
                  padding: EdgeInsets.only(
                    bottom: index < contentLineCount - 1 ? lineSpacing : 0.0,
                  ),
                  child: ShimmerPlaceholder(
                    width: index % 2 == 0 ? double.infinity : 200.0,
                    height: lineHeight,
                  ),
                ),
              ),
            ),
          ),
          if (hasFooter) ...[  
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ShimmerPlaceholder(
                  width: 80.0,
                  height: lineHeight,
                ),
                ShimmerPlaceholder(
                  width: 80.0,
                  height: lineHeight,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}