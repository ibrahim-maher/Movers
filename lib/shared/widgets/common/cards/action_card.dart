import 'package:flutter/material.dart';
import 'base_card.dart';

class ActionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? content;
  final List<Widget> actions;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final bool hasShadow;
  final double? width;
  final double? height;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final MainAxisAlignment actionsAlignment;
  final bool actionsStacked;

  const ActionCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.content,
    required this.actions,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
    this.elevation = 1.0,
    this.hasShadow = true,
    this.width,
    this.height,
    this.titleStyle,
    this.subtitleStyle,
    this.actionsAlignment = MainAxisAlignment.end,
    this.actionsStacked = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTitleStyle = theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        );
    final defaultSubtitleStyle = theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        );

    return BaseCard(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      elevation: elevation,
      hasShadow: hasShadow,
      width: width,
      height: height,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 12)],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: titleStyle ?? defaultTitleStyle,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    if (subtitle != null) ...[  
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: subtitleStyle ?? defaultSubtitleStyle,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          if (content != null) ...[
            const SizedBox(height: 16),
            content!,
            const SizedBox(height: 16),
          ] else ...[
            const SizedBox(height: 16),
          ],

          _buildActions(),
        ],
      ),
    );
  }

  Widget _buildActions() {
    if (actionsStacked) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: actions.map((action) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: action,
          );
        }).toList(),
      );
    } else {
      return Row(
        mainAxisAlignment: actionsAlignment,
        children: actions.map((action) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: action,
          );
        }).toList(),
      );
    }
  }
}