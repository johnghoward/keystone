# 🚀 Keystone2: The Professional Arch Linux Developer Suite (2026)

> [!IMPORTANT]
> **MODERNIZED:** This repository has been refactored into **Keystone2**, a high-performance, interactive Arch Linux installation suite designed for the modern developer.

<p align="center">
  <img src="keystone_green_teal.png" alt="Keystone2 Logo" width="600px" />
</p>

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Arch Linux](https://img.shields.io/badge/OS-Arch%20Linux-blue?logo=arch-linux)](https://archlinux.org/)

**Keystone2** is a professional-grade, interactive Arch Linux deployment suite. It moves beyond simple scripting to provide a polished, menu-driven experience (powered by `whiptail`) for building high-end workstations and AI-ready development environments.

---

## 🌟 What's New in Keystone2?

Keystone2 introduces significant architectural improvements and modern tooling for the 2026 developer landscape.

### Key Features:
*   **Interactive TUI:** A polished, user-friendly interface using `whiptail` for all configuration steps.
*   **2026 Developer Suite:** Integrated support for `uv` (Python), `Ollama` (Local AI), `Gemini CLI`, and more.
*   **Keystone Companion App:** A built-in React-based dashboard for managing your system post-install.
*   **Profile Export:** Save your installation configuration as a reusable template for future deployments.
*   **Advanced Hardware Logic:** Automated detection and optimized driver installation for NVIDIA (DKMS), AMD, and Intel.
*   **Security First:** Native **LUKS** encryption support integrated directly into the BTRFS subvolume workflow.
*   **Modern Shell:** Pre-configured ZSH with `powerlevel10k` and automated alias management.

---

## 🛠️ Installation Instructions

### 1. Boot the Arch Linux ISO
Download the latest Arch ISO from [archlinux.org](https://archlinux.org/download/) and boot your system.

### 2. Connect to the Internet
Ensure you have an active internet connection. For Wi-Fi, use `iwctl`.

### 3. Run the Keystone2 Installer
Execute the following one-liner to clone and start the interactive setup:

```bash
pacman -Sy --noconfirm git && \
git clone https://github.com/johnghoward/keystone keystone2 && \
cd keystone2 && \
./keystone.sh
```

---

## 🎨 Professional Developer Suite

During setup, you can toggle specific tools for your stack:
*   **AI/LLM:** Ollama (Local AI) and Gemini CLI.
*   **Web/Data:** XAMPP, SQLite, and R Statistical Suite.
*   **Tooling:** `uv` and `uvx` for lightning-fast Python management.
*   **Dashboard:** The **Keystone Companion** (React) dashboard for system monitoring.

---

## 📂 Project Structure

*   `keystone.sh`: The main entry point and orchestrator.
*   `scripts/lib.sh`: Centralized UI and execution library.
*   `scripts/startup.sh`: Interactive configuration and profile generator.
*   `companion-app/`: React-based system management dashboard.
*   `configs/`: Optimized configurations for KDE, ZSH, and system services.

---

## 🤝 Credits & Evolution

*   **Original Foundation:** Based on [ArchTitus](https://github.com/ChrisTitusTech/ArchTitus) by Chris Titus.
*   **Evolution:** Modernized and expanded by John G. Howard to meet 2026 standards.
*   **Status:** Active development. Contributions are welcome!

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  <i>Keystone2: Professionalism. Performance. Precision.</i>
</p>
