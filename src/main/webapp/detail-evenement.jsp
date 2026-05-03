<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>${evenement.titre} - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .hero-banner { width: 100%; height: 350px; background-color: #e2e2e6; background-image: url('https://via.placeholder.com/1200x400'); background-size: cover; background-position: center; margin-bottom: 40px; }
        .event-layout { display: grid; grid-template-columns: 2fr 1fr; gap: 40px; }
        @media (max-width: 768px) { .event-layout { grid-template-columns: 1fr; } }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="${pageContext.request.contextPath}/catalogue.jsp" class="logo">EventTix</a>
        </div>
    </header>

    <div class="hero-banner"></div>

    <div class="container event-layout">
        <div>
            <h1 style="font-size: 40px; margin-top: 0;">${evenement.titre}</h1>
            <h3 style="color: var(--primary-orange);">${evenement.date}</h3>
            <p style="color: var(--text-muted); font-size: 16px; margin-bottom: 30px;">📍 ${evenement.lieu}</p>
            <h2>À propos de cet événement</h2>
            <p style="font-size: 16px; line-height: 1.6;">${evenement.description}</p>
        </div>
        <div>
            <div class="card" style="position: sticky; top: 100px;">
                <h3 style="margin-top: 0;">Billetterie</h3>
                <!-- Fixed Path: Routes to ma.ismagi.controller.CommandeController -->
                <form action="${pageContext.request.contextPath}/CommandeController" method="GET">
                    <input type="hidden" name="action" value="preparePayment">
                    <input type="hidden" name="idEvenement" value="${evenement.id}">
                    <div class="form-group">
                        <label for="typePlace">Type de Billet</label>
                        <select id="typePlace" name="typePlace">
                            <option value="standard">Standard (150 MAD)</option>
                            <option value="vip">VIP (300 MAD)</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label for="quantite">Quantité</label>
                        <input type="number" id="quantite" name="quantite" value="1" min="1" max="10" required>
                    </div>
                    <button type="submit" class="btn" style="width: 100%; margin-top: 10px;">Acheter des billets</button>
                </form>
            </div>
        </div>
    </div>
</body>
</html>