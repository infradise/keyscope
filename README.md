<br />
<div align="center">
  <img src="https://download.keyscope.dev/logo.png" alt="Keyscope Logo" width="128" height="128">
  <br>
 
  <h1>Keyscope</h1>
  <p>
    A high-performance GUI client designed for <b>Redis</b>, <b>Valkey</b>, and <b>Dragonfly</b>.<br>
    It supports Cluster, Sentinel, SSH tunneling, and handles millions of keys smoothly.<br>
  </p>

  [![pub package](https://img.shields.io/pub/v/keyscope.svg?label=Latest)](https://pub.dev/packages/keyscope)
  [![GUI](https://github.com/infradise/keyscope/actions/workflows/build-gui.yaml/badge.svg)](https://github.com/infradise/keyscope/actions/workflows/build-gui.yaml)
  [![CLI](https://github.com/infradise/keyscope/actions/workflows/build-cli.yaml/badge.svg)](https://github.com/infradise/keyscope/actions/workflows/build-cli.yaml)
  [![pub package](https://img.shields.io/pub/v/keyscope_client.svg?label=keyscope_client)](https://pub.dev/packages/keyscope_client)
  [![pub package](https://img.shields.io/pub/v/dense_table.svg?label=dense_table&color=blue)](https://pub.dev/packages/dense_table)

  <!-- ![Build Status](https://img.shields.io/github/actions/workflow/status/infradise/keyscope/build.yml?branch=main) -->

  <p>
    <a href="#-why-keyscope">Why Keyscope?</a> •
    <a href="#-key-features">Key Features</a> •
    <a href="#-powered-by">Powered By</a> •
    <a href="#-build">Build</a> •
    <a href="#-installation">Installation</a>
  </p>

</div>

## ✨ Why Keyscope?

While existing tools are heavy (Electron-based) or lack support for modern Valkey features, Keyscope runs natively on [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/), powered by the high-performance [keyscope_client](https://pub.dev/packages/keyscope_client) and [dense_table](https://pub.dev/packages/dense_table). Keyscope supports **[Redis](https://redis.io), [Valkey](https://valkey.io), and [Dragonfly](https://www.dragonflydb.io/)**, with built‑in **Multilingual (i18n) support** for global users.

## 🚀 Key Features

* **High Performance:** Render 100k+ keys smoothly using `dense_table` virtualization.
* **Cluster Ready:** First-class support for Redis/Valkey Cluster & Sentinel.
* **Secure:** Built-in SSH Tunneling and TLS (SSL) support.
* **Multi-Platform:** Runs natively on macOS, Windows, and Linux.
* **Multilingual:** Internationalization (i18n) with full multi-language support.
* **Developer Friendly:** JSON viewer, CLI console, and dark mode optimized for engineers.

## 🛠 Powered By

Built with ❤️ using [keyscope_client](https://pub.dev/packages/keyscope_client) and [dense_table](https://pub.dev/packages/dense_table).

* **[keyscope_client](https://pub.dev/packages/keyscope_client):** The engine behind the connectivity.
* **[dense_table](https://pub.dev/packages/dense_table):** The engine behind the UI performance.

## 🔨 Build

To build **Keyscope**, you need to generate the `i18n.dart` file first.

This can be done by running:

```sh
dart run setup.dart
```

Alternatively, you can use the dedicated i18n generator:

```sh
dart run tool/i18n_generator.dart
```

The i18n generator compiles all translation resources into `lib/i18n.dart`, ensuring proper multi-language support.  
This file is required for a successful build.

## 📦 Installation

Check the [Releases](https://github.com/infradise/keyscope/releases) page for the latest installer (`.dmg`, `.exe`, `.msi`, `.rpm`, `.deb`).