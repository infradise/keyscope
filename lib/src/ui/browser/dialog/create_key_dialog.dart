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
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../connection/repository/connection_repository.dart';

class CreateKeyDialog extends ConsumerStatefulWidget {
  const CreateKeyDialog({super.key});

  @override
  ConsumerState<CreateKeyDialog> createState() => _CreateKeyDialogState();
}

class _CreateKeyDialogState extends ConsumerState<CreateKeyDialog> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _keyController = TextEditingController();
  final _ttlController = TextEditingController();

  // String / List / Set Value
  final _valueController = TextEditingController();

  // Hash (Field/Value)
  final _hashFieldController = TextEditingController();
  final _hashValueController = TextEditingController();

  // ZSet (Score/Member)
  final _zScoreController = TextEditingController();
  final _zMemberController = TextEditingController();

  String _selectedType = 'string';
  final List<String> _types = ['string', 'hash', 'list', 'set', 'zset'];

  @override
  Widget build(BuildContext context) => Dialog(
        backgroundColor: const Color(0xFF2B2D30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create New Key',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // 1. Key Name & Type
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: _buildTextField(
                        controller: _keyController,
                        label: 'Key Name',
                        hint: 'e.g. user:1001',
                        validator: (v) =>
                            v == null || v.isEmpty ? 'Required' : null,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedType, // value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Type',
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                        dropdownColor: const Color(0xFF2B2D30),
                        items: _types
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.toUpperCase()),
                              ),
                            )
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            _selectedType = val!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 2. Dynamic Value Input based on Type
                const Text(
                  'Initial Value',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                _buildValueInputs(),

                const SizedBox(height: 16),

                // 3. TTL (Optional)
                _buildTextField(
                  controller: _ttlController,
                  label: 'TTL (Seconds, Optional)',
                  hint: '-1 (Forever)',
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),

                const SizedBox(height: 24),

                // 4. Action Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton(
                        onPressed: _submit, child: const Text('Create')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildValueInputs() {
    switch (_selectedType) {
      case 'string':
        return _buildTextField(
          controller: _valueController,
          label: 'Value',
          maxLines: 3,
          validator: (v) => v!.isEmpty ? 'Required' : null,
        );
      case 'hash':
        return Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _hashFieldController,
                label: 'Field',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _hashValueController,
                label: 'Value',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ),
          ],
        );
      case 'list':
        return _buildTextField(
          controller: _valueController,
          label: 'Initial Item',
          validator: (v) => v!.isEmpty ? 'Required' : null,
        );
      case 'set':
        return _buildTextField(
          controller: _valueController,
          label: 'Member',
          validator: (v) => v!.isEmpty ? 'Required' : null,
        );
      case 'zset':
        return Row(
          children: [
            Expanded(
              flex: 1,
              child: _buildTextField(
                controller: _zScoreController,
                label: 'Score',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp('[0-9.]'),
                  ), // RegExp(r'[0-9.]')
                ],
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: _buildTextField(
                controller: _zMemberController,
                label: 'Member',
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
            ),
          ],
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) =>
      TextFormField(
        controller: controller,
        maxLines: maxLines,
        inputFormatters: inputFormatters,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          isDense: true,
          border: const OutlineInputBorder(),
        ),
      );

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final repo = ref.read(connectionRepositoryProvider);
    final key = _keyController.text;
    final ttl = int.tryParse(_ttlController.text);

    dynamic value;
    try {
      // Prepare value payload
      switch (_selectedType) {
        case 'string':
        case 'list':
        case 'set':
          value = _valueController.text;
          break;
        case 'hash':
          value = {_hashFieldController.text: _hashValueController.text};
          break;
        case 'zset':
          value = {_zMemberController.text: num.parse(_zScoreController.text)};
          break;
      }

      await repo.createKey(
        key: key,
        type: _selectedType,
        value: value,
        ttl: ttl,
      );

      if (!mounted) return;
      Navigator.pop(context, true); // Return true to indicate success
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }
}
