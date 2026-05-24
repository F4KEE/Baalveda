# 📚 Grace Clinic API Documentation

## Base URL
```
http://localhost:3001/api
```

## Authentication
Currently no authentication required (basic setup). For production, implement JWT or similar.

---

## Endpoints

### 1. Book Appointment ✅
**POST** `/api/book`

Books a new appointment for a patient.

#### Request Body
```json
{
  "patientName": "John Doe",
  "phone": "+91 98765 43210",
  "doctor": "Dr. Rajesh Kumar",
  "appointmentDate": "2026-05-15",
  "appointmentTime": "10:00 AM"
}
```

#### Request Headers
```
Content-Type: application/json
```

#### Response (Success - 201)
```json
{
  "success": true,
  "message": "Appointment booked successfully",
  "appointmentId": 1,
  "data": {
    "patientName": "John Doe",
    "phone": "+91 98765 43210",
    "doctor": "Dr. Rajesh Kumar",
    "appointmentDate": "2026-05-15",
    "appointmentTime": "10:00 AM"
  }
}
```

#### Response (Error - 400)
```json
{
  "success": false,
  "message": "All fields are required"
}
```

#### Response (Conflict - 409)
```json
{
  "success": false,
  "message": "This time slot is already booked. Please choose another time."
}
```

#### Validation Rules
- `patientName`: Required, string, max 100 chars
- `phone`: Required, valid format (7+ digits)
- `doctor`: Required, must be valid doctor name
- `appointmentDate`: Required, must be today or future date
- `appointmentTime`: Required, must be from available slots

---

### 2. Get All Appointments (Admin) 📋
**GET** `/api/admin/appointments`

Retrieves all appointments. No authentication in basic version.

#### Response (Success - 200)
```json
{
  "success": true,
  "count": 3,
  "data": [
    {
      "id": 1,
      "patient_name": "John Doe",
      "phone": "+91 98765 43210",
      "doctor": "Dr. Rajesh Kumar",
      "appointment_date": "2026-05-15",
      "appointment_time": "10:00 AM",
      "created_at": "2026-05-03T10:30:00Z"
    },
    {
      "id": 2,
      "patient_name": "Jane Smith",
      "phone": "+91 87654 32109",
      "doctor": "Dr. Priya Kumar",
      "appointment_date": "2026-05-16",
      "appointment_time": "2:00 PM",
      "created_at": "2026-05-03T11:15:00Z"
    }
  ]
}
```

#### Usage
```javascript
fetch('http://localhost:3001/api/admin/appointments')
  .then(res => res.json())
  .then(data => console.log(data));
```

---

### 3. Get Booked Time Slots 🕐
**GET** `/api/appointments/:doctor/:date`

Gets all booked time slots for a specific doctor on a specific date.

#### URL Parameters
- `doctor`: Doctor name (URL encoded if has spaces)
- `date`: Date in YYYY-MM-DD format

#### Example
```
GET /api/appointments/Dr. Rajesh Kumar/2026-05-15
```

#### Response (Success - 200)
```json
{
  "success": true,
  "bookedTimes": [
    "10:00 AM",
    "11:00 AM",
    "2:30 PM"
  ]
}
```

#### Usage
```javascript
const doctor = "Dr. Rajesh Kumar";
const date = "2026-05-15";
fetch(`http://localhost:3001/api/appointments/${encodeURIComponent(doctor)}/${date}`)
  .then(res => res.json())
  .then(data => {
    console.log('Booked times:', data.bookedTimes);
  });
```

---

### 4. Cancel Appointment ❌
**DELETE** `/api/appointments/:id`

Cancels an appointment by ID.

#### URL Parameters
- `id`: Appointment ID (integer)

#### Example
```
DELETE /api/appointments/1
```

#### Response (Success - 200)
```json
{
  "success": true,
  "message": "Appointment cancelled successfully"
}
```

#### Response (Error - 404)
```json
{
  "success": false,
  "message": "Appointment not found"
}
```

#### Usage
```javascript
fetch('http://localhost:3001/api/appointments/1', {
  method: 'DELETE'
})
.then(res => res.json())
.then(data => {
  if (data.success) {
    console.log('Cancelled');
  }
});
```

---

### 5. Health Check 🏥
**GET** `/api/health`

Verifies server is running and responsive.

#### Response (Success - 200)
```json
{
  "status": "Server is running"
}
```

#### Usage
```javascript
fetch('http://localhost:3001/api/health')
  .then(res => res.json())
  .then(data => console.log(data));
