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

import 'dart:async' show unawaited;

import 'dart:io' show File, InternetAddress, ServerSocket, Socket;
// \ import 'dart:nativewrappers/_internal/vm/bin/common_patch.dart';

// import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart' show SSHClient, SSHKeyPair, SSHSocket;
import 'package:file_picker/file_picker.dart';

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
  ConnectionConfig? _selectedConfig;
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _hostController;
  late TextEditingController _portController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;

  bool _isConfirmPasswordObscured = true;
  bool _isSshKeyPassphraseObscured = true;

  // final ScrollController _connectionScrollController = ScrollController();
  late ScrollController _connectionScrollController;

  late TextEditingController _bastionHostController;
  late TextEditingController _bastionUsernameController;
  late TextEditingController _serverHostController;
  late TextEditingController _serverPortController;
  late TextEditingController _sshKeyFilePathController;
  late TextEditingController _sshKeyPassphraseController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _hostController = TextEditingController();
    _portController = TextEditingController();
    _usernameController = TextEditingController();
    _passwordController = TextEditingController();
    _connectionScrollController = ScrollController();
    _bastionHostController = TextEditingController();
    _bastionUsernameController = TextEditingController();
    _serverHostController = TextEditingController();
    _serverPortController = TextEditingController();
    _sshKeyFilePathController = TextEditingController();
    _sshKeyPassphraseController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _hostController.dispose();
    _portController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _connectionScrollController.dispose();
    _bastionHostController.dispose();
    _bastionUsernameController.dispose();
    _serverHostController.dispose();
    _serverPortController.dispose();
    _sshKeyFilePathController.dispose();
    _sshKeyPassphraseController.dispose();
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

      _bastionHostController.text = config.bastionHost ?? '';
      _bastionUsernameController.text = config.bastionUsername ?? '';
      _serverHostController.text = config.serverHost ?? '';
      _serverPortController.text = config.serverPort.toString();
      _sshKeyFilePathController.text = config.sshKeyFilePath ?? '';
      _sshKeyPassphraseController.text = config.sshKeyPassphrase ?? '';
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

                          // const SizedBox(height: 16),
                          // _buildTextField(
                          //     I18n.of(context).username, _usernameController,
                          //     defaultLabelText: 'default',
                          //     prefixIcon: const Icon(Icons.person)),
                          // const SizedBox(height: 16),
                          // _buildTextField(
                          //   I18n.of(context).password,
                          //   _passwordController,
                          //   obscureText: _isConfirmPasswordObscured,
                          //   prefixIcon: const Icon(Icons.lock),
                          //   suffixIcon: IconButton(
                          //     icon: Icon(_isConfirmPasswordObscured
                          //         ? Icons.visibility_off
                          //         : Icons.visibility),
                          //     onPressed: () => setState(() =>
                          //         _isConfirmPasswordObscured =
                          //             !_isConfirmPasswordObscured),
                          //   ),
                          // ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: _buildTextField(
                                    I18n.of(context).username,
                                    _usernameController,
                                    defaultLabelText: 'default',
                                    prefixIcon: const Icon(Icons.person)),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: _buildTextField(
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
                              ),
                            ],
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

                          // ---------------------------------
                          // SSH Tunneling
                          // ---------------------------------

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildTextField(
                                    I18n.of(context).bastionHost,
                                    _bastionHostController),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: _buildTextField(
                                  I18n.of(context).username,
                                  _bastionUsernameController,
                                  // prefixIcon: const Icon(Icons.person),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: _buildTextField(I18n.of(context).server,
                                    _serverHostController),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 1,
                                child: _buildTextField(I18n.of(context).port,
                                    _serverPortController),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          _buildTextField(
                            I18n.of(context).sshKeyFilePath,
                            _sshKeyFilePathController,
                            prefixIcon: const Icon(Icons.key),
                            suffixIcon: IconButton(
                                icon: const Icon(Icons.folder_outlined),
                                onPressed: chooseSshKeyFile),
                          ),

                          const SizedBox(height: 16),
                          _buildTextField(
                            I18n.of(context).sshKeyPassphrase,
                            _sshKeyPassphraseController,
                            obscureText: _isSshKeyPassphraseObscured,
                            prefixIcon: const Icon(Icons.password),
                            suffixIcon: IconButton(
                              icon: Icon(_isSshKeyPassphraseObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () => setState(() =>
                                  _isSshKeyPassphraseObscured =
                                      !_isSshKeyPassphraseObscured),
                            ),
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
      bastionHost: _sanitize(_bastionHostController.text),
      bastionUsername: _sanitize(_bastionUsernameController.text),
      serverHost: _sanitize(_serverHostController.text),
      serverPort: int.tryParse(_sanitize(_serverPortController.text)) ?? 6379,
      sshKeyFilePath: _sanitize(_sshKeyFilePathController.text),
      sshKeyPassphrase: _sanitize(_sshKeyPassphraseController.text),
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

      // TODO: Consider later if keyscope_client internalize
      //       SSH client's core features.
      // bastionHost: config.bastionHost,
      // bastionUsername: config.bastionUsername,
      // serverHost: config.serverHost,
      // serverPort: config.serverPort,
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

      if (_selectedConfig!.useSsh == true) {
        await _connectUsingSshTunneling();
      } else {
        await _connectToRepo();
      }

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
      if (_selectedConfig!.useSsh == true) {
        await _connectUsingSshTunneling();
      } else {
        await _connectToRepo();
      }

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

  Future<void> chooseSshKeyFile() async {
    final result = await FilePicker.platform.pickFiles(
      initialDirectory: '~/.ssh/',
      // allowMultiple: false,
      // type: FileType.custom,
      // allowedExtensions: ['pem'],
    );

    if (result != null) {
      final privateKeyFilePath = result.files.single.path!;

      final config = _selectedConfig!;

      config.sshKeyFilePath = privateKeyFilePath;
      _sshKeyFilePathController.text = privateKeyFilePath;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(I18n.of(context).cancel),
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  Future<void> _connectUsingSshTunneling() async {
    final config = _selectedConfig!;
    final host = config.host;
    final localPort = config.port;
    const sshPort = 22;
    final bastionHost = config.bastionHost!;
    final bastionUsername = config.bastionUsername!;
    final serverHost = config.serverHost!;
    final serverPort = config.serverPort!;

    try {
      final sshKeyFilePath = _sanitize(_sshKeyFilePathController.text);
      final passphrase = _sanitize(_sshKeyPassphraseController.text);
      final privateKey = File(sshKeyFilePath).readAsStringSync();
      final socket = await SSHSocket.connect(bastionHost, sshPort);
      final keyPair = SSHKeyPair.fromPem(
          privateKey, passphrase.isEmpty ? null : passphrase);
      final sshClient = SSHClient(
        socket,
        username: bastionUsername,
        identities: [...keyPair],
      );

      await sshClient.authenticated;
      print('✅ SSH Authentication Confirmed!');

      final serverSocket =
          await ServerSocket.bind(InternetAddress.loopbackIPv4, localPort);

      serverSocket.listen((Socket localSocket) async {
        print('⚡ [Tunnel] Local connection detected: '
            'Port ${localSocket.remotePort}');

        try {
          print('⚡ [Tunnel] Requesting forwarding to $serverHost:$serverPort '
              'via Bastion...');
          final sshChannel =
              await sshClient.forwardLocal(serverHost, serverPort);
          print('⚡ [Tunnel] SSH Channel established successfully!');

          unawaited(localSocket.cast<List<int>>().pipe(sshChannel.sink));
          // await localSocket
          //     .cast<List<int>>()
          //     .pipe(sshChannel.sink)
          //     .catchError((e) {
          //   print('❌ [Tunnel] Local -> SSH Pipeline Error: $e');
          // });

          unawaited(sshChannel.stream.cast<List<int>>().pipe(localSocket));
          // await sshChannel.stream
          //     .cast<List<int>>()
          //     .pipe(localSocket)
          //     .catchError((e) {
          //   print('❌ [Tunnel] SSH -> Local Pipeline Error: $e');
          // });
        } catch (e) {
          // This is where the root cause of Errno 54 will be caught.
          print('❌ [Tunnel] Critical Forwarding Error: $e');
          localSocket.destroy();
        }
      });

      // Allow the OS to bind the local port
      await Future<void>.delayed(const Duration(milliseconds: 500));

      // Wait until the port is actually ready (up to 15 seconds)
      final isPortReady = await _waitForPort(localPort);
      if (!isPortReady) {
        throw Exception('Failed to open local port $localPort. '
            'Tunnel might have failed to start.');
      }
      print('✅ Tunnel is ready!\n');

      _syncAndSave();

      final repo = ref.read(connectionRepositoryProvider);

      print('2. Connecting to server...');

      print(config.host);
      print(localPort);

      await repo.connect(
        host: host,
        port: localPort,
        // NOTE: If the username is empty (length == 0),
        // defaulting to "default" is required for proper authentication.
        username:
            config.username?.isEmpty ?? true ? 'default' : config.username,
        password: config.password,
      );
    } catch (e) {
      print('Connection or Tunneling Error: $e');
      // Case 1. If passphrase is null
      // Invalid argument(s): Passphrase is not required for unencrypted keys
    } finally {
      // strict: ensure this runs even if an exception occurs
      // if (context.mounted) {
      //   Navigator.pop(context);
      // }
    }
  }

  // Actively waits for the local port to open
  Future<bool> _waitForPort(int port, {int maxRetries = 15}) async {
    print('⏳ Waiting for SSH tunnel to open on port $port...');
    for (var i = 0; i < maxRetries; i++) {
      try {
        final socket = await Socket.connect('127.0.0.1', port,
            timeout: const Duration(seconds: 1));
        socket.destroy();
        return true;
      } catch (_) {
        await Future<void>.delayed(const Duration(seconds: 1));
      }
    }
    return false;
  }
}
