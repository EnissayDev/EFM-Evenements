<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Dashboard Organisateur</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
    </style>
</head>
<body>
    <header>
        <div class="container">
            <h1>Espace Organisateur</h1>
        </div>
    </header>
    <div class="container dashboard-grid">
        <!-- Section: Créer un Événement -->
        <div class="card">
            <h2>Créer un Nouvel Événement</h2>
            <form action="EvenementController" method="POST">
                <input type="hidden" name="action" value="create">
                <div class="form-group">
                    <label for="titre">Titre de l'événement</label>
                    <input type="text" id="titre" name="titre" required>
                </div>
                <div class="form-group">
                    <label for="date">Date</label>
                    <input type="date" id="date" name="date" required>
                </div>
                <div class="form-group">
                    <label for="lieu">Lieu</label>
                    <input type="text" id="lieu" name="lieu" required>
                </div>
                <div class="form-group">
                    <label for="capacite">Capacité Totale</label>
                    <input type="number" id="capacite" name="capacite" required>
                </div>
                <button type="submit" class="btn">Créer l'événement</button>
            </form>
        </div>

        <!-- Section: Résumé des Ventes (Requires Backend Data) -->
        <div class="card">
            <h2>Résumé des Ventes Récentes</h2>
             <c:if test="${empty ventes}">
                 <p>Aucune vente enregistrée pour le moment.</p>
             </c:if>
             <ul>
                <c:forEach var="vente" items="${ventes}">
                    <li>Événement: ${vente.evenementTitre} - Billets Vendus: ${vente.quantite} - Revenu: ${vente.revenuTotal} MAD</li>
                </c:forEach>
             </ul>
        </div>
    </div>
</body>
</html>