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

import 'dialog/create_key_dialog.dart';
import 'key_detail_panel.dart';
import 'logic/key_browser_provider.dart';

class KeyBrowserScreen extends ConsumerStatefulWidget {
  const KeyBrowserScreen({super.key});

  @override
  ConsumerState<KeyBrowserScreen> createState() => _KeyBrowserScreenState();
}

class _KeyBrowserScreenState extends ConsumerState<KeyBrowserScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController(
    text: '*',
  );

  String? _selectedKey;

  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(keyBrowserProvider.notifier).refresh();
    });

    // Setup infinite scroll listener
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        ref.read(keyBrowserProvider.notifier).loadMore();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final browserState = ref.watch(keyBrowserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref
                  .read(keyBrowserProvider.notifier)
                  .refresh(pattern: _searchController.text);
            },
          ),
        ],
      ),
      // Add Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final success = await showDialog<bool>(
            context: context,
            builder: (context) => const CreateKeyDialog(),
          );

          if (success ?? false) {
            // Refresh list on success
            await ref.read(keyBrowserProvider.notifier).refresh();

            if (!mounted) return;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Key created successfully!'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        tooltip: 'Create New Key',
        child: const Icon(Icons.add),
      ),
      body: Row(
        children: [
          // [Left Panel] Key List
          Container(
            width: 300,
            decoration: const BoxDecoration(
              border: Border(right: BorderSide(color: Color(0xFF3F4246))),
            ),
            child: Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search keys (e.g. user:*)',
                      prefixIcon: const Icon(Icons.search, size: 18),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.arrow_forward),
                        onPressed: () {
                          ref
                              .read(keyBrowserProvider.notifier)
                              .refresh(pattern: _searchController.text);
                        },
                      ),
                    ),
                    onSubmitted: (value) {
                      ref
                          .read(keyBrowserProvider.notifier)
                          .refresh(pattern: value);
                    },
                  ),
                ),
                const Divider(height: 1),

                // Key List View
                Expanded(
                  child: browserState.isLoading && browserState.keys.isEmpty
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount:
                              browserState.keys.length +
                              (browserState.cursor != '0' ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Loading indicator at bottom
                            if (index == browserState.keys.length) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            }

                            final key = browserState.keys[index];
                            return ListTile(
                              title: Text(
                                key,
                                style: const TextStyle(fontSize: 13),
                              ),
                              dense: true,
                              // Add Selection Color
                              selected: _selectedKey == key,
                              selectedTileColor: const Color(0xFF393B40),
                              onTap: () {
                                // Select key and show value editor
                                // print('Selected key: $key');
                                setState(() {
                                  _selectedKey = key;
                                });
                              },
                            );
                          },
                        ),
                ),

                // Footer Status
                Container(
                  padding: const EdgeInsets.all(8),
                  color: const Color(0xFF2B2D30),
                  child: Row(
                    children: [
                      Text(
                        '${browserState.keys.length} keys loaded',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // [Right Panel] Value Editor (Placeholder)
          Expanded(
            // child: Center(
            //   child: Column(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: [
            //       const Icon(
            //         Icons.data_object, size: 64, color: Colors.grey),
            //       const SizedBox(height: 16),
            //       const Text('Select a key to view details'),
            //       if (browserState.error != null)
            //         Padding(
            //           padding: const EdgeInsets.only(top: 16),
            //           child: Text('Error: ${browserState.error}',
            //               style: const TextStyle(color: Colors.red)),
            //         )
            //     ],
            //   ),
            // ),
            child: KeyDetailPanel(selectedKey: _selectedKey),
          ),
        ],
      ),
    );
  }
}
