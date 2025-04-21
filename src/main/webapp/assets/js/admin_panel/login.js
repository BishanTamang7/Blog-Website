// Basic form validation
const form = document.querySelector('.login-form');

form.addEventListener('submit', function(e) {
    e.preventDefault();

    let isValid = true;

    // Validate username/email
    const username = document.getElementById('username');
    if (username.value.trim() === '') {
        username.classList.add('error');
        isValid = false;
    } else {
        username.classList.remove('error');
    }

    // Validate password
    const password = document.getElementById('password');
    if (password.value === '') {
        password.classList.add('error');
        isValid = false;
    } else {
        password.classList.remove('error');
    }

    if (isValid) {
        // Form would be submitted here
        alert('Login successful!');
    }
});