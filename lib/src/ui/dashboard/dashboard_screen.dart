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
import '../browser/key_browser_screen.dart' show KeyBrowserScreen;
import '../connection/repository/connection_repository.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late Future<Map<String, String>> _infoFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final repo = ref.read(connectionRepositoryProvider);
    setState(() {
      _infoFuture = repo.getInfo();
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.list_alt),
              tooltip: 'Data Explorer',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<DashboardScreen>(
                    builder: (context) => const KeyBrowserScreen(),
                  ),
                );
              },
            ),
            IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
            IconButton(
              icon: const Icon(Icons.power_settings_new),
              onPressed: () {
                ref.read(connectionRepositoryProvider).disconnect();
                Navigator.of(context).pop(); // Go back to Home
              },
              tooltip: 'Disconnect',
            ),
          ],
        ),
        body: FutureBuilder<Map<String, String>>(
          future: _infoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text('Error fetching INFO: ${snapshot.error}'),
                    TextButton(onPressed: _refresh, child: const Text('Retry')),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('No info available'));
            }

            final info = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle('Server'),
                  _buildInfoGrid([
                    _InfoItem(
                      'Version',
                      info['valkey_version'] ?? info['redis_version'] ?? 'N/A',
                    ),
                    _InfoItem('OS', info['os'] ?? 'N/A'),
                    _InfoItem('Port', info['tcp_port'] ?? 'N/A'),
                    _InfoItem('Uptime', '${info['uptime_in_days']} days'),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Memory'),
                  _buildInfoGrid([
                    _InfoItem(
                        'Used Memory', info['used_memory_human'] ?? 'N/A'),
                    _InfoItem(
                      'Peak Memory',
                      info['used_memory_peak_human'] ?? 'N/A',
                    ),
                    _InfoItem(
                      'Frag Ratio',
                      info['mem_fragmentation_ratio'] ?? 'N/A',
                    ),
                  ]),
                  const SizedBox(height: 24),
                  _buildSectionTitle('Stats'),
                  _buildInfoGrid([
                    _InfoItem(
                      'Connected Clients',
                      info['connected_clients'] ?? 'N/A',
                    ),
                    _InfoItem(
                      'Total Connections',
                      info['total_connections_received'] ?? 'N/A',
                    ),
                    _InfoItem(
                      'Total Commands',
                      info['total_commands_processed'] ?? 'N/A',
                    ),
                  ]),
                ],
              ),
            );
          },
        ),
      );

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
      );

  Widget _buildInfoGrid(List<_InfoItem> items) => GridView.count(
        crossAxisCount: 4, // Adjust for desktop width
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // children: items.map((item) => _buildCard(item)).toList(),
        children: items.map(_buildCard).toList(),
      );

  Widget _buildCard(_InfoItem item) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF2B2D30),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF3F4246)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              item.label,
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              item.value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
}

class _InfoItem {
  final String label;
  final String value;
  _InfoItem(this.label, this.value);
}
