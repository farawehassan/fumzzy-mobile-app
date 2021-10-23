import 'category.dart';

/// A class to hold my [Product] model
class Product {

  /// Setting constructor for [Product] class
  Product({
    this.id,
    this.productName,
    this.category,
    this.costPrice,
    this.sellingPrice,
    this.initialQty,
    this.currentQty,
    this.sellersName,
    this.createdAt,
    this.updatedAt
  });

  /// This variable holds the product id
  String? id;

  /// This variable holds the product name
  String? productName;

  /// This variable holds the product category
  Category? category;

  /// This variable holds the product cost price
  double? costPrice;

  /// This variable holds the product selling price
  double? sellingPrice;

  /// This variable holds the product initial quantity
  double? initialQty;

  /// This variable holds the product current quantity
  double? currentQty;

  /// This variable holds the product seller name
  String? sellersName;

  /// This variable holds the product created at
  DateTime? createdAt;

  /// This variable holds the product updated at
  DateTime? updatedAt;

  /// Function to map product's details from a JSON object
  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"],
    productName: json["productName"],
    category: Category.fromJson(json["category"]),
    costPrice: double.parse(json["costPrice"].toString()),
    sellingPrice: double.parse(json["sellingPrice"].toString()),
    initialQty: double.parse(json["initialQty"].toString()),
    currentQty: double.parse(json["currentQty"].toString()),
    sellersName: json["sellersName"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  /// Function to map product's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    "_id": id,
    "productName": productName,
    "category": category!.toJson(),
    "costPrice": costPrice,
    "sellingPrice": sellingPrice,
    "initialQty": initialQty,
    "currentQty": currentQty,
    "sellersName": sellersName,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}