@echo off
title Student Attendance System - Selenium Test & Screenshot Generator
echo =========================================================================
echo   EXECUTING SELENIUM AUTOMATED TESTS & GENERATING SCREENSHOTS
echo =========================================================================
echo.

rem Check python
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python was not found in PATH!
    pause
    exit /b 1
)

echo [*] Running automated Selenium WebDriver suite...
python run_selenium_tests.py
if %errorlevel% neq 0 (
    echo [ERROR] Selenium suite execution encountered an error!
    pause
    exit /b 1
)

echo.
echo =========================================================================
echo   ALL SCREENSHOTS SUCCESSFULLY CAPTURED IN: .\screenshots\
echo =========================================================================
dir screenshots\*.png
echo.
pause
