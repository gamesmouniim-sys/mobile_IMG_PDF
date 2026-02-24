import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/di/app_providers.dart';
import '../../domain/entities/conversion_settings.dart';
import '../widgets/gradient_background.dart';

class ConversionSettingsScreen extends ConsumerStatefulWidget {
  const ConversionSettingsScreen({super.key});

  @override
  ConsumerState<ConversionSettingsScreen> createState() => _ConversionSettingsScreenState();
}

class _ConversionSettingsScreenState extends ConsumerState<ConversionSettingsScreen> {
  late ConversionSettings _settings;
  late TextEditingController _range;
  late TextEditingController _customDpi;
  late TextEditingController _watermark;

  @override
  void initState() {
    super.initState();
    _settings = ref.read(appControllerProvider).settings;
    _range = TextEditingController(text: _settings.pageRanges);
    _customDpi = TextEditingController(text: _settings.dpi.toString());
    _watermark = TextEditingController(text: _settings.watermark);
  }

  @override
  void dispose() {
    _range.dispose();
    _customDpi.dispose();
    _watermark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text('Conversion Settings'), backgroundColor: Colors.transparent),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            SwitchListTile(
              value: _settings.convertAll,
              onChanged: (v) => setState(() => _settings = _settings.copyWith(convertAll: v)),
              title: const Text('Convert all pages'),
            ),
            TextField(
              controller: _range,
              enabled: !_settings.convertAll,
              decoration: const InputDecoration(labelText: 'Page ranges (e.g., 1-5,8,10-15)'),
            ),
            DropdownButtonFormField<ImageFormat>(
              value: _settings.imageFormat,
              items: ImageFormat.values
                  .map((e) => DropdownMenuItem(value: e, child: Text(e.name.toUpperCase())))
                  .toList(),
              onChanged: (v) => setState(() => _settings = _settings.copyWith(imageFormat: v)),
              decoration: const InputDecoration(labelText: 'Output format'),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<int>(
              value: [72, 150, 300].contains(_settings.dpi) ? _settings.dpi : 0,
              items: const [
                DropdownMenuItem(value: 72, child: Text('72 DPI')),
                DropdownMenuItem(value: 150, child: Text('150 DPI')),
                DropdownMenuItem(value: 300, child: Text('300 DPI')),
                DropdownMenuItem(value: 0, child: Text('Custom DPI')),
              ],
              onChanged: (v) {
                if (v != null && v != 0) {
                  setState(() {
                    _settings = _settings.copyWith(dpi: v);
                    _customDpi.text = v.toString();
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Resolution'),
            ),
            TextField(
              controller: _customDpi,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Custom DPI'),
            ),
            const SizedBox(height: 8),
            Text('Quality ${_settings.quality}%'),
            Slider(
              value: _settings.quality.toDouble(),
              min: 0,
              max: 100,
              onChanged: (v) => setState(() => _settings = _settings.copyWith(quality: v.toInt())),
            ),
            SwitchListTile(
              value: _settings.grayscale,
              onChanged: (v) => setState(() => _settings = _settings.copyWith(grayscale: v)),
              title: const Text('Grayscale mode'),
            ),
            SwitchListTile(
              value: _settings.optimizeCompression,
              onChanged: (v) => setState(() => _settings = _settings.copyWith(optimizeCompression: v)),
              title: const Text('Compression optimization'),
            ),
            TextField(
              controller: _watermark,
              decoration: const InputDecoration(labelText: 'Watermark text'),
            ),
            Text('Watermark opacity ${(_settings.watermarkOpacity * 100).round()}%'),
            Slider(
              value: _settings.watermarkOpacity,
              min: 0,
              max: 1,
              onChanged: (v) => setState(() => _settings = _settings.copyWith(watermarkOpacity: v)),
            ),
            FilledButton(
              onPressed: () {
                final dpi = int.tryParse(_customDpi.text) ?? _settings.dpi;
                final finalSettings = _settings.copyWith(
                  pageRanges: _range.text,
                  dpi: dpi,
                  watermark: _watermark.text,
                );
                ref.read(appControllerProvider.notifier).updateSettings(finalSettings);
                Navigator.pop(context);
              },
              child: const Text('Save Settings'),
            )
          ],
        ),
      ),
    );
  }
}
