<br />
<div align="center">
  <a href="https://keyscope.dev">
    <img src="https://download.keyscope.dev/logo.png" alt="Keyscope — Kubernetes IDE" width="128">
  </a>

  <h1>Keyscope <br /><br /> The Data-Aware Kubernetes IDE</h1>

  <p>
    <a href="#-2-data-aware-stack">
      <img src="https://img.shields.io/badge/Data%20Stack-Redis%20%7C%20Valkey%20%7C%20Upstash%20%7C%20Cloudflare%20%7C%20modern%20databases-teal?style=flat-square" alt="Data Stack">
    </a>
    <br />
    <a href="#-3-zero-switch-debugging-toolkit">
      <img src="https://img.shields.io/badge/Developer%20Toolkit-Mail%20Sender%20%7C%20HTTP%20Client%20%7C%20Visual%20Diff%20%7C%20Local%20Terminal%20%7C%20SSH%20Client%20%7C%20Text%20Editor-success?style=flat-square" alt="Toolkit">
    </a>
    <br />
    <a href="#-translations">
      <img src="https://img.shields.io/badge/Languages-English%20%7C%20Korean%20%7C%20Portuguese%20%7C%20Vietnamese%20%7C%20German%20%7C%20Japanese%20%7C%20French%20%7C%20Russian%20%7C%20Spanish-black?style=flat-square" alt="Multilingual">
    </a>
    <br />
    <a href="#-installation">
      <img src="https://img.shields.io/badge/Platform-macOS%20%7C%20Windows%20%7C%20Linux-blue?style=flat-square" alt="Supported Platforms">
    </a>
  </p>
  <br />
  <p>
    <strong>Your clusters, your data, your debugging tools — in one native app.</strong>
  </p>
  <p>
    Keyscope pairs a multi-cluster Kubernetes IDE with a GUI for in-cluster and standalone data stacks<br />
    (Redis, Valkey, Upstash, Cloudflare, modern databases) and a built-in debugging toolkit<br />
    (HTTP Client, SSH Client, Visual Diff, Local Terminal, Text Editor, Mail Sender).<br />
    Inspect and manage in-cluster data stacks <strong>without manual port-forwarding</strong>.
  </p>
  <p>
    <a href="https://keyscope.dev"><strong>Website</strong></a> •
    <a href="#-installation"><strong>Download</strong></a> •
    <a href="#-1-kubernetes-ide"><strong>Kubernetes</strong></a> •
    <a href="#-2-data-aware-stack"><strong>Data Stack</strong></a> •
    <a href="#-3-zero-switch-debugging-toolkit"><strong>Debugging Toolkit</strong></a>
  </p>
</div>

<p>
  <img width="1920" height="992" alt="Keyscope - Kubernetes IDE" src="https://github.com/user-attachments/assets/0b4fc2a1-2d3d-41dc-8326-ff0ce8809caf" />
</p>

<br />

<p>
  <img width="1920" height="992" alt="Keyscope - Data Stack IDE (Redis)" src="https://github.com/user-attachments/assets/86dbc777-1748-406c-ac2f-31d34c349cc7" />
</p>

