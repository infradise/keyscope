<br />
<div align="center">
  <a href="https://keyscope.dev">
    <img src="https://download.keyscope.dev/logo.png" alt="Keyscope — Dev Stack GUI" width="128">
  </a>

  <h1>Keyscope <br /><br /> Dev Stack GUI</h1>

  <p>
    <a href="#">
      <img src="https://img.shields.io/badge/Dev%20Stack-Kubernetes%20%7C%20Redis%20%7C%20Valkey%20%7C%20Upstash%20%7C%20Cloudflare%20%7C%20modern%20databases-teal?style=flat-square" alt="Dev Stack (Infra & Data Stack)">
    </a>
    <br />
    <a href="#">
      <img src="https://img.shields.io/badge/Developer%20Toolkit-Mail%20Sender%20%7C%20HTTP%20Client%20%7C%20Visual%20Diff%20%7C%20Local%20Terminal%20%7C%20SSH%20Client%20%7C%20Text%20Editor-success?style=flat-square" alt="Toolkit">
    </a>
    <br />
    <a href="#">
      <img src="https://img.shields.io/badge/Languages-English%20%7C%20Korean%20%7C%20Portuguese%20%7C%20Vietnamese%20%7C%20German%20%7C%20Japanese%20%7C%20French%20%7C%20Russian%20%7C%20Spanish-black?style=flat-square" alt="Multilingual">
    </a>
    <br />
    <a href="#">
      <img src="https://img.shields.io/badge/Platform-macOS%20%7C%20Windows%20%7C%20Linux-blue?style=flat-square" alt="Supported Platforms">
    </a>
  </p>
  <br />
  <p>
    <strong>A lightweight native app to manage Kubernetes, Redis, Valkey, Upstash, Cloudflare, modern databases, and essential Toolkit (Mail Sender, HTTP Client, Visual Diff, Local Terminal, SSH Client, and Text Editor) all in one place.</strong>
  </p>
</div>

