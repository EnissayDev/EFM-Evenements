<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
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
            <a href="${pageContext.request.contextPath}/catalogue" class="logo">EventTix</a>
            <nav>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Déconnexion</a>
            </nav>
        </div>
    </header>

    <div class="hero-banner"></div>

    <div class="container event-layout">
        <div>
            <h1 style="font-size: 40px; margin-top: 0;">${evenement.titre}</h1>
            <h3 style="color: var(--primary-orange);">${evenement.date}</h3>
            <p style="color: var(--text-muted); font-size: 16px; margin-bottom: 8px;">📍 ${evenement.lieu}</p>
            <p style="color: var(--text-muted); font-size: 16px; margin-bottom: 30px;">🎟️ Capacité : ${billetsSold}/${evenement.capacite} places</p>
            <h2>À propos de cet événement</h2>
            <p style="font-size: 16px; line-height: 1.6;">${evenement.description}</p>

            <c:if test="${not empty mesBillets}">
                <h2 style="margin-top: 40px;">Mes Billets</h2>
                <div style="display: flex; flex-direction: column; gap: 12px;">
                    <c:forEach var="billet" items="${mesBillets}">
                        <div style="display: flex; align-items: center; justify-content: space-between;
                                    border: 1px solid var(--border-color); border-radius: 10px;
                                    padding: 14px 18px; background: var(--bg-light);">
                            <div>
                                <div style="font-size: 13px; color: var(--text-muted); margin-bottom: 4px;">Code du billet</div>
                                <code style="font-size: 15px; font-weight: 600; letter-spacing: 0.5px;">${billet.code}</code>
                            </div>
                            <c:choose>
                                <c:when test="${billet.statut == 'VALIDE'}">
                                    <span style="background:#dcfce7; color:#15803d; padding:4px 10px; border-radius:12px; font-size:13px; font-weight:600;">Utilisé</span>
                                </c:when>
                                <c:otherwise>
                                    <span style="background:#e0f2fe; color:#0284c7; padding:4px 10px; border-radius:12px; font-size:13px; font-weight:600;">Actif</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:forEach>
                </div>
            </c:if>
        </div>
        <div>
            <div class="card" style="position: sticky; top: 100px;">
                <h3 style="margin-top: 0;">Billetterie</h3>
                <c:choose>
                    <c:when test="${billetsSold >= evenement.capacite}">
                        <p style="color: red; font-weight: bold; text-align: center;">Cet événement est complet.</p>
                    </c:when>
                    <c:otherwise>
                        <c:if test="${param.error == 'complet'}">
                            <p style="color: red; margin-bottom: 12px;">La quantité demandée dépasse la capacité restante.</p>
                        </c:if>
                        <form action="${pageContext.request.contextPath}/paiement" method="GET">
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
                                <input type="number" id="quantite" name="quantite" value="1" min="1" max="${evenement.capacite - billetsSold}" required>
                            </div>
                            <button type="submit" class="btn" style="width: 100%; margin-top: 10px;">Acheter des billets</button>
                        </form>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
</body>
</html>
