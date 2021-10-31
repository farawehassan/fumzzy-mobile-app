import 'package:fumzy/model/staff.dart';

///A class to hold [Expense] model
class Expense {

  /// Setting constructor for [Expense] class
  Expense({
    this.description,
    this.amount,
    this.staff,
    this.id,
    this.createdAt,
    this.updatedAt
  });

  ///This variable holds the expense description
  String? description;

  ///This variable holds the amount
  double? amount;

  ///This variable holds the staff details
  Staff? staff;

  ///This variable holds the expense id
  String? id;

  /// This variable holds the expense created at
  DateTime? createdAt;

  /// This variable holds the expense created at
  DateTime? updatedAt;

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
    description: json["description"],
    amount: double.parse(json["amount"].toString()),
    staff: Staff.fromJson(json["staff"]),
    id: json["_id"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  Map<String, dynamic> toJson() => {
    "description": description,
    "amount": amount,
    "staff": staff,
    "_id": id,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
