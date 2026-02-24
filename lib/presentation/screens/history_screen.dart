import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/di/app_providers.dart';
import '../../domain/entities/history_entry.dart';
import '../widgets/gradient_background.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GradientBackground(
      child: FutureBuilder<List<HistoryEntry>>(
        future: ref.read(appControllerProvider.notifier).history(),
        builder: (context, snapshot) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(title: const Text('Conversion History'), backgroundColor: Colors.transparent),
            body: snapshot.connectionState != ConnectionState.done
                ? const Center(child: CircularProgressIndicator())
                : (snapshot.data ?? []).isEmpty
                    ? const Center(child: Text('No conversions yet.'))
                    : ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, i) {
                          final item = snapshot.data![i];
                          return ListTile(
                            title: Text(item.sourceName),
                            subtitle: Text('${item.totalPages} pages • ${item.format.toUpperCase()}'),
                            trailing: Text(DateFormat('MMM d, HH:mm').format(item.createdAt)),
                          );
                        },
                      ),
          );
        },
      ),
    );
  }
}
