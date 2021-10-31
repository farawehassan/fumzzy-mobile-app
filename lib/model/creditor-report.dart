/// A class to hold my [CreditorReport] model
class CreditorReport {

  /// Setting constructor for [CreditorReport] class
  CreditorReport({
    this.amount,
    this.paymentMade,
    this.description,
    this.id,
  });

  /// This variable holds the creditor report's amount
  double? amount;

  /// This variable holds the creditor report's payment made
  double? paymentMade;

  /// This variable holds the creditor report's description
  String? description;

  /// This variable holds the creditor report's id
  String? id;

  /// Function to map creditor report's details from a JSON object
  factory CreditorReport.fromJson(Map<String, dynamic> json) => CreditorReport(
    amount: double.parse(json["amount"].toString()),
    paymentMade: double.parse(json["paymentMade"].toString()),
    description: json["description"],
    id: json["_id"],
  );

  /// Function to map creditor report's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    "amount": amount,
    "paymentMade": paymentMade,
    "description": description,
    "_id": id,
  };
}
