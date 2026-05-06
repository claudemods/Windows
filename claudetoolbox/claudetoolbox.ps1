# claudetoolbox.ps1 - GUI Version

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = 'claudetoolbox beta v1.0 ── 06-05-2026'
$form.Size = New-Object System.Drawing.Size(900, 600)
$form.StartPosition = 'CenterScreen'
$form.BackColor = [System.Drawing.Color]::Black
$form.FormBorderStyle = 'FixedDialog'
$form.MaximizeBox = $false

# ASCII Art Label
$asciiLabel = New-Object System.Windows.Forms.Label
$asciiLabel.Location = New-Object System.Drawing.Point(10, 10)
$asciiLabel.Size = New-Object System.Drawing.Size(860, 100)
$asciiLabel.Font = New-Object System.Drawing.Font('Consolas', 6.5)
$asciiLabel.ForeColor = [System.Drawing.Color]::Red
$asciiLabel.TextAlign = 'MiddleCenter'
$asciiLabel.Text = @"
   ░█████╗░██╗░░░░░░█████╗░██╗░░░██╗██████╗░███████╗███╗░░░███╗░█████╗░██████╗░██████╗
   ██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝
   ██║░░╚═╝██║░░░░░███████║██║░░░██║██║░░██║█████╗░░██╔████╔██║██║░░██║██║░░██║╚█████╗░
   ██║░░██╗██║░░░░░██╔══██║██║░░░██║██║░░██║██╔══╝░░██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗
   ╚█████╔╝███████╗██║░░██║╚██████╔╝██████╔╝███████╗██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝
   ░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░
"@

# Title Label
$titleLabel = New-Object System.Windows.Forms.Label
$titleLabel.Location = New-Object System.Drawing.Point(10, 115)
$titleLabel.Size = New-Object System.Drawing.Size(860, 25)
$titleLabel.Font = New-Object System.Drawing.Font('Consolas', 10, [System.Drawing.FontStyle]::Bold)
$titleLabel.ForeColor = [System.Drawing.Color]::Cyan
$titleLabel.Text = 'claudetoolbox beta v1.0 ── 06-05-2026'
$titleLabel.TextAlign = 'MiddleCenter'

# ComboBox for tool selection
$toolComboBox = New-Object System.Windows.Forms.ComboBox
$toolComboBox.Location = New-Object System.Drawing.Point(10, 150)
$toolComboBox.Size = New-Object System.Drawing.Size(700, 25)
$toolComboBox.BackColor = [System.Drawing.Color]::Black
$toolComboBox.ForeColor = [System.Drawing.Color]::Cyan
$toolComboBox.Font = New-Object System.Drawing.Font('Consolas', 11)
$toolComboBox.DropDownStyle = 'DropDownList'

# Define tools array
$tools = @(
    "01. Control Panel - control",
    "02. Network Connections - ncpa.cpl",
    "03. Programs and Features - appwiz.cpl",
    "04. Device Manager - devmgmt.msc",
    "05. Task Manager - taskmgr",
    "06. Services - services.msc",
    "07. System Configuration - msconfig",
    "08. Registry Editor - regedit",
    "09. Group Policy Editor - gpedit.msc",
    "10. Windows Security - windowsdefender:",
    "11. Power Options - powercfg.cpl",
    "12. Disk Management - diskmgmt.msc",
    "13. System Information - msinfo32",
    "14. Command Prompt - cmd",
    "15. Event Viewer - eventvwr.msc",
    "16. Performance Monitor - perfmon.msc",
    "17. Resource Monitor - resmon",
    "18. Computer Management - compmgmt.msc",
    "19. Task Scheduler - taskschd.msc",
    "20. Local Users and Groups - lusrmgr.msc",
    "21. Shared Folders - fsmgmt.msc",
    "22. Windows Features - optionalfeatures",
    "23. Disk Cleanup - cleanmgr",
    "24. System Restore - rstrui",
    "25. Windows Memory Diagnostic - mdsched",
    "26. Reliability Monitor - perfmon /rel",
    "27. Steps Recorder - psr",
    "28. System File Checker (SFC Scan) - sfc /scannow",
    "29. Check Disk (CHKDSK) - chkdsk",
    "30. Network and Sharing Center - control /name Microsoft.NetworkAndSharingCenter",
    "31. Windows Firewall - firewall.cpl",
    "32. Internet Options - inetcpl.cpl",
    "33. Remote Desktop - mstsc",
    "34. Network Reset - netcfg -d",
    "35. Wi-Fi Settings - ms-settings:network-wifi",
    "36. VPN Settings - ms-settings:network-vpn",
    "37. Proxy Settings - ms-settings:network-proxy",
    "38. Flush DNS Cache - ipconfig /flushdns",
    "39. IP Configuration - ipconfig /all",
    "40. User Accounts - control userpasswords2",
    "41. Date and Time - timedate.cpl",
    "42. Region Settings - intl.cpl",
    "43. Sound Settings - mmsys.cpl",
    "44. Mouse Properties - main.cpl",
    "45. Keyboard Properties - control keyboard",
    "46. Ease of Access - utilman",
    "47. AutoPlay Settings - control /name Microsoft.AutoPlay",
    "48. Default Programs - control /name Microsoft.DefaultPrograms",
    "49. Font Settings - fonts",
    "50. Print Management - printmanagement.msc",
    "51. Windows PowerShell (Admin) - powershell",
    "52. Windows Terminal (Admin) - wt",
    "53. Windows Update - ms-settings:windowsupdate",
    "54. Activation Settings - ms-settings:activation",
    "55. Windows Defender Firewall Advanced - wf.msc",
    "56. Certificate Manager - certmgr.msc",
    "57. ODBC Data Sources - odbcad32",
    "58. Component Services - comexp.msc",
    "59. Windows Tools Folder - control admintools",
    "60. Exit"
)

