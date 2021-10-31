///A class to hold my [STAFF] model

class Staffs {
  Staffs({
    this.id,
    this.name,
    this.phone,
    this.type,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  ///A variable to hold staff id
  String? id;

  ///A variable to hold staff name
  String? name;

  ///A variable to hold staff phone number
  String? phone;

  ///A variable to hold staff type
  String? type;

  ///A variable to hold staff status
  String? status;

  ///A variable to hold staff createdAt
  DateTime? createdAt;

  ///A variable to hold staff updatedAt
  DateTime? updatedAt;

  factory Staffs.fromJson(Map<String, dynamic> json) => Staffs(
    id: json["_id"],
    name: json["name"],
    phone: json["phone"],
    type: json["type"],
    status: json["status"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "phone": phone,
    "type": type,
    "status": status,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}