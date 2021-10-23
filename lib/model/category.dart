/// A class to hold my [Category] model
class Category {

  /// Setting constructor for [Category] class
  Category({
    this.id,
    this.name,
    this.products,
    this.createdAt,
    this.updatedAt,
  });

  /// This variable holds the category id
  String? id;

  /// This variable holds the category name
  String? name;

  /// This variable holds the category product count
  int? products;

  /// This variable holds the category created at
  DateTime? createdAt;

  /// This variable holds the category updated at
  DateTime? updatedAt;

  /// Function to map category's details from a JSON object
  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["_id"],
    name: json["name"],
    products: json["products"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

  /// Function to map category's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "products": products,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
