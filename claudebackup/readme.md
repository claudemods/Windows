# 🖥️ VHDX → WIM → ISO Automation Tool

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

- A folder named `ISO_Build` containing bootable media structure (boot, efi directories, etc.)
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
- **📦 Portable** - Single ISO can deploy to many machines
- **🔧 Ready-to-use** - Output works with standard deployment tools

---

**⚠️ Note:** This tool creates a complete system image - ensure you have sufficient disk space (typically 20-50GB depending on your C: drive usage)
