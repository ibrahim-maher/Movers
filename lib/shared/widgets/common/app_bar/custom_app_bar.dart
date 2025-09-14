import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final PreferredSizeWidget? bottom;
  final double? titleSpacing;
  final double? leadingWidth;
  final TextStyle? titleTextStyle;
  final bool automaticallyImplyLeading;
  final double toolbarHeight;
  final Widget? flexibleSpace;
  final bool? primary;
  final ShapeBorder? shape;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0.0,
    this.backgroundColor,
    this.foregroundColor,
    this.systemOverlayStyle,
    this.bottom,
    this.titleSpacing,
    this.leadingWidth,
    this.titleTextStyle,
    this.automaticallyImplyLeading = true,
    this.toolbarHeight = kToolbarHeight,
    this.flexibleSpace,
    this.primary = true,
    this.shape,
    this.titleWidget,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.colorScheme.surface;
    final fgColor = foregroundColor ?? theme.colorScheme.onSurface;

    Widget? leadingWidget = leading;
    if (leadingWidget == null && showBackButton) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    return AppBar(
      title: titleWidget ?? Text(title),
      actions: actions,
      leading: leadingWidget,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      systemOverlayStyle: systemOverlayStyle ?? _getSystemOverlayStyle(bgColor),
      bottom: bottom,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      titleTextStyle: titleTextStyle ?? theme.textTheme.titleLarge?.copyWith(
        color: fgColor,
        fontWeight: FontWeight.bold,
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      flexibleSpace: flexibleSpace,
      primary: primary!,
      shape: shape,
    );
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}