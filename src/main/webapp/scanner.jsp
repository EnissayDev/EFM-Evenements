<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Contrôle d'Accès</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>

    <style>
        body { background-color: #1e0a3c; }
        .scanner-wrapper { display: flex; justify-content: center; align-items: center; min-height: 100vh; padding: 20px;}
        .scanner-card { width: 100%; max-width: 600px; text-align: center; padding: 30px; }

        #reader { width: 100%; border-radius: 8px; overflow: hidden; margin-bottom: 20px; background-color: #000; }
        #qrInput { font-size: 20px; text-align: center; padding: 15px; margin-bottom: 15px; width: 100%; box-sizing: border-box; }

        #resultMessage { font-size: 22px; font-weight: 800; margin-top: 20px; padding: 20px; border-radius: 8px; display: none; }
        .mode-switch { display: flex; justify-content: center; gap: 10px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <jsp:include page="/nav.jsp" />

    <div class="container scanner-wrapper">
        <div class="card scanner-card">
            <h2 style="margin-top: 0; color: var(--text-dark);">Scanner de Billets</h2>

            <div class="mode-switch">
                <button id="btnCameraMode" class="btn">📹 Utiliser la Caméra</button>
                <button id="btnManualMode" class="btn btn-outline">⌨️ Saisie Manuelle</button>
            </div>

            <div id="cameraSection">
                <div id="reader"></div>
                <p style="color: var(--text-muted); font-size: 14px;">Placez le QR Code dans le cadre.</p>
            </div>

            <div id="manualSection" style="display: none;">
                <div class="form-group">
                    <input type="text" id="qrInput" placeholder="Code du billet..." autocomplete="off">
                </div>
                <button id="btnScanManual" class="btn" style="width: 100%; font-size: 18px; padding: 15px;">Vérifier le Billet</button>
            </div>

            <div id="resultMessage"></div>
            <button id="btnNext" class="btn btn-outline" style="width: 100%; margin-top: 20px; display: none;">Scanner le billet suivant</button>
        </div>
    </div>

    <script>
        const APP_CONTEXT_PATH = '${pageContext.request.contextPath}';

        document.addEventListener('DOMContentLoaded', function() {
            const cameraSection = document.getElementById('cameraSection');
            const manualSection = document.getElementById('manualSection');
            const resultDiv = document.getElementById('resultMessage');
            const btnNext = document.getElementById('btnNext');

            let html5QrcodeScanner = null;
            let isProcessing = false;

            // --- Basculer sur la Caméra ---
            document.getElementById('btnCameraMode').addEventListener('click', function() {
                manualSection.style.display = 'none';
                cameraSection.style.display = 'block';
                this.className = 'btn';
                document.getElementById('btnManualMode').className = 'btn btn-outline';
                startCamera();
            });

            // --- Basculer sur la saisie manuelle ---
            document.getElementById('btnManualMode').addEventListener('click', function() {
                cameraSection.style.display = 'none';
                manualSection.style.display = 'block';
                this.className = 'btn';
                document.getElementById('btnCameraMode').className = 'btn btn-outline';
                stopCamera();
                document.getElementById('qrInput').focus();
            });

            // --- Fonction Principale de Validation (Votre fetch mis à jour) ---
            function validateTicket(code) {
                if (isProcessing) return;
                isProcessing = true;

                // Mettre en pause la caméra pendant le traitement
                try {
                    if (html5QrcodeScanner) html5QrcodeScanner.pause();
                } catch (e) { /* already paused — safe to ignore */ }

                // Utilisation de votre endpoint exact /validation et credentials
                fetch(APP_CONTEXT_PATH + '/validation', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    credentials: 'same-origin',
                    body: 'qrCode=' + encodeURIComponent(code)
                })
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    // Cacher les interfaces de scan et afficher le résultat
                    cameraSection.style.display = 'none';
                    manualSection.style.display = 'none';
                    resultDiv.style.display = 'block';
                    btnNext.style.display = 'block';

                    if (data.status === 'OK') {
                        resultDiv.style.backgroundColor = '#dcfce7';
                        resultDiv.style.color = '#15803d';
                        resultDiv.innerHTML = '✅ ACCÈS VALIDÉ<br><span style="font-size:16px;font-weight:normal;">' + (data.typePlace ? 'Type: ' + data.typePlace : '') + '</span>';
                    } else {
                        resultDiv.style.backgroundColor = '#fee2e2';
                        resultDiv.style.color = '#b91c1c';
                        resultDiv.innerHTML = '❌ ACCÈS REFUSÉ<br><span style="font-size:16px;font-weight:normal;">Billet invalide ou déjà consommé.</span>';
                    }
                    document.getElementById('qrInput').value = '';
                    isProcessing = false;
                })
                .catch(function(error) {
                    cameraSection.style.display = 'none';
                    manualSection.style.display = 'none';
                    resultDiv.style.display = 'block';
                    btnNext.style.display = 'block';

                    resultDiv.style.backgroundColor = '#fef08a';
                    resultDiv.style.color = '#a16207';
                    resultDiv.innerHTML = '⚠️ ERREUR<br><span style="font-size:16px;font-weight:normal;">Connexion au serveur (error:' + error.message + ')</span>';
                    isProcessing = false;
                });
            }

            // --- Configuration de la Caméra ---
            function startCamera() {
                if (!html5QrcodeScanner) {
                    // Initialise le scanner sur la div #reader
                    html5QrcodeScanner = new Html5QrcodeScanner("reader", { fps: 10, qrbox: {width: 250, height: 250} }, false);
                    html5QrcodeScanner.render((decodedText, decodedResult) => {
                        // Quand un QR Code est détecté
                        validateTicket(decodedText);
                    }, (error) => {
                        // Ignore en silence les frames vides
                    });
                } else {
                    html5QrcodeScanner.resume();
                }
            }

            function stopCamera() {
                if (html5QrcodeScanner) { html5QrcodeScanner.pause(); }
            }

            // --- Déclenchement Manuel ---
            document.getElementById('btnScanManual').addEventListener('click', function() {
                const qrCodeValue = document.getElementById('qrInput').value;
                if (qrCodeValue) validateTicket(qrCodeValue);
            });

            // Permet de valider avec la touche "Entrée"
            document.getElementById('qrInput').addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    document.getElementById('btnScanManual').click();
                }
            });

            // --- Bouton "Scanner le billet suivant" ---
            btnNext.addEventListener('click', function() {
                isProcessing = false;
                resultDiv.style.display = 'none';
                btnNext.style.display = 'none';

                // Si le mode caméra est actif, on relance la vidéo, sinon on remet l'input
                if (document.getElementById('btnCameraMode').className === 'btn') {
                    cameraSection.style.display = 'block';
                    html5QrcodeScanner.resume();
                } else {
                    manualSection.style.display = 'block';
                    document.getElementById('qrInput').focus();
                }
            });

            // Démarrer la caméra par défaut au chargement de la page
            startCamera();
        });
    </script>
</body>
</html>