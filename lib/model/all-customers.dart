import 'customer-reports.dart';

/// A class to hold my [AllCustomers] model
class AllCustomers {

  /// Setting constructor for [AllCustomers] class
  AllCustomers({
    this.id,
    this.name,
    this.reports,
    this.createdAt,
    this.updatedAt,
  });

  /// This variable holds the customer id
  String? id;

  /// This variable holds the customer name
  String? name;

  /// This variable holds the customer list of reports(sales)
  List<AllCustomerReport>? reports;

  /// This variable holds the customer created at
  DateTime? createdAt;

  /// This variable holds the customer updated at
  DateTime? updatedAt;

  /// Function to map customer's details from a JSON object
  factory AllCustomers.fromJson(Map<String, dynamic> json) => AllCustomers(
    id: json["_id"],
    name: json["name"],
    reports: List<AllCustomerReport>.from(json["reports"].map((x) => AllCustomerReport.fromJson(x))),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  /// Function to map customer's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "reports": List<dynamic>.from(reports!.map((x) => x.toJson())),
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
