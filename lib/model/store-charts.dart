class StoreCharts {
  StoreCharts({
    this.yesterday,
    this.today,
    this.week,
    this.thisMonth,
    this.sixMonth,
    this.allTime,
  });

  Map<String, dynamic>? yesterday;
  Map<String, dynamic>? today;
  Map<String, dynamic>? week;
  Map<String, dynamic>? thisMonth;
  Map<String, dynamic>? sixMonth;
  Map<String, dynamic>? allTime;

  factory StoreCharts.fromJson(Map<String, dynamic> json) => StoreCharts(
    yesterday: json['yesterday'],
    today: json['today'],
    week: json['week'],
    thisMonth: json['thisMonth'],
    sixMonth: json['sixMonth'],
    allTime: json['allTime'],
  );

  Map<String, dynamic> toJson() => {
    'yesterday': yesterday,
    'today': today,
    'week': week,
    'thisMonth': thisMonth,
    'sixMonth': sixMonth,
    'allTime': allTime
  };
}
