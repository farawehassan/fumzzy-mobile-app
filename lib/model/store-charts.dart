class StoreCharts {
  StoreCharts({
    this.yesterday,
    this.today,
    this.week,
    this.thisMonth,
    this.sixMonth,
    this.allTime,
  });

  Yesterday? yesterday;
  Today? today;
  Week? week;
  ThisMonth? thisMonth;
  SixMonth? sixMonth;
  AllTime? allTime;

  factory StoreCharts.fromJson(Map<String, dynamic> json) => StoreCharts(
    yesterday: Yesterday.fromJson(json["yesterday"]),
    today: Today.fromJson(json["today"]),
    week: Week.fromJson(json["week"]),
    thisMonth: ThisMonth.fromJson(json["thisMonth"]),
    sixMonth: SixMonth.fromJson(json["sixMonth"]),
    allTime: AllTime.fromJson(json["allTime"]),
  );

  Map<String, dynamic> toJson() => {
    "yesterday": yesterday!.toJson(),
    "today": today!.toJson(),
    "week": week!.toJson(),
    "thisMonth": thisMonth!.toJson(),
    "sixMonth": sixMonth!.toJson(),
    "allTime": allTime!.toJson(),
  };
}

class AllTime {
  AllTime({
    this.allSales,
    this.allProfit,
    this.allExpenses,
    this.allPurchases,
  });

  List<dynamic>? allSales;
  List<dynamic>? allProfit;
  List<dynamic>? allExpenses;
  List<dynamic>? allPurchases;

