# Changelog

## Upcoming Next
* **SSH Tunneling** 🎉
    * Now connect to Google Cloud Memorystore via SSH tunneling on Connection Manager.

## 0.9.0 🎉

### ✨ New Features
* **Revamped Connection Dialog**
  * Easily add new connections via the Connection Manager in the Side Bar (includes scrolling support, `+` button, and dotted box UI).
  * Users can now create, edit, and save custom connection configurations (`ConnectionConfig`) locally.
  * Auto-save configurations upon clicking the 'Test Connect' or 'Connect' buttons. (The hardcoded default connection example has been removed).
* **Auto-generate Names for New Connections (`GenerateRandomName`)**
  * Automatically assigns random names in the format: `[Server]-[US City]-[UUID v4]`.
  * Supported servers: `Redis`, `Valkey`, `Dragonfly`, `KeyDB`, `Amazon MemoryDB`, `Garnet`, `Redict`, `Apache Kvrocks`, `Upstash`, `Azure Cache for Redis`, `Google Cloud Memorystore`, `Alibaba Cloud Tair`.

### 🎨 UI/UX & Localization
* **Updated Data Type Label Colors**
  * **New assigned colors (changed from default Gray):**
    * `STREAM`: Blue Gray
    * `MBbloom--`: Pink
    * `vectorset`: Amber
    * `TSDB-TYPE`: Teal
    * `TDIS-TYPE`: Lime
  * **Modified colors:**
    * `ZSET`: Red to Indigo
* Enhanced visual effects (hover, color selection, press/tap animations) in the Connection Dialog for better usability.
* Updated and improved multilingual translation data.

### 🐛 Bug Fixes
* Fixed an issue where the `hDel` command was duplicated in the `deleteHashField` execution.

### 🛠️ Refactoring & Chores
* **Dart Code Optimization:** Refactored the `_getTypeColor` function to use modern Dart `switch expression` syntax.
* **Abstract Class Cleanup:** Removed the empty bodies of `deleteKey` and `setStringValue` in the `ConnectionRepository`.
* **Internal Tool Update:** Updated the i18n Generator (`i18n_generator.dart`) to include line length checks for simple getters without arguments.

### 📦 Dependencies
* Added `uuid` package for generating random names in the connection dialog.
* Added `shared_preferences` package for saving connection configurations locally.

## 0.8.3
* **Refactor (i18n)**: Externalized all text resources to `assets/i18n.csv` and applied localization keys to UI components via generated `lib/i18n.dart`.
* **Style**: Updated `tool/i18n_generator.dart` to enforce 80-character line limit in generated `lib/i18n.dart`.

## 0.8.2
* **Fix (Example)**: Replaced MaterialApp wrapper with KeyscopeApp to ensure locale and theme settings are applied correctly.

## 0.8.1
* **Fix**: Included the missing `lib/i18n.dart` in the package to resolve static analysis errors on pub.dev.

## 0.8.0
* **Multilingual:** Added Internationalization (i18n) with full multi-language support.
* **Core Engine**
    * **keyscope_client**: Bump version to `4.2.0`.
* **Dependencies & Tooling**
    * **New i18n Generation Tool**: Introduced a custom-built internal translation tool (`tool/i18n_generator.dart`). This internal tool replaces the removed dependencies, streamlining the i18n workflow, ensuring better maintainability and control without relying on obsolete external libraries..

## 0.7.0
* **Connection Dialog & Test Connection**
    * **Enhanced** Implemented full `TextEditingController` support for all form fields (name, host, port, username, password).
      * Dialog now correctly captures and applies user-entered values.
      * Test Connection action uses the latest input values to validate connectivity.

## 0.6.0
* **New Feature:** Advanced Data Editing (Complex Types)
    * **Hash Editing:** Added support for adding, editing, and deleting individual fields within a Hash.
    * **List Editing:** Support for appending items (`RPUSH`), updating items by index (`LSET`), and removing items (`LREM`).
    * **Set Management:** Ability to add (`SADD`) and remove (`SREM`) members from Sets.
    * **ZSet (Sorted Set) Management:** Support for adding members with scores (`ZADD`), updating scores, and removing members.
