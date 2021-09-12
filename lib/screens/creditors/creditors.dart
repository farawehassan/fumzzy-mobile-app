import 'package:flutter/material.dart';
import 'package:fumzy/dashboard/drawer.dart';
import 'package:flutter_iconly/flutter_iconly.dart';

class Creditors extends StatefulWidget {
  const Creditors({Key? key}) : super(key: key);

  @override
  _CreditorsState createState() => _CreditorsState();
}

class _CreditorsState extends State<Creditors> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
          ),
          drawer: RefactoredDrawer(),
          body: LayoutBuilder(builder: (context, constraints) => ListView(
            children: [
              Container(
                child: Container(
                  padding: EdgeInsets.only(top: constraints.maxHeight*0.07, left: constraints.maxWidth*0.026, right: constraints.maxWidth*0.026,),
                  color: Color(0xFFF7F8F9),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: constraints.maxHeight*0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'All Creditors',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print("save changes");
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: constraints.maxHeight*0.044),
                                height: constraints.maxHeight*0.163,
                                width: constraints.maxWidth*0.156,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  color: Color(0xFF00509A),
                                ),
                                child: Center(
                                  child: Text(
                                    'Add New Creditor',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: constraints.maxHeight*0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: constraints.maxHeight*0.155,
                              width: constraints.maxWidth*0.34,
                              padding: EdgeInsets.symmetric(horizontal: 15.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(27.5),
                              ),
                              child: TextField(
                                textAlign: TextAlign.start,
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
                                  fontSize: 17.0,
                                  color: Colors.black
                                ),
                              ),
                            ),//search
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    print("export table");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: constraints.maxHeight*0.044),
                                    padding: EdgeInsets.all(15),
                                    color: Colors.transparent,
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.file_download_outlined,
                                          color: Color(0xFF75759E),
                                          size: 17,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 5.0),
                                          child: Text(
                                            'Export table',
                                            style: TextStyle(
                                              color: Color(0xFF75759E),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print("filter");
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(left: constraints.maxHeight*0.044),
                                    padding: EdgeInsets.all(15),
                                    height: constraints.maxHeight*0.163,
                                    width: constraints.maxWidth*0.131,
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
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 13,
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
                                ),//filter
                              ],
                            ),
                          ],
                        ),
                      ),//search, export and filter
                      Container(
                        margin: EdgeInsets.only(top: constraints.maxHeight*0.028),
                        width: constraints.maxWidth*0.69,
                        height: constraints.maxHeight*1.8,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFFE2E2EA),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                          ],
                        ),
                      ),//settings details
                    ],
                  ),
                ),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }
}
