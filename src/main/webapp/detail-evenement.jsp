<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Détails: ${evenement.titre}</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <div class="container">
            <h1>${evenement.titre}</h1>
        </div>
    </header>
    <div class="container">
        <div class="card">
            <h2>Informations</h2>
            <p><strong>Date:</strong> ${evenement.date}</p>
            <p><strong>Lieu:</strong> ${evenement.lieu}</p>
            <p><strong>Description:</strong> ${evenement.description}</p>

            <hr>

            <h3>Choisir une place</h3>
            <!-- The action points to the Controller that prepares the payment page -->
            <form action="CommandeController" method="GET">
                <input type="hidden" name="action" value="preparePayment">
                <input type="hidden" name="idEvenement" value="${evenement.id}">

                <div class="form-group">
                    <label for="typePlace">Type de Billet (Prix indicatif)</label>
                    <select id="typePlace" name="typePlace" style="width: 100%; padding: 10px;">
                        <option value="standard">Standard (150 MAD)</option>
                        <option value="vip">VIP (300 MAD)</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="quantite">Quantité</label>
                    <input type="number" id="quantite" name="quantite" value="1" min="1" max="10" required>
                </div>

                <button type="submit" class="btn">Procéder au paiement</button>
            </form>
        </div>
    </div>
</body>
</html>