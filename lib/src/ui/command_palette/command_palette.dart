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
import 'package:flutter_riverpod/legacy.dart' show StateProvider;
import '../../../i18n.dart' show I18n;
import '../connection/repository/connection_repository.dart';

// --- State Providers ---
final commandInputProvider = StateProvider<String>((ref) => '');
final isExpandedProvider = StateProvider<bool>((ref) => false);
final isGridViewProvider = StateProvider<bool>((ref) => true);
final isExecutingProvider = StateProvider<bool>((ref) => false);
final resultProvider = StateProvider<CommandResult?>((ref) => null);

final isSearchVisibleProvider = StateProvider<bool>((ref) => false);
final searchQueryProvider = StateProvider<String>((ref) => '');
final matchCaseProvider = StateProvider<bool>((ref) => false);
final currentSearchIndexProvider = StateProvider<int>((ref) => 0);
final totalSearchCountProvider = StateProvider<int>((ref) => 0);
final colorIndexProvider = StateProvider<int>((ref) => 2); // Default: Green

class CommandResult {
  final String output;
  final bool isError;
  CommandResult(this.output, {this.isError = false});
}

class KeyscopeCommandPalette extends ConsumerStatefulWidget {
  const KeyscopeCommandPalette({super.key});

  @override
  ConsumerState<KeyscopeCommandPalette> createState() =>
      _KeyscopeCommandPaletteState();
}

