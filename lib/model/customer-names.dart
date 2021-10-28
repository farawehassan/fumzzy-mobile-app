/// A class to hold my [CustomerName] model
class CustomerName {

  /// Setting constructor for [CustomerName] class
  CustomerName({
    this.id,
    this.name,
  });

  /// This variable holds the customer id
  String? id;

  /// This variable holds the customer name
  String? name;

  /// Function to map customer's details from a JSON object
  factory CustomerName.fromJson(Map<String, dynamic> json) => CustomerName(
    id: json['_id'],
    name: json['name'],
  );

  /// Function to map customer's details to a [Map<String, dynamic>] object
  Map<String, dynamic> toJson() => {
    '_id': id,
    'name': name,
  };
}
