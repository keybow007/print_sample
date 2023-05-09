import 'package:pdf/pdf.dart';

class PaperSize {
  final String name;
  final double width;
  final double height;
  final PdfPageFormat pageFormat;

  const PaperSize({
    required this.name,
    required this.width,
    required this.height,
    required this.pageFormat,
  });
}

/*
* 各用紙サイズのアスペクト比
*   A3: 297x420
*   A4: 210x297
*   B4: 257x364
*   B5: 182x257
*
* */

final paperSizes = [
  PaperSize(name: "A3", width: 297, height: 420, pageFormat: PdfPageFormat.a3),
  PaperSize(name: "A4", width: 210, height: 297, pageFormat: PdfPageFormat.a4),
  PaperSize(
    name: "B4",
    width: 257,
    height: 364,
    pageFormat: PdfPageFormat(
      257 * PdfPageFormat.mm,
      364 * PdfPageFormat.mm,
      //marginAll: 20 * PdfPageFormat.mm,
    ),
  ),
  PaperSize(
    name: "B5",
    width: 182,
    height: 257,
    pageFormat: PdfPageFormat(
      182 * PdfPageFormat.mm,
      257 * PdfPageFormat.mm,
      //marginAll: 20 * PdfPageFormat.mm,
    ),
  ),
];
