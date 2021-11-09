/// A class to hold my [AllCustomerReport] model
class AllCustomerReport {

  /// Setting constructor for [AllCustomerReport] class
  AllCustomerReport({
    this.report,
    this.totalAmount,
    this.paymentMade,
    this.paid,
    this.soldAt,
    this.dueDate,
    this.description,
    this.id,
    this.paymentReceivedAt,
  });

  /// This variable holds the list of reports [Report]
  List<Report>? report;

  /// This variable holds the sales total amount
  double? totalAmount;

  /// This variable holds the sales payment made amount
  double? paymentMade;

  /// This variable holds the sales paid either true or false
  bool? paid;

  /// This variable holds the sales sold at
  DateTime? soldAt;

  /// This variable holds the sales due date
  DateTime? dueDate;

  /// This variable holds the sales description
  String? description;

  /// This variable holds the sales id
  String? id;

  /// This variable holds the sales payment received date
  DateTime? paymentReceivedAt;

  /// Function to map customer report's details from a JSON object
  factory AllCustomerReport.fromJson(Map<String, dynamic> json) => AllCustomerReport(
    report: List<Report>.from(json['report'].map((x) => Report.fromJson(x))),
    totalAmount: double.parse(json['totalAmount'].toString()),
    paymentMade: double.parse(json['paymentMade'].toString()),
    paid: json['paid'],
    soldAt: DateTime.parse(json['soldAt']),
    dueDate: json['dueDate'] == null ? null : DateTime.parse(json['dueDate']),
    description: json['description'] ?? '',
    id: json['_id'],
    paymentReceivedAt: json['paymentReceivedAt'] == null ? null : DateTime.parse(json['paymentReceivedAt']),
  );

  /// Function to map customer report's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    'report': List<dynamic>.from(report!.map((x) => x.toJson())),
    'totalAmount': totalAmount,
    'paymentMade': paymentMade,
    'paid': paid,
    'soldAt': soldAt!.toIso8601String(),
    'dueDate': dueDate == null ? null : dueDate!.toIso8601String(),
    'description': description ?? null,
    '_id': id,
    'paymentReceivedAt': paymentReceivedAt == null ? null : paymentReceivedAt!.toIso8601String(),
  };
}

/// A class to hold my [Report] model
class Report {

  /// Setting constructor for [Report] class
  Report({
    this.quantity,
    this.productName,
    this.costPrice,
    this.unitPrice,
    this.totalPrice,
  });

  /// This variable holds the reports quantity
  double? quantity;

  /// This variable holds the reports product name
  String? productName;

  /// This variable holds the reports cost price
  double? costPrice;

  /// This variable holds the reports unit price
  double? unitPrice;

  /// This variable holds the reports total price
  double? totalPrice;

  /// Function to map customer report's details from a JSON object
  factory Report.fromJson(Map<String, dynamic> json) => Report(
    quantity: double.parse(json['quantity'].toString()),
    productName: json['productName'],
    costPrice: double.parse(json['costPrice'].toString()),
    unitPrice: double.parse(json['unitPrice'].toString()),
    totalPrice: double.parse(json['totalPrice'].toString()),
  );

  /// Function to map customer report's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    'quantity': quantity,
    'productName': productName,
    'costPrice': costPrice,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
  };
}