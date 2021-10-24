import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fumzy/screens/notification/mobile-notification-content.dart';
import 'screens/inventory/inventory.dart';
import 'screens/invoices/invoices.dart';
import 'screens/splash-screen.dart';
import 'screens/creditors/creditors.dart';
import 'screens/dashboard/dashboard.dart';
import 'screens/login.dart';
import 'screens/settings/settings.dart';
import 'screens/staff/staff.dart';
import 'screens/customers/customers.dart';
import 'screens/transactions/transactions.dart';
import 'screens/customers/customer-detail/customer-detail.dart';
import 'screens/inventory/inventory-detail/inventory-detail.dart';
import 'screens/transactions/sales-info.dart';
import 'screens/transactions/expense-info.dart';
import 'screens/transactions/purchase-info.dart';
import 'screens/transactions/add-sale.dart';
import 'screens/notification/notifications.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fumzzy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF00509A),
        backgroundColor: Colors.black,
        tabBarTheme: TabBarTheme(
          labelPadding: EdgeInsets.only(left: 0.0, right: 0.0),
          labelColor: Color(0xFF004E92),
          indicatorSize: TabBarIndicatorSize.label,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFFFFFFF),
          centerTitle: false
        ),
        fontFamily: "Overpass",
        cupertinoOverrideTheme: CupertinoThemeData(
          brightness: Brightness.dark,
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Color(0xFF00509A),
        ),
        popupMenuTheme: PopupMenuThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3.0),
          ),
          color: Colors.white,
          textStyle: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        Login.id: (context) => Login(),
        Dashboard.id: (context) => Dashboard(),
        Staff.id: (context) => Staff(),
        Settings.id: (context) => Settings(),
        Creditors.id: (context) => Creditors(),
        Transactions.id: (context) => Transactions(),
        Inventory.id: (context) => Inventory(),
        Invoices.id: (context) => Invoices(),
        Customers.id: (context) => Customers(),
        CustomersDetail.id: (context) => CustomersDetail(),
        InventoryDetail.id: (context) => InventoryDetail(),
        SalesInfo.id: (context) => SalesInfo(),
        ExpenseInfo.id: (context) => ExpenseInfo(),
        PurchaseInfo.id: (context) => PurchaseInfo(),
        AddSale.id: (context) => AddSale(),
        Notifications.id: (context) => Notifications(),
        MobileNotificationScreen.id: (context) => MobileNotificationScreen(),
      },
    );
  }

}
