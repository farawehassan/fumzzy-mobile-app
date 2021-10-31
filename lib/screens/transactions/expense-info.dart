import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fumzy/components/app-bar.dart';
import 'package:fumzy/components/button.dart';
import 'package:fumzy/components/circle-indicator.dart';
import 'package:fumzy/components/info-table.dart';
import 'package:fumzy/model/expense.dart';
import 'package:fumzy/networking/expense-datasource.dart';
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ExpenseInfo extends StatefulWidget {

  static const String id = 'expenseInfo';

  final Expense? expense;

  const ExpenseInfo({
    Key? key,
    @required this.expense
  }) : super(key: key);

  @override
  _ExpenseInfoState createState() => _ExpenseInfoState();
}

class _ExpenseInfoState extends State<ExpenseInfo> {

  bool _showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => (Scaffold(
        appBar: buildAppBarWithBackButton(context, 'TRANSACTIONS'),
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(
                            IconlyBold.arrowLeftCircle,
                            size: 19,
                            color: Color(0xFF004E92).withOpacity(0.5),
                          ),
                        ),
                        Text(
                          ' Transactions’s Details',
                          style: TextStyle(
                            color: Color(0xFF75759E),
                            fontWeight: FontWeight.w600,
                            fontSize: 15.7,
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        _deletePermanently();
                      },
                      child: Row(
                        children: [
                          Text(
                            'Delete ',
                            style: TextStyle(
                              color: Color(0xFFF64932),
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.delete,
                            color: Color(0xFFF64932),
                            size: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Container(
                  width: constraints.maxWidth,
                  decoration: kTableContainer,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Expense Info',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF004E92),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 15.0),
                        child: Divider(
                          height: 1,
                          thickness: 1,
                          color: Colors.black.withOpacity(0.2),
                        ),
                      ),
                      Wrap(
                        runSpacing: 14,
                        spacing: 60,
                        children: [
                          ReusableCustomerInfoFields(
                            tableTitle: 'Amount',
                            widget: Text(
                              Functions.money(widget.expense!.amount!, 'N'),
                            ),
                          ),
                          ReusableCustomerInfoFields(
                            tableTitle: 'Description',
                            widget: Text(widget.expense!.description!),
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Wrap(
                        runSpacing: 15,
                        spacing: 60,
                        children: [
                          ReusableCustomerInfoFields(
                            tableTitle: 'Date',
                            widget: Text(
                              Functions.getFormattedShortDate(widget.expense!.createdAt!),
                            ),
                          ),
                          ReusableCustomerInfoFields(
                            tableTitle: 'Staff',
                            widget: Text(widget.expense!.staff!.name!),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      )),
    );
  }

  Future<void> _deletePermanently() {
    final formKey = GlobalKey<FormState>();
    String newPin = '';
    return showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Color(0xFF000428).withOpacity(0.86),
      builder: (context) => GestureDetector(
        onTap: (){
          FocusScopeNode currentFocus = FocusScope.of(context);
          if(!currentFocus.hasPrimaryFocus) currentFocus.unfocus();
        },
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) => AbsorbPointer(
            absorbing: _showSpinner,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFFFFFFF),
              ),
              margin: EdgeInsets.all(50),
              child: Material(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.fromLTRB(24, 30, 24, 27),
                      decoration: BoxDecoration(
                        color: Color(0xFFF5F8FF),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15.0),
                          topRight: Radius.circular(15.0),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'DELETE',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              IconlyBold.closeSquare,
                              color: Colors.black.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(children: [
                          Padding(
                            padding: EdgeInsets.only(top: 42),
                            child: Text(
                              'Are You Sure You want to Delete this Expense?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF00509A),
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 35, vertical: 15.0),
                            child: Text(
                              'This means that this expense will no longer be available. This action cannot be undone.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFF000428).withOpacity(0.6),
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enter your PIN',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                  SizedBox(height: 13),
                                  Container(
                                    width: 280,
                                    child: PinCodeTextField(
                                        appContext: context,
                                        length: 4,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                                        ],
                                        keyboardType: TextInputType.number,
                                        animationType: AnimationType.fade,
                                        enablePinAutofill: false,
                                        textStyle: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFF004E92),
                                          fontWeight: FontWeight.w500,
                                        ),
                                        pinTheme: PinTheme(
                                            shape: PinCodeFieldShape.box,
                                            borderWidth: 1,
                                            fieldHeight: 60,
                                            fieldWidth: 60,
                                            activeColor: Color(0xFF7BBBE5),
                                            selectedColor: Color(0xFF7BBBE5),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(3))),
                                        validator: (value) {
                                          if (value!.isEmpty) return 'Enter your pin';
                                          if (newPin.length != 4) return 'Enter a valid 4 digit pin';
                                          return null;
                                        },
                                        onChanged: (value) {
                                          if (!mounted) return;
                                          setState(() => newPin = value);
                                        }),
                                  ),
                                  SizedBox(height: 36),
                                ],
                              ),
                            ),
                          ),
                          Button(
                            onTap: () {
                              if(!_showSpinner){
                                if(formKey.currentState!.validate()){
                                  _deleteExpense(setDialogState);
                                }
                              }
                            },
                            buttonColor: Color(0xFFF64932),
                            child: Center(
                              child: _showSpinner
                                  ? CircleProgressIndicator()
                                  : Text(
                                'Yes, delete',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                                'No, Cancel',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 50),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///function to make api call to [deleteExpense]
  void _deleteExpense(StateSetter setDialogState) async{
    if(!mounted)return;
    setDialogState(() => _showSpinner = true);
    var api = ExpenseDataSource();
    await api.deleteExpense(widget.expense!.id!).then((message) async{
      if(!mounted)return;
      setDialogState((){
        _showSpinner = false;
        Navigator.pop(context);
      });
      Functions.showSuccessMessage(message);
      Navigator.pop(context);
    }).catchError((e){
      if(!mounted)return;
      setDialogState(()=> _showSpinner = false);
      Functions.showErrorMessage(e);
    });
  }

}
