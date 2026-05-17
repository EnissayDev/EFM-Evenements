<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Votre Billet - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <script src="https://cdnjs.cloudflare.com/ajax/libs/qrcodejs/1.0.0/qrcode.min.js"></script>

    <style>
        .ticket-wrapper { display: flex; justify-content: center; margin-top: 40px; }
        .ticket {
            background: var(--white);
            border: 2px dashed var(--border-color);
            border-radius: 12px;
            padding: 30px;
            max-width: 400px;
            width: 100%;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .qr-container {
            display: flex;
            justify-content: center;
            margin: 20px 0;
            padding: 20px;
            background: var(--white);
        }
    </style>
</head>
<body>
    <jsp:include page="/nav.jsp" />

    <div class="container ticket-wrapper">
        <div class="ticket">
            <h2 style="color: var(--primary-orange); margin-top: 0;">Billet Confirmé !</h2>
            <p><strong>Événement :</strong> ${billet.evenementTitre}</p>
            <p><strong>Lieu :</strong> ${billet.lieu}</p>
            <p><strong>Date :</strong> ${billet.date}</p>
            <p><strong>Participant :</strong> ${sessionScope.user.prenom} ${sessionScope.user.nom}</p>

            <hr style="border: none; border-top: 1px dashed #ccc; margin: 20px 0;">

            <p style="font-size: 14px; color: var(--text-muted);">Présentez ce QR Code à l'entrée</p>

            <div id="qrcode" class="qr-container"></div>

            <p style="font-family: monospace; font-size: 16px; font-weight: bold; letter-spacing: 2px;">
                ${billet.codeSecret}
            </p>

            <button onclick="window.print()" class="btn btn-outline" style="width: 100%; margin-top: 15px;">Imprimer le billet</button>
        </div>
    </div>

    <script>
        // Dès que la page charge, on génère le QR Code
        document.addEventListener("DOMContentLoaded", function() {
            // On récupère le code généré par le backend (ex: "TICKET-12345-XYZ")
            // S'il est vide (test local), on met un code par défaut
            var codeBillet = "${billet.codeSecret}";
            if (!codeBillet) {
                codeBillet = "CODE-TEST-123";
            }

            // Génération magique du QR Code
            new QRCode(document.getElementById("qrcode"), {
                text: codeBillet,
                width: 200,
                height: 200,
                colorDark : "#1e0a3c", // La couleur bleue foncée de votre charte graphique
                colorLight : "#ffffff",
                correctLevel : QRCode.CorrectLevel.H
            });
        });
    </script>
</body>
</html>