# claudeupdater.ps1 - GUI Version

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'claudeupdateblocker beta v1.0 ── 06-05-2026'
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
$cyanLabel.Text = 'claudeupdateblocker beta v1.0 ── 06-05-2026'
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

$form.Controls.Add($asciiLabel)
$form.Controls.Add($cyanLabel)
$form.Controls.Add($lockButton)
$form.Controls.Add($unlockButton)
$form.Controls.Add($statusLabel)
$form.Controls.Add($outputBox)

$form.ShowDialog()