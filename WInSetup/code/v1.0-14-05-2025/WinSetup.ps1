# Get the script directory properly with multiple fallback methods
$scriptDirectory = if ($MyInvocation.MyCommand.Path) {
    Split-Path -Parent $MyInvocation.MyCommand.Path
} elseif ($PSScriptRoot) {
    $PSScriptRoot
} else {
    # Ultimate fallback
    Get-Location
}

# Additional safety check
if ([string]::IsNullOrEmpty($scriptDirectory)) {
    $scriptDirectory = Get-Location
}

# Verify directory exists
if (-not (Test-Path $scriptDirectory)) {
    $scriptDirectory = [Environment]::GetFolderPath("Desktop")
    Write-Host "Warning: Using Desktop as fallback directory" -ForegroundColor Yellow
}

# Create log file path
$logPath = Join-Path $scriptDirectory "WinSetup_log_$(Get-Date -Format 'yyyyMMdd_HHmmss').txt"

function Write-Log {
    param([string]$Message, [string]$Type = "INFO")
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logEntry = "[$timestamp] [$Type] $Message"
    Add-Content -Path $logPath -Value $logEntry -ErrorAction SilentlyContinue
}

Write-Log "WinSetup v1.0 Started"
Write-Log "Script directory: $scriptDirectory"

# Load assemblies
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to check if apps are installed
function Check-AppInstalled {
    param($AppName)
    
    $paths = @{
        "Steam" = @("C:\Program Files (x86)\Steam\Steam.exe", "C:\Program Files\Steam\Steam.exe")
        "Rockstar Launcher" = @("C:\Program Files\Rockstar Games\Launcher\Launcher.exe")
        "OBS" = @("C:\Program Files\obs-studio\bin\64bit\obs64.exe")
        "Medal" = @("C:\Users\$env:USERNAME\AppData\Local\Medal\Medal.exe")
        "WinRAR" = @("C:\Program Files\WinRAR\WinRAR.exe", "C:\Program Files (x86)\WinRAR\WinRAR.exe")
        "Opera GX" = @("C:\Users\$env:USERNAME\AppData\Local\Programs\Opera GX\opera.exe")
        "FileZilla" = @("C:\Program Files\FileZilla FTP Client\filezilla.exe")
        "FXSound" = @("C:\Program Files\FXSound\FXSound.exe")
        "Battle.net" = @("C:\Program Files (x86)\Battle.net\Battle.net.exe")
    }
    
    if ($paths.ContainsKey($AppName)) {
        foreach ($path in $paths[$AppName]) {
            if (Test-Path $path) {
                return $true
            }
        }
    }
    
    # Check VC++ 14
    if ($AppName -eq "VC++ 14") {
        if ((Test-Path "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64") -and (Test-Path "HKLM:\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x86")) {
            return $true
        }
    }
    
    # Check Store apps via registry (instant)
    $storeAppRegPaths = @{
        "WhatsApp" = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WhatsApp.exe", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\WhatsApp.exe")
        "Telegram" = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Telegram.exe", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Telegram.exe")
        "Netflix" = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Netflix.exe", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Netflix.exe")
        "Instagram" = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Instagram.exe", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Instagram.exe")
        "Discord" = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Discord.exe", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Discord.exe")
        "Spotify" = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Spotify.exe", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Spotify.exe")
        "iTunes" = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\iTunes.exe", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\iTunes.exe")
        "Battle.net" = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Battle.net.exe", "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\Battle.net.exe")
    }
    
    if ($storeAppRegPaths.ContainsKey($AppName)) {
        foreach ($regPath in $storeAppRegPaths[$AppName]) {
            if (Test-Path $regPath) {
                return $true
            }
        }
    }
    
    return $false
}

# Function to check settings
function Check-SettingApplied {
    param($SettingName)
    
    switch ($SettingName) {
        "Ultimate Performance Mode" {
            $scheme = powercfg /getactivescheme
            return $scheme -match "Ultimate Performance"
        }
        "Show Hidden Files" {
            $hidden = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -ErrorAction SilentlyContinue
            $ext = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -ErrorAction SilentlyContinue
            return ($hidden.Hidden -eq 1) -and ($ext.HideFileExt -eq 0)
        }
        "Hyper-V" {
            $feature = Get-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -ErrorAction SilentlyContinue
            return $feature.State -eq "Enabled"
        }
    }
    return $false
}

