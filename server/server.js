// ============================================
// GRACE CLINIC - NODE.JS EXPRESS SERVER
// ============================================

const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3001;

// Middleware
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(cors());

// Database connection pool
const pool = mysql.createPool({
    host: process.env.DB_HOST || 'localhost',
    user: process.env.DB_USER || 'root',
    password: process.env.DB_PASSWORD || 'password',
    database: process.env.DB_NAME || 'grace_clinic',
    waitForConnections: true,
    connectionLimit: 10,
    queueLimit: 0
});

// ============================================
// ROUTES
// ============================================

// Health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'Server is running' });
});

// Book appointment
app.post('/api/book', async (req, res) => {
    try {
        const { patientName, phone, doctor, appointmentDate, appointmentTime } = req.body;

        // Validation
        if (!patientName || !phone || !doctor || !appointmentDate || !appointmentTime) {
            return res.status(400).json({
                success: false,
                message: 'All fields are required'
            });
        }

        // Validate phone format
        const phoneRegex = /^[0-9\-\+\s\(\)]{7,}$/;
        if (!phoneRegex.test(phone)) {
            return res.status(400).json({
                success: false,
                message: 'Invalid phone number format'
            });
        }

        // Validate date is not in past
        const appointmentDateTime = new Date(appointmentDate + ' ' + appointmentTime);
        if (appointmentDateTime < new Date()) {
            return res.status(400).json({
                success: false,
                message: 'Cannot book appointment for past dates'
            });
        }

        // Get connection from pool
        const connection = await pool.getConnection();

        try {
            // Check for duplicate booking (same doctor, date, time)
            const [existingAppointment] = await connection.execute(
                'SELECT id FROM appointments WHERE doctor = ? AND appointment_date = ? AND appointment_time = ?',
                [doctor, appointmentDate, appointmentTime]
            );

            if (existingAppointment.length > 0) {
                await connection.end();
                return res.status(409).json({
                    success: false,
                    message: 'This time slot is already booked. Please choose another time.'
                });
            }

            // Insert appointment
            const [result] = await connection.execute(
                'INSERT INTO appointments (patient_name, phone, doctor, appointment_date, appointment_time, created_at) VALUES (?, ?, ?, ?, ?, NOW())',
                [patientName, phone, doctor, appointmentDate, appointmentTime]
            );

            await connection.end();

            res.status(201).json({
                success: true,
                message: 'Appointment booked successfully',
                appointmentId: result.insertId,
                data: {
                    patientName,
                    phone,
                    doctor,
                    appointmentDate,
                    appointmentTime
                }
            });

        } catch (error) {
            await connection.end();
            throw error;
        }

    } catch (error) {
        console.error('Booking error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error: ' + error.message
        });
    }
});

// Get all appointments (admin route - basic, no auth)
app.get('/api/admin/appointments', async (req, res) => {
    try {
        const connection = await pool.getConnection();

        const [appointments] = await connection.execute(
            'SELECT id, patient_name, phone, doctor, appointment_date, appointment_time, created_at FROM appointments ORDER BY appointment_date DESC, appointment_time DESC'
        );

        await connection.end();

        res.json({
            success: true,
            count: appointments.length,
            data: appointments
        });

    } catch (error) {
        console.error('Fetch error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error: ' + error.message
        });
    }
});

// Get appointments for specific date and doctor
app.get('/api/appointments/:doctor/:date', async (req, res) => {
    try {
        const { doctor, date } = req.params;

        const connection = await pool.getConnection();

        const [appointments] = await connection.execute(
            'SELECT appointment_time FROM appointments WHERE doctor = ? AND appointment_date = ?',
            [doctor, date]
        );

        await connection.end();

        // Extract booked times
        const bookedTimes = appointments.map(a => a.appointment_time);

        res.json({
            success: true,
            bookedTimes
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error: ' + error.message
        });
    }
});

// Cancel appointment (basic - would need auth in production)
app.delete('/api/appointments/:id', async (req, res) => {
    try {
        const { id } = req.params;

        const connection = await pool.getConnection();

        const [result] = await connection.execute(
            'DELETE FROM appointments WHERE id = ?',
            [id]
        );

        await connection.end();

        if (result.affectedRows === 0) {
            return res.status(404).json({
                success: false,
                message: 'Appointment not found'
            });
        }

        res.json({
            success: true,
            message: 'Appointment cancelled successfully'
        });

    } catch (error) {
        console.error('Error:', error);
        res.status(500).json({
            success: false,
            message: 'Server error: ' + error.message
        });
    }
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        success: false,
        message: 'Internal server error'
    });
});

// Start server
app.listen(PORT, () => {
    console.log(`\n✅ Grace Clinic Server running on http://localhost:${PORT}`);
    console.log(`📝 API Documentation:`);
    console.log(`   POST /api/book - Book an appointment`);
    console.log(`   GET /api/admin/appointments - View all appointments`);
    console.log(`   GET /api/appointments/:doctor/:date - Get booked times`);
    console.log(`   DELETE /api/appointments/:id - Cancel appointment`);
    console.log(`   GET /api/health - Health check\n`);
});

module.exports = app;
