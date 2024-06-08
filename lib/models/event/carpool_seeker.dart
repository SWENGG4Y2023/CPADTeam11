// To parse this JSON data, do
//
//     final carpoolSeeker = carpoolSeekerFromJson(jsonString);

import 'dart:convert';

import 'member.dart';

CarpoolSeeker carpoolSeekerFromJson(String str) => CarpoolSeeker.fromJson(json.decode(str));

String carpoolSeekerToJson(CarpoolSeeker data) => json.encode(data.toJson());

class CarpoolSeeker {
  final String carpoolMemberId;
  final String providerMemberId;
  final String seekerMemberId;
  final String eventId;
   String status;
  final Member seekerMember;

  CarpoolSeeker({
    required this.carpoolMemberId,
    required this.providerMemberId,
    required this.seekerMemberId,
    required this.eventId,
    required this.status,
    required this.seekerMember,
  });

  factory CarpoolSeeker.fromJson(Map<String, dynamic> json) => CarpoolSeeker(
    carpoolMemberId: json["carpool_member_id"],
    providerMemberId: json["provider_member_id"],
    seekerMemberId: json["seeker_member_id"],
    eventId: json["event_id"],
    status: json["status"],
    seekerMember: Member.fromJson(json["seeker_member"]),
  );

  Map<String, dynamic> toJson() => {
    "carpool_member_id": carpoolMemberId,
    "provider_member_id": providerMemberId,
    "seeker_member_id": seekerMemberId,
    "event_id": eventId,
    "status": status,
    "seeker_member": seekerMember.toJson(),
  };
}

