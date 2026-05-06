<p align="center">
<img src="https://i.postimg.cc/JhMRf2RZ/claudemods-03-17-2025.gif">	

<div align="center">
  <a href="https://microsoft.com/" target="_blank"><img src="https://img.shields.io/badge/OS-Windows-0000FF?style=for-the-badge&logo=windows" /></a>

claudeupdater v1.0 06-05-2026

## Windows Installation (Copy & Paste)

```powershell
powershell -c "Invoke-WebRequest 'https://raw.githubusercontent.com/claudemods/Windows/refs/heads/main/claudeupdater/claudeupdater.ps1' -OutFile $env:TEMP\up.ps1; Start-Process powershell -Verb RunAs -ArgumentList '-ExecutionPolicy Bypass -File $env:TEMP\up.ps1'"
