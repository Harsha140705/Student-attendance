@echo off
setlocal enabledelayedexpansion
title Student Attendance System - Database Setup & Seeder

echo =========================================================================
echo   STUDENT ATTENDANCE SYSTEM - SQL DATABASE SETUP ^& DATA SEEDER
echo =========================================================================
echo.

rem Locate psql
set "PSQL_BIN=psql"
where psql >nul 2>&1
if %errorlevel% neq 0 (
    if exist "C:\Program Files\PostgreSQL\18\bin\psql.exe" (
        set "PSQL_BIN=C:\Program Files\PostgreSQL\18\bin\psql.exe"
    ) else if exist "C:\Program Files\PostgreSQL\17\bin\psql.exe" (
        set "PSQL_BIN=C:\Program Files\PostgreSQL\17\bin\psql.exe"
    ) else if exist "C:\Program Files\PostgreSQL\16\bin\psql.exe" (
        set "PSQL_BIN=C:\Program Files\PostgreSQL\16\bin\psql.exe"
    ) else (
        echo [ERROR] PostgreSQL 'psql' client was not found in PATH or standard Program Files.
        echo Please ensure PostgreSQL is installed.
        pause
        exit /b 1
    )
)

echo [*] Using PostgreSQL client: "!PSQL_BIN!"
echo.

set /p PG_HOST="Enter PostgreSQL Host [default: localhost]: "
if "!PG_HOST!"=="" set "PG_HOST=localhost"

set /p PG_PORT="Enter PostgreSQL Port [default: 5432]: "
if "!PG_PORT!"=="" set "PG_PORT=5432"

set /p PG_USER="Enter PostgreSQL User [default: postgres]: "
if "!PG_USER!"=="" set "PG_USER=postgres"

set /p PGPASSWORD="Enter PostgreSQL Password for !PG_USER! [default: root]: "
if "!PGPASSWORD!"=="" set "PGPASSWORD=root"
export PGPASSWORD=!PGPASSWORD!

echo.
echo [1/3] Testing PostgreSQL connection...
"!PSQL_BIN!" -h !PG_HOST! -p !PG_PORT! -U !PG_USER! -d postgres -c "SELECT 1;" >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Could not connect to PostgreSQL. Please check:
    echo   1. PostgreSQL service is running
    echo   2. Host, port, username and password are correct
    pause
    exit /b 1
)
echo [OK] Connected successfully!

echo.
echo [2/3] Checking if database 'attendance_db' exists...
"!PSQL_BIN!" -h !PG_HOST! -p !PG_PORT! -U !PG_USER! -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='attendance_db'" | findstr "1" >nul
if %errorlevel% neq 0 (
    echo [*] Creating database 'attendance_db'...
    "!PSQL_BIN!" -h !PG_HOST! -p !PG_PORT! -U !PG_USER! -d postgres -c "CREATE DATABASE attendance_db;"
) else (
    echo [OK] Database 'attendance_db' already exists.
)

echo.
echo [3/3] Executing schema creation and seeding student data from sql\attendance_system.sql...
"!PSQL_BIN!" -h !PG_HOST! -p !PG_PORT! -U !PG_USER! -d attendance_db -f "sql\attendance_system.sql"
if %errorlevel% neq 0 (
    echo [ERROR] An error occurred during SQL execution.
    pause
    exit /b 1
)

echo.
echo =========================================================================
echo   DATABASE VERIFICATION:
echo =========================================================================
"!PSQL_BIN!" -h !PG_HOST! -p !PG_PORT! -U !PG_USER! -d attendance_db -c "SELECT 'Students count:' AS Table, COUNT(*) FROM students UNION ALL SELECT 'Users count:', COUNT(*) FROM app_users UNION ALL SELECT 'Attendance records:', COUNT(*) FROM attendance_records;"

echo.
echo =========================================================================
echo   SUCCESS! Database linked and student data seeded successfully.
echo   You can now launch the application via: run.bat
echo =========================================================================
pause
