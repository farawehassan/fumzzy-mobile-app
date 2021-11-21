/// A class to hold my [RepaymentHistory] model
class RepaymentHistory {

  /// Setting constructor for [RepaymentHistory] class
  RepaymentHistory({
    this.id,
    this.customer,
    this.reportId,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  /// This variable holds the repayment history id
  String? id;

  /// This variable holds the repayment history customer id
  String? customer;

  /// This variable holds the repayment history report id
  String? reportId;

  /// This variable holds the repayment history amount
  double? amount;

  /// This variable holds the repayment history created at
  DateTime? createdAt;

  /// This variable holds the repayment history updated at
  DateTime? updatedAt;

  /// Function to map repayment history details from a JSON object
  factory RepaymentHistory.fromJson(Map<String, dynamic> json) => RepaymentHistory(
    id: json["_id"],
    customer: json["customer"],
    reportId: json["reportId"],
    amount: double.parse(json["amount"].toString()),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  /// Function to map repayment history details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    "_id": id,
    "customer": customer,
    "reportId": reportId,
    "amount": amount,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
