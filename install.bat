@echo off
title GoXLR Power - Installation
color 0A

echo ============================================
echo    GoXLR Power - Installation
echo ============================================
echo.

REM Verifie les droits administrateur
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERREUR] Ce script necessite les droits administrateur.
    echo Clic droit ^> Executer en tant qu'administrateur
    echo.
    pause
    exit /b 1
)

REM Definit le dossier d'installation
set "INSTALL_DIR=%ProgramData%\GoXLR-Power"
set "GOXLR_CLIENT=C:\Program Files\GoXLR Utility\goxlr-client.exe"

REM Verifie que GoXLR Utility est installe
if not exist "%GOXLR_CLIENT%" (
    echo [ERREUR] GoXLR Utility n'est pas installe dans le chemin par defaut.
    echo Chemin attendu: %GOXLR_CLIENT%
    echo.
    pause
    exit /b 1
)

echo [1/4] Creation du dossier d'installation...
if not exist "%INSTALL_DIR%" mkdir "%INSTALL_DIR%"

echo [2/4] Creation des scripts...

REM Cree le script PowerShell (eteint les lumieres a l'arret)
(
echo $goxlrClient = "C:\Program Files\GoXLR Utility\goxlr-client.exe"
echo.
echo Add-Type -AssemblyName System.Windows.Forms
echo.
echo [Microsoft.Win32.SystemEvents]::add_SessionEnding({
echo     if (Test-Path $goxlrClient^) {
echo         Start-Process -FilePath $goxlrClient -ArgumentList "lighting", "global", "000000" -NoNewWindow -Wait
echo     }
echo }^)
echo.
echo while ($true^) { Start-Sleep -Seconds 60 }
) > "%INSTALL_DIR%\goxlr-power.ps1"

REM Cree le lanceur VBS (fenetre cachee)
(
echo Set objShell = CreateObject("WScript.Shell"^)
echo objShell.Run "powershell.exe -ExecutionPolicy Bypass -File ""%ProgramData%\GoXLR-Power\goxlr-power.ps1""", 0, False
) > "%INSTALL_DIR%\goxlr-power.vbs"

echo [3/4] Suppression des anciennes taches...
schtasks /delete /tn "GoXLR-Power" /f >nul 2>&1
schtasks /delete /tn "GoXLR-Power-On" /f >nul 2>&1
schtasks /delete /tn "GoXLR-Power-Off" /f >nul 2>&1

echo [4/4] Creation de la tache planifiee...
schtasks /create /tn "GoXLR-Power" /tr "wscript.exe \"%INSTALL_DIR%\goxlr-power.vbs\"" /sc onlogon /rl highest /f >nul 2>&1

if %errorlevel% neq 0 (
    echo [ERREUR] Impossible de creer la tache planifiee.
    pause
    exit /b 1
)

echo       Tache "GoXLR-Power" creee.

REM Arrete l'ancien processus si present
powershell -Command "Get-Process powershell -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like '*goxlr-power*'} | Stop-Process -Force -ErrorAction SilentlyContinue" >nul 2>&1

REM Lance le script maintenant (en cache)
start "" wscript.exe "%INSTALL_DIR%\goxlr-power.vbs"

echo.
echo ============================================
echo    Installation terminee !
echo ============================================
echo.
echo Les lumieres du GoXLR s'eteindront a l'arret du PC.
echo (GoXLR Utility les rallume automatiquement au demarrage)
echo.
echo Pour desinstaller: lancez uninstall.bat
echo.
pause
