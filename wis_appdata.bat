@echo off
setlocal EnableDelayedExpansion
title AppData Wisser

echo ============================================
echo         WINDOWS APP DATA WISSER
echo ============================================
echo.
echo Dit script wist de volgende locaties:
echo  - Tijdelijke bestanden (TEMP / TMP)
echo  - Windows Temp map
echo  - Prefetch bestanden
echo  - Recente bestanden (Recent)
echo  - Prullenbak
echo  - Browser caches (Chrome, Edge, Firefox)
echo  - Thumbnail cache
echo  - Microsoft Excel (recent, cache, AutoRecover, temp bestanden)
echo.
echo WAARSCHUWING: Dit kan niet ongedaan worden gemaakt.
echo.
set /p keuze="Wilt u doorgaan? (J/N): "
if /i not "%keuze%"=="J" (
    echo Geannuleerd.
    pause
    exit /b 0
)

echo.
echo [*] Bezig met wissen...
echo.

:: --- Tijdelijke bestanden gebruiker ---
echo [1/12] Tijdelijke bestanden gebruiker (%TEMP%)...
if exist "%TEMP%" (
    rd /s /q "%TEMP%" 2>nul
    md "%TEMP%" 2>nul
)
if exist "%TMP%" (
    rd /s /q "%TMP%" 2>nul
    md "%TMP%" 2>nul
)

:: --- Windows Temp map ---
echo [2/12] Windows Temp map (C:\Windows\Temp)...
if exist "C:\Windows\Temp" (
    rd /s /q "C:\Windows\Temp" 2>nul
    md "C:\Windows\Temp" 2>nul
)

:: --- Prefetch bestanden (vereist admin) ---
echo [3/12] Prefetch bestanden...
if exist "C:\Windows\Prefetch" (
    del /f /q "C:\Windows\Prefetch\*.*" 2>nul
)

:: --- Recente bestanden ---
echo [4/12] Recente bestanden...
if exist "%APPDATA%\Microsoft\Windows\Recent" (
    del /f /q "%APPDATA%\Microsoft\Windows\Recent\*.*" 2>nul
    del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" 2>nul
    del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*.*" 2>nul
)

:: --- Thumbnail cache ---
echo [5/12] Thumbnail cache...
if exist "%LOCALAPPDATA%\Microsoft\Windows\Explorer" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
)

:: --- Google Chrome cache ---
echo [6/12] Google Chrome cache...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" (
    rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" 2>nul
)
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache" (
    rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache" 2>nul
)

:: --- Microsoft Edge cache ---
echo [7/12] Microsoft Edge cache...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" 2>nul
)
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" 2>nul
)

:: --- Firefox cache ---
echo [8/12] Firefox cache...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%P in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        if exist "%%P\cache2" rd /s /q "%%P\cache2" 2>nul
    )
)

:: --- Microsoft Excel ---
echo [9/12] Excel recente bestanden lijst wissen...
if exist "%APPDATA%\Microsoft\Excel" (
    del /f /q "%APPDATA%\Microsoft\Excel\*.xlb" 2>nul
)

echo [10/12] Excel AutoRecover bestanden wissen...
if exist "%APPDATA%\Microsoft\Excel" (
    del /f /q "%APPDATA%\Microsoft\Excel\*.xar" 2>nul
    del /f /q "%APPDATA%\Microsoft\Excel\*.tmp" 2>nul
)
for /d %%V in ("%APPDATA%\Microsoft\Excel") do (
    del /f /q "%%V\*.xar" 2>nul
    del /f /q "%%V\*.tmp" 2>nul
)

echo [11/12] Office cache (OfficeFileCache) wissen...
if exist "%LOCALAPPDATA%\Microsoft\Office\16.0\OfficeFileCache" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\Office\16.0\OfficeFileCache" 2>nul
)
if exist "%LOCALAPPDATA%\Microsoft\Office\15.0\OfficeFileCache" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\Office\15.0\OfficeFileCache" 2>nul
)
if exist "%LOCALAPPDATA%\Microsoft\Office\UnsavedFiles" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Office\UnsavedFiles\*.xls" 2>nul
    del /f /q "%LOCALAPPDATA%\Microsoft\Office\UnsavedFiles\*.xlsx" 2>nul
    del /f /q "%LOCALAPPDATA%\Microsoft\Office\UnsavedFiles\*.xlsm" 2>nul
)

:: --- Prullenbak leegmaken ---
echo [12/12] Prullenbak leegmaken...
rd /s /q "C:\$Recycle.Bin" 2>nul

echo.
echo ============================================
echo  Klaar! App data is gewist.
echo ============================================
echo.
pause
endlocal
