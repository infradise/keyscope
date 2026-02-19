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

import '../../../i18n.dart' show I18n;
import '../dashboard/dashboard_screen.dart';
import 'connections_provider.dart';
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
    ConnectionConfig(id: '2', name: 'myValkey-Local', port: 6379),
    ConnectionConfig(id: '3', name: 'myDragonfly-Local', port: 6379),
    ConnectionConfig(
      id: '4',
      name: 'Production-Cluster',
      host: '127.0.0.1',
      port: 7001,
    ),
  ];

  late ConnectionConfig _selectedConfig;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _selectedConfig = _savedConnections.first;

    _nameController = TextEditingController(text: _selectedConfig.name);
    _hostController = TextEditingController(text: _selectedConfig.host);
    _portController = TextEditingController(
      text: _selectedConfig.port.toString(),
    );
    _usernameController = TextEditingController(
      text: _selectedConfig.username ?? '',
    );
    _passwordController = TextEditingController(
      text: _selectedConfig.password ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
              Expanded(flex: 1, child: _buildSidebar()),
              const VerticalDivider(width: 1, color: Color(0xFF3F4246)),
              // [Right Panel] Connection Form
              Expanded(flex: 2, child: _buildFormPanel()),
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
                  Text(
                    I18n.of(context).connections,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
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
                  I18n.of(context).editConnection,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[400],
                  ),
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
                    _buildSectionHeader(I18n.of(context).general),
                    _buildTextField(I18n.of(context).name, _nameController),
                    const SizedBox(height: 16),
                    _buildSectionHeader(I18n.of(context).connectionDetails),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _buildTextField(
                              I18n.of(context).host, _hostController),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: _buildTextField(
                              I18n.of(context).port, _portController),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                        I18n.of(context).username, _usernameController),
                    const SizedBox(height: 16),
                    _buildTextField(
                      I18n.of(context).password,
                      _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader(I18n.of(context).advanced),
                    CheckboxListTile(
                      title: Text(
                        I18n.of(context).useSshTunneling,
                        style: const TextStyle(fontSize: 13),
                      ),
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
                  child: Text(I18n.of(context).testConnection),
                ),
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(I18n.of(context).cancel),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                      onPressed: () async {
                        try {
                          // 1. Show loading indicator
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(I18n.of(context).connecting),
                              duration: const Duration(milliseconds: 500),
                            ),
                          );

                          await _connectToRepo();

                          if (!mounted) return;

                          // 3. Navigate to Dashboard
                          Navigator.of(context).pop(); // Close Dialog
                          await Navigator.of(context).push(
                            MaterialPageRoute<DashboardScreen>(
                              builder: (context) => const DashboardScreen(),
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('❌ ${I18n.of(context).error}}: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Text(I18n.of(context).ok),
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
            fontSize: 12,
          ),
        ),
      );

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: Color(0xFFBBBBBB)),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            style: const TextStyle(fontSize: 13),
            decoration: const InputDecoration(
              isDense: true,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6B6F77)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3574F0)),
              ),
            ),
          ),
        ],
      );

  /// Update _selectedConfig with sanitized values from controllers.
  /// NOTE: All inputs are trimmed to avoid leading/trailing whitespace issues.
  void _updateSelectedConfigFromControllers() {
    _selectedConfig.name = _sanitize(_nameController.text.trim());
    _selectedConfig.host = _sanitize(_hostController.text.trim());
    _selectedConfig.port =
        int.tryParse(_sanitize(_portController.text.trim())) ?? 0;
    _selectedConfig.username = _sanitize(_usernameController.text.trim());
    // NOTE: Always trim the password input.
    // Without trimming, leading/trailing spaces may cause authentication mismatches.
    _selectedConfig.password = _sanitize(_passwordController.text.trim());
  }

  /// Helper function to remove all leading/trailing whitespace characters.
  /// This covers normal spaces, tabs, newlines, non-breaking spaces,
  /// full-width spaces, etc.
  String _sanitize(String input) => input.replaceAll(RegExp(r'^\s+|\s+$'), '');

  Future<void> _connectToRepo() async {
    _updateSelectedConfigFromControllers();

    final repo = ref.read(connectionRepositoryProvider);

    return repo.connect(
      host: _selectedConfig.host,
      port: _selectedConfig.port,
      // NOTE: If the username is empty (length == 0),
      // defaulting to "default" is required for proper authentication.
      username: _selectedConfig.username?.isEmpty ?? true
          ? 'default'
          : _selectedConfig.username,
      password: _selectedConfig.password,
    );
  }

  Future<void> _testConnection() async {
    try {
      await _connectToRepo();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${I18n.of(context).connectionSuccessful1} '
            '(SSH: ${_selectedConfig.useSsh})',
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('❌ ${I18n.of(context).error}: $e'),
            backgroundColor: Colors.red),
      );
    }
  }
}
