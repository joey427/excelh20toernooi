@echo off
setlocal EnableDelayedExpansion
title Excel Bestanden Wisser

echo ============================================
echo       EXCEL BESTANDEN WISSER
echo ============================================
echo.
echo Dit script verwijdert ALLE Excel bestanden
echo (.xlsx, .xls, .xlsm, .xlsb, .csv) van:
echo  - Bureaublad
echo  - Documenten
echo  - Downloads
echo  - OneDrive
echo  - Volledige C:\ schijf
echo.
echo WAARSCHUWING: Bestanden worden PERMANENT
echo verwijderd en zijn NIET terug te halen.
echo.
set /p keuze="Wilt u doorgaan? (J/N): "
if /i not "%keuze%"=="J" (
    echo Geannuleerd.
    pause
    exit /b 0
)

echo.
echo [*] Sluit Excel af indien geopend...
taskkill /f /im excel.exe 2>nul

echo.
echo [*] Zoeken en verwijderen van Excel bestanden...
echo.

set teller=0

for %%E in (xlsx xls xlsm xlsb csv) do (
    for /r "C:\" %%F in (*.%%E) do (
        echo Verwijderd: %%F
        del /f /q "%%F" 2>nul
        set /a teller+=1
    )
)

echo.
echo ============================================
echo  Klaar! !teller! Excel bestanden verwijderd.
echo ============================================
echo.
pause
endlocal