<!-- ![Keyscope Native Workspace Integration](https://download.keyscope.dev/screenshots/main/keyscope-native-workspace-integration.png) -->

<br />

## ✨ Why Keyscope?

A typical debugging session means juggling a Kubernetes dashboard, a database GUI, an API client, an SSH client, and a handful of terminals running `kubectl port-forward`. Every switch costs context.

Keyscope collapses that workflow into **one data-aware workspace**, built on three pillars:

| Pillar | Instead of… | Keyscope gives you |
| :--- | :--- | :--- |
| **[1. Kubernetes IDE](#-1-kubernetes-ide)** | A standalone cluster dashboard | Multi-cluster groups, real-time resource watch, 50+ resource views, YAML editing, pod shells & logs |
| **[2. Data-Aware Stack](#-2-data-aware-stack)** | A separate DB GUI + `kubectl port-forward` | Direct access to in-cluster data stacks and standalone cloud data services — no tunnels to babysit |
| **[3. Zero-Switch Debugging Toolkit](#-3-zero-switch-debugging-toolkit)** | Separate API, SSH, diff, terminal & mail tools | HTTP Client, SSH Client, Visual Diff, Local Terminal, Mail Sender, and Text Editor (Planned) in the same window |

**Built into every pillar:**

- ⚡ **Blazing-Fast Native Core** — Built on a proprietary, high-performance client engine. Compact native builds for macOS, Windows, and Linux with fast response times — **~14–15 MB on macOS**.
- 🌐 **Multilingual UI** — Supports [9 key languages](#-translations) out of the box.
- 🖥️ **Cross-Platform** — macOS, Windows, and Linux across `arm64` and `x86_64`.

<br />

## 🚢 1. Kubernetes IDE

**Multi-Cluster & Real-Time Workload Control**

Navigate every cluster you own from a single Activity Bar — with live state, in-place edits, and shell access one click away.

<p>
  <img width="1920" height="992" alt="Keyscope - Kubernetes Cluster Manager" src="https://github.com/user-attachments/assets/3d6b264e-9333-47b0-8522-11efc52c136d" />
</p>

<p>
  <img width="1126" height="705" alt="Keyscope - Kubernetes Multi-Cluster Group" src="https://github.com/user-attachments/assets/3d062f15-c60e-4c0f-a891-585e984401df" />
</p>

### Core features

- **Multi-Cluster Groups** — Group clusters and pin them to the Activity Bar for instant one-click access.
- **Multi-Cluster & Context Management** — Manage and favorite multiple Kubernetes clusters & contexts.
- **Automated `~/.kube` Discovery** — Scan and discover all kubeconfig files across `~/.kube`.
- **Real-Time Resource Watch** — Live status updates across pods, workloads, and cluster events.
- **50+ K8s Resource Views** — Comprehensive inspection for workloads, network, storage, and configs.
- **Manifest & YAML Editor** — Fast, in-place resource editing with syntax validation.
- **Interactive Terminal & Pod Logs** — Multi-container shell access and real-time log streaming.

### 50+ K8s Resource Views

| Category | Resources |
| :--- | :--- |
| **Cluster** | Nodes, Namespaces, Events, API Services, Component Statuses, Cluster CIDR |
| **Workloads** | Pods, Deployments, Daemon Sets, Stateful Sets, Replica Sets, Replication Controllers, Jobs, Cron Jobs, Controller Revisions, Pod Templates |
| **Network** | Services, Ingresses, Endpoint Slices, Endpoints, Ingress Classes, Network Policies, Port Forwarding |
| **Config** | Secrets, ConfigMaps, Horizontal Pod Autoscalers, Vertical Pod Autoscalers, Limit Ranges, Resource Quotas, Pod Disruption Budgets, Leases, Flow Schemas, Priority Level Configurations |
| **Admin** | Custom Resource Definitions, Priority Classes, Runtime Classes, Mutating Webhook Configurations, Validating Webhook Configurations |
| **Storage** | Persistent Volumes, Persistent Volume Claims, Volume Attachments, Storage Classes, CSI Drivers, CSI Nodes, CSI Storage Capacities |
| **Access Control** | Service Accounts, Cluster Roles, Cluster Role Bindings, Roles, Role Bindings, Pod Security Admissions, Certificate Signing Requests |
| **Metric** | Node Metrics, Pod Metrics |
| **Helm** | Charts, Releases |

<br />

## 💾 2. Data-Aware Stack

**In-Cluster & Standalone Data GUI**

Most Kubernetes tools stop at the pod boundary. Keyscope goes one layer deeper — into the data your workloads depend on. Manage the data stack running **inside your clusters** and **standalone cloud data services** from the same client, **without manual `kubectl port-forward`**.

| Mode | How it connects | Targets |
| :--- | :--- | :--- |
| **In-Cluster** | Directly through your Kubernetes context — no manual port-forwarding | Redis, Valkey, and modern databases running in your clusters |
| **Standalone** | TLS, SSH, and SSH tunneling handled natively by the Connection Manager | Upstash, AWS ElastiCache, Google Cloud Memorystore, Azure Cache, Cloudflare R2 & D1, local / remote / managed database instances |

> [!NOTE]
> Standalone Redis and Valkey support was added in **v0.50.0**. In-Cluster Redis and Valkey support is scheduled for **v0.70.0**, and Modern Databases are planned. See the [Upcoming Roadmap](#upcoming-roadmap-v0500--v0700).

### Redis & Valkey

Keyscope provides both a `redis-cli` style shell for direct server interaction and a **Command Palette** for searchable command execution with minimal typing.

It supports **TLS, SSH, and SSH tunneling** to securely manage instances such as **Upstash, Google Cloud Memorystore, AWS ElastiCache, and Azure Cache**.

<p>
  <img width="1920" height="994" alt="Keyscope - Data Stack IDE (Redis Statistics)" src="https://github.com/user-attachments/assets/daf55b41-dcbe-4554-81bf-df63c2d8c306" />
</p>

#### Key features

Designed around developer productivity and zero-configuration setups:

- **Zero-Config Connection Manager** — Simplifies SSH tunnel setup by removing the need for multiple configuration steps.
  - **Pre-built Provider Templates** — Choose your server type from a dropdown list to start quickly.
  - **Unrivaled Connectivity** — Secure connections out of the box. TLS, SSH, and SSH tunneling are supported natively, with no manual terminal configuration.
- **Dual Interface** — The `redis-cli` shell for command-line sessions, plus a Command Palette GUI for executing commands through a searchable grid.
- **Real-time Watch** — Monitor key changes in real time while maintaining visibility across clusters.

#### Keyscope Engine & compatibility

Powered by the proprietary **Keyscope Engine**, designed for a native command experience. The engine is continuously updated toward full command coverage across Redis, Valkey, and major cloud providers, tracked by an in-app **Compatibility Matrix**.

Supported data types & commands — well beyond basic string operations:

| Category | Coverage |
| :--- | :--- |
| **Core Data Types** | String • Hash • List • Set • Sorted Set • Bitmap • HyperLogLog • Geospatial Indices • Stream • Generic |
| **Modules & Extensions** | JSON • Search • Time Series • Vector Set • Bloom Filter • Cuckoo Filter • Count-Min Sketch • T-Digest Sketch • Top-K Sketch |
| **System & Operations** | Connection • Server • Cluster • PubSub • Transactions • Scripting and Functions |

#### Quick connection guide

The **Template-Driven Connection Manager** takes care of SSH tunneling and TLS setup for you.

1. Open the **Connection Manager**.
2. Select your **Server Type** from the dropdown. Built-in templates require minimal input:
   - `Upstash (Read/Write)`
   - `Upstash (Read Only)`
   - `Google Cloud Memorystore`
   - `Custom Redis/Valkey` *(for fully manual setups)*
3. Keyscope handles **TLS / SSL**, **SSH**, or **SSH Tunneling** automatically based on your selection.
4. Click **Test Connection** to verify securely, then **Save**.

### Cloudflare R2 & D1

| | **Cloudflare R2** | **Cloudflare D1** |
| :--- | :--- | :--- |
| **What it is** | A dedicated desktop workflow to browse buckets, edit configs, and manage R2 storage | A direct connection to D1 serverless SQLite databases to run queries and inspect schemas |
| **Highlights** | • Complete Bucket Lifecycle Controls<br />• Precision Object Explorer<br />• Drag & Drop File Transfers | • Native SQL Query Editor<br />• Instant Table & Schema Browser<br />• Query Execution & Result Grid |

### Modern Databases (Planned)

Support for **PostgreSQL, MySQL, MariaDB, and MongoDB** across standalone and in-cluster environments:

- **In-Cluster** — Inspect and query databases running inside your Kubernetes clusters directly, without manual port-forwarding.
- **Standalone** — Connect directly to local, remote, or managed database instances via dedicated database connections.

<br />

## 🧰 3. Zero-Switch Debugging Toolkit

**Built-in Developer Utilities**

The utilities you reach for between `kubectl` commands — built in, so you never leave the workspace.

| Tool | Best for | Killer feature |
| :--- | :--- | :--- |
| **[HTTP Client](#http-client)** | API testing | Native Postman v2.1 collection import/export |
| **[SSH Client](#ssh-client)** | Remote servers | OS-native Keychain credential storage |
| **[Visual Diff](#visual-diff)** | Comparing configs & data | 2D scrolling with Bezier curved ribbons + data stack semantic diffing |
| **[Local Terminal](#local-terminal)** | Local shell work | Native PTY with automatic Zsh / Bash / PowerShell detection |
| **[Mail Sender](#mail-sender)** | Transactional email testing | Side-by-side live preview + direct dispatch via provider APIs (Resend) |
| **[Text Editor (Planned)](#text-editor-planned)** | Notes & scratch buffers | Timestamped files persisted to your workdir with auto-save |

### HTTP Client

- **Postman Collection Interop** — Import and export Postman v2.1 collections natively with hierarchical tree navigation.
- **Rich Response Previews** — Native inline preview for TIFF, HEIC/HEIF, AVIF, SVG, embedded PDFs, and raster images.
- **Dynamic Environment Manager** — Manage Dev/Staging/Prod environments with `{{variable}}` substitution and masked secrets.

### SSH Client

- **Multi-Auth & OS Security** — Password & Key (PEM/RSA) auth with OS-native Keychain credential storage.
- **Multi-Session Tab System** — Manage concurrent SSH sessions across tabs with real-time status indicators.
- **Connection Manager Sidebar** — Split-pane layout with a dedicated sidebar to save, edit, and quickly launch remote server connections.

### Visual Diff

- **Synchronized 2D Workspace** — Dual-pane 2D scrolling with fluid Bezier curved ribbons and token-level change highlighting.
- **Data Stack Semantic Diffing** — Direct diffing for Redis values, K8s Manifests, and D1 records with auto JSON key sorting.
- **Interactive Merge & Write-Back** — 1-click inline merges (→, ←), patch file generation, and a non-blocking 10k+ line async engine.

### Local Terminal

- **Native PTY Integration** — Native PTY process I/O with automatic OS shell detection (Zsh, Bash, PowerShell) and dynamic viewport resizing.
- **Multi-Session Tab System** — Seamless multi-session tab management with fast switching, session control, and custom tab renaming.
- **Action Bar & Shortcuts** — Built-in utility bar for real-time search, log exporting, buffer clearing, and native terminal control signals.

### Mail Sender

- **Live Preview Editor** — Compose HTML or plain text emails with an instant side-by-side live preview.
- **Direct Mail Dispatch** — Send test and transactional emails directly using email provider APIs (starting with Resend).
- **API Key Security** — Securely store and manage email API keys and sender credentials locally.

### Text Editor (Planned)

- Multi-buffer text editor and scratchpad with instant tab creation — persists flat timestamped files directly to your workdir with a per-file auto-save toggle (enabled by default), featuring sidebar navigation and direct in-place renaming from tabs or the sidebar.

<br />

## 📦 Installation

Keyscope ships as a **true native binary** — about **14–15 MB on macOS** — available for macOS, Windows, and Linux across `arm64` and `x86_64` architectures.

| Platform | Architecture | Package | Size |
| :--- | :--- | :--- | :--- |
| **macOS** | Apple Silicon (`arm64`) | `.dmg` | 14.1 MB |
| **macOS** | Intel (`x86_64`) | `.dmg` | 15.0 MB |
| **Windows** | ARM64 (`arm64`) | `.msi` | 16.6 MB |
| **Windows** | x64 (`x86_64`) | `.msi` | 17.4 MB |
| **Linux** | ARM64 (`aarch64`) | `.AppImage` | 64.9 MB |
| **Linux** | x64 (`x86_64`) | `.AppImage` | 68.6 MB |

Download the latest native builds for your operating system from the [official website](https://keyscope.dev) or from GitHub releases.

> [!TIP]
> Since **v0.41.0**, Keyscope includes a built-in auto-updater for macOS, Windows, and Linux (with AppImage delta updates) — install once and stay current.

## 🌐 Translations

Keyscope supports 9 key languages across major regions:

| Region | Languages |
| :--- | :--- |
| **Asia** | 한국어 (KR), 日本語 (JP), Tiếng Việt (VN) |
| **Europe** | Deutsch (DE), Français (FR), Русский (RU) |
| **Americas** | English (US), Português (BR), Español (ES) |

<br />

## 🧭 Roadmap & Releases

### Upcoming Roadmap (v0.50.0 ~ v0.70.0)

| Version | Milestone |
| :--- | :--- |
| **v0.70.0** | In-Cluster Redis and Valkey support |
| **v0.60.0** | Local Container Playground |
| **v0.5x.0** | Real-Time Watch for Redis and Valkey |

### Recent Release Highlights (v0.16.0 ~ v0.50.0)

| Version | Type | Highlights |
| :--- | :--- | :--- |
| **v0.50.0** | Feature | Added Standalone Redis and Valkey support |
| **v0.44.0** | Feature | Added Multi-Cluster Grouping & Connection for Kubernetes and Multi-Kubeconfig Directory Scan |
| **v0.42.0** | Feature | Added Factory Reset |
| **v0.41.0** | Feature | Added Auto-updater support for macOS, Windows, and Linux with AppImage delta update |
| **v0.40.0** | Feature | Added Kubernetes support |
| **v0.33.0** | Build & Package | Separated macOS release packages into distinct Apple Silicon (`arm64`) and Intel (`x86_64`) binaries |
| **v0.33.0** | Feature | Added Linux Pre-Launch System Setup |
| **v0.32.0** | Feature | Added SSH Client |
| **v0.31.0** | Feature | Added Local Terminal |
| **v0.30.2** | Build & Package | Added official support for Linux WebKit with full compatibility |
| **v0.30.0** | Build & Package | Added official support for Windows ARM64 |
| **v0.30.0** | Feature | Added Mail Sender, HTTP Client, and Visual Diff |
| **v0.20.1** | Build & Package | Added official support for Linux ARM64 (`aarch64`) |
| **v0.20.1** | Feature | Added support for Cloudflare R2 and D1 |
| **v0.16.0** | Build & Package | Updated installer formats and reduced package sizes |

> [!NOTE]
> For feature requests, bug reports, or more information, open a GitHub issue, start a discussion, or visit the [official website](https://keyscope.dev).

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
