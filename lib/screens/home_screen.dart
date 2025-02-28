import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EBook Audio Player'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );

            if (result != null) {
              if (kIsWeb) {
                // On web, use bytes property
                Uint8List? fileBytes = result.files.single.bytes;
                if (fileBytes != null) {
                  Navigator.pushNamed(context, '/upload', arguments: fileBytes);
                }
              } else {
                // On non-web platforms, use path property
                String? filePath = result.files.single.path;
                if (filePath != null) {
                  Navigator.pushNamed(context, '/upload', arguments: filePath);
                }
              }
            }
          },
          child: const Text('Upload PDF'),
        ),
      ),
    );
  }
}
