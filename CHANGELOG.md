# Changelog

## 0.3.1

* **New CI Badge**: `GUI` and `CLI` build status badges for GitHub Actions workflows to `README.md`
* **New Example**: A GUI example using `Keyscope` widget

## 0.3.0

* **New Feature: Data Explorer**
    * Browse keys efficiently using `SCAN` command (cursor-based pagination).
    * Supports infinite scrolling for navigating millions of keys without blocking the server.
    * Search/Filter keys by pattern (e.g., `user:*`).
* **New Feature: Value Inspector**
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
