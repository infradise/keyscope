# Keyscope

[![pub package](https://img.shields.io/pub/v/keyscope.svg)](https://pub.dev/packages/keyscope)
[![GUI](https://github.com/infradise/keyscope/actions/workflows/build-gui.yaml/badge.svg)](https://github.com/infradise/keyscope/actions/workflows/build-gui.yaml)
[![CLI](https://github.com/infradise/keyscope/actions/workflows/build-cli.yaml/badge.svg)](https://github.com/infradise/keyscope/actions/workflows/build-cli.yaml)
<!-- ![Build Status](https://img.shields.io/github/actions/workflow/status/infradise/keyscope/build.yml?branch=main) -->

### The Open Source Redis & Valkey GUI Client

**Keyscope** is a high-performance GUI client designed for **Redis** and **Valkey**.
It supports Cluster, Sentinel, SSH tunneling, and handles millions of keys smoothly.

Built with ❤️ using [valkey_client](https://pub.dev/packages/valkey_client) and [dense_table](https://pub.dev/packages/dense_table).

---

> **Why Keyscope?**  
> While existing tools are heavy (Electron-based) or lack support for modern Valkey features, Keyscope runs natively on **Flutter**, powered by the high-performance [valkey_client](https://pub.dev/packages/valkey_client) and [dense_table](https://pub.dev/packages/dense_table).

## 🚀 Key Features

* **High Performance:** Render 100k+ keys smoothly using `dense_table` virtualization.
* **Cluster Ready:** First-class support for Redis/Valkey Cluster & Sentinel.
* **Secure:** Built-in SSH Tunneling and TLS (SSL) support.
* **Multi-Platform:** Runs natively on macOS, Windows, and Linux.
* **Developer Friendly:** JSON viewer, CLI console, and dark mode optimized for engineers.

## 🛠 Powered By

* **[valkey_client](https://pub.dev/packages/valkey_client):** The engine behind the connectivity.
* **[dense_table](https://pub.dev/packages/dense_table):** The engine behind the UI performance.

## 📦 Installation

Check the [Releases](https://github.com/infradise/keyscope/releases) page for the latest installer (`.dmg`, `.exe`, `.rpm`, `.deb`).