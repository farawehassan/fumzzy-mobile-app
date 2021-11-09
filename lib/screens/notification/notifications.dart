import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/bubble-color-indicator.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/screens/dashboard/drawer.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'mobile-notification-content.dart';

class Notifications extends StatefulWidget {

  static const String id = 'notification';

  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBar(constraints, 'NOTIFICATIONS'),
        drawer: RefactoredDrawer(title: 'NOTIFICATIONS'),
        body: OrientationBuilder(builder: (context, orientation) {
          if(constraints.maxWidth < 450){
            //since for tablet view, orientation of both portrait and landscape > 450 screen width
            return _mobileLayout(constraints);
          }
          else{
            return _tabletLayout(constraints);
          }
        },
        ),
      )),
    );
  }
}

Widget _tabletLayout(BoxConstraints constraints){

  TextEditingController search = TextEditingController();

  return Padding(
    padding: EdgeInsets.fromLTRB(20, 30, 20, 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'All Notifications',
                  style: TextStyle(
                    color: Color(0xFF171725),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.0,
                  ),
                ),
                SizedBox(width: 20),
                //search
                Container(
                  width: 170,
                  height: 50,
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
                  margin: EdgeInsets.only(right: 50),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(27.5),
                  ),
                  child: TextField(
                    textAlign: TextAlign.start,
                    textInputAction: TextInputAction.search,
                    controller: search,
                    decoration: InputDecoration(
                      suffixIcon: Icon(
                        IconlyLight.search,
                        color: Colors.black,
                        size: 17,
                      ),
                      hintText: 'Search',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //filter
                InkWell(
                  onTap: () {
                    print('filter');
                  },
                  child: Container(
                    width: 110,
                    height: 50,
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.0),
                      color: Colors.white,
                      border: Border.all(
                        width: 1,
                        color: Color(0xFFE2E2EA),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter',
                          style: TextStyle(
                            color: Color(0xFF171725),
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                        Icon(
                          Icons.tune,
                          color: Colors.black,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                //refresh
                Button(
                  onTap: () {
                    print('Refresh');
                  },
                  buttonColor: Color(0xFF00509A),
                  width: 100,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh,
                          color: Colors.white,
                          size: 15,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Refresh',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 15),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: kTableContainer.copyWith(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListView.builder(
                    itemCount: 6,
                    itemBuilder: (context, position) => Card(
                      margin: EdgeInsets.all(0.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                      ),
                      child: InkWell(
                        splashColor: Color(0xFFF7FCFF),
                        highlightColor: Color(0xFFF7FCFF),
                        onTap: () {
                          print('tapped');
                        },
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 30, 15, 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Wrap(
                                spacing: 8,
                                alignment: WrapAlignment.end,
                                children: [
                                  Text(
                                    'Notifications are for delete, discounts, expenses, Inventory out of stock and so on...',
                                    style: TextStyle(
                                      color: Color(0xFF1F1F1F),
                                    ),
                                  ),
                                  GreenIndicator(),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Just now',
                                style: TextStyle(
                                    color: Color(0xFF767676),
                                    fontSize: 12
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: MessageContent(),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _mobileLayout(BoxConstraints constraints){

  TextEditingController search = TextEditingController();

  return Padding(
    padding: EdgeInsets.fromLTRB(20, 30, 20, 5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'All Notifications',
              style: TextStyle(
                color: Color(0xFF171725),
                fontWeight: FontWeight.w600,
                fontSize: 14.0,
              ),
            ),
            SizedBox(width: 20),
            //search
            Container(
              width: 170,
              height: 50,
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 15.0),
              margin: EdgeInsets.only(right: 50),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(27.5),
              ),
              child: TextField(
                textAlign: TextAlign.start,
                textInputAction: TextInputAction.search,
                controller: search,
                decoration: InputDecoration(
                  suffixIcon: Icon(
                    IconlyLight.search,
                    color: Colors.black,
                    size: 17,
                  ),
                  hintText: 'Search',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    color: Colors.black),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            //filter
            InkWell(
              onTap: () {
                print('filter');
              },
              child: Container(
                width: 110,
                height: 50,
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3.0),
                  color: Colors.white,
                  border: Border.all(
                    width: 1,
                    color: Color(0xFFE2E2EA),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: Color(0xFF171725),
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                    Icon(
                      Icons.tune,
                      color: Colors.black,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            //refresh
            Button(
              onTap: () {
                print('Refresh');
              },
              buttonColor: Color(0xFF00509A),
              width: 100,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 15,
                    ),
                    SizedBox(width: 5),
                    Text(
                      'Refresh',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        Expanded(
          child: Container(
            clipBehavior: Clip.hardEdge,
            decoration: kTableContainer.copyWith(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: ListView.builder(
              itemCount: 6,
              itemBuilder: (context, position) => Card(
                margin: EdgeInsets.all(0.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: InkWell(
                  splashColor: Color(0xFFF7FCFF),
                  highlightColor: Color(0xFFF7FCFF),
                  onTap: () {
                    Navigator.pushNamed(context, MobileNotificationScreen.id);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20, 30, 15, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 8,
                          alignment: WrapAlignment.end,
                          children: [
                            Text(
                              'Notifications are for delete, discounts, expenses, Inventory out of stock and so on...',
                              style: TextStyle(
                                color: Color(0xFF1F1F1F),
                              ),
                            ),
                            GreenIndicator(),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Just now',
                          style: TextStyle(
                              color: Color(0xFF767676),
                              fontSize: 12
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
