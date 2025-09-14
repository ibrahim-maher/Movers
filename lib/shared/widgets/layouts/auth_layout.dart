import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/app_bar/transparent_app_bar.dart';

class AuthLayout extends StatelessWidget {
  final String? title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final SystemUiOverlayStyle systemOverlayStyle;
  final Color? backgroundColor;
  final Widget? backgroundImage;
  final Widget? logo;
  final String? subtitle;
  final EdgeInsets padding;
  final bool scrollable;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool showAppBar;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? footer;
  final double? logoHeight;
  final double? logoWidth;
  final EdgeInsets? logoMargin;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final bool safeArea;
  final Widget? titleWidget;

  const AuthLayout({
    super.key,
    this.title,
    required this.body,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.systemOverlayStyle = SystemUiOverlayStyle.dark,
    this.backgroundColor,
    this.backgroundImage,
    this.logo,
    this.subtitle,
    this.padding = const EdgeInsets.all(24.0),
    this.scrollable = true,
    this.scrollController,
    this.physics,
    this.showAppBar = true,
    this.showBackButton = false,
    this.onBackPressed,
    this.footer,
    this.logoHeight = 80.0,
    this.logoWidth,
    this.logoMargin = const EdgeInsets.only(bottom: 32.0),
    this.titleStyle,
    this.subtitleStyle,
    this.safeArea = true,
    this.titleWidget,
  }) : assert(title != null || titleWidget != null || !showAppBar, 
      'Either title or titleWidget must be provided when showAppBar is true');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.scaffoldBackgroundColor;

    Widget content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (logo != null) ...[  
          Container(
            margin: logoMargin,
            height: logoHeight,
            width: logoWidth,
            child: logo,
          ),
        ],
        if (!showAppBar && title != null) ...[  
          Text(
            title!,
            style: titleStyle ?? theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onBackground,
            ),
            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 8.0),
        ],
        if (!showAppBar && subtitle != null) ...[  
          Text(
            subtitle!,
            style: subtitleStyle ?? theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onBackground.withOpacity(0.7),
            ),
            textAlign: centerTitle ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 32.0),
        ],
        Expanded(
          child: body,
        ),
        if (footer != null) ...[  
          const SizedBox(height: 24.0),
          footer!,
        ],
      ],
    );

    if (scrollable) {
      content = SingleChildScrollView(
        controller: scrollController,
        physics: physics,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                (showAppBar ? kToolbarHeight : 0) -
                MediaQuery.of(context).padding.top -
                MediaQuery.of(context).padding.bottom,
          ),
          child: IntrinsicHeight(child: content),
        ),
      );
    }

    content = Padding(
      padding: padding,
      child: content,
    );

    if (safeArea) {
      content = SafeArea(child: content);
    }

    if (backgroundImage != null) {
      content = Stack(
        fit: StackFit.expand,
        children: [
          backgroundImage!,
          content,
        ],
      );
    }

    return Scaffold(
      appBar: showAppBar
          ? TransparentAppBar(
              title: title ?? '',
              titleWidget: titleWidget,
              actions: actions,
              leading: leading,
              centerTitle: centerTitle,
              systemOverlayStyle: systemOverlayStyle,
              showBackButton: showBackButton,
              onBackPressed: onBackPressed,
              iconColor: theme.colorScheme.onBackground,
              titleColor: theme.colorScheme.onBackground,
            )
          : null,
      body: content,
      backgroundColor: bgColor,
      resizeToAvoidBottomInset: true,
    );
  }
}