import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;
  final String? message;
  final TextStyle? messageStyle;
  final bool center;
  final EdgeInsetsGeometry padding;
  final LoadingIndicatorType type;

  const LoadingIndicator({
    super.key,
    this.size = 40.0,
    this.color,
    this.strokeWidth = 4.0,
    this.message,
    this.messageStyle,
    this.center = true,
    this.padding = const EdgeInsets.all(16.0),
    this.type = LoadingIndicatorType.circular,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final indicatorColor = color ?? theme.colorScheme.primary;
    final defaultMessageStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurface,
    );

    Widget indicator;
    switch (type) {
      case LoadingIndicatorType.circular:
        indicator = SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(
            strokeWidth: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
          ),
        );
        break;
      case LoadingIndicatorType.linear:
        indicator = SizedBox(
          width: size * 5,
          child: LinearProgressIndicator(
            minHeight: strokeWidth,
            valueColor: AlwaysStoppedAnimation<Color>(indicatorColor),
            backgroundColor: indicatorColor.withOpacity(0.2),
          ),
        );
        break;
      case LoadingIndicatorType.dots:
        indicator = _buildDotsIndicator(indicatorColor);
        break;
    }

    Widget content = message != null
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              indicator,
              const SizedBox(height: 16.0),
              Text(
                message!,
                style: messageStyle ?? defaultMessageStyle,
                textAlign: TextAlign.center,
              ),
            ],
          )
        : indicator;

    if (center) {
      content = Center(child: content);
    }

    return Padding(
      padding: padding,
      child: content,
    );
  }

  Widget _buildDotsIndicator(Color color) {
    return SizedBox(
      width: size * 3,
      height: size,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          3,
          (index) => _DotPulse(
            size: size / 3,
            color: color,
            index: index,
          ),
        ),
      ),
    );
  }
}

class _DotPulse extends StatefulWidget {
  final double size;
  final Color color;
  final int index;

  const _DotPulse({
    required this.size,
    required this.color,
    required this.index,
  });

  @override
  State<_DotPulse> createState() => _DotPulseState();
}

class _DotPulseState extends State<_DotPulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _animation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          widget.index * 0.2,
          0.6 + widget.index * 0.2,
          curve: Curves.easeInOut,
        ),
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: widget.size * _animation.value,
          height: widget.size * _animation.value,
          decoration: BoxDecoration(
            color: widget.color.withOpacity(_animation.value),
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
}

enum LoadingIndicatorType {
  circular,
  linear,
  dots,
}