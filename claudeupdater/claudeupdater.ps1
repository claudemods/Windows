# claudeupdater.ps1 - GUI Version

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'claudeupdater beta v1.0 ── 06-05-2026'
$form.Size = New-Object System.Drawing.Size(900, 600)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::Black

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
░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░
████████████████████████████████████████████████████████████████████████████████
"@

$cyanLabel = New-Object System.Windows.Forms.Label
$cyanLabel.Location = New-Object System.Drawing.Point(10, 95)
$cyanLabel.Size = New-Object System.Drawing.Size(860, 25)
$cyanLabel.Font = New-Object System.Drawing.Font('Consolas', 10, [System.Drawing.FontStyle]::Bold)
$cyanLabel.ForeColor = [System.Drawing.Color]::Cyan
$cyanLabel.Text = 'claudeupdater beta v1.0 ── 06-05-2026'
$cyanLabel.TextAlign = 'MiddleCenter'

$lockButton = New-Object System.Windows.Forms.Button
$lockButton.Location = New-Object System.Drawing.Point(10, 130)
$lockButton.Size = New-Object System.Drawing.Size(280, 40)
$lockButton.Text = '1. LOCK Windows Updates'
$lockButton.BackColor = [System.Drawing.Color]::DarkRed
$lockButton.ForeColor = [System.Drawing.Color]::White
$lockButton.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]::Bold)

$unlockButton = New-Object System.Windows.Forms.Button
$unlockButton.Location = New-Object System.Drawing.Point(300, 130)
$unlockButton.Size = New-Object System.Drawing.Size(280, 40)
$unlockButton.Text = '2. UNLOCK Windows Updates'
$unlockButton.BackColor = [System.Drawing.Color]::DarkGreen
$unlockButton.ForeColor = [System.Drawing.Color]::White
$unlockButton.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]::Bold)

$checkButton = New-Object System.Windows.Forms.Button
$checkButton.Location = New-Object System.Drawing.Point(590, 130)
$checkButton.Size = New-Object System.Drawing.Size(280, 40)
$checkButton.Text = '3. Check and Install Updates'
$checkButton.BackColor = [System.Drawing.Color]::DarkCyan
$checkButton.ForeColor = [System.Drawing.Color]::White
$checkButton.Font = New-Object System.Drawing.Font('Consolas', 12, [System.Drawing.FontStyle]::Bold)

$statusLabel = New-Object System.Windows.Forms.Label
$statusLabel.Location = New-Object System.Drawing.Point(10, 180)
$statusLabel.Size = New-Object System.Drawing.Size(860, 20)
$statusLabel.Font = New-Object System.Drawing.Font('Consolas', 10, [System.Drawing.FontStyle]::Bold)

$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(10, 200)
$outputBox.Size = New-Object System.Drawing.Size(860, 350)
$outputBox.BackColor = [System.Drawing.Color]::Black
$outputBox.ForeColor = [System.Drawing.Color]::White
$outputBox.Font = New-Object System.Drawing.Font('Consolas', 10)
$outputBox.ReadOnly = $true
$outputBox.Multiline = $true
$outputBox.ScrollBars = 'Vertical'

function Write-ColoredOutput {
    param($Message, $Color)
    $outputBox.SelectionStart = $outputBox.TextLength
    $outputBox.SelectionLength = 0
    
    switch ($Color) {
        'Red' { $outputBox.SelectionColor = [System.Drawing.Color]::Red }
        'Green' { $outputBox.SelectionColor = [System.Drawing.Color]::Green }
        'Yellow' { $outputBox.SelectionColor = [System.Drawing.Color]::Yellow }
        'Cyan' { $outputBox.SelectionColor = [System.Drawing.Color]::Cyan }
        'White' { $outputBox.SelectionColor = [System.Drawing.Color]::White }
        default { $outputBox.SelectionColor = [System.Drawing.Color]::White }
    }
    
    $outputBox.AppendText($Message + "`n")
    $outputBox.SelectionColor = $outputBox.ForeColor
    $outputBox.ScrollToCaret()
}

function Update-StatusLabel {
    $SDBackupPath = 'C:\Windows\SoftwareDistribution.bak'
    if (Test-Path $SDBackupPath) {
        $statusLabel.Text = 'STATUS: Updating LOCKED'
        $statusLabel.ForeColor = [System.Drawing.Color]::Red
    } else {
        $statusLabel.Text = 'STATUS: Updating UNLOCKED'
        $statusLabel.ForeColor = [System.Drawing.Color]::Green
    }
}

$timer = New-Object System.Windows.Forms.Timer
$timer.Interval = 1000
$timer.Add_Tick({
    Update-StatusLabel
})
$timer.Start()

Update-StatusLabel

