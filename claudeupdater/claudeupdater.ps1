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

# Show initial status
Show-StatusLine
Write-Host ""

Write-Host "1. LOCK Windows Updates" -ForegroundColor Yellow
Write-Host "2. UNLOCK Windows Updates" -ForegroundColor Green
Write-Host "3. Check and Install Updates" -ForegroundColor Cyan
Write-Host ""

$choice = Read-Host "Select option (1, 2, or 3)"

if ($choice -eq "1") {
    Write-Host "`n=== LOCKING Windows Updates ===" -ForegroundColor Cyan
    Stop-Service -Name wuauserv -Force
    Stop-Service -Name bits -Force
    
    if (Test-Path "C:\Windows\SoftwareDistribution") {
        Rename-Item -Path "C:\Windows\SoftwareDistribution" -NewName "SoftwareDistribution.bak" -Force
        Write-Host "Windows Updates LOCKED successfully" -ForegroundColor Green
    } else {
        Write-Host "SoftwareDistribution folder not found" -ForegroundColor Yellow
    }
}
elseif ($choice -eq "2") {
    Write-Host "`n=== UNLOCKING Windows Updates ===" -ForegroundColor Cyan
    Stop-Service -Name wuauserv -Force -ErrorAction SilentlyContinue
    Stop-Service -Name bits -Force -ErrorAction SilentlyContinue
    
    if (Test-Path "C:\Windows\SoftwareDistribution.bak") {
        Rename-Item -Path "C:\Windows\SoftwareDistribution.bak" -NewName "SoftwareDistribution" -Force
        Write-Host "Windows Updates UNLOCKED successfully" -ForegroundColor Green
    } else {
        Write-Host "Backup folder not found" -ForegroundColor Yellow
    }
    
    Start-Service -Name wuauserv
    Start-Service -Name bits
}
elseif ($choice -eq "3") {
    Write-Host "`n=== Checking and Installing Windows Updates ===" -ForegroundColor Cyan
    
    if (-not (Get-Module -ListAvailable -Name PSWindowsUpdate)) {
        Write-Host "Installing PSWindowsUpdate module..." -ForegroundColor Yellow
        Install-PackageProvider -Name NuGet -Force -ErrorAction SilentlyContinue
        Install-Module PSWindowsUpdate -Force -AllowClobber -Scope CurrentUser
    }
    
    Import-Module PSWindowsUpdate -ErrorAction SilentlyContinue
    Get-WindowsUpdate -Install -AcceptAll -AutoReboot:$false
}
else {
    Write-Host "Invalid choice. Please run again and select 1, 2, or 3." -ForegroundColor Red
}

# Show final status
Write-Host ""
Show-StatusLine

# Clean up background job when script ends
Stop-Job -Name StatusUpdater -ErrorAction SilentlyContinue
Remove-Job -Name StatusUpdater -ErrorAction SilentlyContinue