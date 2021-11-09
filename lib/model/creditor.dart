import 'creditor-report.dart';

/// A class to hold my [Creditor] model
class Creditor {

  /// Setting constructor for [Creditor] class
  Creditor({
    this.id,
    this.name,
    this.reports,
    this.createdAt,
    this.updatedAt,
  });

  /// This variable holds the creditor id
  String? id;

  /// This variable holds the creditor name
  String? name;

  /// This variable holds the creditor reports
  List<CreditorReport>? reports;

  /// This variable holds the creditor created at
  DateTime? createdAt;

  /// This variable holds the creditor updated at
  DateTime? updatedAt;

  /// Function to map creditor's details from a JSON object
  factory Creditor.fromJson(Map<String, dynamic> json) => Creditor(
    id: json['_id'],
    name: json['name'],
    reports: List<CreditorReport>.from(json['reports'].map((x) => CreditorReport.fromJson(x))),
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  /// Function to map creditor's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
    'reports': List<dynamic>.from(reports!.map((x) => x.toJson())),
    'createdAt': createdAt!.toIso8601String(),
    'updatedAt': updatedAt!.toIso8601String(),
  };
}
