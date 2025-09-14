class LoadTrackingModel {
  final String id;
  final String loadId;
  final String statusId;
  final String statusName;
  final String location;
  final double latitude;
  final double longitude;
  final String? notes;
  final DateTime timestamp;
  final String updatedBy;

  LoadTrackingModel({
    required this.id,
    required this.loadId,
    required this.statusId,
    required this.statusName,
    required this.location,
    required this.latitude,
    required this.longitude,
    this.notes,
    required this.timestamp,
    required this.updatedBy,
  });

  factory LoadTrackingModel.fromJson(Map<String, dynamic> json) {
    return LoadTrackingModel(
      id: json['id'],
      loadId: json['load_id'],
      statusId: json['status_id'],
      statusName: json['status_name'],
      location: json['location'],
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      notes: json['notes'],
      timestamp: DateTime.parse(json['timestamp']),
      updatedBy: json['updated_by'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'load_id': loadId,
      'status_id': statusId,
      'status_name': statusName,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'timestamp': timestamp.toIso8601String(),
      'updated_by': updatedBy,
    };
  }
}