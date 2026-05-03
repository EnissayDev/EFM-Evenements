<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Paiement</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <div class="container">
        <div class="card" style="max-width: 500px; margin: 50px auto;">
            <h2>Finaliser l'achat</h2>
            <p>Montant total: ${montant} MAD</p>
            <form action="CommandeController" method="POST">
                <input type="hidden" name="idEvenement" value="${idEvenement}">
                <input type="hidden" name="place" value="${placeChoisie}">
                <div class="form-group">
                    <label for="cardNumber">Numéro de carte</label>
                    <input type="text" id="cardNumber" name="cardNumber" required>
                </div>
                <div class="form-group">
                    <label for="expiry">Date d'expiration</label>
                    <input type="text" id="expiry" name="expiry" placeholder="MM/YY" required>
                </div>
                <div class="form-group">
                    <label for="cvv">CVV</label>
                    <input type="text" id="cvv" name="cvv" required>
                </div>
                <button type="submit" class="btn">Payer et Générer le billet</button>
            </form>
            <p style="color:red;">${erreurPaiement}</p>
        </div>
    </div>
</body>
</html>