# Create main form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'WinSetup v1.0 ── 15-05-2026'
$form.Size = New-Object System.Drawing.Size(900, 720)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::Black
$form.FormBorderStyle = 'FixedSingle'
$form.MaximizeBox = $false

# ASCII Art Label
$asciiLabel = New-Object System.Windows.Forms.Label
$asciiLabel.Location = New-Object System.Drawing.Point(10, 10)
$asciiLabel.Size = New-Object System.Drawing.Size(860, 80)
$asciiLabel.Font = New-Object System.Drawing.Font('Consolas', 7)
$asciiLabel.ForeColor = [System.Drawing.Color]::Red
$asciiLabel.TextAlign = 'MiddleCenter'
$asciiLabel.Text = @"
████████████████████████████████████████████████████████████████████████████████
░█████╗░██║░░░░░░█████╗░██║░░░██║██████╗░███████╗███╗░░░███╗░█████╗░██████╗░██████╗
██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝
██║░░╚═╝██║░░░░░███████║██║░░░██║██║░░██║█████╗░░██╔████╔██║██║░░██║██║░░██║╚█████╗░
██║░░██╗██║░░░░░██╔══██║██║░░░██║██║░░██║██╔══╝░░██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗
╚█████╔╝███████╗██║░░██║╚██████╔╝██████╔╝███████╗██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝
░╚════╝░╚══════╝╚═╝░░░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░
████████████████████████████████████████████████████████████████████████████████
"@
$form.Controls.Add($asciiLabel)

