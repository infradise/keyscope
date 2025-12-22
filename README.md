[![JetBrains Plugin Version](https://img.shields.io/jetbrains/plugin/v/dev.keyscope.plugin)](https://plugins.jetbrains.com/plugin/29250-keyscope)

# Keyscope

<div align="center">
  <img src="https://download.keyscope.dev/logo.png" alt="Keyscope Logo" width="128" height="128">
  <br>
  
  <h1>The Native Redis & Valkey IDE for JetBrains</h1>
  <p>
    The native, lightweight, high-performance Redis & Valkey management plugin for JetBrains IDEs.<br> 
    Manage data and monitor performance without leaving your code.<br>
    <b>Built exclusively for JetBrains IDEs</b>
  </p>

  <p>
    <a href="https://github.com/infradise/keyscope/releases/latest">
      <img src="https://img.shields.io/badge/macOS-gray?logo=apple&style=for-the-badge" alt="macOS"></a>  
    <a href="https://github.com/infradise/keyscope/releases/latest">
      <img src="https://img.shields.io/badge/Windows-blue?logo=windows&style=for-the-badge" alt="Windows"></a>
    <a href="https://github.com/infradise/keyscope/releases/latest">
      <img src="https://img.shields.io/badge/Linux-green?logo=linux&style=for-the-badge" alt="Linux"></a>  
  </p>

  <p>
    <a href="#features">Features</a> •
    <a href="#installation">Installation</a> •
    <a href="#roadmap">Roadmap</a> •
    <a href="https://keyscope.dev">Website</a>
  </p>
</div>

---

  ![Keyscope Key-Value Screen](https://download.keyscope.dev/screenshot/keyscope-key-value-editor.png)

  ![Keyscope Connection Screen](https://download.keyscope.dev/screenshot/keyscope-connection-manager.png)
</div>

---

## Key Features

### Support for Valkey-specific Features
* **Multi-Database Support in Valkey Cluster Mode**: Valkey 9.0 and later supports multiple databases even in cluster mode.

### Connectivity & Compatibility
* **Dual Support:** Fully compatible with both **Redis** and **Valkey** (detects version automatically).
* **Connection Modes:**
    * **Standalone:** Direct connection to single instances.
    * **Cluster:** Automatic topology discovery and redirection handling.
    * **Sentinel:** (Planned) Support for high-availability setups.
* **SSH Tunneling:** Built-in SSH tunneling support (Password & Key Pair auth) for secure remote access without external tools.

### Full CRUD Support
* You can now **Create, Read, Update, and Delete** Redis keys directly within your IDE. We have also improved database navigation to make managing multiple logical databases easier.

### Security
* **Secure Storage:** Passwords and private keys are never stored in plain text. Keyscope integrates with the **OS System Keychain** to keep your credentials safe.

### UI/UX
* **Native IDE Integration:** Built with Kotlin UI DSL to provide a seamless JetBrains look-and-feel (Dark/Light theme support).
* **Hierarchical Explorer:**
    * Tree-based navigation: `Server` → `Database` → `Data Type`.
    * Quickly identify key distribution by type (String, Hash, List, Set, ZSet, Stream).
* **Tabbed Workspace:** Open multiple database views simultaneously using the IDE's native tab system.
* **Database Visibility:**
    * The Explorer now displays all available databases (e.g., DB0 ~ DB15) even if they are empty, enabling you to add new keys to unused databases easily.
* **Multi-Database Reliability:**
    * Enhanced the connection logic to strictly enforce `SELECT <dbIndex>` commands, ensuring that read/write operations always occur on the correct database tab.

### Data Management & Editor
* **Key Management (CRUD):**
    * **Add Key:** Create new keys (String type) with custom values and TTL using the new "Add Key" dialog. The list automatically refreshes to show the new key immediately.
    * **Edit Value:** The data viewer is now a fully functional editor. Modify text values and click "Save" to update them in Redis instantly.
    * **Delete Key:** Select and remove keys directly from the list (supports multi-selection) via the new toolbar action.
* **Session Toolbar:**
    * Added a dedicated toolbar inside the editor tabs for quick access to **Add**, **Delete**, **Refresh**, **Save**, and **Format JSON** actions.
* **Smart Data Viewer:**
    * **JSON Pretty Print:** Automatically detects JSON strings within keys and formats them for readability.
    * **Type-Specific Rendering:** Specialized views for Hashes, Lists, Sets, and Sorted Sets.
* **Performance:**
    * **Lazy Loading:** Uses `SCAN` cursors to handle millions of keys without freezing the UI.
    * **Type Filtering:** Server-side filtering using `SCAN ... TYPE` for efficient browsing.
* **Metadata:** Displays Key TTL (Time-To-Live), Type, and Size at a glance.

## Why Keyscope?

**Keyscope** is not just another Redis GUI client. It is a specialized tool designed to unlock the full potential of **Valkey**. We focus on modern developer experience (DX) and performance.

* **Built for Valkey and Redis**
    * Native support for Valkey's new threading model and data structures.
    * Visualized monitoring optimized for Valkey metrics.
* **Native Performance**
    * Built with **Kotlin** and the JetBrains SDK. No web views, no heavy frameworks, and no context switching. It is optimized for speed and minimal resource consumption.
* **Native Look & Feel**
    * We utilize the standard **JetBrains UI components**. Whether you are using the Darcula theme or the new UI, Keyscope blends in perfectly, providing a consistent and comfortable user experience, and an interface designed for long coding sessions.
* **Focus on Essentials**
    * Designed for developers who need to manage Valkey and Redis clusters without leaving their code.

## Supported IDEs

Keyscope is compatible with all IntelliJ Platform-based products (Version 2023.x and later):

* **Android Studio**
* **IntelliJ IDEA** (Community & Ultimate)
* **PyCharm** (Community & Professional)
* PhpStorm, GoLand, WebStorm, CLion, DataGrip, RubyMine, RustRover

> **Note:** This plugin is **NOT** available for VS Code or Eclipse. It is a specialized tool for the JetBrains family.

## Installation

1.  Open your IDE (Android Studio, IntelliJ IDEA, PyCharm, etc.).
2.  Go to **Settings/Preferences** → **Plugins** → **Marketplace**.
3.  Search for **"Keyscope"**.
4.  Click **Install**.

## Roadmap

- [ ] Basic CRUD Operations (Key-Value)
- [ ] **Local Cluster Management (No Docker)**
- [ ] Advanced Performance Monitoring (Real-time graphs)
- [ ] Slow Log & Hot Key Analysis
- [ ] Data Import/Export (JSON, CSV)
- [ ] Team Collaboration Features (Pro)
- [ ] 1-Click Cluster Setup (Docker-less)
  - Deploy a production-ready **3 Master + 3 Replica** cluster on your local machine in seconds.
  - **No Docker Desktop required.** No complex `docker-compose` files. It just works.

## Feedback & Support

Found a bug? Please let us know!

* **Bug Report:** [Open an Issue](https://github.com/infradise/keyscope/issues/new?template=bug_report.md)

---

## Legal Notices

© 2025 Infradise Inc. All rights reserved.  

**Keyscope** is a product of Infradise Inc.  

We are **not affiliated with** The Linux Foundation, Redis Ltd., JetBrains s.r.o.  

All other trademarks cited herein are the property of their respective owners.  
For full legal details and a comprehensive list of third-party trademarks, please visit our [Legal Notices](https://keyscope.dev/legal).