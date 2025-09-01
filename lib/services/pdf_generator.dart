// services/pdf_generator.dart
import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';

class PDFGenerator {
  static Future<File> generatePDF(List<String> imagePaths) async {
    final pdf = pw.Document();

    for (final imagePath in imagePaths) {
      final image = pw.MemoryImage(
        File(imagePath).readAsBytesSync(),
      );

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(image),
            );
          },
        ),
      );
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/document_${DateTime.now().millisecondsSinceEpoch}.pdf');
    
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}