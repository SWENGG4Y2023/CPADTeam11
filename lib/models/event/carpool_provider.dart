// To parse this JSON data, do
//
//     final carpoolMember = carpoolMemberFromJson(jsonString);

import 'dart:convert';

import 'member.dart';

CarpoolProvider carpoolMemberFromJson(String str) => CarpoolProvider.fromJson(json.decode(str));

String carpoolMemberToJson(CarpoolProvider data) => json.encode(data.toJson());

class CarpoolProvider {
  final String carpoolMemberId;
  final String providerMemberId;
  final String seekerMemberId;
  final String eventId;
  final String status;
  final Member providerMember;

  CarpoolProvider({
    required this.carpoolMemberId,
    required this.providerMemberId,
    required this.seekerMemberId,
    required this.eventId,
    required this.status,
    required this.providerMember,
  });

  factory CarpoolProvider.fromJson(Map<String, dynamic> json) => CarpoolProvider(
    carpoolMemberId: json["carpool_member_id"],
    providerMemberId: json["provider_member_id"],
    seekerMemberId: json["seeker_member_id"],
    eventId: json["event_id"],
    status: json["status"],
    providerMember: Member.fromJson(json["provider_member"]),
  );

  Map<String, dynamic> toJson() => {
    "carpool_member_id": carpoolMemberId,
    "provider_member_id": providerMemberId,
    "seeker_member_id": seekerMemberId,
    "event_id": eventId,
    "status": status,
    "provider_member": providerMember.toJson(),
  };
}

