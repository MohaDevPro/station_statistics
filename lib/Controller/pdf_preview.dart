import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:station_statistics/Controller/pdf_controller.dart';
import 'package:station_statistics/Database/Entities/Invoices.dart';

class PDFPreview extends StatefulWidget {
  final List<Invoice>? data;
  final int? invoiceNumber;
  static const double inch = 72.0;
  static const double mm = inch / 25.4;
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

  static const Map<String, PdfPageFormat> pageFormats = {
    "8 سم": PdfPageFormat.roll80,
    "A6": PdfPageFormat.a6,
    "A5": PdfPageFormat.a5,
    "A4": PdfPageFormat.a4,
    "A3": PdfPageFormat.a3,
    "letter": PdfPageFormat.letter,
    "legal": PdfPageFormat.legal,
    // "roll57": PdfPageFormat.roll57,
  };

  @override
  State<PDFPreview> createState() => _PDFPreviewState();
}

class _PDFPreviewState extends State<PDFPreview> {
  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت طباعة الملف بنجاح'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('تمت مشاركة الملف بنجاح'),
      ),
    );
  }

  String? date;

  String _formatDate(DateTime date) {
    final format = intl.DateFormat.yMMMd('en_US');
    return format.format(date);
  }

  static const double inch = 72.0;
  static const double mm = inch / 25.4;
  // var _pageFormat = PdfPageFormat(80 * mm, double.infinity, marginAll: 5 * mm);
  var _pageFormat = PdfPageFormat.roll80;
  var iconColor = Colors.white;
  var dropdownColor = Colors.blue;
  final keys = PDFPreview.pageFormats.keys.toList();
  @override
  Widget build(BuildContext context) {
    if (widget.data!.length == 1) {
      date = _formatDate(DateTime.fromMicrosecondsSinceEpoch(
          widget.data![0].timeStamp as int));
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("عرض الملف"),
          centerTitle: true,
          elevation: 0,
        ),
        body: FutureBuilder(
          future: PDFController().buildPdf(
              _pageFormat, widget.data!, widget.invoiceNumber,
              date: date),
          builder: (BuildContext context, AsyncSnapshot<Uint8List> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  Expanded(
                    flex: 15,
                    child: PdfPreview(
                      maxPageWidth: 700,
                      build: (format) => snapshot.data!,
                      canDebug: false,
                      canChangePageFormat: false,
                      canChangeOrientation: false,
                      useActions: false,
                      pageFormats: PDFPreview.pageFormats,
                      onPrinted: _showPrintedToast,
                      onShared: _showSharedToast,
                    ),
                  ),
                  IconTheme.merge(
                    data: IconThemeData(
                      color: iconColor,
                    ),
                    child: Material(
                      elevation: 4,
                      color: dropdownColor,
                      child: SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: SafeArea(
                          child: Wrap(
                            alignment: WrapAlignment.spaceAround,
                            children: [
                              DropdownButton<PdfPageFormat>(
                                dropdownColor: dropdownColor,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  color: iconColor,
                                ),
                                value: _pageFormat,
                                items: List<
                                    DropdownMenuItem<PdfPageFormat>>.generate(
                                  PDFPreview.pageFormats.length,
                                  (int index) {
                                    final key = keys[index];
                                    final val = PDFPreview.pageFormats[key];
                                    return DropdownMenuItem<PdfPageFormat>(
                                      value: val,
                                      child: Text(key,
                                          style: TextStyle(color: iconColor)),
                                    );
                                  },
                                ),
                                onChanged: (PdfPageFormat? pageFormat) {
                                  setState(() {
                                    if (pageFormat != null) {
                                      _pageFormat = pageFormat;
                                      print(
                                          "pageFormat ${pageFormat.portrait}");
                                      print(
                                          "_pageFormat ${_pageFormat.portrait}");
                                      // raster();
                                    }
                                  });
                                },
                              ),
                              IconButton(
                                  onPressed: () async {
                                    // Return the PDF file content
                                    await Printing.layoutPdf(
                                        onLayout:
                                            (PdfPageFormat format) async =>
                                                snapshot.data!);
                                  },
                                  icon: const Icon(Icons.print)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  pageFormatsDropdown(Color dropdownColor, Color iconColor) {
    return;
  }
}
