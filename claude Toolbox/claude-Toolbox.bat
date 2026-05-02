@echo off
setlocal EnableDelayedExpansion
title Claude Toolbox Beta v1.0
mode con: cols=65 lines=25

:MAIN
cls
color 30
echo.
echo  [31m   Claude Toolbox Beta v1.0[0m
echo  [37m   ==============================[0m
echo.
echo  [37m   [1]  Control Panel[0m
echo  [37m   [2]  Network Connections[0m
echo  [37m   [3]  Programs and Features[0m
echo  [37m   [4]  Device Manager[0m
echo  [37m   [5]  Task Manager[0m
echo  [37m   [6]  Services[0m
echo  [37m   [7]  System Configuration (msconfig)[0m
echo  [37m   [8]  Registry Editor (regedit)[0m
echo  [37m   [9]  Group Policy Editor (gpedit.msc)[0m
echo  [37m   [10] Windows Security[0m
echo  [37m   [11] Power Options[0m
echo  [37m   [12] Disk Management[0m
echo  [37m   [13] System Information[0m
echo  [37m   [14] Command Prompt[0m
echo  [37m   [15] Exit[0m
echo.
echo  [37m   ==============================[0m
echo.
set /p "choice=  [36mEnter your choice: [0m"

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

goto MAIN
