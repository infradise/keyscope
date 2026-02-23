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

final keyDetailProvider = FutureProvider.family.autoDispose<KeyDetail, String>((
  ref,
  key,
) {
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
  // String Edit Controller
  bool _isEditingString = false;
  late TextEditingController _stringValueController;

  @override
  void initState() {
    super.initState();
    _stringValueController = TextEditingController();
  }

  @override
  void dispose() {
    _stringValueController.dispose();
    super.dispose();
  }

  // Exit editing mode automatically when the selected key changes
  @override
  void didUpdateWidget(covariant KeyDetailPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedKey != widget.selectedKey) {
      _isEditingString = false;
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
            Text(
              I18n.of(context).selectKeyToViewDetails,
              style: const TextStyle(color: Colors.grey),
            ),
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
          child: Text('${I18n.of(context).error}: $err',
              style: const TextStyle(color: Colors.red)),
        ),
        // data: _buildDetailView,
        data: (detail) {
          // Initialize controller value only once when entering edit mode
          if (_isEditingString &&
              _stringValueController.text.isEmpty &&
              detail.value is String) {
            _stringValueController.text = detail.value.toString();
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
                  child: Text(
                    detail.type.toUpperCase(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Key Name
                Expanded(
                  child: Text(
                    detail.key,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.timer, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  detail.ttl == -1
                      ? I18n.of(context).forever
                      : '${detail.ttl}s',
                  style: const TextStyle(color: Colors.grey),
                ),

                // --- Type Specific Actions ---

                // Actions: Edit/Save (Only for String type in v0.4.0)
                if (detail.type == 'string') ...[
                  IconButton(
                    icon: Icon(_isEditingString ? Icons.save : Icons.edit),
                    tooltip: _isEditingString
                        ? I18n.of(context).saveChanges
                        : I18n.of(context).editValue,
                    color: _isEditingString ? Colors.green : Colors.grey,
                    onPressed: () => _handleStringEdit(detail),
                  ),
                  if (_isEditingString)
                    IconButton(
                      icon: const Icon(Icons.close),
                      tooltip: I18n.of(context).cancel,
                      onPressed: () {
                        setState(() {
                          _isEditingString = false;
                          _stringValueController.clear();
                        });
                      },
                    ),
                ],
                // Collection Add Actions
                if (detail.type == 'hash')
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: I18n.of(context).addField,
                    onPressed: () => _showAddHashDialog(detail),
                  ),
                if (detail.type == 'list')
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: '${I18n.of(context).addItem} + (RPUSH)',
                    onPressed: () => _showAddListDialog(detail),
                  ),
                if (detail.type == 'set')
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: I18n.of(context).addMember,
                    onPressed: () => _showAddSetDialog(detail),
                  ),
                if (detail.type == 'zset')
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: I18n.of(context).addMember,
                    onPressed: () => _showAddZSetDialog(detail),
                  ),

                const SizedBox(width: 8),

                // Action: Delete (Delete Key Action)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.red,
                  tooltip: I18n.of(context).deleteKey,
                  onPressed: () => _handleDeleteKey(detail.key),
                ),
              ],
            ),
          ),

          // TODO: REMOVE
          // [Body] Value Viewer -- v0.3.x
          // Expanded(
          //   child: SingleChildScrollView(
          //     padding: const EdgeInsets.all(16),
          //     child: SizedBox(
          //       width: double.infinity,
          //       child: _buildValueContent(detail), // -- v0.5.0
          //     ),
          //   ),
          // ),

          // [Body] Value Editor / Viewer -- v0.4.0
          Expanded(
            // child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: _isEditingString && detail.type == 'string'
                  ? TextField(
                      controller: _stringValueController,
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
                        child: _buildBodyContent(detail), // v0.6.0
                      ),
                    ),
            ),
          ),
        ],
      );

  Widget _buildBodyContent(KeyDetail detail) {
    if (detail.value == null) {
      return const Text('nil', style: TextStyle(color: Colors.grey));
    }

    if (_isEditingString && detail.type == 'string') {
      return TextField(
        controller: _stringValueController,
        maxLines: null,
        style: const TextStyle(fontFamily: 'monospace'),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: I18n.of(context).enterStringValue,
        ),
      );
    }

    switch (detail.type) {
      case 'string':
        return SelectableText(
          detail.value.toString(),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 14),
        );
      case 'hash':
        return _buildHashView(detail);

      // return buildHashViewDenseTable2(detail); // TODO: REMOVE
      // return buildHashViewDenseTable1(detail); // TODO: REMOVE
      // --------------------------------
      // TODO: REMOVE
      // case 'list':
      // case 'set':
      // return buildListAndSetView();
      // --------------------------------

      case 'list':
        return _buildListView(detail);
      case 'set':
        return _buildSetView(detail);

      case 'zset':
        return _buildZSetView(detail);
      default:
        return Text(detail.value.toString());

      // TODO: import module and type checker from keyscope_client
      // Redis
      // \ MD: bf, search, timeseries, ReJSON
      // \ DT: bloomfltr, ReJSON-RL
      // Valkey
      // \ MD: json, search, bf, ldap
      // \ DT: bloomfltr
      // Dragonfly
      // \ MD:
      // \ DT:
    }
  }

  // --- Type Specific Views ---

  // Handle Map (Hash)
  Widget _buildHashView(KeyDetail detail) {
    // (X) if (detail.value != Map) return const Text('(Expected hash type)');

    final map = detail.value as Map;
    if (map.isEmpty) return const Text('(Empty Hash)');

    return SingleChildScrollView(
      child: DataTable(
        // TODO: update two modes => datatable and dense_table (for performance)
        columns: [
          DataColumn(label: Text(I18n.of(context).field)),
          DataColumn(label: Text(I18n.of(context).value)),
          DataColumn(label: Text(I18n.of(context).actions)),
        ],
        rows: map.entries.map((e) {
          final field = e.key.toString();
          final value = e.value.toString();
          return DataRow(
            cells: [
              DataCell(
                Text(
                  field,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              DataCell(Text(value)),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 16),
                      onPressed: () =>
                          _showEditHashDialog(detail, field, value),
                      tooltip: I18n.of(context).editValue,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _deleteHashField(detail, field),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  // Handle List/Set
  Widget _buildListView(KeyDetail detail) {
    // (X) if (detail.value != List) return const Text('(Expected list type)');

    final list = detail.value as List;
    if (list.isEmpty) return const Text('(Empty List)');

    return ListView.separated(
      shrinkWrap: true, // NOTE: hasSize
      itemCount: list.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Colors.white10),
      itemBuilder: (context, index) {
        final value = list[index].toString();
        return ListTile(
          dense: true,
          leading: Text('#$index', style: const TextStyle(color: Colors.grey)),
          title: Text(value),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 16),
                onPressed: () => _showEditListDialog(detail, index, value),
                tooltip: I18n.of(context).editValue,
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  size: 16,
                  color: Colors.redAccent,
                ),
                onPressed: () => _deleteListValue(detail, value),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSetView(KeyDetail detail) {
    final list = detail.value as List; // Set comes as list from repo
    if (list.isEmpty) return const Text('(Empty Set)');

    return ListView.separated(
      shrinkWrap: true, // NOTE: hasSize
      itemCount: list.length,
      separatorBuilder: (_, __) =>
          const Divider(height: 1, color: Colors.white10),
      itemBuilder: (context, index) {
        final member = list[index].toString();
        return ListTile(
          dense: true,
          title: Text(member),
          trailing: IconButton(
            icon: const Icon(Icons.delete, size: 16, color: Colors.redAccent),
            onPressed: () => _deleteSetMember(detail, member),
          ),
        );
      },
    );
  }

  Widget _buildZSetView(KeyDetail detail) {
    final list =
        detail.value as List; // ["member", "score", "member", "score"...]
    if (list.isEmpty) return const Text('(Empty ZSet)');

    // Parse flat list into pairs
    final pairs = <MapEntry<String, String>>[];
    for (var i = 0; i < list.length; i += 2) {
      if (i + 1 < list.length) {
        pairs.add(MapEntry(list[i].toString(), list[i + 1].toString()));
      }
    }

    return SingleChildScrollView(
      child: DataTable(
        columns: [
          DataColumn(label: Text(I18n.of(context).score)),
          DataColumn(label: Text(I18n.of(context).member)),
          DataColumn(label: Text(I18n.of(context).actions)),
        ],
        rows: pairs.map((e) {
          final member = e.key;
          final score = e.value;
          return DataRow(
            cells: [
              DataCell(
                Text(score, style: const TextStyle(color: Colors.blueAccent)),
              ),
              DataCell(Text(member)),
              DataCell(
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 16),
                      onPressed: () =>
                          _showEditZSetDialog(detail, member, score),
                      tooltip: I18n.of(context).editValue,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        size: 16,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _deleteZSetMember(detail, member),
                    ),
                  ],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Color _getTypeColor(String type) => switch (type) {
        'string' => Colors.blue,
        'hash' => Colors.green,
        'list' => Colors.orange,
        'set' => Colors.purple,
        'zset' => Colors.indigo,
        'stream' => Colors.blueGrey,
        'vectorset' => Colors.amber,
        'ReJSON-RL' => Colors.brown,
        'MBbloom--' => Colors.pink,
        'MBbloomCF' => Colors.pink,
        'TSDB-TYPE' => Colors.teal,
        'CMSk-TYPE' => Colors.deepPurpleAccent,
        'TopK-TYPE' => Colors.deepPurple,
        'TDIS-TYPE' => Colors.lightBlueAccent,
        _ => () {
            print('Type: $type');
            return Colors.grey;
          }(),
      };

  // --- Actions & Dialogs ---

  Future<void> _handleStringEdit(KeyDetail detail) async {
    if (!_isEditingString) {
      setState(() => _isEditingString = true);
      return;
    }

    // Save Logic
    try {
      final repo = ref.read(connectionRepositoryProvider);
      await repo.setStringValue(
        detail.key,
        _stringValueController.text,
        ttl: detail.ttl,
      );
      _showSuccess(I18n.of(context).valueUpdate1);

      setState(() => _isEditingString = false);

      // Refresh the UI to show new value
      // -- final newValue = ref.refresh(keyDetailProvider(detail.key));
      // -- await ref.refresh(keyDetailProvider(detail.key).future);
      // This resets the provider state, triggering a re-fetch in the build
      // method.

      ref.invalidate(keyDetailProvider(detail.key));
    } catch (e) {
      _showError(e);
    }
  }

  // Generic Dialog Helper
  Future<void> _showInputDialog({
    required String title,
    required List<Widget> inputs,
    required Future<void> Function() onSave,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(mainAxisSize: MainAxisSize.min, children: inputs),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(I18n.of(context).cancel),
          ),
          FilledButton(
            onPressed: () {
              onSave().then((_) => Navigator.pop(context, true));
            },
            child: Text(I18n.of(context).save),
          ),
        ],
      ),
    );
    if (confirm ?? false) {
      ref.invalidate(keyDetailProvider(widget.selectedKey!));
      _showSuccess(I18n.of(context).operationSuccessful);
    }
  }

  // --- HASH Actions ---
  void _showAddHashDialog(KeyDetail detail) {
    final fieldCtrl = TextEditingController();
    final valCtrl = TextEditingController();
    _showInputDialog(
      title: I18n.of(context).addHashField,
      inputs: [
        TextField(
          controller: fieldCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).field),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: valCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).value),
        ),
      ],
      onSave: () async => ref
          .read(connectionRepositoryProvider)
          .setHashField(detail.key, fieldCtrl.text, valCtrl.text),
    );
  }

  void _showEditHashDialog(
    KeyDetail detail,
    String field,
    String currentValue,
  ) {
    final valCtrl = TextEditingController(text: currentValue);
    _showInputDialog(
      title: '${I18n.of(context).editField}: $field',
      inputs: [
        TextField(
          controller: valCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).value),
        ),
      ],
      onSave: () async => ref
          .read(connectionRepositoryProvider)
          .setHashField(detail.key, field, valCtrl.text),
    );
  }

  Future<void> _deleteHashField(KeyDetail detail, String field) async {
    try {
      await ref
          .read(connectionRepositoryProvider)
          .deleteHashField(detail.key, field);
      ref.invalidate(keyDetailProvider(detail.key));
    } catch (e) {
      _showError(e);
    }
  }

  // --- LIST Actions ---
  void _showAddListDialog(KeyDetail detail) {
    final valCtrl = TextEditingController();
    _showInputDialog(
      title: '${I18n.of(context).addListItem} (RPUSH)',
      inputs: [
        TextField(
          controller: valCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).value),
        ),
      ],
      onSave: () async => ref
          .read(connectionRepositoryProvider)
          .addListItem(detail.key, valCtrl.text),
    );
  }

  void _showEditListDialog(KeyDetail detail, int index, String currentValue) {
    final valCtrl = TextEditingController(text: currentValue);
    _showInputDialog(
      title: I18n.of(context).editItemAt(index: index.toString()),
      inputs: [
        TextField(
          controller: valCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).value),
        ),
      ],
      onSave: () async => ref
          .read(connectionRepositoryProvider)
          .updateListItem(detail.key, index, valCtrl.text),
    );
  }

  Future<void> _deleteListValue(KeyDetail detail, String value) async {
    try {
      await ref
          .read(connectionRepositoryProvider)
          .removeListValue(detail.key, value);
      ref.invalidate(keyDetailProvider(detail.key));
    } catch (e) {
      _showError(e);
    }
  }

  // --- SET Actions ---
  void _showAddSetDialog(KeyDetail detail) {
    final valCtrl = TextEditingController();
    _showInputDialog(
      title: I18n.of(context).addSetMember,
      inputs: [
        TextField(
          controller: valCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).member),
        ),
      ],
      onSave: () async => ref
          .read(connectionRepositoryProvider)
          .addSetMember(detail.key, valCtrl.text),
    );
  }

  Future<void> _deleteSetMember(KeyDetail detail, String member) async {
    try {
      await ref
          .read(connectionRepositoryProvider)
          .removeSetMember(detail.key, member);
      ref.invalidate(keyDetailProvider(detail.key));
    } catch (e) {
      _showError(e);
    }
  }

  // --- ZSET Actions ---
  void _showAddZSetDialog(KeyDetail detail) {
    final scoreCtrl = TextEditingController();
    final memCtrl = TextEditingController();
    _showInputDialog(
      title: I18n.of(context).addZSetMember,
      inputs: [
        TextField(
          controller: scoreCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).score),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 8),
        TextField(
          controller: memCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).member),
        ),
      ],
      onSave: () async {
        final score = double.parse(scoreCtrl.text);
        await ref
            .read(connectionRepositoryProvider)
            .addZSetMember(detail.key, score, memCtrl.text);
      },
    );
  }

  void _showEditZSetDialog(
    KeyDetail detail,
    String member,
    String currentScore,
  ) {
    final scoreCtrl = TextEditingController(text: currentScore);
    _showInputDialog(
      title: I18n.of(context).updateScore(member: member),
      inputs: [
        TextField(
          controller: scoreCtrl,
          decoration: InputDecoration(labelText: I18n.of(context).score),
          keyboardType: TextInputType.number,
        ),
      ],
      onSave: () async {
        final score = double.parse(scoreCtrl.text);
        await ref
            .read(connectionRepositoryProvider)
            .addZSetMember(detail.key, score, member);
      },
    );
  }

  Future<void> _deleteZSetMember(KeyDetail detail, String member) async {
    try {
      await ref
          .read(connectionRepositoryProvider)
          .removeZSetMember(detail.key, member);
      ref.invalidate(keyDetailProvider(detail.key));
    } catch (e) {
      _showError(e);
    }
  }

  // --- Common Helpers ---
  Future<void> _handleDeleteKey(String key) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(I18n.of(context).deleteKey),
        content: Text(I18n.of(context).deleteKey2(key: key)),
        // content: Text(
        //     I18n.of(context).areYouSureYouWantToDeleteKey(key: key)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(I18n.of(context).cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              I18n.of(context).delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (confirm ?? false) {
      try {
        // final repo = ref.read(connectionRepositoryProvider);
        // await repo.deleteKey(key);
        await ref.read(connectionRepositoryProvider).deleteKey(key);

        if (!mounted) return;
        // Refresh the key list in the browser
        await ref.read(keyBrowserProvider.notifier).refresh();

        // TODO: Need to clear the detail (right) panel here,
      } catch (e) {
        _showError(e);
      }
    }
  }

  void _showSuccess(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.green));
  }

  void _showError(Object e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${I18n.of(context).error}: $e'),
          backgroundColor: Colors.red),
    );
  }
}
