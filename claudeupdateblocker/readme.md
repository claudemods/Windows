# 🔒 ClaudeUpdateblocker.ps1 - Windows Update Lock Tool 🛡️

[![Version](https://img.shields.io/badge/version-beta%20v1.01-blue.svg)](https://github.com/claudemods/Windows/blob/main/claudeupdateblocker/claudeupdateblocker.ps1)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-green.svg)](https://microsoft.com/powershell)
[![Windows](https://img.shields.io/badge/Platform-Windows%2010%2F11-orange.svg)](https://microsoft.com/windows)

> **⚠️ DISCLAIMER:** Use this tool responsibly. Locking Windows Updates may expose your system to security vulnerabilities. Only use if you know what you're doing!

## ✨ Features

- 🎨 **Beautiful GUI** with cyberpunk aesthetic (black/red/cyan theme)
- 🔒 **One-click Lock** for Windows Updates
- 🔓 **One-click Unlock** with automatic cleanup
- 📊 **Real-time Status** indicator (LOCKED/UNLOCKED)
- 📝 **Rich console output** with color-coded messages
- 🔄 **Auto-refresh** status every second

## 🎯 What It Does

This PowerShell script gives you **granular control** over Windows Updates by manipulating permissions on the `SoftwareDistribution` folder (where Windows stores update data).

### Lock Mode 🔒
- Stops Windows Update services (`wuauserv`, `bits`)
- **Removes SYSTEM account** permissions from the update folder
- Prevents Windows from downloading/installing updates

### Unlock Mode 🔓
- Restores full permissions to the update folder
- **Recursively deletes** the `SoftwareDistribution` folder (clear update cache)
- Restarts Windows Update services
- Returns system to normal update behavior

## 🚀 Quick Start

### Prerequisites
- Windows 10/11
- PowerShell 5.1 or higher
- **Administrator privileges** (must run as Admin!)

### Installation

```powershell
# 1. Download the script
powershell -c "Invoke-WebRequest 'https://raw.githubusercontent.com/claudemods/Windows/refs/heads/main/claudeupdateblocker/claudeupdateblocker.ps1' -OutFile $env:TEMP\up.ps1; Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy Bypass -File $env:TEMP\up.ps1'"
```
