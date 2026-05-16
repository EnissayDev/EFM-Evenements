<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Espace Organisateur - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .dashboard-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 30px; margin-top: 40px; }
        @media (max-width: 768px) { .dashboard-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
<jsp:include page="/nav.jsp" />

<div class="container">

    <c:if test="${not empty erreurMessage}">
        <div class="alert alert-error" style="margin-top: 20px;">${erreurMessage}</div>
    </c:if>
    <c:if test="${not empty successMessage}">
        <div class="alert alert-success" style="margin-top: 20px;">${successMessage}</div>
    </c:if>

    <div class="dashboard-grid">
        <div class="card">
            <h2 style="margin-top: 0; border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">Créer un Nouvel Événement</h2>
            <form action="${pageContext.request.contextPath}/evenements"
                  method="POST"
                  accept-charset="UTF-8">
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
                <div class="form-group">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="3" style="width:100%;resize:vertical;"></textarea>
                </div>
                <button type="submit" class="btn">Publier l'événement</button>
            </form>
        </div>

        <div class="card">
            <h2 style="margin-top: 0; border-bottom: 1px solid var(--border-color); padding-bottom: 15px;">Aperçu des Ventes</h2>
            <c:if test="${empty commandes}">
                <div style="text-align: center; padding: 40px 0; color: var(--text-muted);">
                    <p>Aucune commande enregistrée pour le moment.</p>
                </div>
            </c:if>
            <ul style="list-style: none; padding: 0; margin: 0;">
                <c:forEach var="commande" items="${commandes}">
                    <li style="padding: 15px 0; border-bottom: 1px solid var(--border-color);">
                        <strong style="display: block; font-size: 16px;">${commande.evenementTitre}</strong>
                        <span style="color: var(--text-muted);">${commande.quantite} billets vendus</span>
                        <span style="float: right; color: var(--primary-orange); font-weight: bold;">${commande.montantTotal} MAD</span>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </div>
</div>
</body>
</html>
