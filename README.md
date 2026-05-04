# 🏥 Grace Clinic - Premium Healthcare Website

A production-quality clinic website with integrated appointment booking system, built with Node.js, Express, MySQL, and modern HTML/CSS/JavaScript.

---

## 📋 Features

### Frontend
- ✅ Premium, modern design inspired by top hospital websites
- ✅ Fully responsive (mobile, tablet, desktop)
- ✅ White + Teal/Green color palette
- ✅ Smooth animations and hover effects
- ✅ Clean navigation and user experience

### Pages
1. **Homepage** - Hero section, services overview, testimonials, contact info
2. **About Page** - Doctor profiles with qualifications and experience
3. **Services Page** - Comprehensive list of medical services
4. **Appointments Page** - Working booking system with validation
5. **Contact Page** - Location, hours, contact details, embedded map

### Backend
- ✅ REST API with Express.js
- ✅ MySQL database integration
- ✅ Appointment booking with validation
- ✅ Duplicate booking prevention
- ✅ CORS enabled
- ✅ Error handling
- ✅ Admin route to view all appointments

### Core Features
- ✅ Real-time appointment booking
- ✅ Doctor selection
- ✅ Date and time slot selection
- ✅ Phone number validation
- ✅ Success/error feedback
- ✅ Responsive form design

---

## 🛠️ Tech Stack

| Component | Technology |
|-----------|-----------|
| Frontend | HTML5, CSS3, Vanilla JavaScript |
| Backend | Node.js, Express.js |
| Database | MySQL |
| CORS | Enabled for frontend communication |

---

## 📦 Project Structure

```
DOCTOR/
├── client/                    # Frontend files
│   ├── index.html            # Homepage
│   ├── about.html            # About page
│   ├── services.html         # Services page
│   ├── appointments.html     # Booking page
│   ├── contact.html          # Contact page
│   ├── styles.css            # Premium styling
│   └── script.js             # Client-side logic
│
├── server/                    # Backend files
│   ├── server.js             # Express server
│   ├── package.json          # Dependencies
│   ├── .env                  # Environment variables
│   └── .env.example          # Example env file
│
├── database/
│   └── schema.sql            # MySQL schema
│
└── README.md                 # This file
```

---

## ⚡ Quick Start

### Prerequisites
- Node.js (v14 or higher)
- npm or yarn
- MySQL (v5.7 or higher)
- A modern web browser

### Installation & Setup

#### 1️⃣ Clone/Download the Project
```bash
cd DOCTOR
```

#### 2️⃣ Setup Database

**Option A: Using MySQL Workbench or Command Line**

```bash
mysql -u root -p < database/schema.sql
```

When prompted, enter your MySQL root password.

**Option B: Using MySQL CLI directly**

```bash
mysql -u root -p
```

Then paste the contents of `database/schema.sql` and press Enter.

#### 3️⃣ Configure Environment Variables

Edit `server/.env` with your MySQL credentials:

```env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=your_password
DB_NAME=grace_clinic
PORT=3001
NODE_ENV=development
```

#### 4️⃣ Install Backend Dependencies

```bash
cd server
npm install
```

#### 5️⃣ Start the Backend Server

```bash
npm start
```

You should see:
```
✅ Grace Clinic Server running on http://localhost:3001
```

#### 6️⃣ Open Frontend in Browser

Open `client/index.html` in your web browser:
- Direct: Double-click the file
- Or: Use VS Code Live Server extension
- Or: Right-click → Open with → Browser

---

## 🌐 API Endpoints

### Book Appointment
**POST** `/api/book`
```json
{
  "patientName": "John Doe",
  "phone": "+91 98765 43210",
  "doctor": "Dr. Rajesh Kumar",
  "appointmentDate": "2026-05-15",
  "appointmentTime": "10:00 AM"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Appointment booked successfully",
  "appointmentId": 1,
  "data": { ... }
}
```

### View All Appointments (Admin)
**GET** `/api/admin/appointments`

Returns all appointments with details.

### Get Booked Time Slots
**GET** `/api/appointments/:doctor/:date`

Returns already booked time slots for a specific doctor and date.

### Cancel Appointment
**DELETE** `/api/appointments/:id`

Cancels an appointment by ID.

### Health Check
**GET** `/api/health`

Verifies server is running.

---

## 🎨 Design Features

