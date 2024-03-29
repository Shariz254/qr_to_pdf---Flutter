import 'package:flutter/material.dart';
import 'package:qr_to_pdf/qr_code_pdf.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter QR',
      home: const QRCodeGenerator(),
    );
  }
}

