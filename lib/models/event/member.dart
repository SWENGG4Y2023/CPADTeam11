// To parse this JSON data, do
//
//     final rideProvider = rideProviderFromJson(jsonString);

import 'dart:convert';

import '../profile/profile.dart';

Member rideProviderFromJson(String str) => Member.fromJson(json.decode(str));

String rideProviderToJson(Member data) => json.encode(data.toJson());

class Member {
  final String memberId;
  final String userId;
  final String eventId;
  final String startLocationId;
  final String memberCarpoolType;
  final dynamic departureTime;
  final dynamic returnTime;
  final int? seats;
  final BaseLocation startLocation;
  final User user;

  Member({
    required this.memberId,
    required this.userId,
    required this.eventId,
    required this.startLocationId,
    required this.memberCarpoolType,
    required this.departureTime,
    required this.returnTime,
    required this.seats,
    required this.startLocation,
    required this.user,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
    memberId: json["member_id"],
    userId: json["user_id"],
    eventId: json["event_id"],
    startLocationId: json["start_location_id"],
    memberCarpoolType: json["member_carpool_type"],
    departureTime: json["departure_time"],
    returnTime: json["return_time"],
    seats: json["seats"],
    startLocation: BaseLocation.fromJson(json["start_location"]),
    user: User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "member_id": memberId,
    "user_id": userId,
    "event_id": eventId,
    "start_location_id": startLocationId,
    "member_carpool_type": memberCarpoolType,
    "departure_time": departureTime,
    "return_time": returnTime,
    "seats": seats,
    "start_location": startLocation.toJson(),
    "user": user.toJson(),
  };
}


