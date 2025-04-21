// Get the user avatar and dropdown elements
const userAvatar = document.querySelector('.user-avatar');
const userDropdown = document.getElementById('userDropdown');

// Toggle dropdown when clicking on the avatar
userAvatar.addEventListener('click', function(event) {
    event.stopPropagation();
    if (userDropdown.style.display === 'none' || userDropdown.style.display === '') {
        userDropdown.style.display = 'block';
    } else {
        userDropdown.style.display = 'none';
    }
});

// Close dropdown when clicking elsewhere on the page
document.addEventListener('click', function(event) {
    if (!userAvatar.contains(event.target) && !userDropdown.contains(event.target)) {
        userDropdown.style.display = 'none';
    }
});