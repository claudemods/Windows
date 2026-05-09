@echo off
chcp 65001 >nul
title claudeinstaller beta v1.0 ── 09-05-2026
color 0C

:: Check for Administrator privileges
net session >nul 2>&1
if %errorlevel% neq 0 (
    @echo Error: This script must be run as Administrator!
    @echo Please right-click and select "Run as Administrator"
    pause
    exit /b 1
)

:: Define fixed paths
set "wimPath=D:\sources\install.wim"
set "efiLetter=S"
set "windowsLetter=C"

:main
cls
@echo ████████████████████████████████████████████████████████████████████████████████
@echo ░█████╗░██║░░░░░░█████╗░██║░░░██║██████╗░███████╗███╗░░░███╗░█████╗░██████╗░██████╗
@echo ██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝
@echo ██║░░╚═╝██║░░░░░███████║██║░░░██║██║░░██║█████╗░░██╔████╔██║██║░░██║██║░░██║╚█████╗░
@echo ██║░░██╗██║░░░░░██╔══██║██║░░░██║██║░░██║██╔══╝░░██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗
@echo ╚█████╔╝███████╗██║░░██║╚██████╔╝██████╔╝███████╗██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝
@echo ░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░
@echo ████████████████████████████████████████████████████████████████████████████████
@echo.
@echo claudeinstaller beta v1.0 ── 09-05-2026
@echo.
@echo ================================================================
@echo SOURCE IMAGE
@echo ================================================================
@echo Using WIM file: %wimPath%
@echo.
@echo ================================================================
@echo TARGET DISK SELECTION
@echo ================================================================

:: List available disks using diskpart
@echo Available disks:
@echo.
@echo list disk > "%temp%\diskpart_list.txt"
diskpart /s "%temp%\diskpart_list.txt"
del "%temp%\diskpart_list.txt"
@echo.
set /p "diskNumber=Enter disk number to install Windows on: "

:: Validate disk number
@echo %diskNumber%|findstr /r "^[0-9][0-9]*$">nul
if errorlevel 1 (
    @echo Invalid disk number!
    pause
    goto main
)

:: Check if WIM exists
if not exist "%wimPath%" (
    @echo.
    @echo ERROR: WIM file not found at: %wimPath%
    @echo Make sure the Windows installation media is mounted as D: drive.
    @echo.
    pause
    exit /b 1
)

@echo.
@echo ================================================================
@echo WARNING!
@echo ================================================================
@echo ⚠️ Disk %diskNumber% will be ENTIRELY repartitioned!
@echo All data will be permanently destroyed!
@echo.
@echo Partition layout that will be created:
@echo • EFI System Partition: 100 MB - %efiLetter%: (FAT32)
@echo • MSR Partition: 16 MB
@echo • Windows Partition: Remaining space - %windowsLetter%: (NTFS)
@echo.
@echo The script will then apply the WIM image and configure
@echo boot files automatically for UEFI boot.
@echo.
@echo ⚠️⚠️⚠️ THIS WILL DESTROY ALL DATA ON DISK %diskNumber%! ⚠️⚠️⚠️
@echo.
set /p "confirm=Are you sure you want to continue? (YES/NO): "
if /i not "%confirm%"=="YES" (
    @echo Operation cancelled.
    pause
    exit /b 0
)

@echo.
@echo Starting deployment...
@echo.

:: Step 1: Prepare drive letters
@echo [1/6] Preparing drive letters...

:: Remove existing drive letter assignments if they exist
if exist "%efiLetter%:\" (
    @echo select volume %efiLetter% > "%temp%\diskpart_remove.txt"
    @echo remove >> "%temp%\diskpart_remove.txt"
    diskpart /s "%temp%\diskpart_remove.txt" >nul 2>&1
    del "%temp%\diskpart_remove.txt" 2>nul
)