### Color Palette
- **Primary**: Teal (#1abc9c)
- **Secondary**: Dark Blue (#34495e)
- **Background**: White/Light Gray
- **Text**: Dark Gray (#2c3e50)

### Components
- Rounded cards (12-20px border-radius)
- Soft shadows for depth
- Smooth hover effects
- Responsive grid layouts
- Mobile-first design

### Typography
- Clean, modern sans-serif fonts
- Proper hierarchy and spacing
- Readable line-height (1.6)
- Professional font sizing

---

## 📱 Responsive Breakpoints

- **Desktop**: 1200px+
- **Tablet**: 768px - 1199px
- **Mobile**: Below 768px
- **Small Mobile**: Below 480px

All pages and forms fully responsive and touch-friendly.

---

## ✅ Features in Detail

### Appointment Booking
1. Patient enters name and phone
2. Selects preferred doctor
3. Chooses appointment date (min: today)
4. Selects time slot from available options
5. Form validates all inputs
6. Backend checks for duplicate bookings
7. Success message displays confirmation
8. Data saved to MySQL database

### Validation
- Phone number format validation
- Required field checks
- Date cannot be in the past
- Time slots cannot be double-booked
- Real-time error feedback

### Admin Features
- View all appointments via `/api/admin/appointments`
- See patient details, doctor, date, and time
- Cancel appointments via DELETE endpoint
- Track booking history with timestamps

---

## 🚀 Deployment

### Local Production Run
```bash
cd server
NODE_ENV=production npm start
```

### Deploy to Server
1. Upload files to server
2. Install Node.js and MySQL
3. Configure `.env` with production values
4. Run `npm install`
5. Create database using `schema.sql`
6. Start server with PM2 or similar:
   ```bash
   npm install -g pm2
   pm2 start server.js
   pm2 startup
   pm2 save
   ```

### Hosting Options
- **Frontend**: Netlify, Vercel, GitHub Pages, any static host
- **Backend**: Heroku, Railway, DigitalOcean, AWS, Google Cloud
- **Database**: AWS RDS, Google Cloud SQL, managed MySQL services

---

## 🐛 Troubleshooting

### Port 3001 Already in Use
```bash
# On Windows
netstat -ano | findstr :3001
taskkill /PID <PID> /F

# On Mac/Linux
lsof -i :3001
kill -9 <PID>
```

### MySQL Connection Error
- Verify MySQL is running
- Check `.env` credentials
- Ensure database exists: `SHOW DATABASES;`

### CORS Errors
- Backend should have `cors` enabled (it does by default)
- Frontend must use `http://localhost:3001` API URL
- Check that backend is running on correct port

### Form Not Submitting
1. Check browser console for errors (F12)
2. Verify backend server is running
3. Check network tab to see API response
4. Ensure all form fields are valid

---

## 📝 Usage Examples

### Book an Appointment (JavaScript)
```javascript
const bookingData = {
    patientName: "John Doe",
    phone: "+91 98765 43210",
    doctor: "Dr. Rajesh Kumar",
    appointmentDate: "2026-05-15",
    appointmentTime: "10:00 AM"
};

fetch('http://localhost:3001/api/book', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify(bookingData)
})
.then(res => res.json())
.then(data => console.log(data));
```

### View Appointments (cURL)
```bash
curl http://localhost:3001/api/admin/appointments
```

---

## 🔒 Security Notes

### Current Implementation
- CORS enabled for development
- Basic input validation
- SQL injection prevention (prepared statements)
- No authentication (as per requirements)

### For Production
- Add authentication for admin routes
- Implement rate limiting
- Add HTTPS/SSL
- Sanitize all inputs
- Use environment variables for secrets
- Add request logging
- Implement backup strategy

---

## 📞 Customization

### Change Doctor Names
Edit in:
- `client/appointments.html` (option values)
- `client/about.html` (doctor cards)
- Database queries

### Change Clinic Details
- `client/index.html` - Clinic name, tagline, phone
- `client/contact.html` - Address, hours, map location
- `.env` - Database credentials

### Change Colors
Edit `:root` variables in `client/styles.css`:
```css
:root {
    --primary-color: #1abc9c;
    --secondary-color: #34495e;
    /* etc */
}
```

### Change Time Slots
Edit in `client/appointments.html` in the `<select>` element.

---

## 📊 Database Schema

### appointments Table
| Column | Type | Details |
|--------|------|---------|
| id | INT | Primary key, auto-increment |
| patient_name | VARCHAR(100) | Patient's full name |
| phone | VARCHAR(20) | Contact number |
| doctor | VARCHAR(100) | Doctor assigned |
| appointment_date | DATE | Date of appointment |
| appointment_time | VARCHAR(10) | Time slot (e.g., "10:00 AM") |
| created_at | TIMESTAMP | Booking time |
| updated_at | TIMESTAMP | Last update time |

**Constraints:**
- Unique: (doctor, appointment_date, appointment_time)
- Indexes: doctor, date, phone for fast queries

---

## 🎯 Future Enhancements

Possible additions (out of scope for this version):
- Patient login/registration
- Email notifications
- SMS reminders
- Payment integration
- Prescription management
- Medical records
- Video consultation
- Review/rating system
- Analytics dashboard
- Staff management
- Inventory management

---

## 📄 License

MIT License - Free to use and modify

---

## 👨‍💼 Support

For issues or questions:
1. Check this README
2. Review error messages in browser console (F12)
3. Check server terminal for backend errors
4. Verify database connection
5. Ensure all prerequisites are installed

---

## 🎉 You're All Set!

Your Grace Clinic website is ready to go. Start the server, open the frontend, and begin booking appointments!

**Happy coding! 🚀**

---

## 📋 Checklist Before Go-Live

- [ ] Update clinic name and details
- [ ] Add doctor information
- [ ] Configure MySQL database
- [ ] Set environment variables
- [ ] Test all form fields
- [ ] Verify appointment booking works
- [ ] Check responsive design on mobile
- [ ] Test all navigation links
- [ ] Update contact information
- [ ] Test error scenarios
- [ ] Deploy to production server
- [ ] Configure domain/SSL
- [ ] Setup database backups
- [ ] Monitor server logs

---

**Created with ❤️ for Grace Clinic**
