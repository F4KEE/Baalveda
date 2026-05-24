// ============================================
// GRACE CLINIC - CLIENT SIDE JAVASCRIPT
// ============================================

// Set minimum date to today
function setMinDate() {
    const dateInput = document.getElementById('appointmentDate');
    if (dateInput) {
        const today = new Date().toISOString().split('T')[0];
        dateInput.setAttribute('min', today);
    }
}

// Initialize on page load
document.addEventListener('DOMContentLoaded', function() {
    setMinDate();
    setupFormSubmission();
    setupMobileNav();
});

// Setup form submission
function setupFormSubmission() {
    const form = document.getElementById('appointmentForm');
    if (form) {
        form.addEventListener('submit', async function(e) {
            e.preventDefault();
            await submitBooking();
        });
    }
}

// Setup mobile navigation
function setupMobileNav() {
    const navToggle = document.querySelector('.nav-toggle');
    const navLinks = document.getElementById('primary-navigation');
    const navbar = document.querySelector('.navbar');

    if (!navToggle || !navLinks) {
        return;
    }

    if (navToggle.getAttribute('type') !== 'button') {
        navToggle.setAttribute('type', 'button');
    }

    function setMenuOpen(isOpen) {
        navLinks.classList.toggle('open', isOpen);
        navToggle.setAttribute('aria-expanded', String(isOpen));
        if (navbar) {
            navbar.classList.toggle('menu-open', isOpen);
        }
    }

    navToggle.addEventListener('click', function(e) {
        e.preventDefault();
        e.stopPropagation();
        setMenuOpen(!navLinks.classList.contains('open'));
    });

    navLinks.querySelectorAll('a').forEach(link => {
        link.addEventListener('click', function() {
            setMenuOpen(false);
        });
    });

    document.addEventListener('click', function(e) {
        if (!navLinks.classList.contains('open')) {
            return;
        }
        if (!navbar || navbar.contains(e.target)) {
            return;
        }
        setMenuOpen(false);
    });

    window.addEventListener('resize', function() {
        if (window.innerWidth > 700) {
            setMenuOpen(false);
        }
    });
}

// Submit appointment booking
async function submitBooking() {
    const form = document.getElementById('appointmentForm');
    const submitBtn = form.querySelector('button[type="submit"]');
    const submitText = document.getElementById('submitText');
    const loadingSpinner = document.getElementById('loadingSpinner');

    // Get form data
    const patientName = document.getElementById('patientName').value.trim();
    const phone = document.getElementById('phone').value.trim();
    const doctor = document.getElementById('doctor').value;
    const appointmentDate = document.getElementById('appointmentDate').value;
    const appointmentTime = document.getElementById('appointmentTime').value;

    // Validation
    if (!patientName || !phone || !doctor || !appointmentDate || !appointmentTime) {
        showError('Please fill all required fields');
        return;
    }

    // Validate phone number
    const phoneRegex = /^[0-9\-\+\s\(\)]{7,}$/;
    if (!phoneRegex.test(phone)) {
        showError('Please enter a valid phone number');
        return;
    }

    // Show loading state
    submitBtn.disabled = true;
    submitText.style.display = 'none';
    loadingSpinner.style.display = 'inline';

    try {
        const response = await fetch('http://localhost:3001/api/book', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                patientName,
                phone,
                doctor,
                appointmentDate,
                appointmentTime
            })
        });

        const data = await response.json();

        if (response.ok) {
            // Hide form and show success message
            form.style.display = 'none';
            const successMessage = document.getElementById('successMessage');
            const confirmationText = document.getElementById('confirmationText');
            
            confirmationText.innerHTML = `
                <strong>${patientName}</strong><br>
                Date: <strong>${formatDate(appointmentDate)}</strong><br>
                Time: <strong>${appointmentTime}</strong><br>
                Doctor: <strong>${doctor}</strong>
            `;
            
            successMessage.style.display = 'block';
            
            // Reset form
            form.reset();
        } else {
            showError(data.message || 'Failed to book appointment. Please try again.');
        }
    } catch (error) {
        console.error('Error:', error);
        showError('Connection error. Please check your internet and try again.');
    } finally {
        submitBtn.disabled = false;
        submitText.style.display = 'inline';
        loadingSpinner.style.display = 'none';
    }
}

// Show error message
function showError(message) {
    const errorDiv = document.getElementById('errorMessage');
    const errorText = document.getElementById('errorText');
    errorText.textContent = message;
    errorDiv.style.display = 'block';
    
    // Scroll to error
    errorDiv.scrollIntoView({ behavior: 'smooth', block: 'center' });
    
    // Auto-hide after 5 seconds
    setTimeout(() => {
        errorDiv.style.display = 'none';
    }, 5000);
}

// Reset form
function resetForm() {
    const form = document.getElementById('appointmentForm');
    const errorDiv = document.getElementById('errorMessage');
    
    if (form) {
        form.reset();
        form.style.display = 'block';
    }
    
    if (errorDiv) {
        errorDiv.style.display = 'none';
    }
    
    const successMessage = document.getElementById('successMessage');
    if (successMessage) {
        successMessage.style.display = 'none';
    }
}

// Format date for display
function formatDate(dateString) {
    const date = new Date(dateString + 'T00:00:00');
    const options = { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' };
    return date.toLocaleDateString('en-IN', options);
}

// Smooth scroll for navigation
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const target = document.querySelector(this.getAttribute('href'));
        if (target) {
            target.scrollIntoView({
                behavior: 'smooth',
                block: 'start'
            });
        }
    });
});

// Add active class to nav links
function updateActiveNavLink() {
    const currentLocation = location.pathname;
    const menuItems = document.querySelectorAll('.nav-links a');
    
    menuItems.forEach(item => {
        item.classList.remove('active');
        if (item.getAttribute('href') === currentLocation || 
            (currentLocation === '/' && item.getAttribute('href') === 'index.html')) {
            item.classList.add('active');
        }
    });
}

// Call on page load
updateActiveNavLink();
