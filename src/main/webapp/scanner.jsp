<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Contrôle d'Accès</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        body { background-color: #1e0a3c; }
        .scanner-wrapper { display: flex; justify-content: center; align-items: center; min-height: 100vh; }
        .scanner-card { width: 100%; max-width: 500px; text-align: center; padding: 40px; }
        #qrInput { font-size: 24px; text-align: center; padding: 20px; margin-bottom: 20px; }
        #resultMessage { font-size: 28px; font-weight: 800; margin-top: 30px; padding: 20px; border-radius: 8px; }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <div class="logo">EventTix <span style="font-size: 14px; color: var(--text-dark);">| Contrôle</span></div>
            <nav>
                <a href="${pageContext.request.contextPath}/AuthController?action=logout" class="btn btn-outline">Déconnexion</a>
            </nav>
        </div>
    </header>
    <div class="container scanner-wrapper">
        <div class="card scanner-card">
            <h2 style="margin-top: 0; color: var(--text-dark);">Scanner de Billets</h2>
            <p style="color: var(--text-muted); margin-bottom: 30px;">Prêt à scanner le prochain participant.</p>

            <div class="form-group">
                <input type="text" id="qrInput" placeholder="Code du billet..." autofocus autocomplete="off">
            </div>
            <button id="btnScan" class="btn" style="width: 100%; font-size: 18px; padding: 15px;">Vérifier le Billet</button>
            <div id="resultMessage"></div>
        </div>
    </div>

    <!-- Pass dynamic context path to external JS -->
    <script>
        const APP_CONTEXT_PATH = '${pageContext.request.contextPath}';
        document.getElementById('btnScan').addEventListener('click', function() {

                const qrCodeValue = document.getElementById('qrInput').value;
                const resultDiv = document.getElementById('resultMessage');

                if (!qrCodeValue) {
                    return;
                }

                fetch(APP_CONTEXT_PATH + '/validation', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    credentials: 'same-origin',
                    body: 'qrCode=' + encodeURIComponent(qrCodeValue)
                })
                .then(function(response) {
                    if (!response.ok) {
                        throw new Error('HTTP ' + response.status);
                    }
                    return response.json();
                })
                .then(function(data) {
                    if (data.status === 'OK') {
                        resultDiv.style.color = 'green';
                        resultDiv.innerText = 'Accès validé.';
                    } else {
                        resultDiv.style.color = 'red';
                        resultDiv.innerText = 'Accès refusé : Billet invalide ou déjà consommé.';
                    }

                    document.getElementById('qrInput').value = '';
                    document.getElementById('qrInput').focus();
                })
                .catch(function(error) {
                    resultDiv.style.color = 'red';
                    resultDiv.innerText =
                        'Erreur de connexion au serveur. (error:' + error.message + ')';
                });

            });
    </script>
    <!-- <script src="${pageContext.request.contextPath}/js/scanner.js" defer></script> -->
</body>
</html>