$lockButton.Add_Click({
    Write-ColoredOutput -Message "`n=== LOCKING Windows Updates ===" -Color 'Cyan'
    Stop-Service -Name 'wuauserv' -Force
    Stop-Service -Name 'bits' -Force
    
    if (Test-Path 'C:\Windows\SoftwareDistribution') {
        Rename-Item -Path 'C:\Windows\SoftwareDistribution' -NewName 'SoftwareDistribution.bak' -Force
        Write-ColoredOutput -Message 'Windows Updates LOCKED successfully' -Color 'Green'
    } else {
        Write-ColoredOutput -Message 'SoftwareDistribution folder not found' -Color 'Yellow'
    }
    Update-StatusLabel
})

$unlockButton.Add_Click({
    Write-ColoredOutput -Message "`n=== UNLOCKING Windows Updates ===" -Color 'Cyan'
    Stop-Service -Name 'wuauserv' -Force -ErrorAction SilentlyContinue
    Stop-Service -Name 'bits' -Force -ErrorAction SilentlyContinue
    
    if (Test-Path 'C:\Windows\SoftwareDistribution.bak') {
        Rename-Item -Path 'C:\Windows\SoftwareDistribution.bak' -NewName 'SoftwareDistribution' -Force
        Write-ColoredOutput -Message 'Windows Updates UNLOCKED successfully' -Color 'Green'
    } else {
        Write-ColoredOutput -Message 'Backup folder not found' -Color 'Yellow'
    }
    
    Start-Service -Name 'wuauserv'
    Start-Service -Name 'bits'
    Update-StatusLabel
})

$checkButton.Add_Click({
    Write-ColoredOutput -Message "`n=== Checking and Installing Windows Updates ===" -Color 'Cyan'
    
    try {
        # Create Windows Update Session using native COM object
        $UpdateSession = New-Object -ComObject Microsoft.Update.Session
        $UpdateSearcher = $UpdateSession.CreateUpdateSearcher()
        
        Write-ColoredOutput -Message "Searching for available updates..." -Color 'Yellow'
        $SearchResult = $UpdateSearcher.Search("IsInstalled=0")
        
        $Updates = $SearchResult.Updates
        $UpdatesAvailable = $Updates.Count
        
        if ($UpdatesAvailable -eq 0) {
            Write-ColoredOutput -Message "No updates found. System is up to date." -Color 'Green'
            return
        }
        
        Write-ColoredOutput -Message "Found $UpdatesAvailable update(s) available" -Color 'Cyan'
        
        # List available updates
        $i = 1
        foreach ($Update in $Updates) {
            Write-ColoredOutput -Message "$i. $($Update.Title)" -Color 'White'
            if ($Update.MaxDownloadSize -gt 0) {
                Write-ColoredOutput -Message "   Size: $([math]::Round($Update.MaxDownloadSize/1MB, 2)) MB" -Color 'Gray'
            }
            $i++
        }
        
        # Create update downloader
        $UpdateDownloader = $UpdateSession.CreateUpdateDownloader()
        $UpdateDownloader.Updates = $Updates
        
        Write-ColoredOutput -Message "`nDownloading updates..." -Color 'Yellow'
        $DownloadResult = $UpdateDownloader.Download()
        
        if ($DownloadResult.ResultCode -eq 2) { # ResultCode 2 = Downloaded
            Write-ColoredOutput -Message "Download completed successfully" -Color 'Green'
            
            # Create installer
            $UpdateInstaller = $UpdateSession.CreateUpdateInstaller()
            $UpdateInstaller.Updates = $Updates
            
            Write-ColoredOutput -Message "Installing updates..." -Color 'Yellow'
            $InstallResult = $UpdateInstaller.Install()
            
            if ($InstallResult.ResultCode -eq 2) { # ResultCode 2 = Installed
                Write-ColoredOutput -Message "SUCCESS: $($InstallResult.InstalledUpdatesCount) update(s) installed" -Color 'Green'
                
                # Check if restart is needed
                if ($InstallResult.RebootRequired) {
                    Write-ColoredOutput -Message "`nSystem restart required to complete updates" -Color 'Red'
                    
                    $restartDialog = [System.Windows.Forms.MessageBox]::Show(
                        "Restart required to complete updates. Restart now?", 
                        "Restart Required", 
                        [System.Windows.Forms.MessageBoxButtons]::YesNo,
                        [System.Windows.Forms.MessageBoxIcon]::Question
                    )
                    
                    if ($restartDialog -eq 'Yes') {
                        Restart-Computer -Force
                    }
                }
            } else {
                Write-ColoredOutput -Message "Installation failed. Result code: $($InstallResult.ResultCode)" -Color 'Red'
            }
        } else {
            Write-ColoredOutput -Message "Download failed. Result code: $($DownloadResult.ResultCode)" -Color 'Red'
        }
    }
    catch {
        Write-ColoredOutput -Message "Error: $($_.Exception.Message)" -Color 'Red'
        Write-ColoredOutput -Message "Make sure you're running as Administrator" -Color 'Yellow'
    }
    
    Update-StatusLabel
})

$form.Controls.Add($asciiLabel)
$form.Controls.Add($cyanLabel)
$form.Controls.Add($lockButton)
$form.Controls.Add($unlockButton)
$form.Controls.Add($checkButton)
$form.Controls.Add($statusLabel)
$form.Controls.Add($outputBox)

$form.ShowDialog()
