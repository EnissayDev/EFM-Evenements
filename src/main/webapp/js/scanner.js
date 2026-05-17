document.addEventListener('DOMContentLoaded', function() {

    const cameraSection = document.getElementById('cameraSection');
    const manualSection = document.getElementById('manualSection');
    const resultDiv = document.getElementById('resultMessage');
    const btnNext = document.getElementById('btnNext');
    let html5QrcodeScanner = null;
    let isProcessing = false; // Empêche de scanner 10 fois la même image à la seconde

    // --- GESTION DES ONGLETS (CAMÉRA VS MANUEL) ---
    document.getElementById('btnCameraMode').addEventListener('click', function() {
        manualSection.style.display = 'none';
        cameraSection.style.display = 'block';
        this.className = 'btn';
        document.getElementById('btnManualMode').className = 'btn btn-outline';
        startCamera();
    });

    document.getElementById('btnManualMode').addEventListener('click', function() {
        cameraSection.style.display = 'none';
        manualSection.style.display = 'block';
        this.className = 'btn';
        document.getElementById('btnCameraMode').className = 'btn btn-outline';
        stopCamera();
    });

    // --- FONCTION CENTRALE QUI CONTACTE LE BACKEND ---
    function validateTicket(code) {
        if (isProcessing) return; // Si on traite déjà un scan, on ignore
        isProcessing = true;

        // Optionnel : un petit son de "bip" pour confirmer le scan
        // let audio = new Audio(APP_CONTEXT_PATH + '/sounds/beep.mp3'); audio.play();

        // Si on utilise la caméra, on la met en pause le temps d'afficher le résultat
        if (html5QrcodeScanner) {
            html5QrcodeScanner.pause();
        }

        fetch(APP_CONTEXT_PATH + '/ValidationController', {
            method: 'POST',
            headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
            body: 'qrCode=' + encodeURIComponent(code)
        })
        .then(response => response.json())
        .then(data => {
            resultDiv.style.display = 'block';
            btnNext.style.display = 'block';
            cameraSection.style.display = 'none';
            manualSection.style.display = 'none';

            if (data.status === 'OK') {
                resultDiv.style.backgroundColor = '#dcfce7'; // Vert clair
                resultDiv.style.color = '#15803d'; // Vert foncé
                resultDiv.innerHTML = '✅ ACCÈS VALIDÉ<br><span style="font-size:16px;font-weight:normal;">Type: ' + (data.typePlace || 'Inconnu') + '</span>';
            } else {
                resultDiv.style.backgroundColor = '#fee2e2'; // Rouge clair
                resultDiv.style.color = '#b91c1c'; // Rouge foncé
                resultDiv.innerHTML = '❌ ACCÈS REFUSÉ<br><span style="font-size:16px;font-weight:normal;">Billet invalide ou déjà consommé.</span>';
            }
        })
        .catch(error => {
            resultDiv.style.display = 'block';
            resultDiv.style.backgroundColor = '#fef08a'; // Jaune
            resultDiv.style.color = '#a16207';
            resultDiv.innerHTML = '⚠️ ERREUR RÉSEAU<br><span style="font-size:16px;font-weight:normal;">Impossible de contacter le serveur.</span>';
            isProcessing = false;
        });
    }

    // --- GESTION DE LA CAMÉRA ---
    function startCamera() {
        if (!html5QrcodeScanner) {
            html5QrcodeScanner = new Html5QrcodeScanner("reader", { fps: 10, qrbox: {width: 250, height: 250} }, false);
            html5QrcodeScanner.render((decodedText, decodedResult) => {
                // Callback quand la caméra trouve un QR Code
                validateTicket(decodedText);
            }, (error) => {
                // Ignorer les erreurs de frame vide
            });
        } else {
            html5QrcodeScanner.resume();
        }
    }

    function stopCamera() {
        if (html5QrcodeScanner) { html5QrcodeScanner.pause(); }
    }

    // --- GESTION DU MODE MANUEL ---
    document.getElementById('btnScanManual').addEventListener('click', function() {
        const qrCodeValue = document.getElementById('qrInput').value;
        if (qrCodeValue) validateTicket(qrCodeValue);
    });

    // --- BOUTON SUIVANT (RESET) ---
    btnNext.addEventListener('click', function() {
        isProcessing = false;
        resultDiv.style.display = 'none';
        btnNext.style.display = 'none';
        document.getElementById('qrInput').value = '';

        // Restaurer l'interface selon le mode actif
        if (document.getElementById('btnCameraMode').className === 'btn') {
            cameraSection.style.display = 'block';
            html5QrcodeScanner.resume();
        } else {
            manualSection.style.display = 'block';
            document.getElementById('qrInput').focus();
        }
    });

    // Démarrer la caméra automatiquement au chargement
    startCamera();
});