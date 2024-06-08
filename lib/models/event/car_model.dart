// To parse this JSON data, do
//
//     final car = carFromJson(jsonString);

import 'dart:convert';

Car carFromJson(String str) => Car.fromJson(json.decode(str));

String carToJson(Car data) => json.encode(data.toJson());

class Car {
  final String name;
  final int seats;
  final String regNo;

  Car({
    required this.name,
    required this.seats,
    required this.regNo,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
    name: json["name"],
    seats: json["seats"],
    regNo: json["regNo"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "seats": seats,
    "regNo": regNo,
  };
}
