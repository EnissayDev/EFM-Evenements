<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Paiement - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .checkout-wrapper { max-width: 600px; margin: 60px auto; }
        .order-summary { background: var(--bg-light); padding: 20px; border-radius: 8px; margin-bottom: 30px; border: 1px solid var(--border-color); }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="${pageContext.request.contextPath}/catalogue" class="logo">EventTix</a>
            <nav>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Déconnexion</a>
            </nav>
        </div>
    </header>

    <div class="container checkout-wrapper">
        <h1 style="text-align: center; margin-bottom: 40px;">Paiement Sécurisé</h1>
        <div class="order-summary">
            <h3 style="margin-top: 0;">Résumé de la commande</h3>
            <div style="display: flex; justify-content: space-between; font-size: 18px; font-weight: 700;">
                <span>Total à payer</span>
                <span>${montant} MAD</span>
            </div>
        </div>
        <div class="card">
            <form action="${pageContext.request.contextPath}/commandes" method="POST">
                <input type="hidden" name="idEvenement" value="${idEvenement}">
                <input type="hidden" name="place" value="${placeChoisie}">
                <input type="hidden" name="quantite" value="${quantite}">
                <input type="hidden" name="montant" value="${montant}">
                <div class="form-group">
                    <label for="cardNumber">Numéro de carte</label>
                    <input type="text" id="cardNumber" name="cardNumber" placeholder="0000 0000 0000 0000" required>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label for="expiry">Date d'expiration</label>
                        <input type="text" id="expiry" name="expiry" placeholder="MM/YY" required>
                    </div>
                    <div class="form-group">
                        <label for="cvv">Code de sécurité (CVV)</label>
                        <input type="text" id="cvv" name="cvv" placeholder="123" required>
                    </div>
                </div>
                <button type="submit" class="btn" style="width: 100%; font-size: 16px; padding: 16px;">Payer ${montant} MAD</button>
            </form>
            <p style="color: red; margin-top: 15px; text-align: center;">${erreurPaiement}</p>
        </div>
    </div>
</body>
</html>
