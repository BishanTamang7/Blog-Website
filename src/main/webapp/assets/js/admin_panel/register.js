// Basic form validation
const form = document.querySelector('.register-form');

form.addEventListener('submit', function(e) {
    e.preventDefault();

    let isValid = true;

    // Validate username
    const username = document.getElementById('username');
    if (username.value.trim().length < 5) {
        username.classList.add('error');
        isValid = false;
    } else {
        username.classList.remove('error');
    }

    // Validate email
    const email = document.getElementById('email');
    const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    if (!emailPattern.test(email.value)) {
        email.classList.add('error');
        isValid = false;
    } else {
        email.classList.remove('error');
    }

    // Validate password
    const password = document.getElementById('password');
    if (password.value.length < 8) {
        password.classList.add('error');
        isValid = false;
    } else {
        password.classList.remove('error');
    }

    // Validate password confirmation
    const confirmPassword = document.getElementById('confirmPassword');
    if (confirmPassword.value !== password.value) {
        confirmPassword.classList.add('error');
        isValid = false;
    } else {
        confirmPassword.classList.remove('error');
    }

    if (isValid) {
        // Form would be submitted here
        alert('Registration successful!');
        form.reset();
    }
});