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
import '../widgets/dotted_box.dart' show DottedBox;
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
  // final List<ConnectionConfig> _savedConnections = [
  //   ConnectionConfig(id: '1', name: 'myRedis-Local', port: 6379),
  //   ConnectionConfig(id: '2', name: 'myValkey-Local', port: 6379),
  //   ConnectionConfig(id: '3', name: 'myDragonfly-Local', port: 6379),
  //   ConnectionConfig(
  //     id: '4',
  //     name: 'Production-Cluster',
  //     host: '127.0.0.1',
  //     port: 7001,
  //   ),
  // ];

  ConnectionConfig? _selectedConfig;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  bool _isConfirmPasswordObscured = true;

  // final ScrollController _connectionScrollController = ScrollController();
  late ScrollController _connectionScrollController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _hostController = TextEditingController();
    _portController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _connectionScrollController = ScrollController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _connectionScrollController.dispose();
    super.dispose();
  }

  void _selectConfig(ConnectionConfig config) {
    setState(() {
      _selectedConfig = config;
      _nameController.text = config.name;
      _hostController.text = config.host;
      _portController.text = config.port.toString();
      _usernameController.text = config.username ?? '';
      _passwordController.text = config.password ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final connectionsAsync = ref.watch(connectionsProvider);

    return Dialog(
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
              child: _buildSidebar(connectionsAsync),
            ),
            const VerticalDivider(width: 1, color: Color(0xFF3F4246)),
            // [Right Panel] Connection Form
            Expanded(flex: 2, child: _buildFormPanel()),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(AsyncValue<List<ConnectionConfig>> connectionsAsync) =>
      Container(
        // color: const Color(0xFF2B2D30), // NOTE: Do not use for now.
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
                    tooltip: I18n.of(context).createNewConnection,
                    onPressed: _addNewConnection,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, color: Color(0xFF3F4246)),
            Expanded(
              child: connectionsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
                data: (connections) => ListView.builder(
                  cacheExtent: 5000.0, // NOTE: Tune (+/-).
                  controller: _connectionScrollController,
                  itemCount: connections.length,
                  itemBuilder: (context, index) {
                    final config = connections[index];
                    final isSelected = config.id == _selectedConfig?.id;
                    return ListTile(
                      title: Text(
                        config.name,
                        style: const TextStyle(fontSize: 13),
                      ),
                      dense: true,
                      selected: isSelected,
                      selectedTileColor: const Color(0xFF393B40),
                      selectedColor: Colors.white,
                      onTap: () => _selectConfig(config),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                          color: Colors.grey,
                        ),
                        onPressed: () => _removeConnection(config.id),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        tooltip: I18n.of(context).delete,
                      ),
                    );
                  },
                ),
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
            child: _selectedConfig == null
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          child:
                              // Container(
                              //   width: 80,
                              //   height: 80,
                              //   decoration: BoxDecoration(
                              //     border: Border.all(
                              //       color: Colors.grey,
                              //       style: BorderStyle.solid,
                              //     ),
                              //   ),
                              //   child: const Center(
                              //     child: Icon(
                              //       Icons.add,
                              //       size: 48,
                              //       color: Colors.grey,
                              //     ),
                              //   ),
                              // ),
                              const DottedBox(size: 80),
                          onTap: _addNewConnection,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          I18n.of(context).selectConnectionToViewDetails,
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSectionHeader(I18n.of(context).general),
                          _buildTextField(
                              I18n.of(context).name, _nameController),
                          const SizedBox(height: 16),
                          _buildSectionHeader(
                              I18n.of(context).connectionDetails),
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
                              I18n.of(context).username, _usernameController,
                              defaultLabelText: 'default',
                              prefixIcon: const Icon(Icons.person)),
                          const SizedBox(height: 16),
                          _buildTextField(
                            I18n.of(context).password,
                            _passwordController,
                            obscureText: _isConfirmPasswordObscured,
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(_isConfirmPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(() =>
                                  _isConfirmPasswordObscured =
                                      !_isConfirmPasswordObscured),
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildSectionHeader(I18n.of(context).advanced),
                          CheckboxListTile(
                            title: Text(
                              I18n.of(context).useSshTunneling,
                              style: const TextStyle(fontSize: 13),
                            ),
                            value: _selectedConfig!.useSsh,
                            onChanged: (val) {
                              setState(() {
                                _selectedConfig = _selectedConfig!
                                    .copyWith(useSsh: val ?? false);
                              });
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
                  onPressed: _selectedConfig == null ? null : _testConnection,
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
                      onPressed:
                          _selectedConfig == null ? null : _handleConnect,
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
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? defaultLabelText,
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
            decoration: InputDecoration(
              prefixIcon: prefixIcon,
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border: const OutlineInputBorder(),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF6B6F77)),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF3574F0)),
              ),
              // NOTE: Use hintText instead of labelText(w/o font style).
              // labelText: defaultLabelText,
              hintText: defaultLabelText,
              suffixIcon: suffixIcon,
            ),
          ),
        ],
      );

  // --- Actions ---

  /// Add a blank new connection to the list, then select it.
  void _addNewConnection() {
    final newConfig = ConnectionConfig(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
    );
    ref.read(connectionsProvider.notifier).addConnection(newConfig);
    _selectConfig(newConfig);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // NOTE: Style 1
      // _connectionScrollController.animateTo(
      //   _connectionScrollController.position.maxScrollExtent,
      //   duration: const Duration(milliseconds: 300),
      //   curve: Curves.easeOut,
      // );
      // NOTE: Style 2
      _connectionScrollController.jumpTo(
        _connectionScrollController.position.maxScrollExtent,
      );
    });
  }

  /// Remove a connection by id.
  void _removeConnection(String id) {
    ref.read(connectionsProvider.notifier).removeConnection(id);
    if (_selectedConfig?.id == id) {
      setState(() => _selectedConfig = null);
    }
  }

  /// Sync controller values back to _selectedConfig, then persist.
  ///
  /// Update _selectedConfig with sanitized values from controllers.
  /// - NOTE: All inputs are trimmed to avoid leading/trailing whitespace issues.
  ///
  /// ```dart
  /// name: _sanitize( ... text.trim() ),
  ///  |
  /// password: _sanitize( ... text.trim() ),
  /// ```
  void _syncAndSave() {
    if (_selectedConfig == null) return;
    final updated = _selectedConfig!.copyWith(
      name: _sanitize(_nameController.text),
      host: _sanitize(_hostController.text),
      port: int.tryParse(_sanitize(_portController.text)) ?? 6379,
      username: _sanitize(_usernameController.text),
      // NOTE: Always trim the password input.
      // Without trimming, leading/trailing spaces may cause authentication
      // mismatches.
      password: _sanitize(_passwordController.text),
    );
    _selectedConfig = updated;
    ref.read(connectionsProvider.notifier).updateConnection(updated);
  }

  /// Helper: remove all leading/trailing whitespace characters.
  /// This covers normal spaces, tabs, newlines, non-breaking spaces,
  /// full-width spaces, etc.
  String _sanitize(String input) => input.replaceAll(RegExp(r'^\s+|\s+$'), '');

  Future<void> _connectToRepo() async {
    _syncAndSave();
    final config = _selectedConfig!;
    final repo = ref.read(connectionRepositoryProvider);
    return repo.connect(
      host: config.host,
      port: config.port,
      // NOTE: If the username is empty (length == 0),
      // defaulting to "default" is required for proper authentication.
      username: config.username?.isEmpty ?? true ? 'default' : config.username,
      password: config.password,
    );
  }

  Future<void> _handleConnect() async {
    try {
      // Show loading indicator
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(I18n.of(context).connecting),
          duration: const Duration(milliseconds: 500),
        ),
      );

      await _connectToRepo();

      if (!mounted) return;

      // Navigate to Dashboard
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
  }

  Future<void> _testConnection() async {
    try {
      await _connectToRepo();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '✅ ${I18n.of(context).connectionSuccessful1} '
            '(SSH: ${_selectedConfig!.useSsh})',
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
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