# Title label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(10, 95)
$titleLabel.Size = New-Object System.Drawing.Size(860, 25)
$titleLabel.Font = New-Object System.Drawing.Font('Consolas', 10, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::Cyan
$titleLabel.Text = 'WinSetup v1.0 ── 15-05-2026'
$titleLabel.TextAlign = 'MiddleCenter'
$form.Controls.Add($titleLabel)

# Left Panel
$leftPanel = New-Object System.Windows.Forms.Panel
$leftPanel.Location = New-Object System.Drawing.Point(10, 130)
$leftPanel.Size = New-Object System.Drawing.Size(280, 540)
$leftPanel.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
$leftPanel.BorderStyle = 'FixedSingle'

$leftTitle = New-Object System.Windows.Forms.Label
$leftTitle.Location = New-Object System.Drawing.Point(10, 10)
$leftTitle.Size = New-Object System.Drawing.Size(260, 25)
$leftTitle.Text = "Apps from Internet"
$leftTitle.ForeColor = [System.Drawing.Color]::Cyan
$leftTitle.Font = New-Object System.Drawing.Font('Consolas', 10, [System.Drawing.FontStyle]::Bold)
$leftPanel.Controls.Add($leftTitle)

$internetApps = @(
    "Steam", "Rockstar Launcher", "OBS", "Medal", "WinRAR", "Opera GX", "FileZilla", "FXSound", "VC++ 14"
)

$internetURLs = @{
    "Steam" = "https://cdn.cloudflare.steamstatic.com/client/installer/SteamSetup.exe"
    "Rockstar Launcher" = "https://gamedownloads.rockstargames.com/public/installer/Rockstar-Games-Launcher.exe"
    "OBS" = "https://cdn-fastly.obsproject.com/downloads/OBS-Studio-32.1.2-Windows-x64-Installer.exe"
    "Medal" = "https://cdn.medal.tv/production/candidate/electron/win32/2620.176.1/MedalSetup.exe?id=NjMzNzkzNTA1LDEsbm9yZWY="
    "WinRAR" = "https://www.win-rar.com/fileadmin/winrar-versions/winrar/winrar-x64-624.exe"
    "Opera GX" = "https://net.geo.opera.com/opera_gx/stable/windows?utm_try=1"
    "FileZilla" = "https://download.filezilla-project.org/client/FileZilla_3.70.5_win64_sponsored2-setup.exe"
    "FXSound" = "https://release-assets.githubusercontent.com/github-production-release-asset/718542341/839b6607-f23d-44d8-91b1-1b93e7a98059?sp=r&sv=2018-11-09&sr=b&spr=https&se=2026-05-15T03%3A49%3A14Z&rscd=attachment%3B+filename%3Dfxsound_setup.exe&rsct=application%2Foctet-stream&skoid=96c2d410-5711-43a1-aedd-ab1947aa7ab0&sktid=398a6654-997b-47e9-b12b-9515b896b4de&skt=2026-05-15T02%3A48%3A45Z&ske=2026-05-15T03%3A49%3A14Z&sks=b&skv=2018-11-09&sig=s333c%2BpQ43JmRdRDX2nkpFv887BR8dZ8qUNutNVNvVY%3D&jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmVsZWFzZS1hc3NldHMuZ2l0aHVidXNlcmNvbnRlbnQuY29tIiwia2V5Ijoia2V5MSIsImV4cCI6MTc3ODgxNjY2NCwibmJmIjoxNzc4ODE0ODY0LCJwYXRoIjoicmVsZWFzZWFzc2V0cHJvZHVjdGlvbi5ibG9iLmNvcmUud2luZG93cy5uZXQifQ.qKmQg8znaT_kt7qHPFrFsdXgel-koSUkhAgETFs8OmI&response-content-disposition=attachment%3B%20filename%3Dfxsound_setup.exe&response-content-type=application%2Foctet-stream"
    "VC++ 14" = "https://aka.ms/vc14/vc_redist.x64.exe"
}

$y = 45
$buttonHeight = 50
$buttonSpacing = 53
foreach ($app in $internetApps) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Location = New-Object System.Drawing.Point(10, $y)
    $btn.Size = New-Object System.Drawing.Size(260, $buttonHeight)
    $btn.Text = $app
    $btn.BackColor = [System.Drawing.Color]::FromArgb(64,64,64)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = 'Flat'
    $btn.Tag = $internetURLs[$app]
    
    # Check if installed
    if (Check-AppInstalled $app) {
        $btn.BackColor = [System.Drawing.Color]::DarkRed
        $btn.Enabled = $false
        $btn.Text = "$app (Installed)"
    }
    
    $btn.Add_Click({
        $url = $this.Tag
        $appName = $this.Text -replace " \(Installed\)", ""
        
        # Special handling for VC++ 14 - install both x64 and x86
        if ($appName -eq "VC++ 14") {
            Write-Log "Starting VC++ 14 installation (x64 and x86)"
            try {
                $this.Text = "Downloading x64..."
                $this.Enabled = $false
                $this.Refresh()
                
                # Download and install x64
                $downloadPath64 = "$env:TEMP\VC_redist.x64.exe"
                Write-Log "Downloading VC++ 14 x64 from https://aka.ms/vc14/vc_redist.x64.exe"
                Invoke-WebRequest -Uri "https://aka.ms/vc14/vc_redist.x64.exe" -OutFile $downloadPath64
                Write-Log "Download complete, starting x64 installer"
                
                $this.Text = "Installing x64..."
                $this.Refresh()
                Start-Process -FilePath $downloadPath64 -ArgumentList "/install", "/quiet", "/norestart" -Wait
                Write-Log "VC++ 14 x64 installation completed"
                
                # Download and install x86
                $downloadPath86 = "$env:TEMP\VC_redist.x86.exe"
                Write-Log "Downloading VC++ 14 x86 from https://aka.ms/vc14/vc_redist.x86.exe"
                
                $this.Text = "Downloading x86..."
                $this.Refresh()
                Invoke-WebRequest -Uri "https://aka.ms/vc14/vc_redist.x86.exe" -OutFile $downloadPath86
                Write-Log "Download complete, starting x86 installer"
                
                $this.Text = "Installing x86..."
                $this.Refresh()
                Start-Process -FilePath $downloadPath86 -ArgumentList "/install", "/quiet", "/norestart" -Wait
                Write-Log "VC++ 14 x86 installation completed"
                
                $this.BackColor = [System.Drawing.Color]::DarkRed
                $this.Text = "VC++ 14 (Installed)"
                [System.Windows.Forms.MessageBox]::Show("VC++ 14 x64 and x86 installed successfully!", "Success", 'OK', 'Information')
            } catch {
                Write-Log "Failed to install VC++ 14: $($_.Exception.Message)" "ERROR"
                [System.Windows.Forms.MessageBox]::Show("Failed to install VC++ 14`n$($_.Exception.Message)", "Error", 'OK', 'Error')
                $this.Text = "VC++ 14"
                $this.Enabled = $true
            }
            return
        }
        
        # Special handling for Steam
        if ($appName -eq "Steam") {
            $downloadPath = "$env:TEMP\SteamSetup.exe"
            
            Write-Log "Downloading Steam from $url"
            try {
                $this.Text = "Downloading..."
                $this.Enabled = $false
                $this.Refresh()
                
                Invoke-WebRequest -Uri $url -OutFile $downloadPath
                Write-Log "Download complete, starting Steam installer"
                
                # Kill any existing Steam processes before installing
                Get-Process -Name "Steam" -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
                Start-Sleep -Seconds 2
                
                $this.Text = "Installing Steam..."
                $this.Refresh()
                Start-Process -FilePath $downloadPath -Wait
                
                Write-Log "Steam installer completed"
                $this.BackColor = [System.Drawing.Color]::DarkRed
                $this.Text = "Steam (Installed)"
                [System.Windows.Forms.MessageBox]::Show("Steam installed successfully!", "Success", 'OK', 'Information')
            } catch {
                Write-Log "Failed to install Steam: $($_.Exception.Message)" "ERROR"
                [System.Windows.Forms.MessageBox]::Show("Failed to install Steam`n$($_.Exception.Message)", "Error", 'OK', 'Error')
                $this.Text = "Steam"
                $this.Enabled = $true
            }
            return
        }
        
        # Regular handling for other apps
        $downloadPath = "$env:TEMP\$appName.exe"
        
        Write-Log "Downloading $appName from $url"
        try {
            $this.Text = "Downloading..."
            $this.Enabled = $false
            $this.Refresh()
            Invoke-WebRequest -Uri $url -OutFile $downloadPath
            Write-Log "Download complete, starting installer"
            
            $this.Text = "Installing $appName..."
            $this.Refresh()
            Start-Process -FilePath $downloadPath -Wait
            
            Write-Log "$appName installer completed"
            $this.BackColor = [System.Drawing.Color]::DarkRed
            $this.Text = "$appName (Installed)"
        } catch {
            Write-Log "Failed to download $appName : $($_.Exception.Message)" "ERROR"
            [System.Windows.Forms.MessageBox]::Show("Failed to download $appName`n$($_.Exception.Message)", "Error", 'OK', 'Error')
            $this.Text = $appName
            $this.Enabled = $true
        }
    })
    $leftPanel.Controls.Add($btn)
    $y += $buttonSpacing
}

