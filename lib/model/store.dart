/// A class to hold my [Store] model

class Store {

  Store({
    this.inventoryCostPrice,
    this.inventorySellingPrice,
    this.inventoryProfit,
    this.inventoryItems,
    this.outstandingSales,
    this.outstandingSalesVolume,
    this.outstandingPurchase,
    this.outstandingPurchaseVolume,
  });

  /// This variable holds the store inventory cost price
  double? inventoryCostPrice;

  /// This variable holds the store inventory selling price
  double? inventorySellingPrice;

  /// This variable holds the store inventory profit
  double? inventoryProfit;

  /// This variable holds the store inventory items
  double? inventoryItems;

  /// This variable holds the store total outstanding sales
  double? outstandingSales;

  /// This variable holds the store total outstanding sales volume
  int? outstandingSalesVolume;

  /// This variable holds the store total outstanding purchase
  double? outstandingPurchase;

  /// This variable holds the store total outstanding purchase volume
  int? outstandingPurchaseVolume;

  factory Store.fromJson(Map<String, dynamic> json) => Store(
    inventoryCostPrice: double.parse(json['inventoryCostPrice'].toString()),
    inventorySellingPrice: double.parse(json['inventorySellingPrice'].toString()),
    inventoryProfit: double.parse(json['inventoryProfit'].toString()),
    inventoryItems: double.parse(json['inventoryItems'].toString()),
    outstandingSales: double.parse(json['outstandingSales'].toString()),
    outstandingSalesVolume: int.parse(json['outstandingSalesVolume'].toString()),
    outstandingPurchase: double.parse(json['outstandingPurchase'].toString()),
    outstandingPurchaseVolume: int.parse(json['outstandingPurchaseVolume'].toString()),
  );

  Map<String, dynamic> toJson() => {
    'inventoryCostPrice': inventoryCostPrice,
    'inventorySellingPrice': inventorySellingPrice,
    'inventoryProfit': inventoryProfit,
    'inventoryItems': inventoryItems,
    'outstandingSales': outstandingSales,
    'outstandingSalesVolume': outstandingSalesVolume,
    'outstandingPurchase': outstandingPurchase,
    'outstandingPurchaseVolume': outstandingPurchaseVolume,
  };
  
}