import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart' as intl;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share/share.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
import 'package:station_statistics/Screens/PdfPreview.dart';

import '../Database/Entities/Invoices.dart';
import '../Services/LocalDB.dart';
import '../constaint.dart';

class Report extends StatefulWidget {
  @override
  _ReportState createState() => _ReportState();
}

class _ReportState extends State<Report> {
  double allTotal = 0;
  final intl.DateFormat formatter = intl.DateFormat('yyyy-MM-dd hh:mm:ss');
  var isRotate = false;
  // var isExcel = true;
  // var isPdf = false;
  int? radio = 1;
  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  int from = DateTime(2000).microsecondsSinceEpoch;
  int to = DateTime.now().microsecondsSinceEpoch;
  @override
  Widget build(BuildContext context) {
    print(
        "MediaQuery.of(context).orientation ${MediaQuery.of(context).orientation}");
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return await Future.delayed(Duration(milliseconds: 200))
            .then((value) => true);
      },
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Report'),
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Icons.rotate_right_rounded),
                  onPressed: () {
                    setState(() {
                      if (!isRotate) {
                        isRotate = !isRotate;
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft,
                        ]);
                      } else {
                        isRotate = !isRotate;
                        SystemChrome.setPreferredOrientations([
                          DeviceOrientation.landscapeRight,
                          DeviceOrientation.landscapeLeft,
                          DeviceOrientation.portraitUp,
                          DeviceOrientation.portraitDown,
                        ]);
                      }
                    });
                  }),
              IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    var now = DateTime.now();
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => CustomDialog(
                        message: "Choose Date from and To:",
                        confirmButtonTitle: "Apply",
                        confirmButton: () {
                          if (from > to) {
                            var swap = to;
                            to = from;
                            from = swap;
                          }
                          setState(() {});
                          Get.back();
                        },
                        cancelButton: false,
                        icon: Icons.filter_list,
                        color: Colors.blue,
                        widgets: [
                          TextButton.icon(
                              onPressed: () async {
                                DateTime? date =
                                    DateTime(2021, 1, 1, 00, 00, 00);
                                date = await (showDatePicker(
                                    context: context,
                                    initialDate:
                                        DateTime(now.year, now.month, 1),
                                    firstDate: DateTime(2021, 1, 1),
                                    lastDate: DateTime.now()));
                                from = DateTime(date!.year, date.month,
                                        date.day, 00, 00, 00)
                                    .microsecondsSinceEpoch;
                              },
                              icon: Icon(Icons.calendar_today_outlined),
                              label: Text("Date from")),
                          TextButton.icon(
                              onPressed: () async {
                                DateTime? date = DateTime(
                                    now.year, now.month, now.day, 23, 59, 59);
                                date = await (showDatePicker(
                                    context: context,
                                    initialDate: now,
                                    firstDate: DateTime(2021),
                                    lastDate: DateTime.now()));
                                to = DateTime(date!.year, date.month, date.day,
                                        23, 59, 59)
                                    .microsecondsSinceEpoch;
                              },
                              icon: Icon(Icons.calendar_today_outlined),
                              label: Text("Date to")),
                        ],
                      ),
                    );
                  }),
            ],
          ),
          body: FutureBuilder(
            future: LocalDB()
                .appDatabaseCache
                .invoiceDAO
                .getAllInvoicesBetweenDates(from, to),
            builder: (context, AsyncSnapshot<List<Invoice>> snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? Axis.vertical
                            : Axis.horizontal,
                        child: Container(
                          width: MediaQuery.of(context).orientation ==
                                  Orientation.landscape
                              ? Get.width
                              : Get.width * 1.5,
                          child: Table(
                            // defaultColumnWidth: FlexColumnWidth(150.0),
                            // // defaultColumnWidth: MaxColumnWidth(
                            // //     FlexColumnWidth(), FlexColumnWidth()),
                            // // defaultColumnWidth: FixedColumnWidth(70),
                            columnWidths: {
                              0: FlexColumnWidth(1),
                              1: FlexColumnWidth(3),
                              2: FlexColumnWidth(2),
                              3: FlexColumnWidth(1),
                              4: FlexColumnWidth(2),
                              5: FlexColumnWidth(2)
                            },
                            border: TableBorder.all(width: 1.0),
                            children: [
                              TableRow(children: [
                                HeaderTable(
                                  text: 'No.',
                                ),
                                HeaderTable(
                                  text: 'Date',
                                ),
                                HeaderTable(
                                  text: 'Quantity',
                                ),
                                HeaderTable(
                                  text: 'Type',
                                ),
                                HeaderTable(
                                  text: 'Price For Liter',
                                ),
                                HeaderTable(
                                  text: 'Total Price',
                                ),
                              ]),
                              for (int i = 0; i < snapshot.data!.length; i++)
                                TableRow(children: [
                                  CellTable(
                                    text: '${i + 1}',
                                  ),
                                  CellTable(
                                    text:
                                        '${formatter.format(DateTime.fromMicrosecondsSinceEpoch(snapshot.data![i].timeStamp!))}',
                                  ),
                                  CellTable(
                                    text: '${snapshot.data![i].quantity}',
                                  ),
                                  CellTable(
                                    text: '${snapshot.data![i].type}',
                                  ),
                                  CellTable(
                                    text: '${snapshot.data![i].price}',
                                  ),
                                  CellTable(
                                    text: '${snapshot.data![i].totalPrice}',
                                  ),
                                ]),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Radio(
                                      value: 1,
                                      groupValue: radio,
                                      onChanged: (dynamic v) {
                                        setState(() {
                                          print(
                                              "============= Value = ${v} ===========");
                                          radio = v;
                                        });
                                      }),
                                  Image.asset(
                                    "assets/excel.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                  Radio(
                                      value: 2,
                                      groupValue: radio,
                                      onChanged: (dynamic v) {
                                        setState(() {
                                          radio = v;
                                        });
                                        print(
                                            "============= Value = ${v} ===========");
                                      }),
                                  Image.asset(
                                    "assets/pdf.png",
                                    width: 50,
                                    height: 50,
                                  ),
                                ],
                              ),
                              TextButton.icon(
                                  icon: Icon(Icons.visibility),
                                  label: Text('PDF Preview'),
                                  onPressed: () {
                                    Get.to(() => PDFPreview(
                                          data: snapshot.data,
                                        ));
                                  }),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            SystemChrome.setPreferredOrientations([
                              DeviceOrientation.landscapeRight,
                              DeviceOrientation.landscapeLeft,
                              DeviceOrientation.portraitUp,
                              DeviceOrientation.portraitDown,
                            ]);
                            var excel = Excel.createExcel();
                            print(excel.tables.length);
                            CellStyle cellStyle = CellStyle(
                              backgroundColorHex: "#2BBF8A",
                              bold: true,
                              verticalAlign: VerticalAlign.Center,
                              horizontalAlign: HorizontalAlign.Center,
                              fontFamily: getFontFamily(FontFamily.Calibri),
                            );

                            CellStyle cellStyleBody = CellStyle(
                              backgroundColorHex: "#FFFFFF",
                              bold: true,
                              verticalAlign: VerticalAlign.Center,
                              horizontalAlign: HorizontalAlign.Center,
                              fontFamily: getFontFamily(FontFamily.Calibri),
                            );

                            CellStyle cellStyleTotal = CellStyle(
                              backgroundColorHex: "#FFFC7F12",
                              bold: true,
                              verticalAlign: VerticalAlign.Center,
                              horizontalAlign: HorizontalAlign.Center,
                              fontFamily: getFontFamily(FontFamily.Calibri),
                            );

                            excel.tables['Sheet1']!.appendRow([
                              "#",
                              "Date",
                              "Quantity",
                              "Type",
                              "Price For Liter",
                              "Total Price"
                            ]);

                            excel.tables['Sheet1']!.updateCell(
                                CellIndex.indexByColumnRow(
                                    rowIndex: 0, columnIndex: 0),
                                '#',
                                cellStyle: cellStyle);

                            excel.tables['Sheet1']!.updateCell(
                                CellIndex.indexByColumnRow(
                                    rowIndex: 0, columnIndex: 1),
                                'Date',
                                cellStyle: cellStyle);

                            excel.tables['Sheet1']!.updateCell(
                                CellIndex.indexByColumnRow(
                                    rowIndex: 0, columnIndex: 2),
                                'Quantity',
                                cellStyle: cellStyle);

                            excel.tables['Sheet1']!.updateCell(
                                CellIndex.indexByColumnRow(
                                    rowIndex: 0, columnIndex: 3),
                                'Type',
                                cellStyle: cellStyle);

                            excel.tables['Sheet1']!.updateCell(
                                CellIndex.indexByColumnRow(
                                    rowIndex: 0, columnIndex: 4),
                                'Price For Liter',
                                cellStyle: cellStyle);

                            excel.tables['Sheet1']!.updateCell(
                                CellIndex.indexByColumnRow(
                                    rowIndex: 0, columnIndex: 5),
                                'Total Price',
                                cellStyle: cellStyle);

                            int index = 1;

                            for (var data in snapshot.data!) {
                              allTotal += data.totalPrice!;
                              excel.tables['Sheet1']!.appendRow([
                                index,
                                formatter
                                    .format(DateTime.fromMicrosecondsSinceEpoch(
                                        data.timeStamp!))
                                    .toString(),
                                data.quantity,
                                data.type,
                                data.price,
                                data.totalPrice,
                              ]);
                              excel.tables['Sheet1']!.updateCell(
                                  CellIndex.indexByColumnRow(
                                      rowIndex: index, columnIndex: 0),
                                  index,
                                  cellStyle: cellStyleBody);
                              excel.tables['Sheet1']!.updateCell(
                                  CellIndex.indexByColumnRow(
                                      rowIndex: index, columnIndex: 1),
                                  formatter.format(
                                      DateTime.fromMicrosecondsSinceEpoch(
                                          data.timeStamp!)),
                                  cellStyle: cellStyleBody);

                              excel.tables['Sheet1']!.updateCell(
                                  CellIndex.indexByColumnRow(
                                      rowIndex: index, columnIndex: 2),
                                  data.quantity,
                                  cellStyle: cellStyleBody);

                              excel.tables['Sheet1']!.updateCell(
                                  CellIndex.indexByColumnRow(
                                      rowIndex: index, columnIndex: 3),
                                  data.type,
                                  cellStyle: cellStyleBody);

                              excel.tables['Sheet1']!.updateCell(
                                  CellIndex.indexByColumnRow(
                                      rowIndex: index, columnIndex: 4),
                                  data.price,
                                  cellStyle: cellStyleBody);

                              excel.tables['Sheet1']!.updateCell(
                                  CellIndex.indexByColumnRow(
                                      rowIndex: index, columnIndex: 5),
                                  data.totalPrice,
                                  cellStyle: cellStyleBody);
                              index++;
                            }
                            excel.tables['Sheet1']!.appendRow(['']);
                            excel.tables['Sheet1']!.appendRow(['']);
                            //====================== All Total ====================================
                            // excel.tables['Sheet1'].appendRow([
                            //   'Total ',
                            //   allTotal,
                            // ]);

                            excel.tables['Sheet1']!.updateCell(
                                CellIndex.indexByColumnRow(
                                    rowIndex: index, columnIndex: 4),
                                'Full Total',
                                cellStyle: cellStyleTotal);

                            excel.tables['Sheet1']!.updateCell(
                                CellIndex.indexByColumnRow(
                                    rowIndex: index, columnIndex: 5),
                                allTotal,
                                cellStyle: cellStyleTotal);
                            //====================== All Total ====================================
                            // Save the Changes in file
                            File f;
                            if (radio == 1) {
                              Directory appDocDir =
                                  await getApplicationDocumentsDirectory();
                              String appDocPath = appDocDir.path;
                              var bytes = excel.encode()!;
                              f = File(join("$appDocPath/Report.xlsx"))
                                ..createSync(recursive: true)
                                ..writeAsBytesSync(bytes);
                            } else {
                              f = await _saveAsFile(
                                  PdfPageFormat.a4, snapshot.data);
                            }
                            Share.shareFiles([f.path],
                                text: 'Share Excel Report');
                            for (var table in excel.tables.keys) {
                              print(table); //sheet Name
                              print(excel.tables[table]!.maxCols);
                              print(excel.tables[table]!.maxRows);
                              for (var row in excel.tables[table]!.rows) {
                                print("row $row");
                              }
                            }
                            // excel.sheets.addEntries({MapEntry("1",Sheet( ))});
                            excel.tables.forEach((key, value) {
                              print(value);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text("Export and Share"),
                          ),
                          style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0.0),
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue.shade300),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomRight: Radius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else
                return LoadingScreen();
            },
          ),
        ),
      ),
    );
  }

  Future<Uint8List> buildPdf(
      PdfPageFormat pageFormat, List<Invoice>? data) async {
    // Create a PDF document.
    final doc = pw.Document();

    // _logo = await rootBundle.loadString('assets/logo.svg');
    // _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
        ),
        // header: _buildHeader,
        // footer: _buildFooter,
        build: (context) => [
          // _contentHeader(context),
          _contentTable(context, data!),
          pw.SizedBox(height: 20),
          _contentFooter(context, allTotal),
          pw.SizedBox(height: 20),
          // _termsAndConditions(context),
        ],
      ),
    );

    // Return the PDF file content
    return doc.save();
  }

  Future<File> _saveAsFile(
      PdfPageFormat pageFormat, List<Invoice>? data) async {
    final bytes = await buildPdf(pageFormat, data);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File(appDocPath + '/' + 'Report.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    return file;
    // await OpenFile.open(file.path);
  }

  pw.PageTheme _buildTheme(
    PdfPageFormat pageFormat,
  ) {
    return pw.PageTheme(
      pageFormat: pageFormat,
      theme: pw.ThemeData.base(),
      // buildBackground: (context) => pw.FullPage(
      //   ignoreMargins: true,
      //   // child: pw.SvgImage(svg: _bgShape),
      // ),
    );
  }

  var baseColor = PdfColors.teal;
  var accentColor = PdfColors.blueGrey900;

  pw.Widget _contentFooter(pw.Context context, double _total) {
    const _darkColor = PdfColors.blueGrey800;
    const _lightColor = PdfColors.white;
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: const pw.TextStyle(
              fontSize: 10,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Full Total:'),
                    pw.Text(_total.toStringAsFixed(2)),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Tax:'),
                    pw.Text('${(_total * 0.15).toStringAsFixed(2)}'),
                  ],
                ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: baseColor,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text('Net Total: '),
                      pw.Text("${(_total + _total * 0.15).toStringAsFixed(2)}"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  pw.Widget _contentTable(pw.Context context, List<Invoice> data) {
    const tableHeaders = [
      "#",
      "Date",
      "Quantity",
      "Type",
      "Price For Liter",
      "Total Price"
    ];
    var baseColor = PdfColors.teal;
    var accentColor = PdfColors.blueGrey900;
    return pw.Table.fromTextArray(
      border: null,
      cellAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
        color: baseColor,
      ),
      headerHeight: 25,
      cellHeight: 40,
      cellAlignments: {
        0: pw.Alignment.center,
        1: pw.Alignment.center,
        2: pw.Alignment.center,
        3: pw.Alignment.center,
        4: pw.Alignment.center,
        5: pw.Alignment.center,
      },
      headerStyle: pw.TextStyle(
        color: PdfColors.white,
        fontSize: 10,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        color: PdfColors.black,
        fontSize: 10,
      ),
      rowDecoration: pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: accentColor,
            width: 0.5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String?>>.generate(
        data.length,
        (row) => List<String?>.generate(
          tableHeaders.length,
          (col) => data[row].getIndex(col, row),
        ),
      ),
    );
  }
}

class HeaderTable extends StatelessWidget {
  var HeaderStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.white);
  var txtStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
  final String? text;

  HeaderTable({Key? key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        height: 30,
        color: Colors.teal,
        child: Center(
          child: Text(
            text!,
            style: HeaderStyle,
          ),
        ),
      ),
    );
  }
}

class CellTable extends StatelessWidget {
  var HeaderStyle = TextStyle(
      fontWeight: FontWeight.normal, fontSize: 15, color: Colors.black);
  var txtStyle = TextStyle(fontWeight: FontWeight.bold, color: Colors.black);
  final String? text;

  CellTable({Key? key, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TableCell(
      child: Container(
        height: 30,
        color: Colors.white,
        child: Center(
          child: Text(
            text!,
            style: HeaderStyle,
          ),
        ),
      ),
    );
  }
}
