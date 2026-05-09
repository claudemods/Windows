<img width="1319" height="864" alt="image" src="https://github.com/user-attachments/assets/4333de9c-175f-4706-959f-8dc3db03f15e" />


##  [Download](https://claudemodsreloaded.co.uk/claudebackup/info.php)

### installer script being tested everything else works you can backup to iso for now till i update with a guide and news

### prerequisites
1:) hyper v (setup in windows features)

2:) WindowsADK (in admin powershell copy and paste below command) 

winget install --id Microsoft.WindowsADK --source winget

# 🖥️ claudebackup windows 10/11 system cloning tool

## ✨ What This Tool Does

This tool automates the complete workflow of converting a **Windows system backup** into a **bootable ISO image** with an easy-to-use graphical interface. 🚀

### 📋 Core Functionality

| Step | Operation | Description |
|------|-----------|-------------|
| 1️⃣ | **Backup Capture** | Creates a full VHDX backup of your C: drive using Windows Backup |
| 2️⃣ | **VHDX Mounting** | Automatically mounts the backup file to access its contents |
| 3️⃣ | **WIM Creation** | Extracts and compresses the mounted backup into a deployment-ready `install.wim` file |
| 4️⃣ | **ISO Building** | Packages the WIM file alongside bootable media files into a complete ISO image |

### 🎯 What You Get

- ✅ **Bootable ISO** - Ready to use for system deployment or recovery
- ✅ **High Compression** - LZMS solid compression for smaller file sizes
- ✅ **UEFI/BIOS Compatible** - Dual boot support for modern and legacy systems
- ✅ **Single File Output** - Everything packaged into one clean ISO

### 🎨 User Interface Features

- 🖤 **Sleek Dark Theme** - Eye-friendly black interface with cyan/red accents
- 📊 **Visual Progress Bar** - Real-time tracking of multi-step operations
- 📝 **Live Log Console** - Detailed operation output in neon green text
- 🖱️ **Point-and-Click** - Simple browse button to select your backup destination

### 📂 Expected Environment

- A folder named `Iso_Build` containing bootable media structure (boot, efi directories, etc.)
- Windows Assessment and Deployment Kit (for ISO creation tools)
- wimlib utilities for optimized WIM capture

### 🎬 What Happens When You Click "Start Process"

1. Creates a VHDX backup of your C: drive to your chosen location
2. Locates and mounts the backup file to drive letter `V:`
3. Captures the mounted contents as a compressed `install.wim` file
4. Builds a complete hybrid ISO (supports both BIOS and UEFI)
5. Saves `system.iso` to your backup location

### ⚡ Key Benefits

- **🕐 Time-saving** - No manual command-line steps
- **🛡️ Reliable** - Consistent, repeatable process every time
- **📦 Portable** - Single Iso that can restore to the same machine what you had before it was backed up
- **🔧 Ready-to-use** - Output works with standard deployment tools

---

**⚠️ Note:** This tool creates a complete system image - ensure you have sufficient disk space (typically 20-50GB depending on your C: drive usage)

<strong> Copyright <2026> <claudemods> Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the “Software”), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. <strong>
</div>

