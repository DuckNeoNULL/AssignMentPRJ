document.addEventListener('DOMContentLoaded', () => {
    // --- Mood Selector ---
    const moodIcons = document.querySelectorAll('.mood-icon');
    moodIcons.forEach(icon => {
        icon.addEventListener('click', () => {
            // Remove active class from all icons
            moodIcons.forEach(i => i.classList.remove('active'));
            // Add active class to the clicked icon
            icon.classList.add('active');
            // Optional: You can send this mood data to the server
            console.log(`Mood updated to: ${icon.dataset.mood}`);
        });
    });

    // --- Auto Logout Timer ---
    const timerDisplay = document.querySelector('#logout-timer strong');
    let timeLeft = 15 * 60; // 15 minutes in seconds

    const logoutInterval = setInterval(() => {
        timeLeft--;
        const minutes = Math.floor(timeLeft / 60);
        const seconds = timeLeft % 60;

        timerDisplay.textContent = `${minutes.toString().padStart(2, '0')}:${seconds.toString().padStart(2, '0')}`;

        if (timeLeft <= 0) {
            clearInterval(logoutInterval);
            // Redirect to logout page or show a modal
            alert("Time's up! You've been logged out.");
            window.location.href = '/logout'; // Adjust this URL
        }
    }, 1000);
    
    // --- Smooth Scrolling for Nav Links ---
    const navLinks = document.querySelectorAll('.nav-link');
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            e.preventDefault();
            document.querySelector(this.getAttribute('href')).scrollIntoView({
                behavior: 'smooth'
            });
            // Update active state
            navLinks.forEach(l => l.classList.remove('active'));
            this.classList.add('active');
        });
    });

}); 