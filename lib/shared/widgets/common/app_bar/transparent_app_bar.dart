import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final SystemUiOverlayStyle systemOverlayStyle;
  final PreferredSizeWidget? bottom;
  final double? titleSpacing;
  final double? leadingWidth;
  final TextStyle? titleTextStyle;
  final bool automaticallyImplyLeading;
  final double toolbarHeight;
  final Widget? flexibleSpace;
  final bool? primary;
  final Widget? titleWidget;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Color? iconColor;
  final Color? titleColor;

  const TransparentAppBar({
    super.key,
    this.title,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.systemOverlayStyle = SystemUiOverlayStyle.light,
    this.bottom,
    this.titleSpacing,
    this.leadingWidth,
    this.titleTextStyle,
    this.automaticallyImplyLeading = true,
    this.toolbarHeight = kToolbarHeight,
    this.flexibleSpace,
    this.primary = true,
    this.titleWidget,
    this.showBackButton = true,
    this.onBackPressed,
    this.iconColor = Colors.white,
    this.titleColor = Colors.white,
  }) : assert(title != null || titleWidget != null, 'Either title or titleWidget must be provided');

  @override
  Widget build(BuildContext context) {
    Widget? leadingWidget = leading;
    if (leadingWidget == null && showBackButton) {
      leadingWidget = IconButton(
        icon: Icon(Icons.arrow_back, color: iconColor),
        onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    return AppBar(
      title: titleWidget ?? (title != null ? Text(title!) : null),
      actions: actions,
      leading: leadingWidget,
      centerTitle: centerTitle,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: iconColor,
      systemOverlayStyle: systemOverlayStyle,
      bottom: bottom,
      titleSpacing: titleSpacing,
      leadingWidth: leadingWidth,
      titleTextStyle: titleTextStyle ?? Theme.of(context).textTheme.titleLarge?.copyWith(
        color: titleColor,
        fontWeight: FontWeight.bold,
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      toolbarHeight: toolbarHeight,
      flexibleSpace: flexibleSpace,
      primary: primary!,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}