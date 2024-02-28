import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class QRCodeGenerator extends StatefulWidget {
  const QRCodeGenerator({super.key});

  @override
  _QRCodeGeneratorState createState() => _QRCodeGeneratorState();
}

class _QRCodeGeneratorState extends State<QRCodeGenerator> {

  String qrData = 'TRN_1293084_OOOPP'; // Change this to your data
  GlobalKey globalKey = new GlobalKey();
  bool isGenerated = false;

  Future<void> generateQRCode() async {
    try {
      final image = await QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: false,
      ).toImage(300);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Image(
                pw.MemoryImage(pngBytes),
              ),
            );
          },
        ),
      );

      Directory? externalDirectory = await getExternalStorageDirectory();
      final String dir = externalDirectory!.path;
      final String path = '$dir/qrcode.pdf';
      final File file = File(path);
      await file.writeAsBytes(await pdf.save());
      setState(() {
        isGenerated = true;
      });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Generator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RepaintBoundary(
              key: globalKey,
              child: QrImageView(
                data: qrData,
                size: 200,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await generateQRCode();
              },
              child: Text('Generate QR Code and Save as PDF'),
            ),
            SizedBox(height: 20),
            if (isGenerated)
              ElevatedButton(
                onPressed: () async {
                  Directory? externalDir = await getExternalStorageDirectory();
                  if (externalDir != null) {
                    final String dir = externalDir.path;
                    final String path = '$dir/qrcode.pdf';
                    OpenFile.open(path);
                  } else {
                    // Handle the case where the external directory is not available
                    print("External storage directory is not available.");
                  }
                  // Open PDF document here
                  // Example: OpenFile.open('/path/to/qrcode.pdf');
                },
                child: Text('Open PDF'),
              ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QRCodeGenerator(),
  ));
}