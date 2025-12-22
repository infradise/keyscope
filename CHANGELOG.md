# Change Log

## 0.5.0

### Added
* **Multi-Database Support in Valkey Cluster Mode**
    * Supports multiple databases (DB 0-15) in Cluster mode, a feature `numbered databases` introduced in `Valkey` 9.0.
    * This also resolves an issue where `Valkey` clusters could report `Connection Failed (ERR DB index is out of range)` when selecting databases after accessing nodes in cluster mode.

## 0.4.0

### 🎉 Major Update: Full CRUD Support
Keyscope moves beyond a simple viewer. You can now **Create, Read, Update, and Delete** Redis keys directly within your IDE. We have also improved database navigation to make managing multiple logical databases easier.

### Added
* **Key Management (CRUD):**
    * **Add Key:** Create new keys (String type) with custom values and TTL using the new "Add Key" dialog. The list automatically refreshes to show the new key immediately.
    * **Edit Value:** The data viewer is now a fully functional editor. Modify text values and click "Save" to update them in Redis instantly.
    * **Delete Key:** Select and remove keys directly from the list (supports multi-selection) via the new toolbar action.
* **Session Toolbar:**
    * Added a dedicated toolbar inside the editor tabs for quick access to **Add**, **Delete**, **Refresh**, **Save**, and **Format JSON** actions.

### Improved
* **Database Visibility:**
    * The Explorer now displays all available databases (e.g., DB0 ~ DB15) even if they are empty, enabling you to add new keys to unused databases easily.
* **Multi-Database Reliability:**
    * Enhanced the connection logic to strictly enforce `SELECT <dbIndex>` commands, ensuring that read/write operations always occur on the correct database tab.
* **User Experience:**
    * Added safety confirmation dialogs when deleting keys or saving modified values to prevent accidental data loss.
    * Improved the "Empty State" screen in the Explorer with a direct link to create a new connection.

## 0.3.0
### Added
- UX Improvements:
  - In the `Cluster Manager`, after adding a `Redis` or `Valkey` server,  
    clicking the server now displays `No databases found` when no Database entries exist.
  - Cluster Manager:
    - Move up/down icon button is enabled only when a server is selected.
    - Edit menu icon button is enabled only when a server is selected.
    - Displays a `+ Add a connection` text link along with `No connections found` when no server entries exist.
    - Displays `No keys found` instead of `Nothing to show` when no key entries exist.
  - Connection Management:
    - Restored and improved the `Edit`, `Move Up`, and `Move Down` actions in the Explorer toolbar, allowing better organization of your server profiles.

## 0.2.0
### Added
- Hierarchical Tree Explorer:
  - Browse your Redis/Valkey servers in a structured tree view (`Server` → `Database` → `Data Types`).
  - Quickly identify and access keys grouped by their type (String, Hash, List, Set, ZSet, Stream).
- Native Tab Integration:
  - Double-click a database or a type folder to open it in a standard IDE tab.
  - Work on multiple databases simultaneously without modal blocking.
- Smart Data Viewer:
  - Auto JSON Formatting: Automatically detects and pretty-prints JSON values for better readability.
  - Rich Type Support: Native viewing experience for Hashes, Lists, Sets, and Sorted Sets.
  - Metadata at a Glance: View Key TTL (Time-To-Live), Type, and Size directly in the viewer.
- Optimized Performance:
  - Implemented efficient server-side filtering (using `SCAN` with type options) to handle large databases smoothly.

## 0.1.0
### Added
- Initial release