if exist "%windowsLetter%:\" (
    @echo select volume %windowsLetter% > "%temp%\diskpart_remove.txt"
    @echo remove >> "%temp%\diskpart_remove.txt"
    diskpart /s "%temp%\diskpart_remove.txt" >nul 2>&1
    del "%temp%\diskpart_remove.txt" 2>nul
)

@echo Complete.
@echo.

:: Step 2: Clean and initialize disk as GPT
@echo [2/6] Cleaning disk %diskNumber% and initializing GPT...
(
@echo select disk %diskNumber%
@echo clean
@echo convert gpt
) > "%temp%\diskpart_init.txt"
diskpart /s "%temp%\diskpart_init.txt" >nul 2>&1
if errorlevel 1 (
    @echo ERROR: Failed to initialize disk!
    type "%temp%\diskpart_init.txt"
    del "%temp%\diskpart_init.txt"
    pause
    exit /b 1
)
del "%temp%\diskpart_init.txt"
@echo Complete.
@echo.

:: Step 3: Create EFI System Partition
@echo [3/6] Creating EFI System Partition (%efiLetter%:)...
(
@echo select disk %diskNumber%
@echo create partition efi size=100
@echo format quick fs=fat32 label="EFI"
@echo assign letter=%efiLetter%
) > "%temp%\diskpart_efi.txt"
diskpart /s "%temp%\diskpart_efi.txt" >nul 2>&1
if errorlevel 1 (
    @echo ERROR: Failed to create EFI partition!
    type "%temp%\diskpart_efi.txt"
    del "%temp%\diskpart_efi.txt"
    pause
    exit /b 1
)
del "%temp%\diskpart_efi.txt"
@echo Complete.
@echo.

:: Step 4: Create MSR
@echo [4/6] Creating MSR Partition...
(
@echo select disk %diskNumber%
@echo create partition msr size=16
) > "%temp%\diskpart_msr.txt"
diskpart /s "%temp%\diskpart_msr.txt" >nul 2>&1
if errorlevel 1 (
    @echo WARNING: MSR creation may have failed, but continuing...
)
del "%temp%\diskpart_msr.txt"
@echo Complete.
@echo.

:: Step 5: Create Windows Partition
@echo [5/6] Creating Windows Partition (%windowsLetter%:)...
(
@echo select disk %diskNumber%
@echo create partition primary
@echo format quick fs=ntfs label="Windows"
@echo assign letter=%windowsLetter%
) > "%temp%\diskpart_windows.txt"
diskpart /s "%temp%\diskpart_windows.txt" >nul 2>&1
if errorlevel 1 (
    @echo ERROR: Failed to create Windows partition!
    type "%temp%\diskpart_windows.txt"
    del "%temp%\diskpart_windows.txt"
    pause
    exit /b 1
)
del "%temp%\diskpart_windows.txt"
@echo Complete.
@echo.

:: Step 6: Apply WIM image
@echo [6/6] Applying Windows image to %windowsLetter%: (may take 20-60 minutes)...
@echo This may take a while. Please wait...
@echo.

dism /Apply-Image /ImageFile:"%wimPath%" /Index:1 /ApplyDir:%windowsLetter%:\

if errorlevel 1 (
    @echo.
    @echo ERROR: DISM failed with exit code: %errorlevel%
    @echo.
    pause
    exit /b 1
)

@echo.
@echo Complete.
@echo.

:: Configure UEFI boot files
@echo Configuring UEFI boot files...
bcdboot %windowsLetter%:\Windows /s %efiLetter%: /f UEFI

if errorlevel 1 (
    @echo WARNING: Boot configuration may have issues!
) else (
    @echo Boot files configured successfully.
)

@echo.
@echo ================================================================
@echo DEPLOYMENT COMPLETED SUCCESSFULLY!
@echo ================================================================
@echo.
@echo • EFI System Partition: %efiLetter%:
@echo • Windows Partition: %windowsLetter%:
@echo • WIM Index: 1
@echo.
@echo The system is ready to boot.
@echo Remove installation media and restart.
@echo.
pause
exit /b 0