class _KeyscopeCommandPaletteState
    extends ConsumerState<KeyscopeCommandPalette> {
  late TextEditingController _controller;
  late TextEditingController _searchController;
  final ScrollController _resultScrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();
  List<int> _matchIndices = [];

  final List<String> _redisCommands = [
    'INFO',
    'PING',
    'GET',
    'SET',
    'DEL',
    'EXISTS',
    'INCR',
    'DECR',
    'HGETALL',
    'LPUSH',
    'SCAN',
    'KEYS'
  ];

  final List<Color> _responseColors = [
    Colors.grey,
    Colors.white,
    const Color(0xFF4ADE80)
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    _resultScrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // TODO: Command guidance & auto-complete & example & help

  /// quotes and escapes
  ///
  /// Parses a raw command string into a list of arguments (argv).
  /// Handles double quotes (""), single quotes (''), and escape characters (\).
  List<String> parseCommand(String input) {
    final result = <String>[];
    final currentToken = StringBuffer();

    // Tracks if we are inside ' or "
    String? quoteType; // null, "'", or '"'
    var isEscaped = false;

    for (var i = 0; i < input.length; i++) {
      final char = input[i];

      if (isEscaped) {
        // Handle escaped character: add literally and reset flag
        // After a backslash, add the character literally and reset the flag
        currentToken.write(char);
        isEscaped = false;
      } else if (char == r'\') {
        // '\\'
        // Initiate escape sequence
        // Start of an escape sequence
        isEscaped = true;
      } else if (quoteType != null) {
        // Inside a quoted section
        // Currently inside a quoted string
        if (char == quoteType) {
          // Closing quote found
          // Matching closing quote found
          quoteType = null;
        } else {
          currentToken.write(char);
        }
      } else {
        // Outside quotes
        // Outside of any quotes
        if (char == '"' || char == "'") {
          quoteType = char;
        } else if (char == ' ') {
          // Space acts as a delimiter only when not quoted/escaped
          // Split by space only when not quoted or escaped
          if (currentToken.isNotEmpty) {
            result.add(currentToken.toString());
            currentToken.clear();
          }
        } else {
          currentToken.write(char);
        }
      }
    }

    // Add the final token if exists
    // Add the last remaining token to the list
    if (currentToken.isNotEmpty) {
      result.add(currentToken.toString());
    }

    return result;
  }

  // void testcases() {
  //   assert(parseCommand('SET key "a b c"').length == 3);
  //   assert(parseCommand(
  //     'SET key "escaped \\"quote\\""')[2] == 'escaped "quote"');
  //   print(parseCommand('SET key "a b c"')); // [SET, key, a b c]
  //   print(parseCommand('SET key "escaped \\"quote\\""'));
  //   // [SET, key, escaped "quote"]
  // }

  Future<void> _handleExecute() async {
    final cmd = _controller.text.trim();
    // if (cmd.isEmpty) return;
    if (cmd.isEmpty || cmd.trim().isEmpty) return;

    final argv = parseCommand(cmd);

    ref.read(isExecutingProvider.notifier).state = true;
    ref.read(resultProvider.notifier).state = null;
    try {
      // await Future<void>.delayed(const Duration(milliseconds: 600));

      final repo = ref.read(connectionRepositoryProvider);
      // final argv1 = ['SET', 'pp', 'a b c'];
      // final result = await repo.raw(argv1);

      final result = await repo.raw(argv);

      final output = result.toString();
      ref.read(resultProvider.notifier).state = CommandResult(output);
      _updateSearchMatches(
          output, _searchController.text, ref.read(matchCaseProvider));
    } catch (e) {
      ref.read(resultProvider.notifier).state =
          CommandResult(e.toString(), isError: true);
    } finally {
      ref.read(isExecutingProvider.notifier).state = false;
    }
  }

  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(I18n.of(context).copyToClipboard),
          duration: const Duration(seconds: 1),
          backgroundColor: const Color(0xFF3B82F6)),
    );
  }

  void _updateSearchMatches(String text, String query, bool matchCase) {
    if (query.isEmpty) {
      _matchIndices = [];
      ref.read(totalSearchCountProvider.notifier).state = 0;
      return;
    }
    final source = matchCase ? text : text.toLowerCase();
    final target = matchCase ? query : query.toLowerCase();
    final indices = <int>[];
    var index = source.indexOf(target);
    while (index != -1) {
      indices.add(index);
      index = source.indexOf(target, index + target.length);
    }
    _matchIndices = indices;
    ref.read(totalSearchCountProvider.notifier).state = indices.length;
    ref.read(currentSearchIndexProvider.notifier).state =
        indices.isNotEmpty ? 1 : 0;
  }

  void _scrollToMatch(int direction) {
    final total = ref.read(totalSearchCountProvider);
    if (total == 0) return;
    final current = ref.read(currentSearchIndexProvider);
    var next = (current + direction - 1) % total + 1;
    if (next < 1) next = total;
    ref.read(currentSearchIndexProvider.notifier).state = next;
    final offset =
        (_matchIndices[next - 1] / ref.read(resultProvider)!.output.length) *
            _resultScrollController.position.maxScrollExtent;
    _resultScrollController.animateTo(offset,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  @override
  Widget build(BuildContext context) {
    final isExpanded = ref.watch(isExpandedProvider);
    final isExecuting = ref.watch(isExecutingProvider);
    final result = ref.watch(resultProvider);

    // Column commandPaletteWidget() =>
    //   Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       _buildInputBar(isExecuting, isExpanded),
    //       // Use Expanded to make the content area grow/shrink with the window
    //       Expanded(
    //         child: Column(
    //           children: [
    //             if (isExpanded) _buildPaletteContent(),
    //             // Response area also uses Expanded to take remaining space
    //             if (result != null || isExecuting)
    //               Expanded(child: _buildResultPanel(result, isExecuting)),
    //           ],
    //         ),
    //       ),
    //     ],
    //   );

    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: // SafeArea(child:
          Padding(
        padding: const EdgeInsets.all(16.0),
        // child: commandPaletteWidget(),
        // OR
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Wrap the existing InputBar Container with a Row and
            // add an IconButton
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  hoverColor: Colors.transparent,
                  visualDensity: const VisualDensity(vertical: 3.0),
                  // NOTE: Tune (^/v)
                  padding: const EdgeInsets.only(bottom: 10.0),
                  icon: const Icon(Icons.arrow_back_ios_new,
                      size: 18,
                      // color: Colors.grey
                      color: Colors.blueGrey),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                Expanded(child: _buildInputBar(isExecuting, isExpanded)),
              ],
            ),
            // Use Expanded to make the content area grow/shrink with the window
            Expanded(
              child: Column(
                children: [
                  if (isExpanded) _buildPaletteContent(),
                  // Response area also uses Expanded to take remaining space
                  if (result != null || isExecuting)
                    Expanded(child: _buildResultPanel(result, isExecuting)),
                ],
              ),
            ),
          ],
        ),
      ),
      // ),
    );
  }

  Widget _buildInputBar(bool isExecuting, bool isExpanded) => Container(
        height: 54,
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF333333))),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.terminal, color: Colors.grey, size: 18),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                enabled: !isExecuting,
                style: const TextStyle(
                    color: Colors.white, fontSize: 14, fontFamily: 'monospace'),
                decoration: InputDecoration(
                    hintText: I18n.of(context).enterCommand,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12)),
                onSubmitted: (_) => _handleExecute(),
              ),
            ),
            ElevatedButton(
              onPressed: isExecuting ? null : _handleExecute,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white, // White text
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: isExecuting
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(I18n.of(context).run),
            ),
            IconButton(
              onPressed: () =>
                  ref.read(isExpandedProvider.notifier).update((s) => !s),
              icon: Icon(
                  isExpanded ? Icons.expand_less : Icons.keyboard_command_key,
                  color: isExpanded ? const Color(0xFF3B82F6) : Colors.grey),
            ),
          ],
        ),
      );

  Widget _buildResultPanel(CommandResult? result, bool isExecuting) {
    final isSearchVisible = ref.watch(isSearchVisibleProvider);
    final colorIdx = ref.watch(colorIndexProvider);
    final matchCase = ref.watch(matchCaseProvider);
    final query = ref.watch(searchQueryProvider);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xFF151515),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF252525))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(I18n.of(context).response,
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 10,
                      fontWeight: FontWeight.bold)),
              if (result != null && !isExecuting)
                _buildResponseToolbar(result.output, isSearchVisible),
            ],
          ),
          if (isSearchVisible) _buildSearchBar(matchCase),
          const SizedBox(height: 12),
          // Expanded here ensures the text area takes up all available space
          // in the panel
          Expanded(
            child: isExecuting
                ? Text(I18n.of(context).executing,
                    style: const TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 13,
                        fontFamily: 'monospace'))
                : SingleChildScrollView(
                    controller: _resultScrollController,
                    child: _buildHighlightedText(
                        result!.output,
                        query,
                        matchCase,
                        result.isError
                            ? Colors.redAccent
                            : _responseColors[colorIdx]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResponseToolbar(String output, bool isSearchVisible) => Row(
        children: [
          IconButton(
              icon: Icon(Icons.search,
                  color: isSearchVisible ? Colors.blueAccent : Colors.grey,
                  size: 18),
              onPressed: () =>
                  ref.read(isSearchVisibleProvider.notifier).update((s) => !s),
              visualDensity: VisualDensity.compact),
          IconButton(
              icon: const Icon(Icons.palette_outlined,
                  color: Colors.grey, size: 18),
              onPressed: () => ref
                  .read(colorIndexProvider.notifier)
                  .update((s) => (s + 1) % 3),
              visualDensity: VisualDensity.compact),
          IconButton(
              icon: const Icon(Icons.copy_rounded,
                  color: Colors.blueAccent, size: 18),
              onPressed: () => _copyToClipboard(output),
              visualDensity: VisualDensity.compact),
          IconButton(
              icon: const Icon(Icons.delete_outline,
                  color: Colors.redAccent, size: 18),
              onPressed: () => ref.read(resultProvider.notifier).state = null,
              visualDensity: VisualDensity.compact),
        ],
      );

  Widget _buildSearchBar(bool matchCase) {
    final current = ref.watch(currentSearchIndexProvider);
    final total = ref.watch(totalSearchCountProvider);
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(4)),
      child: Row(
        children: [
          // Alternative structure to force vertical centering
          // Container(
          //   height: 40, // Define a fixed height for the search bar
          //   padding: const EdgeInsets.symmetric(horizontal: 8),
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.center, // Physically center everything in the Row
          //     children: [
          //       const Icon(Icons.find_in_page, size: 16, color: Colors.grey),
          //       Expanded(
          //         child: Center( // Force center the TextField
          //           child: TextField(
          //             controller: _searchController,
          //             decoration: const InputDecoration(
          //               hintText: "Search...",
          //               border: InputBorder.none,
          //               isDense: true,
          //               contentPadding: EdgeInsets.zero, // Remove internal padding
          //             ),
          //             style: const TextStyle(fontSize: 12),
          //           ),
          //         ),
          //       ),
          //       IconButton(
          //         icon: const Icon(Icons.close, size: 16),
          //         onPressed: () => _searchController.clear(),
          //       ),
          //     ],
          //   ),
          // ),

          Expanded(
            child: TextField(
              // textAlignVertical: TextAlignVertical(y: 0),
              controller: _searchController,
              onChanged: (val) {
                ref.read(searchQueryProvider.notifier).state = val;
                _updateSearchMatches(
                    ref.read(resultProvider)?.output ?? '', val, matchCase);
              },
              style: const TextStyle(color: Colors.white, fontSize: 12),
              decoration: InputDecoration(
                hintText: I18n.of(context).search,
                border: InputBorder.none,
                isDense: true,
                // NOTE: Vertical Align for 'Search...'
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                // Document with magnifier icon on the left
                prefixIcon: const Icon(Icons.find_in_page,
                    size: 16, color: Colors.grey),
                // Search text clear button
                suffixIcon: IconButton(
                  icon: const Icon(Icons.close, size: 16, color: Colors.grey),
                  onPressed: () {
                    _searchController.clear();
                    ref.read(searchQueryProvider.notifier).state = '';
                    _updateSearchMatches(
                        ref.read(resultProvider)?.output ?? '', '', matchCase);
                  },
                ),
              ),
            ),
          ),
          if (total > 0)
            Text('$current / $total',
                style: const TextStyle(
                    color: Colors.grey, fontSize: 11, fontFamily: 'monospace')),
          IconButton(
              // keyboard_arrow_up
              icon: const Icon(Icons.chevron_left, size: 20),
              onPressed: () => _scrollToMatch(-1)),
          IconButton(
              // keyboard_arrow_down
              icon: const Icon(Icons.chevron_right, size: 20),
              onPressed: () => _scrollToMatch(1)),
          IconButton(
              icon: Icon(Icons.abc,
                  size: 18, color: matchCase ? Colors.blueAccent : Colors.grey),
              onPressed: () {
                ref.read(matchCaseProvider.notifier).update((s) => !s);
                _updateSearchMatches(ref.read(resultProvider)?.output ?? '',
                    _searchController.text, !matchCase);
              }),
          // IconButton(
          //   icon: const Icon(Icons.close, size: 16, color: Colors.grey),
          //   onPressed: () {
          //     _searchController.clear();
          //     ref.read(searchQueryProvider.notifier).state = '';
          //     _updateSearchMatches(
          //       ref.read(resultProvider)?.output ?? '', '', matchCase);
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildHighlightedText(
      String text, String query, bool matchCase, Color baseColor) {
    if (query.isEmpty) {
      return Text(text,
          style: TextStyle(
              color: baseColor, fontSize: 13, fontFamily: 'monospace'));
    }
    final spans = <TextSpan>[];
    final searchSource = matchCase ? text : text.toLowerCase();
    final target = matchCase ? query : query.toLowerCase();
    var start = 0;
    int index;
    while ((index = searchSource.indexOf(target, start)) != -1) {
      if (index > start) {
        spans.add(TextSpan(text: text.substring(start, index)));
      }
      spans.add(TextSpan(
          text: text.substring(index, index + target.length),
          style: const TextStyle(
              backgroundColor: Colors.yellow, color: Colors.black)));
      start = index + target.length;
    }
    if (start < text.length) spans.add(TextSpan(text: text.substring(start)));
    return RichText(
        text: TextSpan(
            style: TextStyle(
                color: baseColor, fontSize: 13, fontFamily: 'monospace'),
            children: spans));
  }

  Widget _buildPaletteContent() {
    final isGrid = ref.watch(isGridViewProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF333333))),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(I18n.of(context).palette,
                style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
            Row(children: [
              IconButton(
                  icon: const Icon(Icons.list, size: 18),
                  onPressed: () =>
                      ref.read(isGridViewProvider.notifier).state = false),
              IconButton(
                  icon: const Icon(Icons.grid_view, size: 18),
                  onPressed: () =>
                      ref.read(isGridViewProvider.notifier).state = true),
            ])
          ]),
          const Divider(color: Color(0xFF333333)),
          ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                  child: isGrid ? _buildGrid() : _buildList())),
        ],
      ),
    );
  }

  Widget _buildGrid() => GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 2.5),
      itemCount: _redisCommands.length,
      itemBuilder: (context, i) => _paletteItem(_redisCommands[i]));

  Widget _buildList() => ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _redisCommands.length,
      itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _paletteItem(_redisCommands[i], alignLeft: true)));

  Widget _paletteItem(String name, {bool alignLeft = false}) => InkWell(
      onTap: () {
        _controller.text = '$name ';
        _focusNode.requestFocus();
      },
      child: Container(
          alignment: alignLeft ? Alignment.centerLeft : Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
              color: const Color(0xFF252525),
              borderRadius: BorderRadius.circular(4)),
          child: Text(name,
              style: const TextStyle(color: Colors.white, fontSize: 12))));
}