* **UI/UX Improvements**
    * **Type-Specific Actions:** The Value Inspector now displays context-aware action buttons (e.g., "Add Field" for Hash, "Add Member" for Set).
    * **Enhanced Dialogs:** Dedicated input dialogs for each data type ensure correct data entry (e.g., Score input validation for ZSet).
* **CLI:**
    * **New Commands**: (`scan`) as a generic command for Redis and Valkey
    * **Command Checker** Added a command checker before connecting to server
* **Data Type**
    * **ReJSON-RL**: Label color changed from default Gray to Brown

## 0.5.0
* **New Feature:** Key Creation
    * **Create New Keys:** Users can now create new keys directly from the Data Explorer.
    * **Supported Types:** Full support for creating **String**, **Hash**, **List**, **Set**, and **ZSet** (Sorted Set) types.
    * **Dynamic Input Forms:** The creation dialog automatically adapts fields based on the selected key type (e.g., Score/Member input for ZSet, Field/Value for Hash).
    * **TTL Support:** Option to set an initial Time-To-Live (TTL) when creating a key.
* **Feature Update:** Value Inspector
    * **ReJSON-RL:** Inspect detailed key information for Redis JSON and Valkey JSON.
* **UI/UX Improvements**
    * **New Button**: Floating Action Button (+) to the Data Explorer for quick access to key creation.
    * Enhanced validation logic to ensure data integrity before submission.
* **CLI:** 
    * **New Commands**: (`json-set`), (`json-get`) for Redis JSON and Valkey JSON
    * Added new commands to `CLI_OPTIONS.md`.

## 0.4.0
* **New Feature:** Key Management (CRUD)
    * **Delete Keys:** Added ability to delete keys directly from the Value Inspector. Includes a confirmation dialog for safety.
    * **Edit String Values:** Users can now modify and save values for `String` type keys.
    * **Real-time Updates:** The UI automatically refreshes the key list and details upon successful modification or deletion.
* **UI/UX Improvements**
    * Added edit/save/cancel toggle mode in the Key Detail Panel.
    * Improved error handling and user feedback (Snackbars) for write operations.
* **CLI:** 
    * Enhanced `Keyscope` CLI with (`ping`) and functions (connect, close, etc).
    * Added `CLI_OPTIONS.md` to introduce the CLI commands and options.
    * Added Commands: (`get` with `--key/-k` and `--value/-v`), (`set` with `--key/-k` and `--value/-v`), (`ping`), etc.
    * Added Options: (`--get`), (`--set`), (`--slient`), (`--db`), (`--ssl`), etc.

## 0.3.1
* **New CI Badge**: `GUI` and `CLI` build status badges for GitHub Actions workflows to `README.md`
* **New Example**: A GUI example using `Keyscope` widget

## 0.3.0
* **New Feature:** Data Explorer
    * Browse keys efficiently using `SCAN` command (cursor-based pagination).
    * Supports infinite scrolling for navigating millions of keys without blocking the server.
    * Search/Filter keys by pattern (e.g., `user:*`).
* **New Feature:** Value Inspector
    * Inspect detailed key information including **Type** and **TTL**.
    * Dedicated visualizers for various data types:
        * **String:** Plain text viewer.
        * **Hash:** Table view for fields and values.
        * **List / Set:** List view.
        * **ZSet:** List view with scores.
* **CLI:** Enhanced `Keyscope` CLI with scan test (`--scan`) and (`--match`).

## 0.2.0
* **New Feature:** Added Connection Manager GUI.
    * Supports `Redis` & `Valkey` connections.
    * Create, edit, and save connection configurations.
    * Support for Username/Password authentication (ACL).
* **New Feature:** Real-time Dashboard.
    * Visualizes Server info, Memory usage, and Client stats.
    * Automatic data fetching via `INFO` command.
* **CLI:** Enhanced `Keyscope` CLI with connectivity check (`--ping`).
    * CLI diagnostic tool (`keyscope --ping`).

## 0.1.0
* Initial placeholder release.