![Keyscope Native Workspace Integration](https://download.keyscope.dev/screenshots/main/keyscope-native-workspace-integration.png)

<br />

## What is Keyscope?

Dev Stack GUI.

A lightweight native app to manage Kubernetes, Redis, Valkey, Upstash, Cloudflare, modern databases, and essential Toolkit (Mail Sender, HTTP Client, Visual Diff, Local Terminal, SSH Client, and Text Editor) all in one place.

## Kubernetes features

### Kubernetes Resources (Rolling out from v0.40.0)
> **Note:** Support for the following resources will be introduced progressively, starting with core features in v0.40.0.

- Cluster: 
  - Nodes, Namespaces, Events, API Services, Component Statuses, Cluster CIDR
- Workloads:  
  - Pods, Deployments, Daemon Sets, Stateful Sets, Replica Sets, Replication Controllers, Jobs, Cron Jobs, Controller Revisions, Pod Templates
- Network:  
  - Services, Ingresses, Endpoint Slices, Endpoints, Ingress Classes, Network Policies, Port Forwarding
- Config:  
  - Secrets, ConfigMaps, Horizontal Pod Autoscalers, Vertical Pod Autoscalers, Limit Ranges, Resource Quotas, Pod Disruption Budgets, Leases, Flow Schemas, Priority Level Configurations
- Admin:
  - Custom Resource Definitions, Priority Classes, Runtime Classes, Mutating Webhook Configurations, Validating Webhook Configurations
- Storage:
  - Persistent Volumes, Persistent Volume Claims, Volume Attachments, Storage Classes, CSI Drivers, CSI Nodes, CSI Storage Capacities
- Access Control:
  - Service Accounts, Cluster Roles, Cluster Role Bindings, Roles, Role Bindings, Pod Security Admissions, Certificate Signing Requests
- Metric: 
  - Node Metrics, Pod Metrics
- Helm: 
  - Charts, Releases


## Cloudflare features

### Cloudflare R2
A dedicated desktop workflow to browse buckets, edit configs, and manage Cloudflare R2 storage effortlessly.
- **Complete Bucket Lifecycle Controls**
- **Precision Object Explorer**
- **Drag & Drop File Transfers**

### Cloudflare D1
Connect directly to Cloudflare D1 serverless SQLite databases, run queries, and inspect schemas.
- **Native SQL Query Editor**
- **Instant Table & Schema Browser**
- **Query Execution & Result Grid**

## Toolkit features
A versatile suite of developer utilities to boost your daily productivity.

### Mail Sender
- **Live Preview Editor**: Compose HTML or plain text emails with an instant side-by-side live preview.
- **Direct Mail Dispatch**: Send test and transactional emails directly using email provider APIs (starting with Resend).
- **API Key Security**: Securely store and manage email API keys and sender credentials locally.

### HTTP Client
- **Postman Collection Interop**: Import and export Postman v2.1 collections natively with hierarchical tree navigation.
- **Rich Response Previews**: Native inline preview for TIFF, HEIC/HEIF, AVIF, SVG, embedded PDFs, and raster images.
- **Dynamic Environment Manager**: Manage Dev/Staging/Prod environments with {{variable}} substitution and masked secrets.

### Visual Diff
- **Synchronized 2D Workspace**: Dual-pane 2D scrolling with fluid Bezier curved ribbons and token-level change highlighting.
- **Data Stack Semantic Diffing**: Direct diffing for Redis values, K8s Manifests, and D1 records with auto JSON key sorting.
- **Interactive Merge & Write-Back**: 1-click inline merges (→, ←), patch file generation, and non-blocking 10k+ line async engine.

### Local Terminal
- **Native PTY Integration**: Native PTY process I/O with automatic OS shell detection (Zsh, Bash, PowerShell) and dynamic viewport resizing.
- **Multi-Session Tab System**: Seamless multi-session tab management with fast switching, session control, and custom tab renaming.
- **Action Bar & Shortcuts**: Built-in utility bar for real-time search, log exporting, buffer clearing, and native terminal control signals.

### SSH Client
- **Multi-Auth & OS Security**: Password & Key (PEM/RSA) auth with OS-native Keychain credential storage.
- **Multi-Session Tab System**: Manage concurrent SSH sessions across tabs with real-time status indicators.
- **Connection Manager Sidebar**: Split-pane layout with a dedicated sidebar to save, edit, and quickly launch remote server connections.

### Text Editor (Upcoming)
- Planned for a future release.


## Redis & Valkey features

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

Keyscope is available for macOS, Windows, and Linux across arm64 and x86_64 architectures.

- macOS arm64 (.dmg): 13.9 MB
- macOS x86_64 (.dmg): 14.8 MB
- Windows Arm64 (.msi): 16.7 MB
- Windows 64-bit (.msi): 17.6 MB
- Linux aarch64 (.AppImage): 66.2 MB
- Linux x86_64 (.AppImage): 70.2 MB

Download the latest native builds for your operating system from the official website or from GitHub releases.

> [!NOTE]
> **Recent Build & Package Updates:**
> - **v0.33.0**: Separated macOS release packages into distinct Apple Silicon (arm64) and Intel (x86_64) binaries. 
> - **v0.30.2**: Added official support for Linux WebKit with full compatibility.
> - **v0.30.0**: Added official support for Windows ARM64.
> - **v0.20.1**: Added official support for Linux ARM64 (`aarch64`).
> - **v0.16.0**: Updated installer formats and reduced package sizes.

> [!NOTE]
> **Recent Version & Roadmap Updates:**
> - **v0.40.0**: Introducing Kubernetes support.
> - **v0.33.0**: Added Linux Pre-Launch System Setup.
> - **v0.32.0**: Added SSH Client.
> - **v0.31.0**: Added Local Terminal.
> - **v0.30.0**: Added Mail Sender, HTTP Client, and Visual Diff.
> - **v0.20.1**: Added support for Cloudflare R2 and D1.
 
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
