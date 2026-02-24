import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';

import '../../core/di/app_providers.dart';
import '../widgets/gradient_background.dart';

class PreviewScreen extends ConsumerStatefulWidget {
  const PreviewScreen({super.key});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen> {
  Future<Uint8List?> _renderPreview(String path) async {
    final doc = await PdfDocument.openFile(path);
    final page = await doc.getPage(1);
    final image = await page.render(width: page.width * 0.8, height: page.height * 0.8);
    await page.close();
    await doc.close();
    return image?.bytes;
  }

  @override
  Widget build(BuildContext context) {
    final pdf = ref.watch(appControllerProvider).pdf;
    if (pdf == null) {
      return const Scaffold(body: Center(child: Text('Select a PDF first.')));
    }
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Live Preview')),
        body: FutureBuilder<Uint8List?>(
          future: _renderPreview(pdf.path),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
            return Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(snapshot.data!),
              ),
            );
          },
        ),
      ),
    );
  }
}
