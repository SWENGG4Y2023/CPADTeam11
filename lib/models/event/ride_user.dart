

class RideUser {
  final String userId;
  final String userEmail;
  final String userType;
  final String firstName;
  final String lastName;

  RideUser({
    required this.userId,
    required this.userEmail,
    required this.userType,
    required this.firstName,
    required this.lastName,
  });

  factory RideUser.fromJson(Map<String, dynamic> json) => RideUser(
    userId: json["userId"],
    userEmail: json["userEmail"],
    userType: json["userType"],
    firstName: json["firstName"],
    lastName: json["lastName"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "userEmail": userEmail,
    "userType": userType,
    "firstName": firstName,
    "lastName": lastName,
  };
}