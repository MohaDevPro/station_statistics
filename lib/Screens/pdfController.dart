import 'dart:io';
import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:station_statistics/Database/Entities/Invoices.dart';

class PDFController {
  Future<Uint8List> buildPdf(
      PdfPageFormat pageFormat, List<Invoice> data, int invoiceNumber) async {
    // Create a PDF document.
    final doc = pw.Document();
    var allTotal = 0.0;
    for (var d in data) {
      allTotal += d.totalPrice;
    }
    // _logo = await rootBundle.loadString('assets/logo.svg');
    // _bgShape = await rootBundle.loadString('assets/invoice.svg');

    // Add page to the PDF
    doc.addPage(
      pw.MultiPage(
        pageTheme: _buildTheme(
          pageFormat,
        ),
        header: (context) => _buildHeader(context, invoiceNumber),
        // footer: _buildFooter,
        build: (context) => [
          // _contentHeader(context),
          _contentTable(context, data),
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

  Future<File> saveAsFile(
      PdfPageFormat pageFormat, List<Invoice> data, int invoiceNumber) async {
    final bytes = await buildPdf(pageFormat, data, invoiceNumber);

    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final file = File(appDocPath + '/' + 'Report.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<void> saveAsFileToPhone(PdfPageFormat pageFormat, List<Invoice> data,
      int invoiceNumber, String path) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    final bytes = await buildPdf(pageFormat, data, invoiceNumber);
    final file = File(path + '/' + 'Report.pdf');
    file
      ..openWrite()
      ..writeAsBytes(bytes);
    // print('Save as file ${file.path} ...');
    // await file.copy(path + '/' + 'Report.pdf');
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

  static const baseColor = PdfColors.teal;
  static const accentColor = PdfColors.blueGrey900;
  static const _darkColor = PdfColors.blueGrey800;
  pw.Widget _contentFooter(pw.Context context, double _total) {
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
                      pw.Text("${(_total - _total * 0.15).toStringAsFixed(2)}"),
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
            width: .5,
          ),
        ),
      ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col],
      ),
      data: List<List<String>>.generate(
        data.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => data[row].getIndex(col, row),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final format = DateFormat.yMMMd('en_US');
    return format.format(date);
  }

  // Future<File>qrCodeToFile(String code)async{
  //    File file;
  //   final qrValidationResult = QrValidator.validate(
  //     data: code,
  //     version: QrVersions.auto,
  //     errorCorrectionLevel: QrErrorCorrectLevel.L,
  //   );
  //   if (qrValidationResult.status == QrValidationStatus.valid) {
  //     final painter = QrPainter.withQr(
  //       qr: qrValidationResult.qrCode,
  //       color: const Color(0xFF000000),
  //       gapless: true,
  //       embeddedImageStyle: null,
  //       embeddedImage: null,
  //     );
  //
  //     Directory tempDir = await getTemporaryDirectory();
  //     String tempPath = tempDir.path;
  //     String path = '$tempPath/qrCode.png';
  //     final picData = await painter.toImageData(2048, format: ImageByteFormat.png);
  //     final buffer = picData.buffer;
  //     file = await File(path).writeAsBytes(
  //         buffer.asUint8List(picData.offsetInBytes, picData.lengthInBytes)
  //     );
  //   }
  //   return file;
  // }
  pw.Widget _buildHeader(pw.Context context, int invoiceNumber) {
    return pw.Column(
      children: [
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Column(
                children: [
                  pw.Container(
                    height: 50,
                    padding: const pw.EdgeInsets.only(left: 20),
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text(
                      'INVOICE',
                      style: pw.TextStyle(
                        color: baseColor,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 40,
                      ),
                    ),
                  ),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      borderRadius:
                          const pw.BorderRadius.all(pw.Radius.circular(2)),
                      color: accentColor,
                    ),
                    padding: const pw.EdgeInsets.only(
                        left: 40, top: 10, bottom: 10, right: 20),
                    alignment: pw.Alignment.centerLeft,
                    height: 50,
                    child: pw.DefaultTextStyle(
                      style: pw.TextStyle(
                        color: _darkColor,
                        fontSize: 12,
                      ),
                      child: pw.GridView(
                        crossAxisCount: 2,
                        children: [
                          pw.Text('Invoice #'),
                          pw.Text(invoiceNumber.toString()),
                          pw.Text('Date:'),
                          pw.Text(_formatDate(DateTime.now())),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            pw.Expanded(
              child: pw.Column(
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.BarcodeWidget(
                    data:
                        'Invoice: ${invoiceNumber.toString()} \n Date: ${_formatDate(DateTime.now())}',
                    width: 60,
                    height: 60,
                    barcode: pw.Barcode.qrCode(),
                    drawText: false,
                  ),

                  // pw.Container(
                  //   color: baseColor,
                  //   padding: pw.EdgeInsets.only(top: 3),
                  // ),
                ],
              ),
            ),
          ],
        ),
        if (context.pageNumber > 1) pw.SizedBox(height: 20)
      ],
    );
  }
}
