import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
import 'package:station_statistics/Screens/pdfController.dart';

class PDFPreview extends StatelessWidget {
  final List<Invoice>? data;
  final int? invoiceNumber;

  PDFPreview({
    Key? key,
    this.data,
    this.invoiceNumber,
  }) : super(key: key);
  // final actions = <PdfPreviewAction>[
  //   if (!kIsWeb)
  //     PdfPreviewAction(
  //       icon: const Icon(Icons.save),
  //       onPressed: _saveAsFile,
  //     )
  // ];

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  static const Map<String, PdfPageFormat> pageFormats = {
    "A6": PdfPageFormat.a6, "A5": PdfPageFormat.a5, "A4": PdfPageFormat.a4,
    "A3": PdfPageFormat.a3,
    "letter": PdfPageFormat.letter,
    "legal": PdfPageFormat.legal,
    "roll57": PdfPageFormat.roll57,
    "roll80": PdfPageFormat.roll80,
    // "standard": PdfPageFormat.standard,
    // "undefined": PdfPageFormat.undefined,
  };
  String? date;
  String _formatDate(DateTime date) {
    final format = DateFormat.yMMMd('en_US');
    return format.format(date);
  }

  @override
  Widget build(BuildContext context) {
    if (data!.length == 1) {
      date = _formatDate(
          DateTime.fromMicrosecondsSinceEpoch(data![0].timeStamp as int));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Preview"),
        centerTitle: true,
        elevation: 0,
      ),
      body: FutureBuilder(
        future: PDFController()
            .buildPdf(PdfPageFormat.a4, data!, invoiceNumber, date: date),
        builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
          if (snapshot.hasData) {
            return PdfPreview(
              maxPageWidth: 700,
              build: (format) => snapshot.data!,
              canDebug: false,
              canChangeOrientation: false,
              pageFormats: pageFormats,
              // actions: [
              //   PdfPreviewAction(
              //     icon: const Icon(Icons.save),
              //     onPressed: (context, build, pageFormat) async {
              //       // var status =
              //       //     await Permission.accessMediaLocation.request();
              //       // await Permission.manageExternalStorage.request();
              //       // print("status: ${status.isGranted}");
              //       // if (status.isGranted) {
              //       // String? outputFile =
              //       //     await FilePicker.platform.getDirectoryPath();
              //       // print("outputFile2 :$outputFile");
              //       // String? outputFile = await FilePicker.platform.saveFile(
              //       //   dialogTitle: 'Please select an output file:',
              //       //   fileName: 'Report.pdf',
              //       // );
              //       // print("outputFile: $outputFile");
              //       // if (outputFile == null) {
              //       //   // User canceled the picker
              //       //   print("User canceled the picker");
              //       // }
              //       // print("outputFile ${outputFile}");
              //       // if (outputFile != null) {
              //         await PDFController()
              //             .saveAsFile(pageFormat, data!,);
              //         // } else {
              //         // CustomDialog(
              //         //   cancelButton: false,
              //         //   confirmButtonTitle: "Ok",
              //         //   confirmButton: () {
              //         //     Get.back();
              //         //   },
              //         //   message: "Please choose folder to save file in",
              //         // );
              //       // }
              //     },
              //   )
              // ],
              onPrinted: _showPrintedToast,
              onShared: _showSharedToast,
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
