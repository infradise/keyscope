<br />
<div align="center">
  <img src="https://download.keyscope.dev/logo.png" alt="Keyscope Devs" width="128" height="128">
  <br>
 
  <h1>Keyscope</h1>
  <p>
    A high-performance GUI client designed for <b>Redis</b> and <b>Valkey</b>.<br>
    It supports Cluster, Sentinel, SSH tunneling, and handles millions of keys smoothly.<br>
  </p>

  [![pub package](https://img.shields.io/pub/v/keyscope.svg?label=Latest)](https://pub.dev/packages/keyscope)
  [![GUI](https://github.com/infradise/keyscope/actions/workflows/build-gui.yaml/badge.svg)](https://github.com/infradise/keyscope/actions/workflows/build-gui.yaml)
  [![CLI](https://github.com/infradise/keyscope/actions/workflows/build-cli.yaml/badge.svg)](https://github.com/infradise/keyscope/actions/workflows/build-cli.yaml)
  [![pub package](https://img.shields.io/pub/v/typeredis.svg?label=TypeRedis&color=blue)](https://pub.dev/packages/TypeRedis)
  [![pub package](https://img.shields.io/pub/v/dense_table.svg?label=DenseTable&color=blue)](https://pub.dev/packages/dense_table)

  <!-- ![Build Status](https://img.shields.io/github/actions/workflow/status/infradise/keyscope/build.yml?branch=main) -->

  <p>
    <a href="#-why-keyscope">Why Keyscope?</a> •
    <a href="#-key-features">Key Features</a> •
    <a href="#-powered-by">Powered By</a> •
    <a href="#-installation">Installation</a>
  </p>

</div>

## ✨ Why Keyscope?

While existing tools are heavy (Electron-based) or lack support for modern Valkey features, Keyscope runs natively on [Dart](https://dart.dev/) and [Flutter](https://flutter.dev/), powered by the high-performance [TypeRedis](https://pub.dev/packages/TypeRedis) and [DenseTable](https://pub.dev/packages/dense_table). Keyscope supports **[Redis](https://redis.io), [Valkey](https://valkey.io), and [Dragonfly](https://www.dragonflydb.io/)**, with built‑in **Multilingual (i18n) support** for global users.

## 🚀 Key Features

* **High Performance:** Render 100k+ keys smoothly using `DenseTable` virtualization.
* **Cluster Ready:** First-class support for Redis/Valkey Cluster & Sentinel.
* **Secure:** Built-in SSH Tunneling and TLS (SSL) support.
* **Multi-Platform:** Runs natively on macOS, Windows, and Linux.
* **Multilingual:** Internationalization (i18n) with full multi-language support.
* **Developer Friendly:** JSON viewer, CLI console, and dark mode optimized for engineers.

## 🛠 Powered By

Built with ❤️ using [TypeRedis](https://pub.dev/packages/TypeRedis) and [DenseTable](https://pub.dev/packages/dense_table).

* **[TypeRedis](https://pub.dev/packages/TypeRedis):** The engine behind the connectivity.
* **[DenseTable](https://pub.dev/packages/dense_table):** The engine behind the UI performance.

## 📦 Installation

Check the [Releases](https://github.com/infradise/keyscope/releases) page for the latest installer (`.dmg`, `.exe`, `.rpm`, `.deb`).