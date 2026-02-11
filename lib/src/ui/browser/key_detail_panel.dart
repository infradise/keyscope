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

// import 'package:dense_table/dense_table.dart' show DenseStyle, DenseTable;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../i18n.dart' show I18n;
import '../connection/repository/connection_repository.dart';
import 'logic/key_browser_provider.dart'; // Required to refresh the list after deletion

final keyDetailProvider =
    FutureProvider.family.autoDispose<KeyDetail, String>((ref, key) {
  final repo = ref.watch(connectionRepositoryProvider);
  return repo.getKeyDetail(key);
});

class KeyDetailPanel extends ConsumerStatefulWidget {
  final String? selectedKey;

  const KeyDetailPanel({super.key, required this.selectedKey});

  @override
  ConsumerState<KeyDetailPanel> createState() => _KeyDetailPanelState();
}

class _KeyDetailPanelState extends ConsumerState<KeyDetailPanel> {
  bool _isEditing = false;
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _valueController = TextEditingController();
  }

  @override
  void dispose() {
    _valueController.dispose();
    super.dispose();
  }

  // Exit editing mode automatically when the selected key changes
  @override
  void didUpdateWidget(covariant KeyDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedKey != widget.selectedKey) {
      _isEditing = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedKey == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icons.data_object
            const Icon(Icons.touch_app, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            Text(I18n.of(context).selectKeyToViewDetails,
                style: const TextStyle(color: Colors.grey)),
          ],
        ),
      );
    }

    final asyncValue = ref.watch(keyDetailProvider(widget.selectedKey!));

    return Container(
      color: const Color(0xFF1E1F22), // Editor BG
      child: asyncValue.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
            child:
                Text('Error: $err', style: const TextStyle(color: Colors.red))),
        // data: _buildDetailView,
        data: (detail) {
          // Initialize controller value only once when entering edit mode
          if (_isEditing &&
              _valueController.text.isEmpty &&
              detail.value is String) {
            _valueController.text = detail.value.toString();
          }
          return _buildDetailView(detail);
        },
      ),
    );
  }

  Widget _buildDetailView(KeyDetail detail) => Column(
        children: [
          // [Header] Key Name, Type, TTL, Actions Toolbar
          Container(
            padding: const EdgeInsets.all(12), // 16
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Color(0xFF3F4246))),
              color: Color(0xFF2B2D30),
            ),
            child: Row(
              children: [
                // Type Badge
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
                // Key Name
                Expanded(
                  child: Text(detail.key,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis),
                ),
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  detail.ttl == -1 ? 'Forever' : '${detail.ttl}s',
                  style: const TextStyle(color: Colors.grey),
                ),

                // --- Type Specific Actions ---

                // Actions: Edit/Save (Only for String type in v0.4.0)
                if (detail.type == 'string') ...[
                  IconButton(
                    icon: Icon(_isEditing ? Icons.save : Icons.edit),
                    tooltip: _isEditing ? 'Save Changes' : 'Edit Value',
                    color: _isEditing ? Colors.green : Colors.grey,
                    onPressed: () => _handleEdit(detail),
                  ),
                  if (_isEditing)
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: I18n.of(context).cancel,
                      onPressed: () {
                        setState(() {
                          _isEditing = false;
                          _valueController.clear();
                        });
                      },
                    ),
                ],
                const SizedBox(width: 8),

                // Action: Delete (Delete Key Action)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  tooltip: 'Delete Key',
                  onPressed: () => _handleDelete(detail.key),
                ),
              ],
            ),
          ),

          // [Body] Value Viewer -- v0.3.x
          // Expanded(
          //   child: SingleChildScrollView(
          //     padding: const EdgeInsets.all(16),
          //     child: SizedBox(
          //       width: double.infinity,
          //       child: _buildValueContent(detail), // full
          //     ),
          //   ),
          // ),

          // [Body] Value Editor / Viewer -- v0.4.0
          Expanded(
            // child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _isEditing && detail.type == 'string'
                  ? TextField(
                      controller: _valueController,
                      maxLines: null,
                      style: const TextStyle(fontFamily: 'monospace'),
                      decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: I18n.of(context).enterStringValue,
                      ),
                    )
                  : SizedBox(
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: _buildValueContent(detail),
                      ),
                    ),
            ),
          ),
        ],
      );

  // _buildValueDisplay
  Widget _buildValueContent(KeyDetail detail) {
    if (detail.value == null) {
      return const Text('nil', style: TextStyle(color: Colors.grey));
    }

    // Handle Map (Hash)
    if (detail.value is Map) {
      final map = detail.value as Map;
      if (map.isEmpty) return const Text('(Empty Hash)');
      // TODO: change to dense_table
      return DataTable(
        columns: [
          DataColumn(label: Text(I18n.of(context).field)),
          DataColumn(label: Text(I18n.of(context).value))
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

    // if (detail.type == 'string') {}
    // if (detail.value is String) {}

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
      case 'ReJSON-RL':
        return Colors.brown;
      default:
        print('Type: $type');
        return Colors.grey;
    }
  }

  Future<void> _handleEdit(KeyDetail detail) async {
    if (!_isEditing) {
      setState(() => _isEditing = true);
      return;
    }

    // Save Logic
    try {
      final repo = ref.read(connectionRepositoryProvider);
      await repo.setStringValue(detail.key, _valueController.text,
          ttl: detail.ttl);
      _showSuccess('Value updated!');



      setState(() => _isEditing = false);

      // Refresh the UI to show new value
      // -- final newValue = ref.refresh(keyDetailProvider(detail.key));
      // -- await ref.refresh(keyDetailProvider(detail.key).future);
      // This resets the provider state, triggering a re-fetch in the build
      // method.
      ref.invalidate(keyDetailProvider(detail.key));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
    }
  }

  Future<void> _handleDelete(String key) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(I18n.of(context).deleteKey),
        content: Text('Are you sure you want to delete "$key"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(I18n.of(context).cancel)),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(I18n.of(context).delete,
                  style: const TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        final repo = ref.read(connectionRepositoryProvider);
        await repo.deleteKey(key);

        if (!mounted) return;
        // Refresh the key list in the browser
        await ref.read(keyBrowserProvider.notifier).refresh();

        // TODO: Need to clear the detail panel here,
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
