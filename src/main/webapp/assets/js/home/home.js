// JavaScript to toggle the profile dropdown menu
document.addEventListener('DOMContentLoaded', function() {
    const profileButton = document.getElementById('profileButton');

    // Toggle dropdown when profile button is clicked
    profileButton.addEventListener('click', function(event) {
        this.classList.toggle('active');
        event.stopPropagation();
    });

    // Close dropdown when clicking elsewhere on the page
    document.addEventListener('click', function(event) {
        if (!profileButton.contains(event.target)) {
            profileButton.classList.remove('active');
        }
    });
});