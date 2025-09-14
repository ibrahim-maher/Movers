class OnboardingItem {
  final String title;
  final String subtitle;
  final String image;

  OnboardingItem({
    required this.title,
    required this.subtitle,
    required this.image,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'image': image,
    };
  }

  // Create from JSON
  factory OnboardingItem.fromJson(Map<String, dynamic> json) {
    return OnboardingItem(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      image: json['image'] ?? '',
    );
  }

  // Copy with new values
  OnboardingItem copyWith({
    String? title,
    String? subtitle,
    String? image,
  }) {
    return OnboardingItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      image: image ?? this.image,
    );
  }

  @override
  String toString() {
    return 'OnboardingItem(title: $title, subtitle: $subtitle, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingItem &&
        other.title == title &&
        other.subtitle == subtitle &&
        other.image == image;
  }

  @override
  int get hashCode {
    return title.hashCode ^ subtitle.hashCode ^ image.hashCode;
  }
}