document.addEventListener('DOMContentLoaded', function() {
    // Get the modal
    const modal = document.getElementById('loginModal');

    // Get the button that opens the modal
    const writeLink = document.querySelector('.write-link');
    const startReadingBtn = document.querySelector('.start-reading-btn');

    // Get the <span> element that closes the modal
    const closeBtn = document.querySelector('.close');

    // When the user clicks on the button, open the modal
    writeLink.addEventListener('click', function(e) {
        e.preventDefault();
        modal.style.display = "block";
    });

    startReadingBtn.addEventListener('click', function(e) {
        e.preventDefault();
        modal.style.display = "block";
    });

    // When the user clicks on <span> (x), close the modal
    closeBtn.addEventListener('click', function() {
        modal.style.display = "none";
    });

    // When the user clicks anywhere outside of the modal, close it
    window.addEventListener('click', function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    });
});