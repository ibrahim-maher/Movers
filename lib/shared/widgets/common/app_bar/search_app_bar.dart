import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final String hintText;
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
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onClear;
  final TextEditingController? searchController;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const SearchAppBar({
    super.key,
    required this.title,
    this.hintText = 'Search...',
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
    this.onChanged,
    this.onSubmitted,
    this.onClear,
    this.searchController,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(toolbarHeight + (bottom?.preferredSize.height ?? 0.0));
}

class _SearchAppBarState extends State<SearchAppBar> {
  late TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController = widget.searchController ?? TextEditingController();
  }

  @override
  void dispose() {
    if (widget.searchController == null) {
      _searchController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? theme.colorScheme.surface;
    final fgColor = widget.foregroundColor ?? theme.colorScheme.onSurface;

    Widget? leadingWidget = widget.leading;
    if (leadingWidget == null && widget.showBackButton) {
      leadingWidget = IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: widget.onBackPressed ?? () => Navigator.of(context).pop(),
      );
    }

    return AppBar(
      title: _isSearching ? _buildSearchField() : Text(widget.title),
      actions: [
        if (!_isSearching)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = true;
              });
            },
          ),
        if (_isSearching)
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              setState(() {
                _isSearching = false;
                _searchController.clear();
                if (widget.onClear != null) {
                  widget.onClear!();
                }
              });
            },
          ),
        if (!_isSearching && widget.actions != null) ...widget.actions!,
      ],
      leading: _isSearching ? null : leadingWidget,
      centerTitle: widget.centerTitle,
      elevation: widget.elevation,
      backgroundColor: bgColor,
      foregroundColor: fgColor,
      systemOverlayStyle: widget.systemOverlayStyle ?? _getSystemOverlayStyle(bgColor),
      bottom: widget.bottom,
      titleSpacing: _isSearching ? 0 : widget.titleSpacing,
      leadingWidth: widget.leadingWidth,
      titleTextStyle: widget.titleTextStyle ?? theme.textTheme.titleLarge?.copyWith(
        color: fgColor,
        fontWeight: FontWeight.bold,
      ),
      automaticallyImplyLeading: _isSearching ? false : widget.automaticallyImplyLeading,
      toolbarHeight: widget.toolbarHeight,
      flexibleSpace: widget.flexibleSpace,
      primary: widget.primary!,
      shape: widget.shape,
    );
  }

  Widget _buildSearchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: widget.foregroundColor?.withOpacity(0.6) ?? 
                 Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        ),
        prefixIcon: Icon(
          Icons.search,
          color: widget.foregroundColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      style: TextStyle(
        color: widget.foregroundColor ?? Theme.of(context).colorScheme.onSurface,
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }

  SystemUiOverlayStyle _getSystemOverlayStyle(Color backgroundColor) {
    final brightness = ThemeData.estimateBrightnessForColor(backgroundColor);
    return brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
  }
}