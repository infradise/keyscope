<br />
<div align="center">
  <img src="https://download.keyscope.dev/logo.png" alt="Keyscope Logo" width="128" height="128">
  <br>
 
  <h1>Keyscope</h1>
  <p>
    Redis, Valkey, and Dragonfly GUI with built-in multilingual support for global users.
    <br><br>
  </p>

  [![pub package](https://img.shields.io/pub/v/keyscope.svg?label=Latest)](https://pub.dev/packages/keyscope)
  [![GUI](https://github.com/infradise/keyscope/actions/workflows/build-gui.yaml/badge.svg)](https://github.com/infradise/keyscope/actions/workflows/build-gui.yaml)
  [![CLI](https://github.com/infradise/keyscope/actions/workflows/build-cli.yaml/badge.svg)](https://github.com/infradise/keyscope/actions/workflows/build-cli.yaml)
  [![pub package](https://img.shields.io/pub/v/keyscope_client.svg?label=keyscope_client)](https://pub.dev/packages/keyscope_client)

  <!-- ![Build Status](https://img.shields.io/github/actions/workflow/status/infradise/keyscope/build.yml?branch=main) -->

  ![Keyscope Data Explorer for ZSet](https://download.keyscope.dev/screenshots/commands/sorted-set/keyscope-data-explorer-zset.png)
 
  <p>
    <a href="#-why-keyscope">Why Keyscope?</a> •
    <a href="#-supported-data-stores">Supported Data Stores</a> •
    <a href="#-key-features">Key Features</a> •
    <a href="#-powered-by">Powered By</a> •
    <a href="#-translations">Translations</a> •
    <a href="#-build">Build</a> •
    <a href="#-run">Run</a> •
    <a href="#-installation">Installation</a>
  </p>

  <br>

</div>

## ✨ Why Keyscope?

While existing tools are heavy (Electron-based) or lack support for modern Valkey and Dragonfly features, Keyscope runs natively and supports [Redis](https://redis.io), [Valkey](https://valkey.io), and [Dragonfly](https://www.dragonflydb.io/), with built-in multilingual support for global users.

<a id="-supported-data-stores"></a>
## 🗄️ Supported Data Stores

We have verified that it works with: Redis, Valkey, Dragonfly, and Google Memorystore.

The remaining items will be tested as planned once the budget for testing is available.

### ✅ Completed – Functioning as expected

| Type | Data Store |
| :--- | :--- |
| **Standard** | [Redis](https://redis.io) |
| **Open Source / Self-hosted** | [Valkey](https://valkey.io), [Dragonfly](https://dragonflydb.io) |
| **Managed Cloud / Serverless** | [Google Cloud Memorystore](https://cloud.google.com/memorystore) |

*Note: Memorystore for Valkey 9.0 (MEMORYSTORE_20251030_01_00).*


### 📅 Planned – Scheduled for later

We look forward to ensuring smooth progress. If you encounter any issues, please let us know.

| Type | Data Store |
| :--- | :--- |
| **Open Source / Self-hosted** | ⏳ [KeyDB](https://docs.keydb.dev), [Garnet](https://microsoft.github.io/garnet), [Redict](https://redict.io), [Apache Kvrocks](https://kvrocks.apache.org) |
| **Managed Cloud / Serverless** | [Amazon MemoryDB](https://aws.amazon.com/memorydb), [Azure Cache for Redis](https://azure.microsoft.com/products/cache/), [Alibaba Cloud Tair](https://www.alibabacloud.com/product/tair), [Upstash](https://upstash.com) |

<!-- ## Supported Data Stores
This package supports **[Redis](https://redis.io)** and various RESP (Redis Serialization Protocol) compatible alternatives.

**Open Source & High-Performance Replacements**
- [Valkey](https://valkey.io) - Open-source alternative backed by the Linux Foundation.
- [Dragonfly](https://dragonflydb.io) - Modern, multi-threaded drop-in replacement.
- [KeyDB](https://docs.keydb.dev) - Multithreaded fork of Redis.
- [Garnet](https://microsoft.github.io/garnet) - High-performance cache-store by Microsoft.
- [Redict](https://redict.io) - Independent, copyleft fork of Redis.
- [Apache Kvrocks](https://kvrocks.apache.org) - Distributed key-value NoSQL database backed by RocksDB.

**☁️ Managed Cloud & Serverless Services**
- [Amazon MemoryDB](https://aws.amazon.com/memorydb) (AWS)
- [Azure Cache for Redis](https://azure.microsoft.com/products/cache/) (Microsoft Azure)
- [Google Cloud Memorystore](https://cloud.google.com/memorystore) (GCP)
- [Alibaba Cloud Tair](https://www.alibabacloud.com/product/tair) (Alibaba)
- [Upstash](https://upstash.com) (Serverless Redis) -->

<!-- ## 🗄️ Redis and RESP Compatible Alternatives

| Type | Data Store |
| :--- | :--- |
| **Standard** | [Redis](https://redis.io) |
| **Open Source / Self-hosted** | [Valkey](https://valkey.io), [Dragonfly](https://dragonflydb.io), [KeyDB](https://docs.keydb.dev), [Garnet](https://microsoft.github.io/garnet), [Redict](https://redict.io), [Apache Kvrocks](https://kvrocks.apache.org) |
| **Managed Cloud / Serverless** | [Amazon MemoryDB](https://aws.amazon.com/memorydb), [Azure Cache for Redis](https://azure.microsoft.com/products/cache/), [Google Cloud Memorystore](https://cloud.google.com/memorystore), [Alibaba Cloud Tair](https://www.alibabacloud.com/product/tair), [Upstash](https://upstash.com) | -->

## 🚀 Key Features

* **High Performance:** Render 100k+ keys smoothly using `dense_table` virtualization.
* **Cluster Ready:** First-class support for Redis/Valkey Cluster & Sentinel.
* **Secure:** Built-in SSH Tunneling and TLS (SSL) support.
* **Multi-Platform:** Runs natively on macOS, Windows, and Linux.
* **Multilingual:** Internationalization (i18n) with full multi-language support.
* **Developer Friendly:** JSON viewer, CLI console, and dark mode optimized for engineers.

## 🛠 Powered By

Built with ❤️ using [keyscope_client](https://pub.dev/packages/keyscope_client) and dense_table.

* **[keyscope_client](https://pub.dev/packages/keyscope_client):** The engine behind the connectivity.
* **dense_table:** The engine behind the UI performance.
  > Merged into Keyscope UI. Functionality now included directly in Keyscope.

## 🌐 Translations

Keyscope currently supports **15+ languages**, making it accessible to developers worldwide.

| Region | Languages |
| :--- | :--- |
| **Asia** | 🇰🇷 한국어 (KR), 🇯🇵 日本語 (JP), 🇨🇳 简体中文 (CN), 🇹🇼 繁體中文 (TW), 🇮🇩 Bahasa Indonesia (ID), 🇻🇳 Tiếng Việt (VN), 🇹🇭 ภาษาไทย (TH) |
| **Europe** | 🇩🇪 Deutsch (DE), 🇨🇭 Deutsch (CH), 🇫🇷 Français (FR), 🇮🇹 Italiano (IT), 🇪🇸 Español (ES), 🇵🇹 Português (PT), 🇷🇺 Русский (RU) |
| **Americas** | 🇺🇸 English (US), 🇧🇷 Português (BR) |

For more details or to contribute a new language, check out the [Translation Guide](https://github.com/infradise/keyscope/blob/main/docs/TRANSLATIONS.md).

## 🔨Build

For more details, check out the [Build Instructions](https://github.com/infradise/keyscope/blob/main/docs/BUILD.md).

<!-- <a id="-run"></a> ▶️ -->
## ⚡ Run

```sh
lib/main.dart
```

## 📦 Installation

Check the [Releases](https://github.com/infradise/keyscope/releases) page for the latest installer (`.dmg`, `.exe`, `.msi`, `.rpm`, `.deb`).