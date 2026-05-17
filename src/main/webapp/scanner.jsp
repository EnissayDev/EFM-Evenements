<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Contrôle d'Accès - EventTix</title>
    <script src="https://unpkg.com/html5-qrcode@2.3.8/html5-qrcode.min.js" type="text/javascript"></script>
</head>
<body class="flex min-h-screen flex-col text-gray-900 bg-gray-50">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 flex items-center justify-center p-5 py-12">
        <div class="w-full max-w-lg bg-white border border-gray-200 rounded-xl p-6 sm:p-10 shadow-sm">

            <h1 class="font-bold text-3xl text-gray-950 mb-2 text-center">Scanner de Billets</h1>
            <p class="text-gray-500 font-medium text-center mb-8">Vérifiez la validité des billets à l'entrée.</p>

            <div class="flex gap-2 mb-6 bg-gray-50 p-1 rounded-lg border border-gray-200">
                <button id="btnCameraMode" class="flex-1 h-10 rounded-md font-bold text-sm transition-colors text-white bg-gray-900 shadow-sm">Caméra</button>
                <button id="btnManualMode" class="flex-1 h-10 rounded-md font-bold text-sm transition-colors text-gray-500 hover:text-gray-900">Saisie Manuelle</button>
            </div>

            <div id="cameraSection">
                <div id="reader" class="w-full rounded-lg overflow-hidden border border-gray-200"></div>
                <div id="cameraError" class="hidden mt-4 p-4 rounded-lg bg-red-50 border border-red-200 text-red-700 text-sm font-semibold text-center"></div>
                <p class="text-center text-sm text-gray-400 font-medium mt-3">Placez le QR Code dans le cadre.</p>

                <div class="flex items-center gap-3 my-5">
                    <div class="flex-1 h-px bg-gray-200"></div>
                    <span class="text-xs font-semibold text-gray-400 uppercase tracking-wide">ou</span>
                    <div class="flex-1 h-px bg-gray-200"></div>
                </div>

                <label for="photoInput" class="w-full h-12 inline-flex items-center justify-center gap-2 rounded-full font-bold text-sm uppercase tracking-wide text-gray-700 bg-gray-100 hover:bg-gray-200 border border-gray-200 transition-colors cursor-pointer">
                    Scanner depuis une photo
                </label>
                <input type="file" id="photoInput" accept="image/*" class="hidden">
            </div>

            <div id="manualSection" class="hidden flex-col gap-4">
                <label class="block text-sm font-bold text-gray-700 uppercase tracking-wide">Code du Billet</label>
                <input type="text" id="qrInput" placeholder="Saisir ou flasher le code..." autocomplete="off"
                       class="w-full h-14 bg-gray-50 text-gray-900 text-center font-bold text-xl border border-gray-200 focus:border-gray-900 rounded-lg px-4 outline-none focus:ring-1 focus:ring-gray-900 transition-colors">
                <button id="btnScanManual" class="w-full h-14 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide text-white bg-gray-900 hover:bg-gray-700 transition-colors">
                    Vérifier le Billet
                </button>
            </div>

            <div id="resultMessage" class="hidden mt-6 p-6 rounded-xl text-center border"></div>

            <button id="btnNext" class="hidden w-full h-14 mt-4 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide text-gray-700 bg-gray-100 hover:bg-gray-200 border border-gray-200 transition-colors">
                Scanner le billet suivant
            </button>

        </div>
    </main>

    <script>
        const CTX = '${pageContext.request.contextPath}';

        const TAB_ACTIVE   = 'flex-1 h-10 rounded-md font-bold text-sm transition-colors text-white bg-gray-900 shadow-sm';
        const TAB_INACTIVE = 'flex-1 h-10 rounded-md font-bold text-sm transition-colors text-gray-500 hover:text-gray-900';

        const cameraSection = document.getElementById('cameraSection');
        const manualSection = document.getElementById('manualSection');
        const resultDiv     = document.getElementById('resultMessage');
        const btnNext       = document.getElementById('btnNext');
        const btnCameraMode = document.getElementById('btnCameraMode');
        const btnManualMode = document.getElementById('btnManualMode');
        const cameraError   = document.getElementById('cameraError');
        const qrInput       = document.getElementById('qrInput');

        let html5QrCode     = null;
        let cameraRunning   = false;
        let processing      = false;
        let currentMode     = 'camera';
        let lastCode        = null;
        let lastCodeTime    = 0;

        function showSection(section) {
            cameraSection.style.display  = section === 'camera' ? 'block' : 'none';
            manualSection.style.display  = section === 'manual' ? 'flex'  : 'none';
            resultDiv.style.display      = 'none';
            btnNext.style.display        = 'none';
        }

        function switchMode(mode) {
            currentMode = mode;
            btnCameraMode.className = mode === 'camera' ? TAB_ACTIVE : TAB_INACTIVE;
            btnManualMode.className = mode === 'manual' ? TAB_ACTIVE : TAB_INACTIVE;

            if (mode === 'camera') {
                showSection('camera');
                startCamera();
            } else {
                stopCamera();
                showSection('manual');
                qrInput.focus();
            }
        }

        function startCamera() {
            cameraError.style.display = 'none';

            if (cameraRunning) return;

            if (!html5QrCode) {
                html5QrCode = new Html5Qrcode('reader');
            }

            Html5Qrcode.getCameras()
                .then(function(cameras) {
                    if (!cameras || cameras.length === 0) {
                        showCameraError('Aucune caméra détectée sur cet appareil.');
                        return;
                    }
                    // prefer back camera (last in list on mobile)
                    const cam = cameras.find(function(c) {
                        return /back|rear|environment/i.test(c.label);
                    }) || cameras[cameras.length - 1];

                    return html5QrCode.start(
                        cam.id,
                        { fps: 10, qrbox: { width: 240, height: 240 } },
                        function(decodedText) {
                            const now = Date.now();
                            if (decodedText === lastCode && now - lastCodeTime < 4000) return;
                            lastCode     = decodedText;
                            lastCodeTime = now;
                            validateTicket(decodedText);
                        },
                        function() { /* frame errors ignored */ }
                    ).then(function() {
                        cameraRunning = true;
                    });
                })
                .catch(function() {
                    showCameraError('Accès à la caméra refusé. Vérifiez les permissions du navigateur.');
                });
        }

        function stopCamera() {
            if (html5QrCode && cameraRunning) {
                html5QrCode.stop().catch(function() {}).finally(function() {
                    cameraRunning = false;
                });
            }
        }

        function showCameraError(msg) {
            cameraError.textContent    = msg;
            cameraError.style.display  = 'block';
        }

        function validateTicket(code) {
            if (processing) return;
            processing = true;

            stopCamera();
            cameraSection.style.display = 'none';
            manualSection.style.display = 'none';

            fetch(CTX + '/validation', {
                method: 'POST',
                headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                credentials: 'same-origin',
                body: 'qrCode=' + encodeURIComponent(code)
            })
            .then(function(r) {
                if (!r.ok) throw new Error('HTTP ' + r.status);
                return r.json();
            })
            .then(function(data) {
                qrInput.value = '';
                if (data.status === 'OK') {
                    resultDiv.className = 'mt-6 p-6 rounded-xl text-center border bg-green-50 border-green-200 text-green-700';
                    resultDiv.innerHTML =
                        '<div class="text-5xl mb-4">✓</div>' +
                        '<div class="text-2xl font-black mb-2">ACCÈS VALIDÉ</div>' +
                        '<div class="font-semibold text-base">Place : <span class="uppercase">' + (data.typePlace || 'Standard') + '</span></div>';
                } else {
                    resultDiv.className = 'mt-6 p-6 rounded-xl text-center border bg-red-50 border-red-200 text-red-700';
                    resultDiv.innerHTML =
                        '<div class="text-5xl mb-4">❌</div>' +
                        '<div class="text-2xl font-black mb-2">ACCÈS REFUSÉ</div>' +
                        '<div class="font-semibold text-base">Billet invalide ou déjà utilisé.</div>';
                }
            })
            .catch(function() {
                resultDiv.className = 'mt-6 p-6 rounded-xl text-center border bg-yellow-50 border-yellow-200 text-yellow-700';
                resultDiv.innerHTML =
                    '<div class="text-5xl mb-4">⚠️</div>' +
                    '<div class="text-2xl font-black mb-2">ERREUR RÉSEAU</div>' +
                    '<div class="font-semibold text-base">Impossible de contacter le serveur.</div>';
            })
            .finally(function() {
                processing              = false;
                resultDiv.style.display = 'block';
                btnNext.style.display   = 'flex';
            });
        }

        document.getElementById('btnScanManual').addEventListener('click', function() {
            var code = qrInput.value.trim();
            if (code) validateTicket(code);
        });

        qrInput.addEventListener('keydown', function(e) {
            if (e.key === 'Enter') {
                e.preventDefault();
                var code = qrInput.value.trim();
                if (code) validateTicket(code);
            }
        });

        btnNext.addEventListener('click', function() {
            switchMode(currentMode);
        });

        btnCameraMode.addEventListener('click', function() { switchMode('camera'); });
        btnManualMode.addEventListener('click', function() { switchMode('manual'); });

        document.getElementById('photoInput').addEventListener('change', function(e) {
            var file = e.target.files[0];
            e.target.value = '';
            if (!file) return;

            if (!html5QrCode) {
                html5QrCode = new Html5Qrcode('reader');
            }

            var doScan = function() {
                html5QrCode.scanFile(file, true)
                    .then(function(decodedText) {
                        validateTicket(decodedText);
                    })
                    .catch(function() {
                        showCameraError('Impossible de lire le QR Code dans cette image.');
                    });
            };

            if (cameraRunning) {
                html5QrCode.stop()
                    .catch(function() {})
                    .finally(function() {
                        cameraRunning = false;
                        doScan();
                    });
            } else {
                doScan();
            }
        });

        // start camera on load
        switchMode('camera');
    </script>
</body>
</html>
