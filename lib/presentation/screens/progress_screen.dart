import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/app_providers.dart';
import '../widgets/gradient_background.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final controller = ref.read(appControllerProvider.notifier);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(backgroundColor: Colors.transparent, title: const Text('Progress & Result')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              LinearProgressIndicator(value: state.isConverting ? null : state.progress),
              const SizedBox(height: 12),
              Text('${(state.progress * 100).toStringAsFixed(0)}% complete'),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: state.logs.length,
                  itemBuilder: (_, i) => Text('• ${state.logs[i]}'),
                ),
              ),
              if (state.result != null) ...[
                Wrap(
                  spacing: 8,
                  children: [
                    OutlinedButton.icon(
                      onPressed: controller.shareResultFiles,
                      icon: const Icon(Icons.share),
                      label: const Text('Share Images'),
                    ),
                    if (state.result!.zipPath != null)
                      OutlinedButton.icon(
                        onPressed: controller.shareZip,
                        icon: const Icon(Icons.archive),
                        label: const Text('Share ZIP'),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: state.result!.outputPaths
                        .map((path) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(File(path)),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
