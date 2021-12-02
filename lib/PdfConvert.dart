// import 'dart:io';
// import 'dart:typed_data';
//
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:station_statistics/Database/Entities/Invoices.dart';
//
// class PdfConverter {
//   Future<Uint8List> buildPdf(
//       PdfPageFormat pageFormat, List<Invoice> data) async {
//     // Create a PDF document.
//     final doc = pw.Document();
//
//     // _logo = await rootBundle.loadString('assets/logo.svg');
//     // _bgShape = await rootBundle.loadString('assets/invoice.svg');
//
//     // Add page to the PDF
//     doc.addPage(
//       pw.MultiPage(
//         pageTheme: _buildTheme(
//           pageFormat,
//         ),
//         // header: _buildHeader,
//         // footer: _buildFooter,
//         build: (context) => [
//           // _contentHeader(context),
//           _contentTable(context, data),
//           pw.SizedBox(height: 20),
//           _contentFooter(context, _allTotal),
//           pw.SizedBox(height: 20),
//           // _termsAndConditions(context),
//         ],
//       ),
//     );
//
//     // Return the PDF file content
//     return doc.save();
//   }
//
//   Future<void> _saveAsFile(
//     // BuildContext context,
//     // LayoutCallback build,
//     PdfPageFormat pageFormat,
//   ) async {
//     final bytes = await buildPdf(pageFormat);
//
//     final appDocDir = await getApplicationDocumentsDirectory();
//     final appDocPath = appDocDir.path;
//     final file = File(appDocPath + '/' + 'document.pdf');
//     print('Save as file ${file.path} ...');
//     await file.writeAsBytes(bytes);
//     // await OpenFile.open(file.path);
//   }
//
//   pw.PageTheme _buildTheme(
//     PdfPageFormat pageFormat,
//   ) {
//     return pw.PageTheme(
//       pageFormat: pageFormat,
//       theme: pw.ThemeData.base(),
//       buildBackground: (context) => pw.FullPage(
//         ignoreMargins: true,
//         // child: pw.SvgImage(svg: _bgShape),
//       ),
//     );
//   }
//
//   var baseColor = PdfColors.teal;
//   var accentColor = PdfColors.blueGrey900;
//
//   pw.Widget _contentFooter(pw.Context context, double _total) {
//     const _darkColor = PdfColors.blueGrey800;
//     const _lightColor = PdfColors.white;
//     return pw.Row(
//       crossAxisAlignment: pw.CrossAxisAlignment.start,
//       children: [
//         pw.Expanded(
//           flex: 1,
//           child: pw.DefaultTextStyle(
//             style: const pw.TextStyle(
//               fontSize: 10,
//               color: _darkColor,
//             ),
//             child: pw.Column(
//               crossAxisAlignment: pw.CrossAxisAlignment.start,
//               children: [
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text('All Total:'),
//                     pw.Text(_total.toString()),
//                   ],
//                 ),
//                 pw.SizedBox(height: 5),
//                 pw.Row(
//                   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   children: [
//                     pw.Text('Tax:'),
//                     pw.Text('${_total * 0.15}%'),
//                   ],
//                 ),
//                 pw.Divider(color: accentColor),
//                 pw.DefaultTextStyle(
//                   style: pw.TextStyle(
//                     color: baseColor,
//                     fontSize: 14,
//                     fontWeight: pw.FontWeight.bold,
//                   ),
//                   // child: pw.Row(
//                   //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                   //   children: [
//                   //     pw.Text('Total:'),
//                   //     pw.Text(_formatCurrency(_grandTotal)),
//                   //   ],
//                   // ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   pw.Widget _contentTable(pw.Context context, List<Invoice> data) {
//     const tableHeaders = [
//       'SKU#',
//       'Item Description',
//       'Price',
//       'Quantity',
//       'Total'
//     ];
//     // String getIndex(int index) {
//     //   switch (index) {
//     //     case 0:
//     //       return id;
//     //     case 1:
//     //       return productName;
//     //     case 2:
//     //       return _formatCurrency(price);
//     //     case 3:
//     //       return quantity.toString();
//     //     case 4:
//     //       return _formatCurrency(total);
//     //   }
//     //   return '';
//     // }
//     var baseColor = PdfColors.teal;
//     var accentColor = PdfColors.blueGrey900;
//     return pw.Table.fromTextArray(
//       border: null,
//       cellAlignment: pw.Alignment.centerLeft,
//       headerDecoration: pw.BoxDecoration(
//         borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
//         color: baseColor,
//       ),
//       headerHeight: 25,
//       cellHeight: 40,
//       cellAlignments: {
//         0: pw.Alignment.center,
//         1: pw.Alignment.center,
//         2: pw.Alignment.center,
//         3: pw.Alignment.center,
//         4: pw.Alignment.center,
//       },
//       headerStyle: pw.TextStyle(
//         color: PdfColors.white,
//         fontSize: 10,
//         fontWeight: pw.FontWeight.bold,
//       ),
//       cellStyle: const pw.TextStyle(
//         color: PdfColors.black,
//         fontSize: 10,
//       ),
//       rowDecoration: pw.BoxDecoration(
//         border: pw.Border(
//           bottom: pw.BorderSide(
//             color: accentColor,
//             width: .5,
//           ),
//         ),
//       ),
//       headers: List<String>.generate(
//         tableHeaders.length,
//         (col) => tableHeaders[col],
//       ),
//       data: List<List<String>>.generate(
//         data.length,
//         (row) => List<String>.generate(
//           tableHeaders.length,
//           (col) => data[row].getIndex(col),
//         ),
//       ),
//     );
//   }
// }
