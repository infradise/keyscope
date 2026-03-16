<br />
<div align="center">
  <img src="https://download.keyscope.dev/logo.png" alt="Keyscope Logo" width="128" />
  <br />

  <h1>Keyscope : Unified Redis/Valkey GUI</h1>

  <p>
    <a href="https://keyscope.dev"><img src="https://img.shields.io/badge/Platform-macOS%20%7C%20Windows%20%7C%20Linux-blue?style=flat-square" alt="Supported Platforms"></a>
    <a href="#"><img src="https://img.shields.io/badge/Supports-Redis%20%7C%20Valkey-red?style=flat-square" alt="Redis & Valkey"></a>
    <a href="#"><img src="https://img.shields.io/badge/Security-TLS%20%7C%20SSH-success?style=flat-square" alt="Security"></a>
    <a href="#"><img src="https://img.shields.io/badge/Languages-16%20Supported-orange?style=flat-square" alt="Multilingual"></a>
  </p>

  **A lightweight, native GUI client for unified Redis and Valkey management.**
</div>

<br />

## What is Keyscope?

Keyscope provides both a `redis-cli` style shell for direct server interaction and a Command Palette for searchable command execution with minimal typing.

Keyscope supports **TLS, SSH, and SSH tunneling** to securely manage instances such as Upstash, Google Cloud Memorystore, AWS ElastiCache, and Azure Cache.

![Keyscope UI Screenshot](https://download.keyscope.dev/screenshots/v1.0.0/keyscope-connection-manager.png)

## Key Features

Keyscope is designed to prioritize developer productivity and zero-configuration setups:

- **Zero-Config Connection Manager:** Simplifies SSH tunnel setup by removing the need for multiple configuration steps.
  - **Pre-built Provider Templates**: Choose your server type from a dropdown list to start quickly.
  - **Unrivaled Connectivity:** Provides secure connections out-of-the-box. The Connection Manager supports TLS, SSH, and SSH tunneling natively, without requiring manual terminal configuration.
- **Dual Interface:** Offers both the `redis-cli` shell for command-line sessions and a Command Palette GUI for executing commands through a searchable grid.
- **Blazing-Fast Native Core:** Built on a proprietary, high-performance client engine, Keyscope delivers compact native builds for macOS (Universal), Windows, and Linux with fast response times.
- **Real-time Watch:** Enables monitoring of key changes in real time while maintaining visibility across clusters.
- **Multilingual UI:** Supports more than 15 languages.

## Unmatched Compatibility & Keyscope Library

Keyscope is powered by the proprietary **Keyscope Library**, designed to provide a native command experience.

The library is continuously updated to provide full command coverage across Redis, Valkey, and major cloud providers, with an in-app **Compatibility Matrix**.

### Supported Data Types & Commands

Keyscope Library supports a wide range of commands beyond basic string operations:

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

Keyscope supports more than 15 languages.

| Region | Languages |
| :--- | :--- |
| **Asia** | 한국어 (KR), 日本語 (JP), 简体中文 (CN), 繁體中文 (TW), Tiếng Việt (VN), ภาษาไทย (TH), Bahasa Indonesia (ID) |
| **Europe** | Français (FR), Deutsch (DE), Schweizerdeutsch (CH), Italiano (IT), Español (ES), Português (PT), Русский (RU) |
| **Americas** | English (US), Português (BR) |

## Installation

Keyscope provides a full-featured experience in under 20MB.

- **macOS Universal** (Silicon & Intel) — 19.0 MB
- **Windows** (64-bit, .zip archive) — 12.6 MB
- **Linux** (x86_64, .AppImage) — 18.5 MB

Download the latest native builds for your operating system from the official website or from GitHub releases.

> [!NOTE]
> For feature requests, bug reports, or more information, open a GitHub issue, start a discussion, or visit the official website.

---

<div align="center">
  © 2025-2026 Infradise Inc. All rights reserved.
</div>