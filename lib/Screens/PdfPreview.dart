import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';
import 'package:station_statistics/Screens/pdfController.dart';

import '../constaint.dart';

class PDFPreview extends StatelessWidget {
  final List<Invoice>? data;
  final int? invoiceNumber;

  const PDFPreview({
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(),
        body: FutureBuilder(
          future:
              PDFController().buildPdf(PdfPageFormat.a4, data!, invoiceNumber),
          builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.hasData) {
              return PdfPreview(
                maxPageWidth: 700,
                build: (format) => snapshot.data!,
                canDebug: false,
                canChangeOrientation: false,
                actions: [
                  PdfPreviewAction(
                    icon: const Icon(Icons.save),
                    onPressed: (context, build, pageFormat) async {
                      var status =
                          await Permission.accessMediaLocation.request();
                      await Permission.manageExternalStorage.request();
                      await Permission.microphone.request();
                      await Permission.camera.request();
                      await Permission.contacts.request();
                      // print("status: ${status.isGranted}");
                      // if (status.isGranted) {
                      String? outputFile =
                          await FilePicker.platform.getDirectoryPath();
                      print("outputFile2 :$outputFile");
                      // String? outputFile = await FilePicker.platform.saveFile(
                      //   dialogTitle: 'Please select an output file:',
                      //   fileName: 'Report.pdf',
                      // );
                      // print("outputFile: $outputFile");
                      // if (outputFile == null) {
                      //   // User canceled the picker
                      //   print("User canceled the picker");
                      // }
                      print("outputFile ${outputFile}");
                      if (outputFile != null) {
                        await PDFController()
                            .saveAsFile(pageFormat, data!, 1, outputFile);
                        // } else {
                        CustomDialog(
                          cancelButton: false,
                          confirmButtonTitle: "Ok",
                          confirmButton: () {
                            Get.back();
                          },
                          message: "Please choose folder to save file in",
                        );
                      }
                      // } else {
                      //   await Permission.storage.request();
                      // }
                    },
                  )
                ],
                onPrinted: _showPrintedToast,
                onShared: _showSharedToast,
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
