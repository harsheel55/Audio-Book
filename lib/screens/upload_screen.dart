import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dynamic fileData = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Processing PDF'),
      ),
      body: FutureBuilder<String>(
        future: extractTextFromPDF(fileData),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            String extractedText = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: kIsWeb
                      ? SfPdfViewer.memory(fileData)
                      : SfPdfViewer.file(File(fileData)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/player',
                        arguments: extractedText);
                  },
                  child: const Text('Play Audio'),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Future<String> extractTextFromPDF(dynamic fileData) async {
    PdfDocument document;
    if (kIsWeb) {
      document = PdfDocument(inputBytes: fileData);
    } else {
      document = PdfDocument(inputBytes: await File(fileData).readAsBytes());
    }

    String extractedText = PdfTextExtractor(document).extractText();
    document.dispose();
    return extractedText;
  }
}
