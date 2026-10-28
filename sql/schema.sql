-- =============================================================================
-- Student Attendance Management System - Database Schema
-- Dialect: PostgreSQL (Compatible with PostgreSQL 14 / 15 / 16 / 17 / 18)
-- =============================================================================

-- Drop tables if they already exist (in reverse dependency order)
DROP TABLE IF EXISTS attendance_records CASCADE;
DROP TABLE IF EXISTS app_users CASCADE;
DROP TABLE IF EXISTS students CASCADE;

-- -----------------------------------------------------------------------------
-- 1. Students Table
-- -----------------------------------------------------------------------------
CREATE TABLE students (
    id BIGSERIAL PRIMARY KEY,
    roll_number VARCHAR(30) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    department VARCHAR(100) NOT NULL,
    semester INTEGER DEFAULT 5,
    email VARCHAR(150),
    phone VARCHAR(20),
    created_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_student_roll ON students(roll_number);
CREATE INDEX idx_student_dept ON students(department);

-- -----------------------------------------------------------------------------
-- 2. Attendance Records Table (Granular 7-Period Tracking)
-- -----------------------------------------------------------------------------
CREATE TABLE attendance_records (
    id BIGSERIAL PRIMARY KEY,
    student_id BIGINT NOT NULL REFERENCES students(id) ON DELETE CASCADE,
    date DATE NOT NULL,
    period_number INTEGER NOT NULL CHECK (period_number BETWEEN 1 AND 7),
    status VARCHAR(10) NOT NULL CHECK (status IN ('PRESENT', 'ABSENT')),
    marked_at TIMESTAMP WITHOUT TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT uk_student_date_period UNIQUE (student_id, date, period_number)
);

CREATE INDEX idx_att_date ON attendance_records(date);
CREATE INDEX idx_att_student_date ON attendance_records(student_id, date);

-- -----------------------------------------------------------------------------
-- 3. App Users Table (RBAC: ADMIN, FACULTY, STUDENT)
-- -----------------------------------------------------------------------------
CREATE TABLE app_users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('ADMIN', 'FACULTY', 'STUDENT')),
    department VARCHAR(100),
    roll_number VARCHAR(30)
);

CREATE INDEX idx_user_username ON app_users(username);
