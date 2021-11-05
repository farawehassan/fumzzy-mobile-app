
///A class to hold my [STORE] model

class Store {
  Store({
    this.inventoryCostPrice,
    this.inventorySellingPrice,
    this.inventoryProfit,
    this.inventoryItems,
    this.totalSales,
    this.totalPurchases,
    this.totalExpenses,
    this.totalProfitMade,
  });

  /// This variable holds the store inventory cost price
  int? inventoryCostPrice;

  /// This variable holds the store inventory selling price
  int? inventorySellingPrice;

  /// This variable holds the store inventory profit
  int? inventoryProfit;

  /// This variable holds the store inventory items
  int? inventoryItems;

  /// This variable holds the store total sales
  int? totalSales;

  /// This variable holds the store total purchase
  int? totalPurchases;

  /// This variable holds the store total expenses
  int? totalExpenses;

  /// This variable holds the store total profit made
  int? totalProfitMade;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    inventoryCostPrice: json["inventoryCostPrice"],
    inventorySellingPrice: json["inventorySellingPrice"],
    inventoryProfit: json["inventoryProfit"],
    inventoryItems: json["inventoryItems"],
    totalSales: json["totalSales"],
    totalPurchases: json["totalPurchases"],
    totalExpenses: json["totalExpenses"],
    totalProfitMade: json["totalProfitMade"],
  );

  Map<String, dynamic> toJson() => {
    "inventoryCostPrice": inventoryCostPrice,
    "inventorySellingPrice": inventorySellingPrice,
    "inventoryProfit": inventoryProfit,
    "inventoryItems": inventoryItems,
    "totalSales": totalSales,
    "totalPurchases": totalPurchases,
    "totalExpenses": totalExpenses,
    "totalProfitMade": totalProfitMade,
  };
}