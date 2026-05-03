<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Contrôle d'Accès</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { background-color: #1e0a3c; } /* Dark background for scanner mode */
        .scanner-wrapper {
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .scanner-card {
            width: 100%;
            max-width: 500px;
            text-align: center;
            padding: 40px;
        }
        #qrInput {
            font-size: 24px;
            text-align: center;
            padding: 20px;
            margin-bottom: 20px;
        }
        #resultMessage {
            font-size: 28px;
            font-weight: 800;
            margin-top: 30px;
            padding: 20px;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="container scanner-wrapper">
        <div class="card scanner-card">
            <h2 style="margin-top: 0; color: var(--text-dark);">Scanner de Billets</h2>
            <p style="color: var(--text-muted); margin-bottom: 30px;">Prêt à scanner le prochain participant.</p>

            <div class="form-group">
                <input type="text" id="qrInput" placeholder="Code du billet..." autofocus autocomplete="off">
            </div>

            <button id="btnScan" class="btn" style="width: 100%; font-size: 18px; padding: 15px;">Vérifier le Billet</button>

            <!-- Result text will be injected here by scanner.js -->
            <div id="resultMessage"></div>
        </div>
    </div>
    <script src="js/scanner.js"></script>
</body>
</html>