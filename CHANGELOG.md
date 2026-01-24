# Changelog

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
