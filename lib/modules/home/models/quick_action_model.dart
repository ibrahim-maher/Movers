import 'package:flutter/material.dart';

/// QuickAction model class
class QuickAction {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  QuickAction({
    required this.title,
    this.subtitle = '',
    this.icon = Icons.info,
    this.color = const Color(0xFF000000),
    this.onTap,
  });

  /// Factory method to create from a Map (like JSON)
  factory QuickAction.fromMap(Map<String, dynamic> map) {
    return QuickAction(
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString() ?? '',
      icon: _getIconFromString(map['icon']?.toString() ?? 'info'),
      color: Color(map['color'] ?? 0xFF000000),
      onTap: map['onTap'] as VoidCallback?,
    );
  }

  /// Convert to Map if needed
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subtitle': subtitle,
      'icon': icon.toString(), // optional: just for reference
      'color': color.value,
      'onTap': onTap,
    };
  }

  /// Private helper to map string to IconData
  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'home':
        return Icons.home;
      case 'info':
        return Icons.info;
      case 'settings':
        return Icons.settings;
      case 'add':
        return Icons.add;
      case 'delete':
        return Icons.delete;
      case 'person':
        return Icons.person;
      case 'message':
        return Icons.message;
      case 'search':
        return Icons.search;
    // Add more mappings here as needed
      default:
        return Icons.info;
    }
  }
}
