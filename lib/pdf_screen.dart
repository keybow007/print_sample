import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/src/pdf/page_format.dart';
import 'package:print_sample/data/card_sIze.dart';
import 'package:print_sample/data/paper_sIze.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfScreen extends StatefulWidget {
  final Uint8List capturedImageByteData;
  final PaperSize paperSize;
  final CardSize cardSize;

  const PdfScreen({
    Key? key,
    required this.paperSize,
    required this.cardSize,
    required this.capturedImageByteData,
  }) : super(key: key);

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("[PDF] ${widget.cardSize.name} / ${widget.paperSize.name}"),
        centerTitle: true,
      ),
      body: PdfPreview(
        //pageFormatはデフォルトだと用紙サイズを変更できてしまうので渡されたサイズに固定
        canChangePageFormat: false,
        canChangeOrientation: false,
        previewPageMargin: EdgeInsets.zero,
        initialPageFormat: widget.paperSize.pageFormat,
        build: (format) => _generatePdf(format),
        onPrinted: (context) => print("印刷されました"),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) {
    final pdf = pw.Document();
    final image = pw.MemoryImage(widget.capturedImageByteData);

    pdf.addPage(
      pw.Page(
        pageFormat: widget.paperSize.pageFormat,
        margin: pw.EdgeInsets.zero,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Image(image),
          );
        },
      ),
    );

    return pdf.save();
  }
}
