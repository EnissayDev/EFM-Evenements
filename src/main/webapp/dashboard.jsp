<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Espace Organisateur - EventTix</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 30px;
            margin-top: 40px;
        }
        @media (max-width: 768px) {
            .dashboard-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="#" class="logo">EventTix <span style="font-size: 14px; color: var(--text-dark);">| Organisateur</span></a>
            <nav>
                <a href="login.jsp" class="btn btn-outline">Déconnexion</a>
            </nav>
        </div>
    </header>

    <div class="container dashboard-grid">
        <div class="card">
            <h2 style="margin-top: 0; border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">Créer un Nouvel Événement</h2>
            <form action="EvenementController" method="POST">
                <input type="hidden" name="action" value="create">
                <div class="form-group">
                    <label for="titre">Titre de l'événement</label>
                    <input type="text" id="titre" name="titre" required>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label for="date">Date</label>
                        <input type="date" id="date" name="date" required>
                    </div>
                    <div class="form-group">
                        <label for="capacite">Capacité Totale</label>
                        <input type="number" id="capacite" name="capacite" required>
                    </div>
                </div>
                <div class="form-group">
                    <label for="lieu">Lieu complet</label>
                    <input type="text" id="lieu" name="lieu" required>
                </div>
                <button type="submit" class="btn">Publier l'événement</button>
            </form>
        </div>

        <div class="card">
            <h2 style="margin-top: 0; border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">Aperçu des Ventes</h2>
             <c:if test="${empty ventes}">
                 <div style="text-align: center; padding: 40px 0; color: var(--text-muted);">
                    <p>Aucune vente enregistrée pour le moment.</p>
                 </div>
             </c:if>
             <ul style="list-style: none; padding: 0; margin: 0;">
                <c:forEach var="vente" items="${ventes}">
                    <li style="padding: 15px 0; border-bottom: 1px solid var(--border-color);">
                        <strong style="display: block; font-size: 16px;">${vente.evenementTitre}</strong>
                        <span style="color: var(--text-muted);">${vente.quantite} billets vendus</span>
                        <span style="float: right; color: var(--primary-orange); font-weight: bold;">${vente.revenuTotal} MAD</span>
                    </li>
                </c:forEach>
             </ul>
        </div>
    </div>
</body>
</html>