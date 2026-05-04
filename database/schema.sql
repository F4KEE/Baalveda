-- ============================================
-- GRACE CLINIC DATABASE SCHEMA
-- ============================================

-- Create database
CREATE DATABASE IF NOT EXISTS grace_clinic;
USE grace_clinic;

-- ============================================
-- Appointments Table
-- ============================================

CREATE TABLE IF NOT EXISTS appointments (
    id INT PRIMARY KEY AUTO_INCREMENT,
    patient_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    doctor VARCHAR(100) NOT NULL,
    appointment_date DATE NOT NULL,
    appointment_time VARCHAR(10) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Indexes for performance
    INDEX idx_doctor_date (doctor, appointment_date),
    INDEX idx_appointment_date (appointment_date),
    INDEX idx_phone (phone),
    INDEX idx_created_at (created_at)
);

-- ============================================
-- Unique constraint to prevent double booking
-- ============================================

ALTER TABLE appointments ADD CONSTRAINT unique_slot 
UNIQUE KEY (doctor, appointment_date, appointment_time);

-- ============================================
-- Sample data (optional - for testing)
-- ============================================

INSERT INTO appointments (patient_name, phone, doctor, appointment_date, appointment_time, created_at) 
VALUES 
('Amit Singh', '+91 98765 43210', 'Dr. Rajesh Kumar', '2026-05-10', '10:00 AM', NOW()),
('Priya Sharma', '+91 87654 32109', 'Dr. Priya Kumar', '2026-05-10', '2:00 PM', NOW()),
('Rohit Patel', '+91 76543 21098', 'Dr. Rajesh Kumar', '2026-05-11', '3:00 PM', NOW());

-- ============================================
-- View for recent appointments
-- ============================================

CREATE OR REPLACE VIEW recent_appointments AS
SELECT 
    id,
    patient_name,
    phone,
    doctor,
    appointment_date,
    appointment_time,
    created_at
FROM appointments
WHERE appointment_date >= CURDATE()
ORDER BY appointment_date ASC, appointment_time ASC;
