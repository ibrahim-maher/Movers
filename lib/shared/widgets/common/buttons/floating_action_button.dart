import 'package:flutter/material.dart';

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isExtended;
  final String? label;
  final bool isLoading;
  final bool mini;
  final double? elevation;

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
    this.backgroundColor,
    this.iconColor,
    this.isExtended = false,
    this.label,
    this.isLoading = false,
    this.mini = false,
    this.elevation,
  }) : assert(isExtended == false || label != null, 
      'Label must be provided when isExtended is true');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.primary;
    final fgColor = iconColor ?? theme.colorScheme.onPrimary;

    if (isLoading) {
      return FloatingActionButton(
        onPressed: null,
        backgroundColor: bgColor.withOpacity(0.7),
        tooltip: tooltip,
        elevation: elevation,
        mini: mini,
        child: SizedBox(
          height: 24,
          width: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(fgColor),
          ),
        ),
      );
    }

    if (isExtended) {
      return FloatingActionButton.extended(
        onPressed: onPressed,
        backgroundColor: bgColor,
        tooltip: tooltip,
        elevation: elevation,
        icon: Icon(icon, color: fgColor),
        label: Text(
          label!,
          style: TextStyle(color: fgColor, fontWeight: FontWeight.bold),
        ),
      );
    }

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: bgColor,
      tooltip: tooltip,
      elevation: elevation,
      mini: mini,
      child: Icon(icon, color: fgColor),
    );
  }
}