foreach ($tool in $tools) {
    [void]$toolComboBox.Items.Add($tool)
}
$toolComboBox.SelectedIndex = 0

# Launch Button
$launchButton = New-Object System.Windows.Forms.Button
$launchButton.Location = New-Object System.Drawing.Point(720, 148)
$launchButton.Size = New-Object System.Drawing.Size(150, 30)
$launchButton.Text = 'LAUNCH TOOL'
$launchButton.BackColor = [System.Drawing.Color]::DarkBlue
$launchButton.ForeColor = [System.Drawing.Color]::Cyan
$launchButton.Font = New-Object System.Drawing.Font('Consolas', 11, [System.Drawing.FontStyle]::Bold)
$launchButton.FlatStyle = 'Flat'

# Output Box
$outputBox = New-Object System.Windows.Forms.RichTextBox
$outputBox.Location = New-Object System.Drawing.Point(10, 190)
$outputBox.Size = New-Object System.Drawing.Size(860, 360)
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

# Tool launch mapping
function Launch-Tool {
    param([int]$ToolNumber)
    
    $commandMap = @{
        1  = @{ Exe = "control"; Args = "" }
        2  = @{ Exe = "ncpa.cpl"; Args = "" }
        3  = @{ Exe = "appwiz.cpl"; Args = "" }
        4  = @{ Exe = "devmgmt.msc"; Args = "" }
        5  = @{ Exe = "taskmgr"; Args = "" }
        6  = @{ Exe = "services.msc"; Args = "" }
        7  = @{ Exe = "msconfig"; Args = "" }
        8  = @{ Exe = "regedit"; Args = "" }
        9  = @{ Exe = "gpedit.msc"; Args = "" }
        10 = @{ Exe = "windowsdefender:"; Args = "" }
        11 = @{ Exe = "powercfg.cpl"; Args = "" }
        12 = @{ Exe = "diskmgmt.msc"; Args = "" }
        13 = @{ Exe = "msinfo32"; Args = "" }
        14 = @{ Exe = "cmd"; Args = "" }
        15 = @{ Exe = "eventvwr.msc"; Args = "" }
        16 = @{ Exe = "perfmon.msc"; Args = "" }
        17 = @{ Exe = "resmon"; Args = "" }
        18 = @{ Exe = "compmgmt.msc"; Args = "" }
        19 = @{ Exe = "taskschd.msc"; Args = "" }
        20 = @{ Exe = "lusrmgr.msc"; Args = "" }
        21 = @{ Exe = "fsmgmt.msc"; Args = "" }
        22 = @{ Exe = "optionalfeatures"; Args = "" }
        23 = @{ Exe = "cleanmgr"; Args = "" }
        24 = @{ Exe = "rstrui"; Args = "" }
        25 = @{ Exe = "mdsched"; Args = "" }
        26 = @{ Exe = "perfmon"; Args = "/rel" }
        27 = @{ Exe = "psr"; Args = "" }
        28 = @{ Exe = "cmd"; Args = "/k sfc /scannow" }
        29 = @{ Exe = "cmd"; Args = "/k chkdsk" }
        30 = @{ Exe = "control"; Args = "/name Microsoft.NetworkAndSharingCenter" }
        31 = @{ Exe = "firewall.cpl"; Args = "" }
        32 = @{ Exe = "inetcpl.cpl"; Args = "" }
        33 = @{ Exe = "mstsc"; Args = "" }
        34 = @{ Exe = "cmd"; Args = "/k netcfg -d" }
        35 = @{ Exe = "ms-settings:network-wifi"; Args = "" }
        36 = @{ Exe = "ms-settings:network-vpn"; Args = "" }
        37 = @{ Exe = "ms-settings:network-proxy"; Args = "" }
        38 = @{ Exe = "cmd"; Args = "/k ipconfig /flushdns" }
        39 = @{ Exe = "cmd"; Args = "/k ipconfig /all" }
        40 = @{ Exe = "control"; Args = "userpasswords2" }
        41 = @{ Exe = "timedate.cpl"; Args = "" }
        42 = @{ Exe = "intl.cpl"; Args = "" }
        43 = @{ Exe = "mmsys.cpl"; Args = "" }
        44 = @{ Exe = "main.cpl"; Args = "" }
        45 = @{ Exe = "control"; Args = "keyboard" }
        46 = @{ Exe = "utilman"; Args = "" }
        47 = @{ Exe = "control"; Args = "/name Microsoft.AutoPlay" }
        48 = @{ Exe = "control"; Args = "/name Microsoft.DefaultPrograms" }
        49 = @{ Exe = "fonts"; Args = "" }
        50 = @{ Exe = "printmanagement.msc"; Args = "" }
        51 = @{ Exe = "powershell"; Args = "-Command Start-Process PowerShell -Verb RunAs" }
        52 = @{ Exe = "wt"; Args = '-p "Command Prompt" -d . --title "Admin Terminal"' }
        53 = @{ Exe = "ms-settings:windowsupdate"; Args = "" }
        54 = @{ Exe = "ms-settings:activation"; Args = "" }
        55 = @{ Exe = "wf.msc"; Args = "" }
        56 = @{ Exe = "certmgr.msc"; Args = "" }
        57 = @{ Exe = "odbcad32"; Args = "" }
        58 = @{ Exe = "comexp.msc"; Args = "" }
        59 = @{ Exe = "control"; Args = "admintools" }
    }
    
    if ($ToolNumber -eq 60) {
        Write-ColoredOutput -Message "Exiting claude Toolbox..." -Color 'Yellow'
        Start-Sleep -Seconds 1
        $form.Close()
        return
    }
    
    if ($commandMap.ContainsKey($ToolNumber)) {
        $cmd = $commandMap[$ToolNumber]
        $toolName = ($tools[$ToolNumber - 1] -split ' - ')[0]
        
        Write-ColoredOutput -Message "`n=== Launching: $toolName ===" -Color 'Cyan'
        Write-ColoredOutput -Message "Command: $($cmd.Exe) $($cmd.Args)" -Color 'White'
        
        try {
            if ($cmd.Args) {
                Start-Process $cmd.Exe -ArgumentList $cmd.Args -ErrorAction Stop
            } else {
                Start-Process $cmd.Exe -ErrorAction Stop
            }
            Write-ColoredOutput -Message "Tool launched successfully!" -Color 'Green'
        }
        catch {
            Write-ColoredOutput -Message "ERROR: Failed to launch tool - $_" -Color 'Red'
        }
    }
}

# Button click event
$launchButton.Add_Click({
    $selectedIndex = $toolComboBox.SelectedIndex + 1
    Launch-Tool -ToolNumber $selectedIndex
})

# Add keyboard shortcut (Enter key on ComboBox)
$toolComboBox.Add_KeyDown({
    if ($_.KeyCode -eq 'Enter') {
        $selectedIndex = $toolComboBox.SelectedIndex + 1
        Launch-Tool -ToolNumber $selectedIndex
    }
})

# Add controls to form
$form.Controls.Add($asciiLabel)
$form.Controls.Add($titleLabel)
$form.Controls.Add($toolComboBox)
$form.Controls.Add($launchButton)
$form.Controls.Add($outputBox)

# Initial output message
Write-ColoredOutput -Message "Welcome to claude Toolbox Beta v1.0" -Color 'Cyan'
Write-ColoredOutput -Message "Select a tool from the dropdown menu and click LAUNCH TOOL" -Color 'Yellow'
Write-ColoredOutput -Message "60 tools available for system administration" -Color 'White'
Write-ColoredOutput -Message "================================================" -Color 'Cyan'

$form.ShowDialog()