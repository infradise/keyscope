<br />
<div align="center">
  <a href="https://keyscope.dev">
    <img src="https://download.keyscope.dev/logo.png" alt="Keyscope logo — Unified GUI for Your Entire Data Stack" width="128">
  </a>

  <h1>Keyscope <br /><br /> All-in-One GUI for Your Data Stack</h1>

  <p>
    <a href="#"><img src="https://img.shields.io/badge/Platform-macOS%20%7C%20Windows%20%7C%20Linux-blue?style=flat-square" alt="Supported Platforms"></a>
    <a href="#"><img src="https://img.shields.io/badge/Supports-Redis%20%7C%20Valkey%20%7C%20Upstash%20%7C%20Cloudflare%20%7C%20Kubernetes-teal?style=flat-square" alt="Supported Integrations"></a>
    <a href="#"><img src="https://img.shields.io/badge/Security-TLS%20%7C%20SSH-success?style=flat-square" alt="Security"></a>
    <a href="#"><img src="https://img.shields.io/badge/Languages-9%20Supported-brown?style=flat-square" alt="Multilingual"></a>
  </p>

  <br />

  <p>
    <strong>A lightweight native app to manage Redis, Valkey, Upstash,<br />
    Cloudflare, Kubernetes, and modern databases in one place.</strong>
  </p>
</div>

![Keyscope Native Workspace Integration](https://download.keyscope.dev/screenshots/main/keyscope-native-workspace-integration.png)

<br />

## What is Keyscope?

Keyscope provides both a `redis-cli` style shell for direct server interaction and a Command Palette for searchable command execution with minimal typing.

Keyscope supports **TLS, SSH, and SSH tunneling** to securely manage instances such as Upstash, Google Cloud Memorystore, AWS ElastiCache, and Azure Cache.

![Keyscope Redis/Valkey Connection Manager](https://download.keyscope.dev/screenshots/v0.20.0/keyscope-redis-valkey-connection-manager.png)

## Key Features

Keyscope is designed to prioritize developer productivity and zero-configuration setups:

- **Zero-Config Connection Manager:** Simplifies SSH tunnel setup by removing the need for multiple configuration steps.
  - **Pre-built Provider Templates**: Choose your server type from a dropdown list to start quickly.
  - **Unrivaled Connectivity:** Provides secure connections out-of-the-box. The Connection Manager supports TLS, SSH, and SSH tunneling natively, without requiring manual terminal configuration.
- **Dual Interface:** Offers both the `redis-cli` shell for command-line sessions and a Command Palette GUI for executing commands through a searchable grid.
- **Blazing-Fast Native Core:** Built on a proprietary, high-performance client engine, Keyscope delivers compact native builds for macOS (Universal), Windows, and Linux with fast response times.
- **Real-time Watch:** Enables monitoring of key changes in real time while maintaining visibility across clusters.
- **Multilingual UI:** Supports 9 key languages.

## Unmatched Compatibility & Keyscope Engine

Keyscope is powered by the proprietary **Keyscope Engine**, designed to provide a native command experience.

The engine is continuously updated to provide full command coverage across Redis, Valkey, and major cloud providers, with an in-app **Compatibility Matrix**.

### Supported Data Types & Commands

Keyscope Engine supports a wide range of commands beyond basic string operations:

* **Core Data Types:**
  String • Hash • List • Set • Sorted Set • Bitmap • HyperLogLog • Geospatial Indices • Stream • Generic
* **Modules & Extensions:**
  JSON • Search • Time Series • Vector Set • Bloom Filter • Cuckoo Filter • Count-Min Sketch • T-Digest Sketch • Top-K Sketch
* **System & Operations:**
  Connection • Server • Cluster • PubSub • Transactions • Scripting and Functions

## Quick Connection Guide

Keyscope simplifies SSH tunneling and TLS setup with a **Template-Driven Connection Manager**.

1. Open the **Connection Manager**.
2. Select your **Server Type** from the dropdown menu. Our built-in templates require minimal input:
   - `Upstash (Read/Write)`
   - `Upstash (Read Only)`
   - `Google Cloud Memorystore`
   - `Custom Redis/Valkey` *(for fully manual setups)*
3. Keyscope automatically handles the heavy lifting for **TLS / SSL** or **SSH** or **SSH Tunneling** based on your selection.
4. Click **Test Connection** to securely verify, then **Save**.

## Translations

Keyscope supports 9 key languages across major regions:

| Region | Languages |
| :--- | :--- |
| **Asia** | 한국어 (KR), 日本語 (JP), Tiếng Việt (VN) |
| **Europe** | Deutsch (DE), Français (FR), Русский (RU) |
| **Americas** | English (US), Português (BR), Español (ES) |

## Installation

Keyscope provides a full-featured experience at under 15MB per single-architecture build.

- **macOS Universal** (Intel & Apple Silicon dual-arch) — 25.8 MB (.dmg installer)
- **Windows** (64-bit, zipped installer) — 12.1 MB
- **Linux** (.AppImage)
  - **x86_64** — 12.1 MB
  - **ARM64** (aarch64) — 11.6 MB

Download the latest native builds for your operating system from the official website or from GitHub releases.

> [!NOTE]
> **Recent Build & Package Updates:**
> - **v0.20.1**: Added official support for Linux ARM64 (`aarch64`).
> - **v0.16.0**: Updated installer formats and reduced package sizes.
> 
> For feature requests, bug reports, or more information, open a GitHub issue, start a discussion, or visit the official website.

<br />

---

<div align="center">
  <h1>
    <img src="https://www.infradise.com/images/logo.png" height=24 alt="Infradise Logo">
    Infradise
  </h1>

  **True Native Engineering.**  
  Simplified Management. Boundless Connection.

  © 2025-2026 Infradise Inc. All rights reserved.
</div>