# Middle Panel
$middlePanel = New-Object System.Windows.Forms.Panel
$middlePanel.Location = New-Object System.Drawing.Point(305, 130)
$middlePanel.Size = New-Object System.Drawing.Size(280, 540)
$middlePanel.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
$middlePanel.BorderStyle = 'FixedSingle'

$middleTitle = New-Object System.Windows.Forms.Label
$middleTitle.Location = New-Object System.Drawing.Point(10, 10)
$middleTitle.Size = New-Object System.Drawing.Size(260, 25)
$middleTitle.Text = "Apps from Microsoft Store"
$middleTitle.ForeColor = [System.Drawing.Color]::Cyan
$middleTitle.Font = New-Object System.Drawing.Font('Consolas', 10, [System.Drawing.FontStyle]::Bold)
$middlePanel.Controls.Add($middleTitle)

$storeApps = @(
    @{Name="WhatsApp"; ID="9NKSQGP7F2NH"},
    @{Name="Telegram"; ID="9NZTWSQNTD0S"},
    @{Name="Netflix"; ID="9WZDNCRFJ3TJ"},
    @{Name="Instagram"; ID="9NBLGGH5L9XT"},
    @{Name="Discord"; ID="XPDC2RH70K22MN"},
    @{Name="Spotify"; ID="9NCBCSZSJRSB"},
    @{Name="iTunes"; ID="9PB2MZ1ZMB1S"},
    @{Name="Battle.net"; ID="9NH4VGF5C7GS"}
)

