/// A class to hold my [User] model
class User {

  /// Setting constructor for [User] class
  User({
    this.id,
    this.name,
    this.phone,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  /// This variable holds the user id
  String? id;

  /// This variable holds the user name
  String? name;

  /// This variable holds the user phone
  String? phone;

  /// This variable holds the user type
  String? type;

  /// This variable holds the user status
  String? status;

  /// This variable holds the user created at
  DateTime? createdAt;

  /// This variable holds the user updated at
  DateTime? updatedAt;

  /// This variable holds the user token
  String? token;

  /// Function to map user's details from a JSON object
  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    type: json["type"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    token: json["token"],
  );

  /// Function to map user's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "type": type,
    "status": status,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
    "token": token,
  };
}
