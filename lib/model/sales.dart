/// A class to hold my [Sale] model
class Sale {

  /// Setting constructor for [Purchase] class
  Sale({
    this.id,
    this.customerName,
    this.quantity,
    this.productName,
    this.costPrice,
    this.unitPrice,
    this.totalPrice,
    this.paymentMode,
    this.staff,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? customerName;
  double? quantity;
  String? productName;
  double? costPrice;
  double? unitPrice;
  double? totalPrice;
  String? paymentMode;
  String? staff;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Sale.fromJson(Map<String, dynamic> json) => Sale(
    id: json['_id'],
    customerName: json['customerName'],
    quantity: double.parse(json['quantity'].toString()),
    productName: json['productName'],
    costPrice: double.parse(json['costPrice'].toString()),
    unitPrice: double.parse(json['unitPrice'].toString()),
    totalPrice: double.parse(json['totalPrice'].toString()),
    paymentMode: json['paymentMode'],
    staff: json['staff'] ?? 'Admin',
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  Map<String, dynamic> toJson() => {
    '_id': id,
    'customerName': customerName,
    'quantity': quantity,
    'productName': productName,
    'costPrice': costPrice,
    'unitPrice': unitPrice,
    'totalPrice': totalPrice,
    'paymentMode': paymentMode,
    'staff': staff,
    'createdAt': createdAt!.toIso8601String(),
    'updatedAt': updatedAt!.toIso8601String(),
  };
}