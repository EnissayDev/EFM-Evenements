// Fonction utilitaire de Debouncing
function debounce(func, wait) {
    let timeout;
    return function(...args) {
        clearTimeout(timeout);
        timeout = setTimeout(() => func.apply(this, args), wait);
    };
}

document.addEventListener('DOMContentLoaded', () => {
    console.log("EventTix Frontend Loaded.");

    // --- LOGIQUE DE DEBOUNCING POUR LA RECHERCHE ---
    // Sélectionne toutes les barres de recherche ayant la classe 'live-search'
    const searchInputs = document.querySelectorAll('.live-search');

    searchInputs.forEach(input => {
        input.addEventListener('input', debounce(function() {
            // Dès que l'utilisateur arrête de taper pendant 800ms, on soumet le formulaire
            this.closest('form').submit();
        }, 800)); // 800 millisecondes (ajustable)
    });

    // --- PRÉVENTION DES DOUBLONS DE SOUMISSION ---
    const allForms = document.querySelectorAll('form:not(.filter-bar)'); // On exclut les barres de filtres
    allForms.forEach(form => {
        form.addEventListener('submit', function(e) {
            const submitBtn = form.querySelector('button[type="submit"]');
            if (submitBtn) {
                submitBtn.disabled = true;
                const originalText = submitBtn.innerText;
                submitBtn.innerText = 'Traitement en cours...';
                setTimeout(() => {
                    submitBtn.disabled = false;
                    submitBtn.innerText = originalText;
                }, 3000);
            }
        });
    });
});