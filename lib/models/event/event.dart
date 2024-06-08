// To parse this JSON data, do
//
//     final event = eventFromJson(jsonString);

import 'dart:convert';

Event eventFromJson(String str) => Event.fromJson(json.decode(str));

String eventToJson(Event data) => json.encode(data.toJson());

class Event {
  DateTime createdAt;
  String createdBy;
  DateTime modifiedAt;
  String modifiedBy;
  String eventId;
  String eventName;
  DateTime eventDate;
  String eventDescription;
  String locationId;
  dynamic teamId;
  Location location;
  String eventImage;

  Event({
    required this.createdAt,
    required this.createdBy,
    required this.modifiedAt,
    required this.modifiedBy,
    required this.eventId,
    required this.eventName,
    required this.eventDate,
    required this.eventDescription,
    required this.locationId,
    required this.teamId,
    required this.location,
    required this.eventImage,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    createdAt: DateTime.parse(json["createdAt"]),
    createdBy: json["createdBy"],
    modifiedAt: DateTime.parse(json["modifiedAt"]),
    modifiedBy: json["modifiedBy"],
    eventId: json["event_id"],
    eventName: json["event_name"],
    eventDate: DateTime.parse(json["event_date"]),
    eventDescription: json["event_description"],
    locationId: json["location_id"],
    teamId: json["team_id"],
    eventImage: json["eventImage"]??'',
    location: Location.fromJson(json["location"],
    ),
  );

  Map<String, dynamic> toJson() => {
    "createdAt": createdAt.toIso8601String(),
    "createdBy": createdBy,
    "modifiedAt": modifiedAt.toIso8601String(),
    "modifiedBy": modifiedBy,
    "event_id": eventId,
    "event_name": eventName,
    "event_date": "${eventDate.year.toString().padLeft(4, '0')}-${eventDate.month.toString().padLeft(2, '0')}-${eventDate.day.toString().padLeft(2, '0')}",
    "event_description": eventDescription,
    "location_id": locationId,
    "team_id": teamId,
    "event_image":eventImage,
    "location": location.toJson(),
  };
}

class Location {
  DateTime createdAt;
  String createdBy;
  DateTime modifiedAt;
  String modifiedBy;
  String locationId;
  String name;
  String address;
  String city;
  String state;
  String country;
  double latitude;
  double longitude;

  Location({
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

  factory Location.fromJson(Map<String, dynamic> json) => Location(
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