  factory AllTime.fromJson(Map<String, dynamic> json) => AllTime(
    allSales: List<dynamic>.from(json["allSales"].map((x) => x)),
    allProfit: List<dynamic>.from(json["allProfit"].map((x) => x)),
    allExpenses: List<dynamic>.from(json["allExpenses"].map((x) => x)),
    allPurchases: List<dynamic>.from(json["allPurchases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "allSales": List<dynamic>.from(allSales!.map((x) => x)),
    "allProfit": List<dynamic>.from(allProfit!.map((x) => x)),
    "allExpenses": List<dynamic>.from(allExpenses!.map((x) => x)),
    "allPurchases": List<dynamic>.from(allPurchases!.map((x) => x)),
  };
}

class SixMonth {
  SixMonth({
    this.sixMonthSales,
    this.sixMonthProfit,
    this.sixMonthExpenses,
    this.sixMonthPurchases,
  });

  List<dynamic>? sixMonthSales;
  List<dynamic>? sixMonthProfit;
  List<dynamic>? sixMonthExpenses;
  List<dynamic>? sixMonthPurchases;

  factory SixMonth.fromJson(Map<String, dynamic> json) => SixMonth(
    sixMonthSales: List<dynamic>.from(json["sixMonthSales"].map((x) => x)),
    sixMonthProfit: List<dynamic>.from(json["sixMonthProfit"].map((x) => x)),
    sixMonthExpenses: List<dynamic>.from(json["sixMonthExpenses"].map((x) => x)),
    sixMonthPurchases: List<dynamic>.from(json["sixMonthPurchases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "sixMonthSales": List<dynamic>.from(sixMonthSales!.map((x) => x)),
    "sixMonthProfit": List<dynamic>.from(sixMonthProfit!.map((x) => x)),
    "sixMonthExpenses": List<dynamic>.from(sixMonthExpenses!.map((x) => x)),
    "sixMonthPurchases": List<dynamic>.from(sixMonthPurchases!.map((x) => x)),
  };
}

class ThisMonth {
  ThisMonth({
    this.monthSales,
    this.monthProfit,
    this.monthExpenses,
    this.monthPurchases,
  });

  List<dynamic>? monthSales;
  List<dynamic>? monthProfit;
  List<dynamic>? monthExpenses;
  List<dynamic>? monthPurchases;

  factory ThisMonth.fromJson(Map<String, dynamic> json) => ThisMonth(
    monthSales: List<dynamic>.from(json["monthSales"].map((x) => x)),
    monthProfit: List<dynamic>.from(json["monthProfit"].map((x) => x)),
    monthExpenses: List<dynamic>.from(json["monthExpenses"].map((x) => x)),
    monthPurchases: List<dynamic>.from(json["monthPurchases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "monthSales": List<dynamic>.from(monthSales!.map((x) => x)),
    "monthProfit": List<dynamic>.from(monthProfit!.map((x) => x)),
    "monthExpenses": List<dynamic>.from(monthExpenses!.map((x) => x)),
    "monthPurchases": List<dynamic>.from(monthPurchases!.map((x) => x)),
  };
}

class Today {
  Today({
    this.todaySales,
    this.todayProfit,
    this.todayExpenses,
    this.todayPurchases,
  });

  List<dynamic>? todaySales;
  List<dynamic>? todayProfit;
  List<dynamic>? todayExpenses;
  List<dynamic>? todayPurchases;

  factory Today.fromJson(Map<String, dynamic> json) => Today(
    todaySales: List<dynamic>.from(json["todaySales"].map((x) => x)),
    todayProfit: List<dynamic>.from(json["todayProfit"].map((x) => x)),
    todayExpenses: List<dynamic>.from(json["todayExpenses"].map((x) => x)),
    todayPurchases: List<dynamic>.from(json["todayPurchases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "todaySales": List<dynamic>.from(todaySales!.map((x) => x)),
    "todayProfit": List<dynamic>.from(todayProfit!.map((x) => x)),
    "todayExpenses": List<dynamic>.from(todayExpenses!.map((x) => x)),
    "todayPurchases": List<dynamic>.from(todayPurchases!.map((x) => x)),
  };
}

class Week {
  Week({
    this.weekSales,
    this.weekProfit,
    this.weekExpenses,
    this.weekPurchases,
  });

  List<dynamic>? weekSales;
  List<dynamic>? weekProfit;
  List<dynamic>? weekExpenses;
  List<dynamic>? weekPurchases;

  factory Week.fromJson(Map<String, dynamic> json) => Week(
    weekSales: List<dynamic>.from(json["weekSales"].map((x) => x)),
    weekProfit: List<dynamic>.from(json["weekProfit"].map((x) => x)),
    weekExpenses: List<dynamic>.from(json["weekExpenses"].map((x) => x)),
    weekPurchases: List<dynamic>.from(json["weekPurchases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "weekSales": List<dynamic>.from(weekSales!.map((x) => x)),
    "weekProfit": List<dynamic>.from(weekProfit!.map((x) => x)),
    "weekExpenses": List<dynamic>.from(weekExpenses!.map((x) => x)),
    "weekPurchases": List<dynamic>.from(weekPurchases!.map((x) => x)),
  };
}

class Yesterday {
  Yesterday({
    this.yesterdaySales,
    this.yesterdayProfit,
    this.yesterdayExpenses,
    this.yesterdayPurchases,
  });

  List<dynamic>? yesterdaySales;
  List<dynamic>? yesterdayProfit;
  List<dynamic>? yesterdayExpenses;
  List<dynamic>? yesterdayPurchases;

  factory Yesterday.fromJson(Map<String, dynamic> json) => Yesterday(
    yesterdaySales: List<dynamic>.from(json["yesterdaySales"].map((x) => x)),
    yesterdayProfit: List<dynamic>.from(json["yesterdayProfit"].map((x) => x)),
    yesterdayExpenses: List<dynamic>.from(json["yesterdayExpenses"].map((x) => x)),
    yesterdayPurchases: List<dynamic>.from(json["yesterdayPurchases"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "yesterdaySales": List<dynamic>.from(yesterdaySales!.map((x) => x)),
    "yesterdayProfit": List<dynamic>.from(yesterdayProfit!.map((x) => x)),
    "yesterdayExpenses": List<dynamic>.from(yesterdayExpenses!.map((x) => x)),
    "yesterdayPurchases": List<dynamic>.from(yesterdayPurchases!.map((x) => x)),
  };
}
