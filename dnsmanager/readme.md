# 🌐 DNS Manager for Windows 11

![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue?logo=powershell)
![Platform](https://img.shields.io/badge/Platform-Windows%2011-0078D6?logo=windows)
![License](https://img.shields.io/badge/License-MIT-green)

A sleek graphical user interface to easily manage and switch between DNS providers on Windows 11 with full IPv4 and IPv6 support.

![DNS Manager Screenshot](https://github.com/claudemods/Windows/blob/main/dnsmanager/v1.0.png)

## ✨ Features

- 🎨 **Modern GUI** - Clean, professional interface with navy blue theme
- 🖱️ **Quick Switching** - Select a provider and click apply to switch DNS
- 🔍 **Auto Detection** - Automatically identifies your current DNS configuration
- 📡 **IPv4 Support** - Full IPv4 DNS management with primary and secondary servers
- 🌐 **IPv6 Support** - Complete IPv6 DNS management with primary and secondary servers
- 🔌 **Quick Reset** - Reset to DHCP-assigned DNS with one click
- 🛡️ **Trusted Providers** - Pre-configured with reliable DNS services
- 📊 **Real-Time Status** - See your current IPv4 and IPv6 DNS servers at a glance

## 📦 Supported DNS Providers

| Provider | IPv4 Primary | IPv4 Secondary | IPv6 Primary | IPv6 Secondary |
|----------|-------------|----------------|--------------|----------------|
| ☁️ **Cloudflare DNS** | `1.1.1.1` | `1.0.0.1` | `2606:4700:4700::1111` | `2606:4700:4700::1001` |
| 🔍 **Google Public DNS** | `8.8.8.8` | `8.8.4.4` | `2001:4860:4860::8888` | `2001:4860:4860::8844` |
| 🏠 **OpenDNS** | `208.67.222.222` | `208.67.220.220` | `2620:119:35::35` | `2620:119:53::53` |
| 🛡️ **Quad9 DNS** | `9.9.9.11` | `149.112.112.11` | `2620:fe::11` | `2620:fe::fe:11` |
| 🚫 **AdGuard DNS** | `94.140.14.14` | `94.140.15.15` | `2a10:50c0::ad1:ff` | `2a10:50c0::ad2:ff` |

## 🚀 Quick Start

### Prerequisites
- 🖥️ Windows 11 (also works on Windows 10)
- ⚡ PowerShell 5.1 or higher
- 👑 Administrator privileges (required for DNS changes)
