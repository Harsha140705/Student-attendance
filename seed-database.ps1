<#
.SYNOPSIS
    Student Attendance System - Database Linker & Student Data Seeder
.DESCRIPTION
    Creates the attendance_db database (if not exists) and executes the SQL scripts
    to create tables and seed student data, auth users, and 154 attendance records.
#>

param (
    [string]$HostName = "localhost",
    [int]$Port = 5432,
    [string]$Username = "postgres",
    [string]$Password = $null,
    [string]$Database = "attendance_db"
)

Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host "  STUDENT ATTENDANCE SYSTEM - SQL DATABASE SETUP & DATA SEEDER" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
Write-Host ""

# 1. Locate psql binary
$psqlPath = "psql"
$found = Get-Command psql -ErrorAction SilentlyContinue
if (-not $found) {
    $candidates = @(
        "C:\Program Files\PostgreSQL\18\bin\psql.exe",
        "C:\Program Files\PostgreSQL\17\bin\psql.exe",
        "C:\Program Files\PostgreSQL\16\bin\psql.exe"
    )
    foreach ($cand in $candidates) {
        if (Test-Path $cand) {
            $psqlPath = $cand
            break
        }
    }
}

if (-not (Get-Command $psqlPath -ErrorAction SilentlyContinue) -and -not (Test-Path $psqlPath)) {
    Write-Host "[ERROR] PostgreSQL 'psql' client was not found. Please install PostgreSQL or add psql to PATH." -ForegroundColor Red
    exit 1
}

Write-Host "[*] Using PostgreSQL client: $psqlPath" -ForegroundColor Gray

if ([string]::IsNullOrWhiteSpace($Password)) {
    $inputPwd = Read-Host "Enter PostgreSQL Password for user '$Username' [press Enter for 'root']"
    if ([string]::IsNullOrWhiteSpace($inputPwd)) {
        $Password = "root"
    } else {
        $Password = $inputPwd
    }
}

$env:PGPASSWORD = $Password

# 2. Test Connection
Write-Host "`n[1/3] Testing PostgreSQL connection on $HostName`:$Port..." -ForegroundColor Yellow
$testConn = & $psqlPath -h $HostName -p $Port -U $Username -d postgres -tAc "SELECT 1" 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] Failed to connect to PostgreSQL ($HostName`:$Port). Error:`n$testConn" -ForegroundColor Red
    Write-Host "`nPlease verify that:" -ForegroundColor Yellow
    Write-Host "  1. The PostgreSQL server is running (Service: postgresql-x64-18)"
    Write-Host "  2. The password entered is correct"
    exit 1
}
Write-Host "[OK] Connected to PostgreSQL successfully!" -ForegroundColor Green

# 3. Create database if it doesn't exist
Write-Host "`n[2/3] Checking if database '$Database' exists..." -ForegroundColor Yellow
$dbExists = & $psqlPath -h $HostName -p $Port -U $Username -d postgres -tAc "SELECT 1 FROM pg_database WHERE datname='$Database'" 2>&1
if ($dbExists.Trim() -ne "1") {
    Write-Host "[*] Creating database '$Database'..." -ForegroundColor Gray
    & $psqlPath -h $HostName -p $Port -U $Username -d postgres -c "CREATE DATABASE $Database;"
    if ($LASTEXITCODE -ne 0) {
        Write-Host "[ERROR] Failed to create database '$Database'." -ForegroundColor Red
        exit 1
    }
    Write-Host "[OK] Database '$Database' created successfully." -ForegroundColor Green
} else {
    Write-Host "[OK] Database '$Database' already exists." -ForegroundColor Green
}

# 4. Execute SQL seed script
$sqlFile = Join-Path $PSScriptRoot "sql\attendance_system.sql"
if (-not (Test-Path $sqlFile)) {
    Write-Host "[ERROR] Could not find SQL script: $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "`n[3/3] Executing schema creation and student data seeding..." -ForegroundColor Yellow
& $psqlPath -h $HostName -p $Port -U $Username -d $Database -f $sqlFile
if ($LASTEXITCODE -ne 0) {
    Write-Host "[ERROR] SQL execution returned errors." -ForegroundColor Red
    exit 1
}

# 5. Verification
Write-Host "`n=========================================================================" -ForegroundColor Cyan
Write-Host "  DATABASE VERIFICATION" -ForegroundColor Cyan
Write-Host "=========================================================================" -ForegroundColor Cyan
& $psqlPath -h $HostName -p $Port -U $Username -d $Database -c "SELECT 'Students count' AS entity, COUNT(*) AS total FROM students UNION ALL SELECT 'Users count', COUNT(*) FROM app_users UNION ALL SELECT 'Attendance records', COUNT(*) FROM attendance_records;"

Write-Host "`n=========================================================================" -ForegroundColor Green
Write-Host "  SUCCESS! Database linked and student data seeded successfully." -ForegroundColor Green
Write-Host "  You can now start the application using: .\run.bat" -ForegroundColor Green
Write-Host "=========================================================================" -ForegroundColor Green
