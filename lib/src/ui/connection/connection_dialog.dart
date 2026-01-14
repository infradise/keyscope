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

import '../dashboard/dashboard_screen.dart';
import 'model/connection_config.dart';
import 'repository/connection_repository.dart';

class ConnectionDialog extends ConsumerStatefulWidget {
  const ConnectionDialog({super.key});

  @override
  ConsumerState<ConnectionDialog> createState() => _ConnectionDialogState();
}

class _ConnectionDialogState extends ConsumerState<ConnectionDialog> {
  // Temporary list for UI demonstration
  final List<ConnectionConfig> _savedConnections = [
    ConnectionConfig(id: '1', name: 'myRedis-Local', port: 6379),
    ConnectionConfig(
        id: '2', name: 'Production-Cluster', host: '127.0.0.1', port: 7001),
  ];

  late ConnectionConfig _selectedConfig;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _selectedConfig = _savedConnections.first;
  }

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: const Color(0xFF2B2D30), // Grey Panel
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: SizedBox(
          width: 900,
          height: 600,
          child: Row(
            children: [
              // [Left Panel] Saved Connections List
              Expanded(
                flex: 1,
                child: _buildSidebar(),
              ),
              const VerticalDivider(width: 1, color: Color(0xFF3F4246)),
              // [Right Panel] Connection Form
              Expanded(
                flex: 2,
                child: _buildFormPanel(),
              ),
            ],
          ),
        ),
      );

  Widget _buildSidebar() => Container(
        color: const Color(0xFF2B2D30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.storage, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  const Text('Connections',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add, size: 20),
                    onPressed: () {
                      // TODO: Add connection logic
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF3F4246)),
            Expanded(
              child: ListView.builder(
                itemCount: _savedConnections.length,
                itemBuilder: (context, index) {
                  final config = _savedConnections[index];
                  final isSelected = config == _selectedConfig;
                  return ListTile(
                    title:
                        Text(config.name, style: const TextStyle(fontSize: 13)),
                    dense: true,
                    selected: isSelected,
                    selectedTileColor:
                        const Color(0xFF393B40), // Selection color
                    selectedColor: Colors.white,
                    onTap: () {
                      setState(() {
                        _selectedConfig = config;
                      });
                    },
                  );
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildFormPanel() => Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Text(
                  'Edit Connection',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400]),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFF3F4246)),

          // Form Fields
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('General'),
                    _buildTextField('Name', _selectedConfig.name),
                    const SizedBox(height: 16),
                    _buildSectionHeader('Connection Details'),
                    Row(
                      children: [
                        Expanded(
                            flex: 3,
                            child:
                                _buildTextField('Host', _selectedConfig.host)),
                        const SizedBox(width: 16),
                        Expanded(
                            flex: 1,
                            child: _buildTextField(
                                'Port', _selectedConfig.port.toString())),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Username', _selectedConfig.username ?? ''),
                    const SizedBox(height: 16),
                    _buildTextField('Password', _selectedConfig.password ?? '',
                        obscureText: true),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Advanced'),
                    CheckboxListTile(
                      title: const Text('Use SSH Tunneling',
                          style: TextStyle(fontSize: 13)),
                      value: _selectedConfig.useSsh,
                      onChanged: (val) {
                        setState(() => _selectedConfig.useSsh = val!);
                      },
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Footer Actions
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Color(0xFF3F4246))),
              color: Color(0xFF2B2D30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _testConnection,
                  child: const Text('Test Connection'),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () async {
                        final repo = ref.read(connectionRepositoryProvider);
                        
                        try {
                          // 1. Show loading indicator
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Connecting...'), 
                                duration: Duration(milliseconds: 500)),
                          );

                          // 2. Connect
                          await repo.connect(
                            host: _selectedConfig.host,
                            port: _selectedConfig.port,
                            username: _selectedConfig.username,
                            password: _selectedConfig.password,
                          );

                          if (!mounted) return;

                          // 3. Navigate to Dashboard
                          Navigator.of(context).pop(); // Close Dialog
                          await Navigator.of(context).push(
                            MaterialPageRoute<DashboardScreen>(
                              builder: (context) => const DashboardScreen()),
                          );
                          
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('❌ Error: $e'), 
                                backgroundColor: Colors.red),
                          );
                        }
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildSectionHeader(String title) => Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Text(
          title,
          style: const TextStyle(
              color: Color(0xFF5F6B7C),
              fontWeight: FontWeight.bold,
              fontSize: 12),
        ),
      );

  Widget _buildTextField(String label, String initialValue,
          {bool obscureText = false}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 12, color: Color(0xFFBBBBBB))),
          const SizedBox(height: 6),
          TextFormField(
            initialValue: initialValue,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF6B6F77))),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF3574F0))),
            ),
          ),
        ],
      );

  Future<void> _testConnection() async {
    final repo = ref.read(connectionRepositoryProvider);

    try {
      await repo.connect(
        host: _selectedConfig.host,
        port: _selectedConfig.port,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('✅ Connection Successful! (SSH: ${_selectedConfig.useSsh})'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
