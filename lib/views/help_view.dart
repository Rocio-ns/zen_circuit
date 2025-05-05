import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class HelpScreen extends StatefulWidget {
  @override
  HelpScreenState createState() => HelpScreenState();
}

class HelpScreenState extends State<HelpScreen> {
  String? localPath;
  bool _isLoading = true;
  bool _hasLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_hasLoaded) {
      _loadPdf();
      _hasLoaded = true;
    }
  }

  Future<void> _loadPdf() async {
    try {
      final locale = Localizations.localeOf(context).languageCode;
      final fileName = locale == 'es' ? 'help_es.pdf' : 'help_en.pdf';
      final byteData = await rootBundle.load('assets/help/$fileName');

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(byteData.buffer.asUint8List(), flush: true);

      setState(() {
        localPath = file.path;
        _isLoading = false;
      });
    } catch (e) {
      print("❌ Error loading PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e")),
        );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ayuda')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : localPath == null
              ? const Center(child: Text("No se pudo cargar el PDF"))
              : PDFView(
                  filePath: localPath!,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                ),
    );
  }
}