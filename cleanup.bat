@echo off
setlocal EnableDelayedExpansion
title Windows Cleanup Tool

echo ============================================
echo          WINDOWS CLEANUP TOOL
echo ============================================
echo.
echo This script will clean the following:
echo  - Temporary files (TEMP / TMP)
echo  - Windows Temp folder
echo  - Prefetch files
echo  - Recent files list
echo  - Recycle Bin
echo  - Browser caches (Chrome, Edge, Firefox)
echo  - Thumbnail cache
echo  - Microsoft Excel cache and temp files
echo  - Excel factory reset (account stays logged in)
echo  - All Excel files on C:\ (.xlsx .xls .xlsm .xlsb .csv)
echo  - Set Windows language to English (United States)
echo.
echo WARNING: This cannot be undone.
echo.
set /p choice="Do you want to continue? (Y/N): "
if /i not "%choice%"=="Y" (
    echo Cancelled.
    pause
    exit /b 0
)

echo.
echo [*] Starting cleanup...
echo.

:: --- User temporary files ---
echo [1/14] User temporary files (%TEMP%)...
if exist "%TEMP%" (
    rd /s /q "%TEMP%" 2>nul
    md "%TEMP%" 2>nul
)
if exist "%TMP%" (
    rd /s /q "%TMP%" 2>nul
    md "%TMP%" 2>nul
)

:: --- Windows Temp folder ---
echo [2/14] Windows Temp folder (C:\Windows\Temp)...
if exist "C:\Windows\Temp" (
    rd /s /q "C:\Windows\Temp" 2>nul
    md "C:\Windows\Temp" 2>nul
)

:: --- Prefetch files (requires admin) ---
echo [3/14] Prefetch files...
if exist "C:\Windows\Prefetch" (
    del /f /q "C:\Windows\Prefetch\*.*" 2>nul
)

:: --- Recent files ---
echo [4/14] Recent files list...
if exist "%APPDATA%\Microsoft\Windows\Recent" (
    del /f /q "%APPDATA%\Microsoft\Windows\Recent\*.*" 2>nul
    del /f /q "%APPDATA%\Microsoft\Windows\Recent\AutomaticDestinations\*.*" 2>nul
    del /f /q "%APPDATA%\Microsoft\Windows\Recent\CustomDestinations\*.*" 2>nul
)

:: --- Thumbnail cache ---
echo [5/14] Thumbnail cache...
if exist "%LOCALAPPDATA%\Microsoft\Windows\Explorer" (
    del /f /q "%LOCALAPPDATA%\Microsoft\Windows\Explorer\thumbcache_*.db" 2>nul
)

:: --- Google Chrome cache ---
echo [6/14] Google Chrome cache...
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" (
    rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Cache" 2>nul
)
if exist "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache" (
    rd /s /q "%LOCALAPPDATA%\Google\Chrome\User Data\Default\Code Cache" 2>nul
)

:: --- Microsoft Edge cache ---
echo [7/14] Microsoft Edge cache...
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Cache" 2>nul
)
if exist "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" (
    rd /s /q "%LOCALAPPDATA%\Microsoft\Edge\User Data\Default\Code Cache" 2>nul
)

:: --- Firefox cache ---
echo [8/14] Firefox cache...
if exist "%LOCALAPPDATA%\Mozilla\Firefox\Profiles" (
    for /d %%P in ("%LOCALAPPDATA%\Mozilla\Firefox\Profiles\*") do (
        if exist "%%P\cache2" rd /s /q "%%P\cache2" 2>nul
    )
)

:: --- Excel: close application ---
echo [9/14] Closing Excel...
taskkill /f /im excel.exe 2>nul

:: --- Excel: factory reset (account stays logged in) ---
echo [10/14] Excel factory reset (account stays logged in)...
reg delete "HKCU\Software\Microsoft\Office\16.0\Excel" /f 2>nul
reg delete "HKCU\Software\Microsoft\Office\15.0\Excel" /f 2>nul
reg delete "HKCU\Software\Microsoft\Office\16.0\Common\Toolbars\Excel" /f 2>nul
reg delete "HKCU\Software\Microsoft\Office\15.0\Common\Toolbars\Excel" /f 2>nul
if exist "%APPDATA%\Microsoft\Excel\XLSTART" (
    del /f /q "%APPDATA%\Microsoft\Excel\XLSTART\*.*" 2>nul
)
if exist "%APPDATA%\Microsoft\Excel" (
    del /f /q "%APPDATA%\Microsoft\Excel\*.xlb" 2>nul
    del /f /q "%APPDATA%\Microsoft\Excel\*.xar" 2>nul
    del /f /q "%APPDATA%\Microsoft\Excel\*.tmp" 2>nul
)

:: --- Office cache ---
echo [11/14] Office file cache...
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

:: --- Delete all Excel files on C:\ ---
echo [12/14] Searching and deleting all Excel files on C:\...
set filecount=0
for %%E in (xlsx xls xlsm xlsb csv) do (
    for /r "C:\" %%F in (*.%%E) do (
        echo Deleted: %%F
        del /f /q "%%F" 2>nul
        set /a filecount+=1
    )
)
echo    ^> !filecount! Excel file(s) deleted.

:: --- Recycle Bin ---
echo [13/14] Emptying Recycle Bin...
rd /s /q "C:\$Recycle.Bin" 2>nul

:: --- Set Windows language to English (United States) ---
echo [14/14] Setting Windows language to English (United States)...
powershell -NoProfile -Command "Set-WinUILanguageOverride -Language 'en-US'; Set-WinUserLanguageList 'en-US' -Force; Set-WinSystemLocale 'en-US'; Set-Culture 'en-US'" 2>nul

echo.
echo ============================================
echo  Done! Cleanup complete.
echo  NOTE: Restart Windows to apply the language change.
echo ============================================
echo.
pause
endlocal
