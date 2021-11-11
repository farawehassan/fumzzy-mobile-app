import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_basic/flutter_bluetooth_basic.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart' hide Image;
import 'package:fumzy/utils/constant-styles.dart';
import 'package:fumzy/utils/functions.dart';
import 'package:image/image.dart';
import 'package:permission_handler/permission_handler.dart';

class PrintReceipt extends StatefulWidget {

  final Map<String, dynamic>? reports;
  final String? paymentMode;

  const PrintReceipt({
    Key? key,
    @required this.reports,
    @required this.paymentMode
  }) : super(key: key);

  @override
  _PrintReceiptState createState() => _PrintReceiptState();
}

class _PrintReceiptState extends State<PrintReceipt> {

  PrinterBluetoothManager _printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> _devices = [];
  String? _devicesMsg;
  BluetoothManager bluetoothManager = BluetoothManager.instance;
  bool _scanned = false;

  void initPrinter() {
    print('init printer');
    _printerManager.startScan(Duration(seconds: 2));
    print('yup ypu');
    _printerManager.scanResults.listen((event) {
      if (!mounted) return;
      setState(() {
        _devices = event;
        _scanned = true;
      });
      if (_devices.isEmpty)
        setState(() => _devicesMsg = 'No devices');
    });
  }

  void _permission() async {
    Map<Permission, PermissionStatus> statuses = await [
    Permission.location,
        Permission.locationWhenInUse,
    ].request();
  }

  void _startScan() {
    if (Platform.isIOS) initPrinter();
    else {
      _permission();
      bluetoothManager.state.listen((val) {
        print("state = $val");
        if (!mounted) return;
        if (val == 12) {
          print('on');
          initPrinter();
        }
        else if (val == 10) {
          print('off');
          setState(() => _devicesMsg = 'Please enable bluetooth to print');
        }
        print('state is $val');
      });
    }
  }

