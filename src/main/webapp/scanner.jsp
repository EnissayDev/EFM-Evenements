<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Scanner de Billets</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="card">
            <h2>Contrôle d'accès</h2>
            <div class="form-group">
                <input type="text" id="qrInput" placeholder="Scanner ou entrer le code du billet" autofocus>
            </div>
            <button id="btnScan" class="btn">Valider l'accès</button>
            <div id="resultMessage" style="margin-top: 20px; font-weight: bold;"></div>
        </div>
    </div>
    <script src="js/scanner.js"></script>
</body>
</html>