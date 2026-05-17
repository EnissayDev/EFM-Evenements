<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes Billets - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .filters-bar { display: flex; gap: 12px; align-items: center; flex-wrap: wrap; margin: 30px 0 24px; }
        .filters-bar input, .filters-bar select { padding: 10px 14px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 14px; }
        .billet-card { display: flex; justify-content: space-between; align-items: center; background: var(--white); border: 1px solid var(--border-color); border-radius: 10px; padding: 20px 24px; margin-bottom: 16px; gap: 20px; }
        .billet-info { flex: 1; }
        .billet-titre { font-size: 18px; font-weight: 700; color: var(--text-dark); margin-bottom: 6px; }
        .billet-meta { font-size: 13px; color: var(--text-muted); display: flex; gap: 20px; flex-wrap: wrap; }
        .badge { padding: 4px 12px; border-radius: 12px; font-size: 12px; font-weight: 600; }
        .badge-actif    { background: #e0f2fe; color: #0284c7; }
        .badge-valide   { background: #dcfce7; color: #15803d; }
        .badge-vip      { background: #fef9c3; color: #92400e; }
        .badge-standard { background: #f3f4f6; color: #374151; }
        .empty-state { text-align: center; padding: 80px 0; color: var(--text-muted); }
    </style>
</head>
<body>
<jsp:include page="/nav.jsp" />

<div class="container">
    <h1 style="margin-top: 40px;">🎟️ Mes Billets</h1>

    <form action="${pageContext.request.contextPath}/BilletController" method="GET" class="filters-bar">
        <input type="hidden" name="action" value="mesBillets">
        <input type="text" name="search" placeholder="Rechercher un événement..." value="${param.search}" style="flex: 1; min-width: 200px;">
        <select name="filter">
            <option value="newest"     ${param.filter == 'newest'     ? 'selected' : ''}>Plus récents</option>
            <option value="oldest"     ${param.filter == 'oldest'     ? 'selected' : ''}>Plus anciens</option>
            <option value="soon"       ${param.filter == 'soon'       ? 'selected' : ''}>Bientôt</option>
            <option value="later"      ${param.filter == 'later'      ? 'selected' : ''}>Plus tard</option>
            <option value="actif"      ${param.filter == 'actif'      ? 'selected' : ''}>Actifs</option>
            <option value="inactif"    ${param.filter == 'inactif'    ? 'selected' : ''}>Utilisés</option>
            <option value="high_price" ${param.filter == 'high_price' ? 'selected' : ''}>Prix décroissant</option>
            <option value="low_price"  ${param.filter == 'low_price'  ? 'selected' : ''}>Prix croissant</option>
        </select>
        <button type="submit" class="btn" style="padding: 10px 24px;">Filtrer</button>
    </form>

    <c:choose>
        <c:when test="${empty billets}">
            <div class="empty-state">
                <p style="font-size: 18px;">Aucun billet trouvé.</p>
                <a href="${pageContext.request.contextPath}/catalogue" class="btn" style="margin-top: 16px; display: inline-block;">Parcourir les événements</a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="b" items="${billets}">
                <div class="billet-card">
                    <div class="billet-info">
                        <div class="billet-titre">${b.evenementTitre}</div>
                        <div class="billet-meta">
                            <span>📅 ${b.dateEvenement}</span>
                            <span>📍 ${b.lieu}</span>
                            <span>💰 <fmt:formatNumber value="${b.prixPaye}" maxFractionDigits="2"/> MAD</span>
                        </div>
                    </div>
                    <div style="display: flex; align-items: center; gap: 12px; flex-shrink: 0;">
                        <span class="badge ${b.typePlace == 'VIP' ? 'badge-vip' : 'badge-standard'}">${b.typePlace}</span>
                        <span class="badge ${b.statut == 'ACTIF' ? 'badge-actif' : 'badge-valide'}">
                            ${b.statut == 'ACTIF' ? 'Actif' : 'Utilisé'}
                        </span>
                        <a href="${pageContext.request.contextPath}/BilletController?action=viewQR&idBillet=${b.id}" class="btn btn-outline" style="padding: 8px 16px; font-size: 13px;">Voir QR</a>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
