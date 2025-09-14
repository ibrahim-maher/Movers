// lib/modules/home/models/navigation_item_model.dart
import 'package:flutter/material.dart';

class NavigationItemModel {
  final String id;
  final String label;
  final IconData icon;
  final IconData activeIcon;
  final String route;
  final bool isEnabled;
  final int? badgeCount;

  NavigationItemModel({
    required this.id,
    required this.label,
    required this.icon,
    required this.activeIcon,
    required this.route,
    this.isEnabled = true,
    this.badgeCount,
  });

  factory NavigationItemModel.fromJson(Map<String, dynamic> json) {
    return NavigationItemModel(
      id: json['id'],
      label: json['label'],
      icon: IconData(json['icon_code'], fontFamily: 'MaterialIcons'),
      activeIcon: IconData(json['active_icon_code'], fontFamily: 'MaterialIcons'),
      route: json['route'],
      isEnabled: json['is_enabled'] ?? true,
      badgeCount: json['badge_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'label': label,
      'icon_code': icon.codePoint,
      'active_icon_code': activeIcon.codePoint,
      'route': route,
      'is_enabled': isEnabled,
      'badge_count': badgeCount,
    };
  }
}