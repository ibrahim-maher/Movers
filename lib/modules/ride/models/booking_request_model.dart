class BookingRequestModel {
  final String rideId;
  final int seats;
  final String? notes;

  BookingRequestModel({
    required this.rideId,
    required this.seats,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'ride_id': rideId,
      'seats': seats,
      'notes': notes,
    };
  }
}