$y = 45
foreach ($app in $storeApps) {
    $btn = New-Object System.Windows.Forms.Button
    $btn.Location = New-Object System.Drawing.Point(10, $y)
    $btn.Size = New-Object System.Drawing.Size(260, $buttonHeight)
    $btn.Text = $app.Name
    $btn.BackColor = [System.Drawing.Color]::FromArgb(64,64,64)
    $btn.ForeColor = [System.Drawing.Color]::White
    $btn.FlatStyle = 'Flat'
    $btn.Tag = $app.ID
    
    # Check if installed
    if (Check-AppInstalled $app.Name) {
        $btn.BackColor = [System.Drawing.Color]::DarkRed
        $btn.Enabled = $false
        $btn.Text = "$($app.Name) (Installed)"
    }
    
    $btn.Add_Click({
        $appID = $this.Tag
        $appName = $this.Text -replace " \(Installed\)", ""
        
        Write-Log "Installing $appName via winget"
        try {
            $this.Text = "Installing..."
            $this.Enabled = $false
            
            $result = Start-Process -FilePath "winget" -ArgumentList "install --id $appID --accept-source-agreements --accept-package-agreements" -NoNewWindow -Wait -PassThru
            
            if ($result.ExitCode -eq 0) {
                Write-Log "Successfully installed $appName"
                [System.Windows.Forms.MessageBox]::Show("$appName installed successfully!", "Success", 'OK', 'Information')
                $this.BackColor = [System.Drawing.Color]::DarkRed
                $this.Text = "$appName (Installed)"
            } else {
                Write-Log "winget failed, opening Store"
                Start-Process "ms-windows-store://pdp/?ProductId=$appID"
                [System.Windows.Forms.MessageBox]::Show("Opening Microsoft Store for $appName...", "Store", 'OK', 'Information')
                $this.Text = $appName
                $this.Enabled = $true
            }
        } catch {
            Write-Log "Error installing $appName" "ERROR"
            Start-Process "ms-windows-store://pdp/?ProductId=$appID"
            $this.Text = $appName
            $this.Enabled = $true
        }
    })
    $middlePanel.Controls.Add($btn)
    $y += $buttonSpacing
}

# Right Panel
$rightPanel = New-Object System.Windows.Forms.Panel
$rightPanel.Location = New-Object System.Drawing.Point(600, 130)
$rightPanel.Size = New-Object System.Drawing.Size(280, 540)
$rightPanel.BackColor = [System.Drawing.Color]::FromArgb(30,30,30)
$rightPanel.BorderStyle = 'FixedSingle'

$rightTitle = New-Object System.Windows.Forms.Label
$rightTitle.Location = New-Object System.Drawing.Point(10, 10)
$rightTitle.Size = New-Object System.Drawing.Size(260, 25)
$rightTitle.Text = "System Settings"
$rightTitle.ForeColor = [System.Drawing.Color]::Cyan
$rightTitle.Font = New-Object System.Drawing.Font('Consolas', 10, [System.Drawing.FontStyle]::Bold)
$rightPanel.Controls.Add($rightTitle)

# Ultimate Performance Mode
$perfBtn = New-Object System.Windows.Forms.Button
$perfBtn.Location = New-Object System.Drawing.Point(10, 45)
$perfBtn.Size = New-Object System.Drawing.Size(260, 60)
$perfBtn.Text = "Ultimate Performance Mode"
$perfBtn.BackColor = [System.Drawing.Color]::FromArgb(64,64,64)
$perfBtn.ForeColor = [System.Drawing.Color]::White
$perfBtn.FlatStyle = 'Flat'

if (Check-SettingApplied "Ultimate Performance Mode") {
    $perfBtn.BackColor = [System.Drawing.Color]::DarkRed
    $perfBtn.Enabled = $false
    $perfBtn.Text = "Ultimate Performance Mode (Installed)"
}

$perfBtn.Add_Click({
    try {
        Write-Log "Installing Ultimate Performance Mode"
        $this.Text = "Applying..."
        $this.Enabled = $false
        
        # Set Ultimate performance power scheme
        powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61 | Out-Null
        
        Write-Log "Ultimate Performance Mode activated"
        $this.BackColor = [System.Drawing.Color]::DarkRed
        $this.Text = "Ultimate Performance Mode (Active)"
        [System.Windows.Forms.MessageBox]::Show("Ultimate Performance Mode Installed Please Activate In Control Panel Settings!", "Success", 'OK', 'Information')
    } catch {
        Write-Log "Error activating Ultimate Performance Mode" "ERROR"
        [System.Windows.Forms.MessageBox]::Show("Failed to activate Ultimate Performance Mode", "Error", 'OK', 'Error')
        $this.Text = "Ultimate Performance Mode"
        $this.Enabled = $true
    }
})
$rightPanel.Controls.Add($perfBtn)

