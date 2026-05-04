
# Set console window size
$host.UI.RawUI.WindowTitle = "claude Toolbox Beta v1.0 04-05-2026"
$host.UI.RawUI.BufferSize = New-Object System.Management.Automation.Host.Size(70, 300)
$host.UI.RawUI.WindowSize = New-Object System.Management.Automation.Host.Size(70, 30)

function Show-Menu {
    Clear-Host
    
    # ASCII art - RED
    Write-Host "   ░█████╗░██╗░░░░░░█████╗░██╗░░░██╗██████╗░███████╗███╗░░░███╗░█████╗░██████╗░██████╗" -ForegroundColor Red
    Write-Host "   ██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝" -ForegroundColor Red
    Write-Host "   ██║░░╚═╝██║░░░░░███████║██║░░░██║██║░░██║█████╗░░██╔████╔██║██║░░██║██║░░██║╚█████╗░" -ForegroundColor Red
    Write-Host "   ██║░░██╗██║░░░░░██╔══██║██║░░░██║██║░░██║██╔══╝░░██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗" -ForegroundColor Red
    Write-Host "   ╚█████╔╝███████╗██║░░██║╚██████╔╝██████╔╝███████╗██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝" -ForegroundColor Red
    Write-Host "   ░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░" -ForegroundColor Red
    Write-Host ""
    Write-Host "         claude Toolbox Beta v1.0 04-05-2026" -ForegroundColor Red
    Write-Host ""
    Write-Host "   ===================================" -ForegroundColor Cyan
    Write-Host ""
    
    # Menu options - CYAN
    Write-Host "   [1]  Control Panel" -ForegroundColor Cyan
    Write-Host "   [2]  Network Connections" -ForegroundColor Cyan
    Write-Host "   [3]  Programs and Features" -ForegroundColor Cyan
    Write-Host "   [4]  Device Manager" -ForegroundColor Cyan
    Write-Host "   [5]  Task Manager" -ForegroundColor Cyan
    Write-Host "   [6]  Services" -ForegroundColor Cyan
    Write-Host "   [7]  System Configuration (msconfig)" -ForegroundColor Cyan
    Write-Host "   [8]  Registry Editor (regedit)" -ForegroundColor Cyan
    Write-Host "   [9]  Group Policy Editor (gpedit.msc)" -ForegroundColor Cyan
    Write-Host "   [10] Windows Security" -ForegroundColor Cyan
    Write-Host "   [11] Power Options" -ForegroundColor Cyan
    Write-Host "   [12] Disk Management" -ForegroundColor Cyan
    Write-Host "   [13] System Information" -ForegroundColor Cyan
    Write-Host "   [14] Command Prompt" -ForegroundColor Cyan
    Write-Host "   [15] Event Viewer" -ForegroundColor Cyan
    Write-Host "   [16] Performance Monitor" -ForegroundColor Cyan
    Write-Host "   [17] Resource Monitor" -ForegroundColor Cyan
    Write-Host "   [18] Computer Management" -ForegroundColor Cyan
    Write-Host "   [19] Task Scheduler" -ForegroundColor Cyan
    Write-Host "   [20] Local Users and Groups" -ForegroundColor Cyan
    Write-Host "   [21] Shared Folders" -ForegroundColor Cyan
    Write-Host "   [22] Windows Features" -ForegroundColor Cyan
    Write-Host "   [23] Disk Cleanup" -ForegroundColor Cyan
    Write-Host "   [24] System Restore" -ForegroundColor Cyan
    Write-Host "   [25] Windows Memory Diagnostic" -ForegroundColor Cyan
    Write-Host "   [26] Reliability Monitor" -ForegroundColor Cyan
    Write-Host "   [27] Steps Recorder" -ForegroundColor Cyan
    Write-Host "   [28] System File Checker (SFC Scan)" -ForegroundColor Cyan
    Write-Host "   [29] Check Disk (CHKDSK)" -ForegroundColor Cyan
    Write-Host "   [30] Network and Sharing Center" -ForegroundColor Cyan
    Write-Host "   [31] Windows Firewall" -ForegroundColor Cyan
    Write-Host "   [32] Internet Options" -ForegroundColor Cyan
    Write-Host "   [33] Remote Desktop" -ForegroundColor Cyan
    Write-Host "   [34] Network Reset" -ForegroundColor Cyan
    Write-Host "   [35] Wi-Fi Settings" -ForegroundColor Cyan
    Write-Host "   [36] VPN Settings" -ForegroundColor Cyan
    Write-Host "   [37] Proxy Settings" -ForegroundColor Cyan
    Write-Host "   [38] Flush DNS Cache" -ForegroundColor Cyan
    Write-Host "   [39] IP Configuration" -ForegroundColor Cyan
    Write-Host "   [40] User Accounts" -ForegroundColor Cyan
    Write-Host "   [41] Date and Time" -ForegroundColor Cyan
    Write-Host "   [42] Region Settings" -ForegroundColor Cyan
    Write-Host "   [43] Sound Settings" -ForegroundColor Cyan
    Write-Host "   [44] Mouse Properties" -ForegroundColor Cyan
    Write-Host "   [45] Keyboard Properties" -ForegroundColor Cyan
    Write-Host "   [46] Ease of Access" -ForegroundColor Cyan
    Write-Host "   [47] AutoPlay Settings" -ForegroundColor Cyan
    Write-Host "   [48] Default Programs" -ForegroundColor Cyan
    Write-Host "   [49] Font Settings" -ForegroundColor Cyan
    Write-Host "   [50] Print Management" -ForegroundColor Cyan
    Write-Host "   [51] Windows PowerShell (Admin)" -ForegroundColor Cyan
    Write-Host "   [52] Windows Terminal (Admin)" -ForegroundColor Cyan
    Write-Host "   [53] Windows Update" -ForegroundColor Cyan
    Write-Host "   [54] Activation Settings" -ForegroundColor Cyan
    Write-Host "   [55] Windows Defender Firewall Advanced" -ForegroundColor Cyan
    Write-Host "   [56] Certificate Manager" -ForegroundColor Cyan
    Write-Host "   [57] ODBC Data Sources" -ForegroundColor Cyan
    Write-Host "   [58] Component Services" -ForegroundColor Cyan
    Write-Host "   [59] Windows Tools Folder" -ForegroundColor Cyan
    Write-Host "   [60] Exit" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "   ===================================" -ForegroundColor Cyan
    Write-Host ""
}

