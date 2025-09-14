import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;
  final double? splashRadius;
  final String? tooltip;
  final EdgeInsetsGeometry padding;
  final BorderRadius? borderRadius;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.size = 24.0,
    this.iconColor,
    this.backgroundColor,
    this.splashRadius,
    this.tooltip,
    this.padding = const EdgeInsets.all(8.0),
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconClr = iconColor ?? theme.colorScheme.primary;
    final bgColor = backgroundColor;

    Widget buttonWidget;

    if (isLoading) {
      buttonWidget = SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          valueColor: AlwaysStoppedAnimation<Color>(iconClr),
        ),
      );
    } else {
      buttonWidget = IconButton(
        icon: Icon(icon, color: iconClr, size: size),
        onPressed: onPressed,
        splashRadius: splashRadius,
        tooltip: tooltip,
        padding: padding,
      );
    }

    if (bgColor != null) {
      return Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius ?? BorderRadius.circular(8.0),
        ),
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }
}