import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/app_providers.dart';
import '../../utils/formatters.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_background.dart';
import 'conversion_settings_screen.dart';
import 'preview_screen.dart';
import 'progress_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(appControllerProvider);
    final controller = ref.read(appControllerProvider.notifier);

    ref.listen(appControllerProvider.select((v) => v.error), (prev, next) {
      if (next != null && next.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(next)));
      }
    });

    return GradientBackground(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PDF to Image Studio', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            GlassCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilledButton.icon(
                    onPressed: controller.pickPdf,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: const Text('Upload PDF'),
                  ),
                  if (state.pdf != null) ...[
                    const SizedBox(height: 12),
                    Text('File: ${state.pdf!.name}'),
                    Text('Size: ${formatBytes(state.pdf!.sizeBytes)}'),
                    Text('Pages: ${state.pdf!.pages}'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ConversionSettingsScreen()),
                          ),
                          child: const Text('Settings'),
                        ),
                        OutlinedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const PreviewScreen()),
                          ),
                          child: const Text('Live Preview'),
                        ),
                        FilledButton(
                          onPressed: () async {
                            await controller.convert();
                            if (context.mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const ProgressScreen()),
                              );
                            }
                          },
                          child: const Text('Convert Now'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(duration: 300.ms).slideY(begin: .1),
            const SizedBox(height: 16),
            Expanded(
              child: GlassCard(
                child: state.pdf == null
                    ? const Center(child: Text('Upload a PDF to unlock advanced conversion tools.'))
                    : ListView(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.auto_awesome),
                            title: const Text('Smart auto naming'),
                            subtitle: Text('Next output: ${state.pdf!.name.replaceAll('.pdf', '')}_page_001'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.bolt),
                            title: const Text('Background processing via isolates'),
                            subtitle: const Text('CPU-heavy image processing off UI thread'),
                          ),
                          ListTile(
                            leading: const Icon(Icons.compress),
                            title: Text('Format: ${state.settings.imageFormat.name.toUpperCase()}'),
                            subtitle: Text('DPI ${state.settings.dpi} • Quality ${state.settings.quality}%'),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
