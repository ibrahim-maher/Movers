import 'package:flutter/material.dart';
import 'base_card.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? icon;
  final Widget? content;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final VoidCallback? onTap;
  final bool hasShadow;
  final double? width;
  final double? height;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const InfoCard({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.content,
    this.padding = const EdgeInsets.all(16.0),
    this.margin = const EdgeInsets.all(0),
    this.borderRadius = 12.0,
    this.backgroundColor,
    this.borderColor,
    this.elevation = 1.0,
    this.onTap,
    this.hasShadow = true,
    this.width,
    this.height,
    this.titleStyle,
    this.subtitleStyle,
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
      onTap: onTap,
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
          ],
        ],
      ),
    );
  }
}