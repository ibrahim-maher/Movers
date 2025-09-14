import 'package:flutter/material.dart';
import 'base_card.dart';

class StatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Widget? icon;
  final Color? valueColor;
  final Color? iconColor;
  final Color? iconBackgroundColor;
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
  final TextStyle? valueStyle;
  final TextStyle? subtitleStyle;
  final Widget? trailing;
  final bool showTrend;
  final double? trendValue;
  final bool trendUp;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.valueColor,
    this.iconColor,
    this.iconBackgroundColor,
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
    this.valueStyle,
    this.subtitleStyle,
    this.trailing,
    this.showTrend = false,
    this.trendValue,
    this.trendUp = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultTitleStyle = theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        );
    final defaultValueStyle = theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: valueColor ?? theme.colorScheme.primary,
        );
    final defaultSubtitleStyle = theme.textTheme.bodySmall?.copyWith(
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (icon != null) ...[  
                      _buildIcon(theme),
                      const SizedBox(width: 12),
                    ],
                    Text(
                      title,
                      style: titleStyle ?? defaultTitleStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      value,
                      style: valueStyle ?? defaultValueStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[  
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: subtitleStyle ?? defaultSubtitleStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              if (showTrend && trendValue != null) _buildTrend(theme),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIcon(ThemeData theme) {
    final iconClr = iconColor ?? theme.colorScheme.primary;
    final bgColor = iconBackgroundColor ?? theme.colorScheme.primaryContainer;

    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: icon is Icon
          ? Icon(
              (icon as Icon).icon,
              color: iconClr,
              size: (icon as Icon).size ?? 20.0,
            )
          : icon,
    );
  }

  Widget _buildTrend(ThemeData theme) {
    final color = trendUp ? Colors.green : Colors.red;
    final icon = trendUp ? Icons.arrow_upward : Icons.arrow_downward;

    return Row(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(width: 4),
        Text(
          '${trendValue!.toStringAsFixed(1)}%',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}