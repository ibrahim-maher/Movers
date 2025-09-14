import 'package:flutter/material.dart';

class LanguageModel {
  final String name;
  final String nativeName;
  final String code;
  final String countryCode;
  final Locale locale;
  final String flag;

  LanguageModel({
    required this.name,
    required this.nativeName,
    required this.code,
    required this.countryCode,
    required this.locale,
    required this.flag,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nativeName': nativeName,
      'code': code,
      'countryCode': countryCode,
      'languageCode': locale.languageCode,
      'countryCodeLocale': locale.countryCode,
      'flag': flag,
    };
  }

  // Create from JSON
  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(
      name: json['name'] ?? '',
      nativeName: json['nativeName'] ?? '',
      code: json['code'] ?? '',
      countryCode: json['countryCode'] ?? '',
      locale: Locale(
        json['languageCode'] ?? 'en',
        json['countryCodeLocale'] ?? 'US',
      ),
      flag: json['flag'] ?? '',
    );
  }

  // Copy with new values
  LanguageModel copyWith({
    String? name,
    String? nativeName,
    String? code,
    String? countryCode,
    Locale? locale,
    String? flag,
  }) {
    return LanguageModel(
      name: name ?? this.name,
      nativeName: nativeName ?? this.nativeName,
      code: code ?? this.code,
      countryCode: countryCode ?? this.countryCode,
      locale: locale ?? this.locale,
      flag: flag ?? this.flag,
    );
  }

  @override
  String toString() {
    return 'LanguageModel(name: $name, code: $code, locale: $locale)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LanguageModel &&
        other.name == name &&
        other.code == code &&
        other.locale == locale;
  }

  @override
  int get hashCode {
    return name.hashCode ^ code.hashCode ^ locale.hashCode;
  }
}