```

---

## Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "All fields are required"
}
```

### 409 Conflict
```json
{
  "success": false,
  "message": "This time slot is already booked"
}
```

### 404 Not Found
```json
{
  "success": false,
  "message": "Appointment not found"
}
```

### 500 Server Error
```json
{
  "success": false,
  "message": "Server error: [error message]"
}
```

---

## Examples

### cURL Examples

#### Book Appointment
```bash
curl -X POST http://localhost:3001/api/book \
  -H "Content-Type: application/json" \
  -d '{
    "patientName": "John Doe",
    "phone": "+91 98765 43210",
    "doctor": "Dr. Rajesh Kumar",
    "appointmentDate": "2026-05-15",
    "appointmentTime": "10:00 AM"
  }'
```

#### Get All Appointments
```bash
curl http://localhost:3001/api/admin/appointments
```

#### Get Booked Times
```bash
curl "http://localhost:3001/api/appointments/Dr.%20Rajesh%20Kumar/2026-05-15"
```

#### Cancel Appointment
```bash
curl -X DELETE http://localhost:3001/api/appointments/1
```

### JavaScript/Fetch Examples

#### Book Appointment
```javascript
const bookAppointment = async () => {
  const response = await fetch('http://localhost:3001/api/book', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      patientName: 'John Doe',
      phone: '+91 98765 43210',
      doctor: 'Dr. Rajesh Kumar',
      appointmentDate: '2026-05-15',
      appointmentTime: '10:00 AM'
    })
  });
  
  const data = await response.json();
  console.log(data);
};
```

#### Check Available Slots
```javascript
const getAvailableSlots = async (doctor, date) => {
  const response = await fetch(
    `http://localhost:3001/api/appointments/${encodeURIComponent(doctor)}/${date}`
  );
  
  const data = await response.json();
  const allSlots = [
    '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM', '12:00 PM',
    '2:00 PM', '2:30 PM', '3:00 PM', '3:30 PM', '4:00 PM', '4:30 PM', '5:00 PM'
  ];
  
  const availableSlots = allSlots.filter(slot => 
    !data.bookedTimes.includes(slot)
  );
  
  return availableSlots;
};
```

---

## Rate Limiting

Currently not implemented. For production, add:
```javascript
const rateLimit = require('express-rate-limit');
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
});

app.use('/api/', limiter);
```

---

## CORS Settings

Currently enabled for all origins in development:
```javascript
app.use(cors());
```

For production, restrict to specific domain:
```javascript
app.use(cors({
  origin: 'https://yourdomain.com',
  credentials: true
}));
```

---

## Database Schema

### appointments Table
```sql
CREATE TABLE appointments (
  id INT PRIMARY KEY AUTO_INCREMENT,
  patient_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  doctor VARCHAR(100) NOT NULL,
  appointment_date DATE NOT NULL,
  appointment_time VARCHAR(10) NOT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  UNIQUE KEY unique_slot (doctor, appointment_date, appointment_time),
  INDEX idx_doctor_date (doctor, appointment_date),
  INDEX idx_appointment_date (appointment_date),
  INDEX idx_phone (phone),
  INDEX idx_created_at (created_at)
);
```

---

## Available Doctors
- `Dr. Rajesh Kumar` - MD, General Medicine
- `Dr. Priya Kumar` - MD, Pediatrics & Family Medicine

---

## Available Time Slots
- 10:00 AM
- 10:30 AM
- 11:00 AM
- 11:30 AM
- 12:00 PM
- 2:00 PM
- 2:30 PM
- 3:00 PM
- 3:30 PM
- 4:00 PM
- 4:30 PM
- 5:00 PM
- 5:30 PM

---

## Environment Variables

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=password
DB_NAME=grace_clinic
PORT=3001
NODE_ENV=development
```

---

## Deployment Checklist

- [ ] Add authentication for admin endpoints
- [ ] Implement rate limiting
- [ ] Add request validation
- [ ] Setup HTTPS/SSL
- [ ] Configure CORS for specific domain
- [ ] Add request logging
- [ ] Setup database backups
- [ ] Add error tracking (Sentry)
- [ ] Implement monitoring
- [ ] Add API documentation on website

---

## Support

For issues or questions about the API, check:
1. Server logs (terminal output)
2. Browser DevTools Console (F12)
3. Network tab in DevTools
4. README.md for general setup

---

**Last Updated**: May 3, 2026  
**API Version**: 1.0.0  
**Status**: Production Ready
