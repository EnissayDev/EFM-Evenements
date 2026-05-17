<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Contrôle d'Accès - EventTix</title>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
</head>
<body class="flex min-h-screen flex-col text-gray-900 bg-gray-50">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 flex items-center justify-center p-5 py-12">
        <div class="w-full max-w-lg bg-white border border-gray-200 rounded-xl p-6 sm:p-10 shadow-sm">
            <h1 class="font-bold text-3xl text-gray-950 mb-2 text-center">Scanner de Billets</h1>
            <p class="text-gray-500 font-medium text-center mb-8">Vérifiez la validité des billets à l'entrée.</p>

            <div class="flex gap-2 mb-6 bg-gray-50 p-1 rounded-lg border border-gray-200">
                <button id="btnCameraMode" class="flex-1 h-10 rounded-md font-bold text-sm transition-colors text-white bg-gray-900 shadow-sm">📹 Caméra</button>
                <button id="btnManualMode" class="flex-1 h-10 rounded-md font-bold text-sm transition-colors text-gray-600 hover:text-gray-900 bg-transparent">⌨️ Saisie Manuelle</button>
            </div>

            <div id="cameraSection" class="w-full">
                <div id="reader" class="w-full rounded-lg overflow-hidden border border-gray-200 bg-black"></div>
                <p class="text-center text-sm text-gray-500 font-medium mt-4">Placez le QR Code dans le cadre.</p>
            </div>

            <div id="manualSection" class="hidden w-full flex-col gap-4">
                <div>
                    <label for="qrInput" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Code du Billet</label>
                    <input type="text" id="qrInput" placeholder="Saisir ou flasher le code..." autocomplete="off"
                           class="w-full h-14 bg-gray-50 text-gray-900 text-center font-bold text-xl border border-gray-200 focus:border-primary-500 rounded-lg px-4 outline-none focus:ring-1 focus:ring-primary-500 transition-colors">
                </div>
                <button id="btnScanManual" class="w-full h-14 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide text-white bg-primary-500 hover:bg-primary-300 transition-colors">
                    Vérifier le Billet
                </button>
            </div>

            <div id="resultMessage" class="hidden mt-6 p-6 rounded-lg text-center font-bold text-xl border"></div>

            <button id="btnNext" class="hidden w-full h-14 mt-6 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide text-gray-900 bg-gray-100 hover:bg-gray-200 border border-gray-200 transition-colors">
                Scanner le billet suivant
            </button>
        </div>
    </main>

    <script>
        const APP_CONTEXT_PATH = '${pageContext.request.contextPath}';

        document.addEventListener('DOMContentLoaded', function() {
            const cameraSection = document.getElementById('cameraSection');
            const manualSection = document.getElementById('manualSection');
            const resultDiv = document.getElementById('resultMessage');
            const btnNext = document.getElementById('btnNext');
            const btnCameraMode = document.getElementById('btnCameraMode');
            const btnManualMode = document.getElementById('btnManualMode');

            let html5QrcodeScanner = null;
            let isProcessing = false;

            // Classes Tailwind pour les onglets Actif/Inactif
            const activeTabClasses = "flex-1 h-10 rounded-md font-bold text-sm transition-colors text-white bg-gray-900 shadow-sm";
            const inactiveTabClasses = "flex-1 h-10 rounded-md font-bold text-sm transition-colors text-gray-600 hover:text-gray-900 bg-transparent";

            // --- Basculer sur la Caméra ---
            btnCameraMode.addEventListener('click', function() {
                manualSection.style.display = 'none';
                cameraSection.style.display = 'block';
                this.className = activeTabClasses;
                btnManualMode.className = inactiveTabClasses;
                startCamera();
            });

            // --- Basculer sur la saisie manuelle ---
            btnManualMode.addEventListener('click', function() {
                cameraSection.style.display = 'none';
                manualSection.style.display = 'flex';
                this.className = activeTabClasses;
                btnCameraMode.className = inactiveTabClasses;
                stopCamera();
                document.getElementById('qrInput').focus();
            });

            // --- Fonction Principale de Validation ---
            function validateTicket(code) {
                if (isProcessing) return;
                isProcessing = true;

                // Mettre en pause la caméra pendant le traitement
                try {
                    if (html5QrcodeScanner) html5QrcodeScanner.pause();
                } catch (e) { /* ignore */ }

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
                    cameraSection.style.display = 'none';
                    manualSection.style.display = 'none';
                    resultDiv.style.display = 'block';
                    btnNext.style.display = 'flex';

                    if (data.status === 'OK') {
                        // Couleurs Tailwind Vertes
                        resultDiv.className = "mt-6 p-6 rounded-lg text-center border bg-[#dcfce7] border-[#86efac] text-[#15803d]";
                        resultDiv.innerHTML = '✅ ACCÈS VALIDÉ<br><span class="block mt-2 text-base font-semibold">Type de place : <span class="uppercase">' + (data.typePlace || 'Standard') + '</span></span>';
                    } else {
                        // Couleurs Tailwind Rouges
                        resultDiv.className = "mt-6 p-6 rounded-lg text-center border bg-[#fee2e2] border-[#fca5a5] text-[#b91c1c]";
                        resultDiv.innerHTML = '❌ ACCÈS REFUSÉ<br><span class="block mt-2 text-base font-semibold">Billet invalide ou déjà scanné.</span>';
                    }
                    document.getElementById('qrInput').value = '';
                    isProcessing = false;
                })
                .catch(function(error) {
                    cameraSection.style.display = 'none';
                    manualSection.style.display = 'none';
                    resultDiv.style.display = 'block';
                    btnNext.style.display = 'flex';

                    // Couleurs Tailwind Jaunes/Oranges
                    resultDiv.className = "mt-6 p-6 rounded-lg text-center border bg-[#fef3c7] border-[#fde047] text-[#a16207]";
                    resultDiv.innerHTML = '⚠️ ERREUR RÉSEAU<br><span class="block mt-2 text-base font-semibold">Impossible de contacter le serveur.</span>';
                    isProcessing = false;
                });
            }

            // --- Configuration de la Caméra ---
            function startCamera() {
                if (!html5QrcodeScanner) {
                    html5QrcodeScanner = new Html5QrcodeScanner("reader", { fps: 10, qrbox: {width: 250, height: 250} }, false);
                    html5QrcodeScanner.render((decodedText, decodedResult) => {
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

                // Vérifier quel mode est actif en regardant les classes du bouton Caméra
                if (btnCameraMode.className.includes('bg-gray-900')) {
                    cameraSection.style.display = 'block';
                    html5QrcodeScanner.resume();
                } else {
                    manualSection.style.display = 'flex';
                    document.getElementById('qrInput').focus();
                }
            });

            // Démarrer la caméra par défaut au chargement
            startCamera();
        });
    </script>
</body>
</html>