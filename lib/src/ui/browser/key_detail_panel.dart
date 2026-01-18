/*
 * Copyright 2025-2026 Infradise Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../connection/repository/connection_repository.dart';

// Simple provider to verify functionality (Optimized for v0.3.0)
final keyDetailProvider =
    FutureProvider.family.autoDispose<KeyDetail, String>((ref, key) {
  final repo = ref.watch(connectionRepositoryProvider);
  return repo.getKeyDetail(key);
});

class KeyDetailPanel extends ConsumerWidget {
  final String? selectedKey;

  const KeyDetailPanel({super.key, required this.selectedKey});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (selectedKey == null) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icons.data_object
            Icon(Icons.touch_app, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('Select a key to view details',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final asyncValue = ref.watch(keyDetailProvider(selectedKey!));

    return Container(
      color: const Color(0xFF1E1F22), // Editor BG
      child: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
            child:
                Text('Error: $err', style: const TextStyle(color: Colors.red))),
        // data: (detail) => _buildDetailView(detail),
        data: _buildDetailView,
      ),
    );
  }

  Widget _buildDetailView(KeyDetail detail) => Column(
        children: [
          // [Header] Key Name, Type, TTL
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF3F4246))),
              color: Color(0xFF2B2D30),
            ),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTypeColor(detail.type),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(detail.type.toUpperCase(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    detail.key,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  detail.ttl == -1 ? 'Forever' : '${detail.ttl}s',
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // [Body] Value Viewer
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: _buildValueContent(detail),
              ),
            ),
          ),
        ],
      );

  Widget _buildValueContent(KeyDetail detail) {
    if (detail.value == null) {
      return const Text('nil', style: TextStyle(color: Colors.grey));
    }

    // Handle Map (Hash)
    if (detail.value is Map) {
      final map = detail.value as Map;
      if (map.isEmpty) return const Text('(Empty Hash)');
      return DataTable(
        columns: const [
          DataColumn(label: Text('Field')),
          DataColumn(label: Text('Value'))
        ],
        rows: map.entries
            .map((e) => DataRow(cells: [
                  DataCell(Text(e.key.toString())),
                  DataCell(Text(e.value.toString())),
                ]))
            .toList(),
      );
    }

    // Handle List/Set
    if (detail.value is List) {
      final list = detail.value as List;
      if (list.isEmpty) return const Text('(Empty List/Set)');
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: list
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('[${e.key}] ',
                          style: const TextStyle(color: Colors.grey)),
                      Expanded(child: SelectableText(e.value.toString())),
                    ],
                  ),
                ))
            .toList(),
      );
    }

    // Default (String)
    return SelectableText(
      detail.value.toString(),
      style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
    );
  }

  Color _getTypeColor(String type) {
    switch (type) {
      case 'string':
        return Colors.blue;
      case 'hash':
        return Colors.green;
      case 'list':
        return Colors.orange;
      case 'set':
        return Colors.purple;
      case 'zset':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
