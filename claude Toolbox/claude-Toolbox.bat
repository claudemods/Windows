@echo off
setlocal EnableDelayedExpansion
mode con: cols=70 lines=30

:MAIN
cls
color 30
echo.
echo [31m   ░█████╗░██╗░░░░░░█████╗░██║░░░██╗██████╗░███████╗███╗░░░███╗░█████╗░██████╗░██████╗
echo [31m   ██╔══██╗██║░░░░░██╔══██╗██║░░░██║██╔══██╗██╔════╝████╗░████║██╔══██╗██╔══██╗██╔════╝
echo [31m   ██║░░╚═╝██║░░░░░███████║██║░░░██║██║░░██║█████╗░░██╔████╔██║██║░░██║██║░░██║╚█████╗░
echo [31m   ██║░░██╗██║░░░░░██╔══██║██║░░░██║██║░░██║██╔══╝░░██║╚██╔╝██║██║░░██║██║░░██║░╚═══██╗
echo [31m   ╚█████╔╝███████╗██║░░██║╚██████╔╝██████╔╝███████╗██║░╚═╝░██║╚█████╔╝██████╔╝██████╔╝
echo [31m   ░╚════╝░╚══════╝╚═╝░░░░░░╚═════╝░╚═════╝░╚══════╝╚═╝░░░░░╚═╝░╚════╝░╚═════╝░╚═════╝░[0m
echo.
echo [31m         claude Toolbox Beta v1.0 03-05-2026[0m
echo.
echo [37m   ===================================[0m
echo.
echo [37m   [1]  Control Panel[0m
echo [37m   [2]  Network Connections[0m
echo [37m   [3]  Programs and Features[0m
echo [37m   [4]  Device Manager[0m
echo [37m   [5]  Task Manager[0m
echo [37m   [6]  Services[0m
echo [37m   [7]  System Configuration (msconfig)[0m
echo [37m   [8]  Registry Editor (regedit)[0m
echo [37m   [9]  Group Policy Editor (gpedit.msc)[0m
echo [37m   [10] Windows Security[0m
echo [37m   [11] Power Options[0m
echo [37m   [12] Disk Management[0m
echo [37m   [13] System Information[0m
echo [37m   [14] Command Prompt[0m
echo [37m   [15] Exit[0m
echo [37m   [16] Event Viewer[0m
echo [37m   [17] Performance Monitor[0m
echo [37m   [18] Resource Monitor[0m
echo [37m   [19] Computer Management[0m
echo [37m   [20] Task Scheduler[0m
echo [37m   [21] Local Users and Groups[0m
echo [37m   [22] Shared Folders[0m
echo [37m   [23] Windows Features[0m
echo [37m   [24] Disk Cleanup[0m
echo [37m   [25] System Restore[0m
echo [37m   [26] Windows Memory Diagnostic[0m
echo [37m   [27] Reliability Monitor[0m
echo [37m   [28] Steps Recorder[0m
echo [37m   [29] System File Checker (SFC Scan)[0m
echo [37m   [30] Check Disk (CHKDSK)[0m
echo [37m   [31] Network and Sharing Center[0m
echo [37m   [32] Windows Firewall[0m
echo [37m   [33] Internet Options[0m
echo [37m   [34] Remote Desktop[0m
echo [37m   [35] Network Reset[0m
echo [37m   [36] Wi-Fi Settings[0m
echo [37m   [37] VPN Settings[0m
echo [37m   [38] Proxy Settings[0m
echo [37m   [39] Flush DNS Cache[0m
echo [37m   [40] IP Configuration[0m
echo [37m   [41] User Accounts[0m
echo [37m   [42] Date and Time[0m
echo [37m   [43] Region Settings[0m
echo [37m   [44] Sound Settings[0m
echo [37m   [45] Mouse Properties[0m
echo [37m   [46] Keyboard Properties[0m
echo [37m   [47] Ease of Access[0m
echo [37m   [48] AutoPlay Settings[0m
echo [37m   [49] Default Programs[0m
echo [37m   [50] Font Settings[0m
echo [37m   [51] Print Management[0m
echo [37m   [52] Windows PowerShell (Admin)[0m
echo [37m   [53] Windows Terminal (Admin)[0m
echo [37m   [54] Windows Update[0m
echo [37m   [55] Activation Settings[0m
echo [37m   [56] Windows Defender Firewall Advanced[0m
echo [37m   [57] Certificate Manager[0m
echo [37m   [58] ODBC Data Sources[0m
echo [37m   [59] Component Services[0m
echo [37m   [60] Windows Tools Folder[0m
echo.
echo [37m   ===================================[0m
echo.
set /p "choice=  [36mEnter your choice: [0m"

if "%choice%"=="1" start control
if "%choice%"=="2" start ncpa.cpl
if "%choice%"=="3" start appwiz.cpl
if "%choice%"=="4" start devmgmt.msc
if "%choice%"=="5" start taskmgr
if "%choice%"=="6" start services.msc
if "%choice%"=="7" start msconfig
if "%choice%"=="8" start regedit
if "%choice%"=="9" start gpedit.msc
if "%choice%"=="10" start windowsdefender:
if "%choice%"=="11" start powercfg.cpl
if "%choice%"=="12" start diskmgmt.msc
if "%choice%"=="13" start msinfo32
if "%choice%"=="14" start cmd
if "%choice%"=="15" exit
if "%choice%"=="16" start eventvwr.msc
if "%choice%"=="17" start perfmon.msc
if "%choice%"=="18" start resmon
if "%choice%"=="19" start compmgmt.msc
if "%choice%"=="20" start taskschd.msc
if "%choice%"=="21" start lusrmgr.msc
if "%choice%"=="22" start fsmgmt.msc
if "%choice%"=="23" start optionalfeatures
if "%choice%"=="24" start cleanmgr
if "%choice%"=="25" start rstrui
if "%choice%"=="26" start mdsched
if "%choice%"=="27" start perfmon /rel
if "%choice%"=="28" start psr
if "%choice%"=="29" start cmd /k "sfc /scannow"
if "%choice%"=="30" start cmd /k "chkdsk"
if "%choice%"=="31" start control /name Microsoft.NetworkAndSharingCenter
if "%choice%"=="32" start firewall.cpl
if "%choice%"=="33" start inetcpl.cpl
if "%choice%"=="34" start mstsc
if "%choice%"=="35" start cmd /k "netcfg -d"
if "%choice%"=="36" start ms-settings:network-wifi
if "%choice%"=="37" start ms-settings:network-vpn
if "%choice%"=="38" start ms-settings:network-proxy
if "%choice%"=="39" start cmd /k "ipconfig /flushdns"
if "%choice%"=="40" start cmd /k "ipconfig /all"
if "%choice%"=="41" start control userpasswords2
if "%choice%"=="42" start timedate.cpl
if "%choice%"=="43" start intl.cpl
if "%choice%"=="44" start mmsys.cpl
if "%choice%"=="45" start main.cpl
if "%choice%"=="46" start control keyboard
if "%choice%"=="47" start utilman
if "%choice%"=="48" start control /name Microsoft.AutoPlay
if "%choice%"=="49" start control /name Microsoft.DefaultPrograms
if "%choice%"=="50" start fonts
if "%choice%"=="51" start printmanagement.msc
if "%choice%"=="52" start powershell -Command "Start-Process PowerShell -Verb RunAs"
if "%choice%"=="53" start wt -p "Command Prompt" -d . --title "Admin Terminal"
if "%choice%"=="54" start ms-settings:windowsupdate
if "%choice%"=="55" start ms-settings:activation
if "%choice%"=="56" start wf.msc
if "%choice%"=="57" start certmgr.msc
if "%choice%"=="58" start odbcad32
if "%choice%"=="59" start comexp.msc
if "%choice%"=="60" start control admintools

goto MAIN