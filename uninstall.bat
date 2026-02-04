@echo off
title GoXLR Power - Desinstallation
color 0C

echo ============================================
echo    GoXLR Power - Desinstallation
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

set "INSTALL_DIR=%ProgramData%\GoXLR-Power"

echo [1/3] Arret des processus...
taskkill /f /im wscript.exe /fi "COMMANDLINE eq *goxlr-power*" >nul 2>&1
powershell -Command "Get-Process powershell -ErrorAction SilentlyContinue | Where-Object {$_.CommandLine -like '*goxlr-power*'} | Stop-Process -Force -ErrorAction SilentlyContinue" >nul 2>&1
echo       Processus arretes.

echo [2/3] Suppression des taches planifiees...
schtasks /delete /tn "GoXLR-Power" /f >nul 2>&1
schtasks /delete /tn "GoXLR-Power-On" /f >nul 2>&1
schtasks /delete /tn "GoXLR-Power-Off" /f >nul 2>&1
echo       Taches supprimees.

echo [3/3] Suppression des fichiers...
if exist "%INSTALL_DIR%" (
    rmdir /s /q "%INSTALL_DIR%" >nul 2>&1
    echo       Fichiers supprimes.
)

echo.
echo ============================================
echo    Desinstallation terminee !
echo ============================================
echo.
echo GoXLR Power a ete completement supprime.
echo.
pause
