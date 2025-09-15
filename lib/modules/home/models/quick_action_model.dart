// lib/modules/home/models/quick_action_model.dart

import 'package:flutter/material.dart';

class QuickActionModel {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final String color;
  final String route;
  final bool isEnabled;
  final int? badge;

  const QuickActionModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.route,
    this.isEnabled = true,
    this.badge,
  });

  factory QuickActionModel.fromMap(Map<String, dynamic> map) {
    return QuickActionModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      subtitle: map['subtitle'] ?? '',
      icon: map['icon'] ?? '',
      color: map['color'] ?? '#000000',
      route: map['route'] ?? '',
      isEnabled: map['isEnabled'] ?? true,
      badge: map['badge']?.toInt(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'color': color,
      'route': route,
      'isEnabled': isEnabled,
      'badge': badge,
    };
  }

  Color get colorValue {
    try {
      return Color(int.parse(color.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.blue;
    }
  }

  QuickActionModel copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? icon,
    String? color,
    String? route,
    bool? isEnabled,
    int? badge,
  }) {
    return QuickActionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      icon: icon ?? this.icon,
      color: color ?? this.color,
      route: route ?? this.route,
      isEnabled: isEnabled ?? this.isEnabled,
      badge: badge ?? this.badge,
    );
  }

  @override
  String toString() {
    return 'QuickActionModel(id: $id, title: $title, subtitle: $subtitle, icon: $icon, color: $color, route: $route, isEnabled: $isEnabled, badge: $badge)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is QuickActionModel &&
        other.id == id &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.icon == icon &&
        other.color == color &&
        other.route == route &&
        other.isEnabled == isEnabled &&
        other.badge == badge;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    title.hashCode ^
    subtitle.hashCode ^
    icon.hashCode ^
    color.hashCode ^
    route.hashCode ^
    isEnabled.hashCode ^
    badge.hashCode;
  }
}