  @override
  void initState() {
    _startScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: mainColor),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back,
            size: 22,
            color: Colors.black,
          ),
        ),
        title: Text(
          'PRINT RECEIPT',
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          /*IconButton(
            onPressed: (){
              _startScan();
            },
            icon: Icon(Icons.refresh, color: mainColor),
          )*/
        ],
      ),
      body: ListView.builder(
        itemCount: _devices.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: (){
              if(_scanned) _startPrint(_devices[index]);
            },
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 10),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.print),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: 10),
                            Text(_devices[index].name ?? ''),
                            Text(_devices[index].address!),
                            Text(
                              'Click to print receipt',
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
              ],
            ),
          );
        }),
    );
  }

  void _startPrint(PrinterBluetooth printer) async {
    try {
      _printerManager.selectPrinter(printer);

      /// Printer's paper
      const PaperSize paper = PaperSize.mm58;
      final profile = await CapabilityProfile.load();

      /// Sales RECEIPT
      await _printerManager.printTicket((await _formatReceipt(paper, profile))).then((PosPrintResult res) {
        Functions.showSuccessMessage(res.msg);
      });
    } catch(e){
      print(e);
      Functions.showErrorMessage(e.toString());
    }
  }

  Future<List<int>> _formatReceipt(PaperSize paper, CapabilityProfile profile) async {
    final Generator ticket = Generator(paper, profile);
    ticket.spaceBetweenRows = 1;
    List<int> bytes = [];

    // Print image
    final ByteData data = await rootBundle.load('assets/images/blue-logo.png');
    final Uint8List buf = data.buffer.asUint8List();
    final Image image = decodeImage(buf)!;
    bytes += ticket.image(image);

    bytes += ticket.text('FUMZZY GLOBAL VENTURES',
        styles: PosStyles(
          align: PosAlign.center,
          height: PosTextSize.size4,
          width: PosTextSize.size3,
          bold: true
        ),
        linesAfter: 1);

    bytes += ticket.text('Container 122 Oriyanrin, Ebute ero',
        styles: PosStyles(align: PosAlign.center));
    bytes += ticket.text('Lagos, Nigeria',
        styles: PosStyles(align: PosAlign.center));
    bytes += ticket.text('Tel: 08130855871, 08033664053',
        styles: PosStyles(align: PosAlign.center));

    bytes += ticket.hr();
    bytes += ticket.row([
      PosColumn(text: 'Qty', width: 1),
      PosColumn(text: 'Item', width: 5),
      PosColumn(text: 'Price', width: 3),
      PosColumn(text: 'Total', width: 3),
    ]);

    for(int i = 0; i < widget.reports!['report'].length; i++){
      double unitPrice = double.parse(widget.reports!['report'][i]['unitPrice'].toString());
      double totalPrice = double.parse(widget.reports!['report'][i]['totalPrice'].toString());
      bytes += ticket.row([
        PosColumn(
          text: widget.reports!['report'][i]['quantity'].toString(), width: 1
        ),
        PosColumn(text: widget.reports!['report'][i]['productName'], width: 5),
        PosColumn(text: Functions.money0(unitPrice, ''), width: 3),
        PosColumn(text: Functions.money0(totalPrice, ''), width: 3),
      ]);
    }
    bytes += ticket.hr();
    double totalPrice = double.parse(widget.reports!['totalAmount']!.toString());
    double paymentMade = double.parse(widget.reports!['paymentMade']!.toString());
    bytes += ticket.row([
      PosColumn(
          text: 'TOTAL: ',
          width: 4,
          styles: PosStyles(
            align: PosAlign.left,
            height: PosTextSize.size3,
            bold: true
          )),
      PosColumn(
          text: Functions.money0(totalPrice, 'NGN'),
          width: 8,
          styles: PosStyles(
            align: PosAlign.right,
            height: PosTextSize.size3,
            bold: true
          )),
    ]);

    bytes += ticket.hr(ch: '=', linesAfter: 1);

    bytes += ticket.row([
      PosColumn(
          text: widget.paymentMode! + ' ',
          width: 5,
          styles: PosStyles(align: PosAlign.left, bold: true)
      ),
      PosColumn(
          text: Functions.money0(paymentMade, 'NGN'),
          width: 7,
          styles: PosStyles(align: PosAlign.left, bold: true)
      ),
    ]);
    if((totalPrice - paymentMade) > 0){
      bytes += ticket.row([
        PosColumn(
            text: 'Balance',
            width: 5,
            styles: PosStyles(align: PosAlign.left, bold: true)
        ),
        PosColumn(
            text: Functions.money0((totalPrice - paymentMade), 'NGN'),
            width: 7,
            styles: PosStyles(align: PosAlign.left, bold: true)
        ),
      ]);
    }

    bytes += ticket.feed(2);
    bytes += ticket.text(
        'Thank you!',
        styles: PosStyles(align: PosAlign.center, bold: true)
    );
    final String timestamp = Functions.getFormattedDateTimeY(DateTime.parse(widget.reports!['soldAt']));
    bytes += ticket.text(
        timestamp,
        styles: PosStyles(align: PosAlign.center),
        linesAfter: 4
    );
    ticket.feed(2);
    ticket.cut();
    return bytes;
  }

  Future<List<int>> _testTicket(PaperSize paper, CapabilityProfile profile) async {
    final Generator generator = Generator(paper, profile);
    List<int> bytes = [];

    bytes += generator.text(
        'Regular: aA bB cC dD eE fF gG hH iI jJ kK lL mM nN oO pP qQ rR sS tT uU vV wW xX yY zZ');
    // bytes += generator.text('Special 1: àÀ èÈ éÉ ûÛ üÜ çÇ ôÔ',
    //     styles: PosStyles(codeTable: PosCodeTable.westEur));
    // bytes += generator.text('Special 2: blåbærgrød',
    //     styles: PosStyles(codeTable: PosCodeTable.westEur));

    bytes += generator.text('Bold text', styles: PosStyles(bold: true));
    bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    bytes += generator.text('Underlined text',
        styles: PosStyles(underline: true), linesAfter: 1);
    bytes +=
        generator.text('Align left', styles: PosStyles(align: PosAlign.left));
    bytes += generator.text('Align center',
        styles: PosStyles(align: PosAlign.center));
    bytes += generator.text('Align right',
        styles: PosStyles(align: PosAlign.right), linesAfter: 1);

    bytes += generator.row([
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col6',
        width: 6,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
      PosColumn(
        text: 'col3',
        width: 3,
        styles: PosStyles(align: PosAlign.center, underline: true),
      ),
    ]);

    bytes += generator.text('Text size 200%',
        styles: PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));

    // Print image
    final ByteData data = await rootBundle.load('assets/images/blue-logo.png');
    final Uint8List buf = data.buffer.asUint8List();
    final Image image = decodeImage(buf)!;
    bytes += generator.image(image);
    // Print image using alternative commands
    // bytes += generator.imageRaster(image);
    // bytes += generator.imageRaster(image, imageFn: PosImageFn.graphics);

    // Print barcode
    final List<int> barData = [1, 2, 3, 4, 5, 6, 7, 8, 9, 0, 4];
    bytes += generator.barcode(Barcode.upcA(barData));

    // Print mixed (chinese + latin) text. Only for printers supporting Kanji mode
    // bytes += generator.text(
    //   'hello ! 中文字 # world @ éphémère &',
    //   styles: PosStyles(codeTable: PosCodeTable.westEur),
    //   containsChinese: true,
    // );

    bytes += generator.feed(2);

    bytes += generator.cut();
    return bytes;
  }

}

