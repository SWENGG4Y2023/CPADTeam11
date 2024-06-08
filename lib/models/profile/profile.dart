import '../event/car_model.dart';

class User {
  final String userId;
  final String userEmail;
  final String userType;
  final String firstName;
  final String lastName;
  final String? car;
  final int? seats;
  final String? baseLocationId;
  final BaseLocation? baseLocation;

  User({
    required this.userId,
    required this.userEmail,
    required this.userType,
    required this.firstName,
    required this.lastName,
     this.car,
     this.baseLocationId,
     this.baseLocation,
    this.seats
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
    userId: json["user_id"],
    userEmail: json["user_email"],
    userType: json["user_type"],
    firstName: json["first_name"],
    lastName: json["last_name"],
    car: json["car"],
    baseLocationId: json["base_location_id"],
    baseLocation: json["base_location"] != null ? BaseLocation.fromJson(json["base_location"]) : null,
    seats: json['seats']
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "user_email": userEmail,
    "user_type": userType,
    "first_name": firstName,
    "last_name": lastName,
    "car": car,
    "base_location_id": baseLocationId,
    "base_location": baseLocation,
    "seats":seats
  };
}

class BaseLocation {
  final DateTime createdAt;
  final String createdBy;
  final DateTime modifiedAt;
  final String modifiedBy;
  final String locationId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String country;
  final double latitude;
  final double longitude;

  BaseLocation({
    required this.createdAt,
    required this.createdBy,
    required this.modifiedAt,
    required this.modifiedBy,
    required this.locationId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory BaseLocation.fromJson(Map<String, dynamic> json) => BaseLocation(
    createdAt: DateTime.parse(json["createdAt"]),
    createdBy: json["createdBy"],
    modifiedAt: DateTime.parse(json["modifiedAt"]),
    modifiedBy: json["modifiedBy"],
    locationId: json["location_id"],
    name: json["name"],
    address: json["address"],
    city: json["city"],
    state: json["state"],
    country: json["country"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "createdBy": createdBy,
    "modifiedAt": modifiedAt.toIso8601String(),
    "modifiedBy": modifiedBy,
    "location_id": locationId,
    "name": name,
    "address": address,
    "city": city,
    "state": state,
    "country": country,
    "latitude": latitude,
    "longitude": longitude,
  };
}
