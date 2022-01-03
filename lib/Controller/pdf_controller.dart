import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
import 'package:station_statistics/Database/Entities/invoice_items.dart';
import 'package:station_statistics/Services/LocalDB.dart';
import 'package:station_statistics/Services/user_preferences.dart';

class PDFController {
  Future<Uint8List> buildPdf(
      PdfPageFormat pageFormat, List<Invoice> data, int? invoiceNumber,
      {String? date}) async {
    List<InvoiceItem> itemInvoiceVM = [];
    print("UserPreferences().prefs.getString("
        ")! ${UserPreferences().prefs.getString("path")!}");
    var f = File(UserPreferences().prefs.getString("path")!);
    Uint8List bytes = f.readAsBytesSync();
    print("UserPreferences().prefs.getString("
        ")! ${UserPreferences().prefs.getString("path")!}");
    if (data.length == 1 && invoiceNumber != null) {
      print("length Done");
      List<InvoiceItem> itemInvoices = await LocalDB()
          .appDatabaseCache
          .invoiceItemDAO
          .getAllInvoiceItemsInvoiceID(invoiceNumber);
      print("Done");

      itemInvoiceVM = [];
      for (var i in itemInvoices) {
        itemInvoiceVM.add(
          InvoiceItem(
            type: i.type,
            price: i.price,
            quantity: i.quantity,
          ),
        );
      }
      print("Done");
    }
    var fontData = await rootBundle.load("assets/fonts/HacenTunisia.ttf");
    final myFont = Font.ttf(fontData);
    // Create a PDF document.
    final doc = pw.Document();
    // _logo = await rootBundle.loadString('assets/logo.svg');
    // _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pageFormat.height == double.infinity
          ? pw.Page(
              // pageTheme: _buildTheme(pageFormat, myFont),
              pageFormat: pageFormat,
              build: (context) => pw.Column(children: [
                // imageContainer(bytes),
                _buildHeader(context, invoiceNumber, myFont, bytes),
                // _contentHeader(context),
                _contentTable(context, data, myFont),
                if (itemInvoiceVM.isNotEmpty) pw.SizedBox(height: 5),
                if (itemInvoiceVM.isNotEmpty)
                  _contentSmallTable(context, itemInvoiceVM, myFont),
                pw.SizedBox(height: 5),
                pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: _contentFooter(context, data, myFont)),
                pw.SizedBox(height: 10),
                //                 pw.SizedBox(height: 20),
                pw.BarcodeWidget(
                  data:
                      'فاتورة: ${invoiceNumber.toString()} \n التاريخ: ${_formatDate(DateTime.now())} \n المستخدم: ${UserPreferences().getUser().userName}',
                  width: 60,
                  height: 60,
                  barcode: pw.Barcode.qrCode(),
                  drawText: true,
                ),
                pw.SizedBox(height: 10),
                // _termsAndConditions(context),
              ]),
            )
          : pw.MultiPage(
              pageTheme: _buildTheme(pageFormat, myFont),
              header: (context) =>
                  _buildHeader(context, invoiceNumber, myFont, bytes),
              // footer: _buildFooter,
              build: (context) => [
                // _contentHeader(context),

                _contentTable(context, data, myFont),
                if (itemInvoiceVM.isNotEmpty) pw.SizedBox(height: 5),
                if (itemInvoiceVM.isNotEmpty)
                  _contentSmallTable(context, itemInvoiceVM, myFont),
                pw.SizedBox(height: 5),
                pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: _contentFooter(context, data, myFont)),
                pw.SizedBox(height: 10),
                //                 pw.SizedBox(height: 20),
                pw.Center(
                  child: pw.BarcodeWidget(
                    data:
                        'فاتورة: ${invoiceNumber.toString()} \n التاريخ: ${_formatDate(DateTime.now())} \n المستخدم: ${UserPreferences().getUser().userName}',
                    width: 60,
                    height: 60,
                    barcode: pw.Barcode.qrCode(),
                    drawText: true,
                  ),
                ),
                pw.SizedBox(height: 10),
              ],
            ),
    );

    return doc.save();
  }

  Future<File> saveAsFile(PdfPageFormat pageFormat, List<Invoice> data,
      {int invoiceNumber = 0, String outputFile = ""}) async {
    final bytes = await buildPdf(pageFormat, data, invoiceNumber);
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File(appDocPath + '/' + 'Report.pdf');
    // ignore: avoid_print
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    // saveAsFileToPhone(file);
    return file;
  }

  Future<void> saveAsFileToPhone(PdfPageFormat pageFormat, List<Invoice> data,
      {int invoiceNumber = 0, String outputFile = ""}) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final bytes = await buildPdf(pageFormat, data, invoiceNumber);
    final file = File(appDocPath + '/' + 'Report.pdf');
    file
      ..create()
      ..writeAsBytes(bytes);
    // file.writeAsBytes(bytes);
  }
  // Future<void> saveAsFileToPhone(PdfPageFormat pageFormat, List<Invoice> data,
  //      int? invoiceNumber, String path) async {
  //    final appDocDir = await getApplicationDocumentsDirectory();
  //    final appDocPath = appDocDir.path;
  //    final bytes = await buildPdf(pageFormat, data, invoiceNumber);
  //    final file = File(path + '/' + 'Report.pdf');
  //    await file.create();
  //    file.writeAsBytes(bytes);
  //
  //    var f = await file.open(mode: FileMode.write);
  //    // print('Save as file ${file.path} ...');
  //    // await file.copy(path + '/' + 'Report.pdf');
  //  }

  pw.PageTheme _buildTheme(PdfPageFormat pageFormat, Font? myFont) {
    return pw.PageTheme(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(5),
        theme: pw.ThemeData.withFont(
          base: myFont,
        ),
        clip: true
        // buildBackground: (context) => pw.FullPage(
        //   ignoreMargins: true,
        //   // child: pw.SvgImage(svg: _bgShape),
        // ),
        );
  }

  static const baseColor = PdfColors.white;
  static const accentColor = PdfColors.blueGrey900;
  static const _darkColor = PdfColors.blueGrey800;
  pw.Widget _contentFooter(
      pw.Context context, List<Invoice> data, Font? myFont) {
    var _total = 0.0;
    var tax = 0.0;
    // var discount = 0.0;
    for (var d in data) {
      _total += d.totalPrice!;
      tax += (d.totalPrice! * d.tax! / 100);
      // discount += d.discount!;
    }
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 1,
          child: pw.DefaultTextStyle(
            style: pw.TextStyle(
              fontSize: 10,
              font: myFont,
              color: _darkColor,
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(_total.toStringAsFixed(2)),
                    pw.Text('المجموع الكلي:'),
                  ],
                ),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text((tax).toStringAsFixed(2)),
                    pw.Text('الضريبة:'),
                  ],
                ),
                // pw.Row(
                //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                //   children: [
                //     pw.Text((discount).toStringAsFixed(2)),
                //     pw.Text('الخصم:'),
                //   ],
                // ),
                pw.Divider(color: accentColor),
                pw.DefaultTextStyle(
                  style: pw.TextStyle(
                    color: accentColor,
                    font: myFont,
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  child: pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text((_total + tax).toStringAsFixed(2)),
                      pw.Text('صافي المجموع: '),
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

  pw.Widget _contentTable(
      pw.Context context, List<Invoice> data, Font? myFont) {
    const tableHeaders = [
      "الضريبة", "المجموع", "التاريخ", "#",

      // "Total Price"
    ];
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Table.fromTextArray(
        border: null,
        cellAlignment: pw.Alignment.centerLeft,
        headerDecoration: const pw.BoxDecoration(
          borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
          color: baseColor,
        ),
        headerHeight: 5,
        // tableWidth: pw.TableWidth.min,
        cellHeight: 10,
        cellAlignments: {
          0: pw.Alignment.center,
          1: pw.Alignment.center,
          2: pw.Alignment.center,
          3: pw.Alignment.center,
          4: pw.Alignment.center,
        },
        headerStyle: pw.TextStyle(
          color: PdfColors.black,
          font: myFont,
          fontSize: 6,
          fontWeight: pw.FontWeight.bold,
        ),
        cellStyle: pw.TextStyle(
          font: myFont,
          color: PdfColors.black,
          fontSize: 10,
        ),
        rowDecoration: const pw.BoxDecoration(
          border: pw.Border(
            bottom: pw.BorderSide(
              color: accentColor,
              width: .5,
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
      ),
    );
  }

  pw.Widget _contentSmallTable(
      pw.Context context, List<InvoiceItem> data, Font? myFont) {
    print("InvoiceItem ${data.length}");
    const tableHeaders = [
      "الكمية", "السعر", "المنتج",

      // "Total Price"
    ];
    return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Center(
          child: pw.Table.fromTextArray(
            border: null,
            cellAlignment: pw.Alignment.centerLeft,
            headerDecoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(10)),
              color: baseColor,
            ),
            headerHeight: 1,
            cellHeight: 5,
            cellAlignments: {
              0: pw.Alignment.center,
              1: pw.Alignment.center,
              2: pw.Alignment.center,
            },
            headerStyle: pw.TextStyle(
              color: PdfColors.black,
              font: myFont,
              fontSize: 7,
              fontWeight: pw.FontWeight.bold,
            ),
            cellStyle: pw.TextStyle(
              font: myFont,
              color: PdfColors.black,
              fontSize: 7,
            ),
            // tableWidth: pw.TableWidth.min,
            rowDecoration: const pw.BoxDecoration(
              border: pw.Border(
                bottom: pw.BorderSide(
                  color: accentColor,
                  width: .5,
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
          ),
        ));
  }

  String _formatDate(DateTime date) {
    final format = DateFormat.yMd('en_US');
    return format.format(date);
  }

  Widget imageContainer(Uint8List bytes) {
    return pw.Container(
      width: Get.width / 4,
      height: Get.width / 2,
      child: pw.Image(
        pw.MemoryImage(bytes),
      ),
    );
  }

  pw.Widget _buildHeader(
      pw.Context context, int? invoiceNumber, Font? myFont, Uint8List bytes,
      {String? date}) {
    return pw.Directionality(
      textDirection: pw.TextDirection.rtl,
      child: pw.Column(
        children: [
          imageContainer(bytes),
          pw.Container(
            // height: 20,
            padding: const pw.EdgeInsets.only(left: 20),
            alignment: pw.Alignment.center,
            child: pw.Text(
              invoiceNumber == null ? "تقرير" : "فاتورة",
              style: pw.TextStyle(
                color: PdfColors.black,
                font: myFont,
                fontStyle: pw.FontStyle.normal,
                fontWeight: pw.FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          pw.SizedBox(height: 1),
          pw.Container(
            decoration: const pw.BoxDecoration(
              borderRadius: pw.BorderRadius.all(pw.Radius.circular(2)),
              color: baseColor,
            ),
            padding: const pw.EdgeInsets.only(
                left: 40, top: 10, bottom: 10, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: 50,
            child: pw.DefaultTextStyle(
              style: pw.TextStyle(
                color: PdfColors.black,
                font: myFont,
                fontSize: 10,
              ),
              child: pw.GridView(
                crossAxisCount: 2,
                children: [
                  pw.Text("${UserPreferences().getUser().userName}"),
                  pw.Text('المستخدم'),
                  pw.Text("${invoiceNumber ?? ""}"),
                  pw.Text(invoiceNumber == null ? "تقرير" : "فاتورة #"),
                  pw.Text(date ?? _formatDate(DateTime.now())),
                  pw.Text('التاريخ:'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
