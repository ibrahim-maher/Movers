import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../common/app_bar/custom_app_bar.dart';

class MainLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final SystemUiOverlayStyle? systemOverlayStyle;
  final PreferredSizeWidget? bottom;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final Widget? bottomNavigationBar;
  final Widget? drawer;
  final Widget? endDrawer;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final bool resizeToAvoidBottomInset;
  final bool showAppBar;
  final bool safeArea;
  final EdgeInsets padding;
  final bool scrollable;
  final ScrollController? scrollController;
  final ScrollPhysics? physics;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final Widget? titleWidget;

  const MainLayout({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.leading,
    this.centerTitle = true,
    this.elevation = 0.0,
    this.backgroundColor,
    this.appBarBackgroundColor,
    this.systemOverlayStyle,
    this.bottom,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomNavigationBar,
    this.drawer,
    this.endDrawer,
    this.extendBody = false,
    this.extendBodyBehindAppBar = false,
    this.resizeToAvoidBottomInset = true,
    this.showAppBar = true,
    this.safeArea = true,
    this.padding = const EdgeInsets.all(16.0),
    this.scrollable = false,
    this.scrollController,
    this.physics,
    this.showBackButton = false,
    this.onBackPressed,
    this.titleWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = backgroundColor ?? theme.scaffoldBackgroundColor;

    Widget content = body;

    if (safeArea) {
      content = SafeArea(
        child: Padding(
          padding: padding,
          child: content,
        ),
      );
    } else {
      content = Padding(
        padding: padding,
        child: content,
      );
    }

    if (scrollable) {
      content = SingleChildScrollView(
        controller: scrollController,
        physics: physics,
        child: content,
      );
    }

    return Scaffold(
      appBar: showAppBar
          ? CustomAppBar(
              title: title,
              actions: actions,
              leading: leading,
              centerTitle: centerTitle,
              elevation: elevation,
              backgroundColor: appBarBackgroundColor,
              systemOverlayStyle: systemOverlayStyle,
              bottom: bottom,
              showBackButton: showBackButton,
              onBackPressed: onBackPressed,
              titleWidget: titleWidget,
            )
          : null,
      body: content,
      backgroundColor: bgColor,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      endDrawer: endDrawer,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
    );
  }
}