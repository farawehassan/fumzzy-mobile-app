import 'package:fumzy/model/product.dart';

/// A class to hold my [Purchase] model
class Purchase {

  /// Setting constructor for [Purchase] class
  Purchase({
    this.id,
    this.product,
    this.costPrice,
    this.sellingPrice,
    this.quantity,
    this.createdAt,
    this.updatedAt,
  });

  /// This variable holds the purchase id
  String? id;

  /// This variable holds the purchase product model
  Product? product;

  /// This variable holds the purchase cost price
  double? costPrice;

  /// This variable holds the purchase selling price
  double? sellingPrice;

  /// This variable holds the purchase quantity
  double? quantity;

  /// This variable holds the purchase created at
  DateTime? createdAt;

  /// This variable holds the purchase updated at
  DateTime? updatedAt;

  /// Function to map purchase's details from a JSON object
  factory Purchase.fromJson(Map<String, dynamic> json) => Purchase(
    id: json["_id"],
    product: Product.fromJson(json["product"]),
    costPrice: double.parse(json["costPrice"].toString()),
    sellingPrice: double.parse(json["sellingPrice"].toString()),
    quantity: double.parse(json["quantity"].toString()),
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  /// Function to map purchase's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    "_id": id,
    "product": product!.toJson(),
    "costPrice": costPrice,
    "sellingPrice": sellingPrice,
    "quantity": quantity,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}