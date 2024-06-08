
class RideLocation {
  final double latitude;
  final double longitude;
  final String address;

  RideLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory RideLocation.fromJson(Map<String, dynamic> json) => RideLocation(
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "latitude": latitude,
    "longitude": longitude,
    "address": address,
  };
}