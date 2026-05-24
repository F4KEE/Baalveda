# 🚀 QUICK START GUIDE

## 30-Second Setup

### ✅ Prerequisites
1. **Node.js** - Download from https://nodejs.org/ (v14+)
2. **MySQL** - Download from https://mysql.com/ (v5.7+)
3. **Any Browser** - Chrome, Firefox, Safari, Edge

### 📥 Step 1: Install Node.js & MySQL
- Download and install both if not already installed
- Verify installation:
  ```bash
  node --version
  npm --version
  mysql --version
  ```

### 🗄️ Step 2: Create Database (3 options)

**Option A: MySQL Command Line**
```bash
mysql -u root -p < database/schema.sql
```
(Enter your MySQL root password when prompted)

**Option B: MySQL Workbench**
1. Open MySQL Workbench
2. File → Open SQL Script → Select `database/schema.sql`
3. Execute the script

**Option C: Quick Copy-Paste**
1. Open MySQL
2. Paste content from `database/schema.sql`
3. Run

### ⚙️ Step 3: Configure Backend

1. Open `server/.env` in a text editor
2. Update with YOUR MySQL credentials:
   ```
   DB_HOST=localhost
   DB_USER=root
   DB_PASSWORD=YOUR_PASSWORD_HERE
   DB_NAME=grace_clinic
   PORT=3001
   ```
3. Save the file

### 📦 Step 4: Install & Start Backend

In terminal, run:
```bash
cd server
npm install
npm start
```

Expected output:
```
✅ Grace Clinic Server running on http://localhost:3001
```

**Keep this terminal open!**

### 🌐 Step 5: Open Frontend

1. Double-click `client/index.html` (opens in browser)
2. Or open browser → Ctrl+O → Select `client/index.html`
3. Or use VS Code Live Server extension

### ✅ Done! Test It
1. Click "Book Appointment" button
2. Fill in form with test data
3. Submit and see confirmation

---

## 📁 File Locations

```
DOCTOR/
├── client/              ← Open index.html here
├── server/              ← Run npm start here
├── database/schema.sql  ← Import to MySQL
└── admin/dashboard.html ← View bookings
```

---

## 🔧 Troubleshooting

### Port 3001 in use?
```bash
# Windows
netstat -ano | findstr :3001
taskkill /PID <number> /F

# Mac/Linux
lsof -i :3001
kill -9 <number>
```

### MySQL error?
- Check MySQL is running
- Verify password in `.env`
- Run schema.sql again

### Form not working?
- Check backend terminal for errors
- Open browser DevTools (F12)
- Check Console tab for messages

### Can't find MySQL?
On Windows:
```bash
# Find MySQL installation
cd "C:\Program Files\MySQL\MySQL Server 8.0\bin"
mysql -u root -p
```

---

## 🎯 Next Steps

After setup works:

1. **Customize**
   - Edit clinic name in `client/` files
   - Change colors in `client/styles.css`
   - Update doctor names

2. **View Admin Dashboard**
   - Open `admin/dashboard.html`
   - See all appointments
   - Cancel bookings

3. **Add Data**
   - Book test appointments
   - Check database with:
     ```bash
     mysql -u root -p grace_clinic
     SELECT * FROM appointments;
     ```

4. **Deploy**
   - Upload `client/` to web host
   - Deploy `server/` to cloud platform
   - Update API URL in `client/script.js`

---

## 📞 Commands Reference

| Task | Command |
|------|---------|
| Install dependencies | `npm install` |
| Start server | `npm start` |
| Access database | `mysql -u root -p grace_clinic` |
| View appointments | `SELECT * FROM appointments;` |
| Create database | `mysql -u root -p < database/schema.sql` |

---

## ✨ What's Included

✅ 5 fully responsive pages  
✅ Working appointment booking system  
✅ MySQL database with schema  
✅ Express backend API  
✅ Admin dashboard  
✅ Premium design  
✅ Form validation  
✅ Error handling  
✅ CORS enabled  

---

## 🎨 Customize Your Clinic

### 1. Clinic Name
- `client/index.html` - Line 1 title, navbar logo
- `client/` - All pages
- Search & replace "Grace Clinic"

### 2. Doctor Names
- `client/appointments.html` - Doctor options
- `client/about.html` - Doctor profiles
- `database/schema.sql` - Sample data

### 3. Contact Info
- `client/contact.html` - Phone, address, hours
- `client/index.html` - Contact strip
- Footer - All pages

### 4. Colors
- `client/styles.css` - `:root` variables
- Change `--primary-color`, `--secondary-color`, etc.

### 5. Services
- `client/services.html` - Edit service cards

---

## 🚀 Now You're Ready!

Go to http://localhost in your browser and start managing appointments! 🎉

---

**Need help?** Check README.md for detailed information.
