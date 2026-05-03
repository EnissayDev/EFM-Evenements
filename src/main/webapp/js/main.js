// main.js - Global frontend interactions

document.addEventListener('DOMContentLoaded', () => {
    console.log("EventTix Frontend Loaded Successfully.");

    // Example: Prevent double-submission on all forms to avoid duplicate payments/database entries
    const allForms = document.querySelectorAll('form');

    allForms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                // Briefly disable the button and change text to show processing
                submitBtn.disabled = true;
                const originalText = submitBtn.innerText;
                submitBtn.innerText = 'Traitement en cours...';

                // Re-enable after 3 seconds in case the page doesn't redirect immediately
                setTimeout(() => {
                    submitBtn.disabled = false;
                    submitBtn.innerText = originalText;
                }, 3000);
            }
        });
    });
});