# claudeupdater.ps1

# Display ASCII Banner
Write-Host "████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
Write-Host "░█████╗░██║░░░░░░█████╗░██║░░░██║██████╗░███████╗███╗░░░███╗░█████╗░██████╗░██████╗" -ForegroundColor Red
Write-Host "██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝" -ForegroundColor Red
Write-Host "██║░░╚═╝██║░░░░░███████║██║░░░██║██║░░██║█████╗░░██╔████╔██║██║░░██║██║░░██║╚█████╗░" -ForegroundColor Red
Write-Host "██║░░██╗██║░░░░░██╔══██║██║░░░██║██║░░██║██╔══╝░░██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗" -ForegroundColor Red
Write-Host "╚█████╔╝███████╗██║░░██║╚██████╔╝██████╔╝███████╗██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝" -ForegroundColor Red
Write-Host "░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░" -ForegroundColor Red
Write-Host "████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████" -ForegroundColor Red
Write-Host ""
Write-Host " claudeupdater v1.0 ── 04-05-2026" -ForegroundColor Cyan
Write-Host ""

# Start a background job that updates status every second
$script:currentStatus = "Unknown"
$statusJob = Start-Job -Name StatusUpdater -ScriptBlock {
    while ($true) {
        $SDBackupPath = "C:\Windows\SoftwareDistribution.bak"
        if (Test-Path $SDBackupPath) {
            $status = "LOCKED"
        } else {
            $status = "UNLOCKED"
        }
        # Store status in a global variable that main script can read
        $global:liveStatus = $status
        Start-Sleep -Seconds 1
    }
}

# Function to display status line
function Show-StatusLine {
    # Read the current status from the background job
    if ($global:liveStatus -eq "LOCKED") {
        Write-Host "STATUS: Updating LOCKED" -ForegroundColor Red
    } elseif ($global:liveStatus -eq "UNLOCKED") {
        Write-Host "STATUS: Updating UNLOCKED" -ForegroundColor Green
    } else {
        $SDBackupPath = "C:\Windows\SoftwareDistribution.bak"
        if (Test-Path $SDBackupPath) {
            Write-Host "STATUS: Updating LOCKED" -ForegroundColor Red
        } else {
            Write-Host "STATUS: Updating UNLOCKED" -ForegroundColor Green
        }
    }
}

param(
    [Parameter(Position=0)]
    [ValidateSet("check", "lock", "unlock")]
    [string]$Action
)

$SDPath = "C:\Windows\SoftwareDistribution"
$SDBackupPath = "C:\Windows\SoftwareDistribution.bak"

function Check-AndInstallUpdates {
    Write-Host "`n=== Checking and Installing Windows Updates ===" -ForegroundColor Cyan
    
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "Installing PSWindowsUpdate module..." -ForegroundColor Yellow
        Install-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue
        Install-Module PSWindowsUpdate -Force -AllowClobber -Scope CurrentUser
    }
    
    Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot:$false
}

function Lock-WindowsUpdates {
    Write-Host "`n=== Locking Windows Updates ===" -ForegroundColor Cyan
    
    Stop-Service -Name wuauserv -Force
    Stop-Service -Name bits -Force
    
    if (Test-Path $SDPath) {
        Rename-Item -Path $SDPath -NewName "SoftwareDistribution.bak" -Force
        Write-Host "SoftwareDistribution folder locked successfully" -ForegroundColor Green
    } else {
        Write-Host "SoftwareDistribution folder not found" -ForegroundColor Yellow
    }
}

function Unlock-WindowsUpdates {
    Write-Host "`n=== Unlocking Windows Updates ===" -ForegroundColor Cyan
    
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
    
    if (Test-Path $SDBackupPath) {
        Rename-Item -Path $SDBackupPath -NewName "SoftwareDistribution" -Force
        Write-Host "SoftwareDistribution folder unlocked successfully" -ForegroundColor Green
    } else {
        Write-Host "Backup folder not found" -ForegroundColor Yellow
    }
    
    Start-Service -Name wuauserv
    Start-Service -Name bits
}

# Show initial status
Show-StatusLine
Write-Host ""

# Execute based on parameter
switch ($Action) {
    "check"   { Check-AndInstallUpdates }
    "lock"    { Lock-WindowsUpdates }
    "unlock"  { Unlock-WindowsUpdates }
    default {
        Write-Host "Usage: .\claudeupdater.ps1 [check|lock|unlock]" -ForegroundColor Yellow
        Write-Host "  check   - Check and install Windows updates"
        Write-Host "  lock    - Lock Windows Updates"  
        Write-Host "  unlock  - Unlock Windows Updates"
    }
}

# Show final status
Write-Host ""
Show-StatusLine

# Clean up background job when script ends
Stop-Job -Name StatusUpdater -ErrorAction SilentlyContinue
Remove-Job -Name StatusUpdater -ErrorAction SilentlyContinue
