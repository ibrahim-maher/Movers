import 'package:flutter/material.dart';

class LoadStatusModel {
  final String id;
  final String name;
  final String description;
  final Color color;
  final int order;

  LoadStatusModel({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.order,
  });

  factory LoadStatusModel.fromJson(Map<String, dynamic> json) {
    return LoadStatusModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      color: Color(int.parse(json['color'], radix: 16)),
      order: json['order'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'color': color.value.toRadixString(16),
      'order': order,
    };
  }

  // Predefined statuses
  static LoadStatusModel pending() {
    return LoadStatusModel(
      id: '1',
      name: 'Pending',
      description: 'Load is pending',
      color: Colors.orange,
      order: 1,
    );
  }

  static LoadStatusModel accepted() {
    return LoadStatusModel(
      id: '2',
      name: 'Accepted',
      description: 'Load is accepted',
      color: Colors.blue,
      order: 2,
    );
  }

  static LoadStatusModel inTransit() {
    return LoadStatusModel(
      id: '3',
      name: 'In Transit',
      description: 'Load is in transit',
      color: Colors.purple,
      order: 3,
    );
  }

  static LoadStatusModel delivered() {
    return LoadStatusModel(
      id: '4',
      name: 'Delivered',
      description: 'Load is delivered',
      color: Colors.green,
      order: 4,
    );
  }

  static LoadStatusModel cancelled() {
    return LoadStatusModel(
      id: '5',
      name: 'Cancelled',
      description: 'Load is cancelled',
      color: Colors.red,
      order: 5,
    );
  }
}