# Main loop
while ($true) {
    Show-Menu
    
    $choice = Read-Host "  Enter your choice"
    
    switch ($choice) {
        "1" { Start-Process "control" }
        "2" { Start-Process "ncpa.cpl" }
        "3" { Start-Process "appwiz.cpl" }
        "4" { Start-Process "devmgmt.msc" }
        "5" { Start-Process "taskmgr" }
        "6" { Start-Process "services.msc" }
        "7" { Start-Process "msconfig" }
        "8" { Start-Process "regedit" }
        "9" { Start-Process "gpedit.msc" }
        "10" { Start-Process "windowsdefender:" }
        "11" { Start-Process "powercfg.cpl" }
        "12" { Start-Process "diskmgmt.msc" }
        "13" { Start-Process "msinfo32" }
        "14" { Start-Process "cmd" }
        "15" { Start-Process "eventvwr.msc" }
        "16" { Start-Process "perfmon.msc" }
        "17" { Start-Process "resmon" }
        "18" { Start-Process "compmgmt.msc" }
        "19" { Start-Process "taskschd.msc" }
        "20" { Start-Process "lusrmgr.msc" }
        "21" { Start-Process "fsmgmt.msc" }
        "22" { Start-Process "optionalfeatures" }
        "23" { Start-Process "cleanmgr" }
        "24" { Start-Process "rstrui" }
        "25" { Start-Process "mdsched" }
        "26" { Start-Process "perfmon" -ArgumentList "/rel" }
        "27" { Start-Process "psr" }
        "28" { Start-Process "cmd" -ArgumentList "/k sfc /scannow" }
        "29" { Start-Process "cmd" -ArgumentList "/k chkdsk" }
        "30" { Start-Process "control" -ArgumentList "/name Microsoft.NetworkAndSharingCenter" }
        "31" { Start-Process "firewall.cpl" }
        "32" { Start-Process "inetcpl.cpl" }
        "33" { Start-Process "mstsc" }
        "34" { Start-Process "cmd" -ArgumentList "/k netcfg -d" }
        "35" { Start-Process "ms-settings:network-wifi" }
        "36" { Start-Process "ms-settings:network-vpn" }
        "37" { Start-Process "ms-settings:network-proxy" }
        "38" { Start-Process "cmd" -ArgumentList "/k ipconfig /flushdns" }
        "39" { Start-Process "cmd" -ArgumentList "/k ipconfig /all" }
        "40" { Start-Process "control" -ArgumentList "userpasswords2" }
        "41" { Start-Process "timedate.cpl" }
        "42" { Start-Process "intl.cpl" }
        "43" { Start-Process "mmsys.cpl" }
        "44" { Start-Process "main.cpl" }
        "45" { Start-Process "control" -ArgumentList "keyboard" }
        "46" { Start-Process "utilman" }
        "47" { Start-Process "control" -ArgumentList "/name Microsoft.AutoPlay" }
        "48" { Start-Process "control" -ArgumentList "/name Microsoft.DefaultPrograms" }
        "49" { Start-Process "fonts" }
        "50" { Start-Process "printmanagement.msc" }
        "51" { Start-Process "powershell" -ArgumentList "-Command Start-Process PowerShell -Verb RunAs" }
        "52" { Start-Process "wt" -ArgumentList '-p "Command Prompt" -d . --title "Admin Terminal"' }
        "53" { Start-Process "ms-settings:windowsupdate" }
        "54" { Start-Process "ms-settings:activation" }
        "55" { Start-Process "wf.msc" }
        "56" { Start-Process "certmgr.msc" }
        "57" { Start-Process "odbcad32" }
        "58" { Start-Process "comexp.msc" }
        "59" { Start-Process "control" -ArgumentList "admintools" }
        "60" { exit }
    }
}