# Show Hidden Files
$hiddenBtn = New-Object System.Windows.Forms.Button
$hiddenBtn.Location = New-Object System.Drawing.Point(10, 115)
$hiddenBtn.Size = New-Object System.Drawing.Size(260, 60)
$hiddenBtn.Text = "Show Hidden Files & Extensions"
$hiddenBtn.BackColor = [System.Drawing.Color]::FromArgb(64,64,64)
$hiddenBtn.ForeColor = [System.Drawing.Color]::White
$hiddenBtn.FlatStyle = 'Flat'

if (Check-SettingApplied "Show Hidden Files") {
    $hiddenBtn.BackColor = [System.Drawing.Color]::DarkRed
    $hiddenBtn.Enabled = $false
    $hiddenBtn.Text = "Hidden Files Visible (Active)"
}

$hiddenBtn.Add_Click({
    try {
        Write-Log "Enabling hidden files visibility"
        $this.Text = "Applying..."
        $this.Enabled = $false
        
        $key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'
        Set-ItemProperty -Path $key -Name "Hidden" -Value 1 -Force
        Set-ItemProperty -Path $key -Name "HideFileExt" -Value 0 -Force
        Set-ItemProperty -Path $key -Name "ShowSuperHidden" -Value 1 -Force
        
        # Restart explorer
        Stop-Process -Name explorer -Force
        Start-Process explorer
        
        Write-Log "Hidden files now visible"
        $this.BackColor = [System.Drawing.Color]::DarkRed
        $this.Text = "Hidden Files Visible (Active)"
        [System.Windows.Forms.MessageBox]::Show("Hidden files and extensions are now visible!", "Success", 'OK', 'Information')
    } catch {
        Write-Log "Error enabling hidden files" "ERROR"
        [System.Windows.Forms.MessageBox]::Show("Failed to enable hidden files", "Error", 'OK', 'Error')
        $this.Text = "Show Hidden Files & Extensions"
        $this.Enabled = $true
    }
})
$rightPanel.Controls.Add($hiddenBtn)

# Enable Hyper-V
$hyperVBtn = New-Object System.Windows.Forms.Button
$hyperVBtn.Location = New-Object System.Drawing.Point(10, 185)
$hyperVBtn.Size = New-Object System.Drawing.Size(260, 60)
$hyperVBtn.Text = "Enable Hyper-V"
$hyperVBtn.BackColor = [System.Drawing.Color]::FromArgb(64,64,64)
$hyperVBtn.ForeColor = [System.Drawing.Color]::White
$hyperVBtn.FlatStyle = 'Flat'

if (Check-SettingApplied "Hyper-V") {
    $hyperVBtn.BackColor = [System.Drawing.Color]::DarkRed
    $hyperVBtn.Enabled = $false
    $hyperVBtn.Text = "Hyper-V (Enabled)"
}

$hyperVBtn.Add_Click({
    try {
        Write-Log "Enabling Hyper-V"
        $this.Text = "Enabling..."
        $this.Enabled = $false
        
        Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V-All -NoRestart
        
        Write-Log "Hyper-V enabled"
        $this.BackColor = [System.Drawing.Color]::DarkRed
        $this.Text = "Hyper-V (Enabled)"
        
        $result = [System.Windows.Forms.MessageBox]::Show("Hyper-V enabled! Restart now?", "Restart Required", 'YesNo', 'Question')
        if ($result -eq 'Yes') {
            Restart-Computer -Force
        }
    } catch {
        Write-Log "Error enabling Hyper-V" "ERROR"
        [System.Windows.Forms.MessageBox]::Show("Failed to enable Hyper-V. Make sure you're running as Administrator and your Windows version supports it.", "Error", 'OK', 'Error')
        $this.Text = "Enable Hyper-V"
        $this.Enabled = $true
    }
})
$rightPanel.Controls.Add($hyperVBtn)

# Add panels to form
$form.Controls.Add($leftPanel)
$form.Controls.Add($middlePanel)
$form.Controls.Add($rightPanel)

Write-Log "WinSetup GUI initialized"

# Show form
$form.ShowDialog() | Out-Null

Write-Log "WinSetup Closed"