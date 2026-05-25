// ============================================
// GRACE CLINIC - CLIENT SIDE JAVASCRIPT
// ============================================

// Set minimum date to today
const supabaseUrl = 'https://yafszzizbuojzdtvoprh.supabase.co';
const supabaseKey = 'sb_publishable_wglkUNoLTpgy23m9KcWTUg_PALnTLde';

const supabaseClient = window.supabase.createClient(
  supabaseUrl,
  supabaseKey
);
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
        const { data, error } = await supabaseClient
    .from('appointments')
    .insert([
        {
            patient_name: patientName,
            phone: phone,
            doctor: doctor,
            appointment_date: appointmentDate,
            appointment_time: appointmentTime
        }
    ]);

if (!error) {
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
            showError(error.message || 'Failed to book appointment. Please try again.');
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
// ================================
// REVIEW FORM SUBMISSION
// ================================

function setupStarRating() {
    const container = document.getElementById('starRating');
    if (!container) return;

    const inputs = container.querySelectorAll('input[name="rating"]');
    const labels = container.querySelectorAll('label');

    function starValue(label) {
        const id = label.getAttribute('for');
        const input = id ? container.querySelector('#' + id) : null;
        return input ? parseInt(input.value, 10) : 0;
    }

    function highlight(count) {
        labels.forEach(function (label) {
            label.classList.toggle('filled', starValue(label) <= count);
        });
    }

    function selectedRating() {
        const checked = container.querySelector('input[name="rating"]:checked');
        return checked ? parseInt(checked.value, 10) : 0;
    }

    labels.forEach(function (label) {
        label.addEventListener('mouseenter', function () {
            highlight(starValue(label));
        });
        label.addEventListener('click', function () {
            highlight(starValue(label));
        });
    });

    container.addEventListener('mouseleave', function () {
        highlight(selectedRating());
    });

    inputs.forEach(function (input) {
        input.addEventListener('change', function () {
            highlight(selectedRating());
        });
    });

    const form = container.closest('form');
    if (form) {
        form.addEventListener('reset', function () {
            highlight(0);
        });
    }

    highlight(0);
}

const REVIEW_SERVICE_LABELS = {
    consultation: 'Child Health Consultation',
    vaccination: 'Vaccination & Immunization',
    suvarn: 'Suvarn Prashan',
    ayurveda: 'Ayurvedic Therapies',
    other: 'Other'
};

function showReviewSuccess(name, rating, service) {
    const form = document.getElementById('reviewForm');
    const successMessage = document.getElementById('reviewSuccessMessage');
    const errorMessage = document.getElementById('reviewErrorMessage');
    const confirmationText = document.getElementById('reviewConfirmationText');

    if (!form || !successMessage || !confirmationText) return;

    const serviceLabel = service
        ? (REVIEW_SERVICE_LABELS[service] || service)
        : 'Not specified';
    const starDisplay = '★'.repeat(rating) + '☆'.repeat(5 - rating);

    confirmationText.innerHTML = `
        <strong>${name}</strong><br>
        Rating: <strong>${rating} / 5</strong> <span style="color:#FFD700;letter-spacing:2px;">${starDisplay}</span><br>
        Service: <strong>${serviceLabel}</strong>
    `;

    form.style.display = 'none';
    if (errorMessage) errorMessage.style.display = 'none';
    successMessage.style.display = 'block';
    successMessage.scrollIntoView({ behavior: 'smooth', block: 'center' });
}

function showReviewError(message) {
    const successMessage = document.getElementById('reviewSuccessMessage');
    const errorMessage = document.getElementById('reviewErrorMessage');
    const errorText = document.getElementById('reviewErrorText');

    if (!errorMessage || !errorText) return;

    errorText.textContent = message;
    if (successMessage) successMessage.style.display = 'none';
    errorMessage.style.display = 'block';
    errorMessage.scrollIntoView({ behavior: 'smooth', block: 'center' });

    setTimeout(function () {
        errorMessage.style.display = 'none';
    }, 5000);
}

function resetReviewForm() {
    const form = document.getElementById('reviewForm');
    const successMessage = document.getElementById('reviewSuccessMessage');
    const errorMessage = document.getElementById('reviewErrorMessage');

    if (form) {
        form.reset();
        form.style.display = 'block';
    }

    if (successMessage) successMessage.style.display = 'none';
    if (errorMessage) errorMessage.style.display = 'none';

    const container = document.getElementById('starRating');
    if (container) {
        container.querySelectorAll('label').forEach(function (label) {
            label.classList.remove('filled');
        });
    }
}

document.addEventListener('DOMContentLoaded', function () {
    setupStarRating();

    const reviewForm = document.getElementById('reviewForm');

    if (reviewForm) {
        reviewForm.addEventListener('submit', async function (e) {
            e.preventDefault();

            const name = document.getElementById('name').value.trim();
            const email = document.getElementById('email').value.trim();
            const phone = document.getElementById('phone').value.trim();
            const ratingRaw = document.querySelector('input[name="rating"]:checked')?.value;
            const rating = parseInt(ratingRaw, 10);
            const service = document.getElementById('service').value;
            const review = document.getElementById('review').value.trim();

            if (!name || !email || !ratingRaw || !review || Number.isNaN(rating) || rating < 1 || rating > 5) {
                showReviewError('Please fill all required fields, including your star rating.');
                return;
            }

            const submitBtn = reviewForm.querySelector('.submit-btn');
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.textContent = 'Submitting...';
            }

            try {
                const { error } = await supabaseClient
                    .from('reviews')
                    .insert([
                        {
                            name: name,
                            email: email,
                            phone: phone,
                            rating: rating,
                            service: service,
                            review_text: review
                        }
                    ]);

                if (!error) {
                    reviewForm.reset();
                    showReviewSuccess(name, rating, service);
                } else {
                    showReviewError(error.message || 'Failed to submit your review. Please try again.');
                }

            } catch (err) {
                console.error(err);
                showReviewError('Something went wrong. Please check your connection and try again.');
            } finally {
                if (submitBtn) {
                    submitBtn.disabled = false;
                    submitBtn.textContent = 'Submit Your Review';
                }
            }
        });
    }
});