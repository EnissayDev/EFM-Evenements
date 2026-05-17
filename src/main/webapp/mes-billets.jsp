<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mes Billets - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .filter-bar {
            background: var(--white);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            margin-bottom: 30px;
            display: flex;
            gap: 15px;
            border: 1px solid var(--border-color);
        }
        .ticket-list-card {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            margin-bottom: 15px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            background: var(--white);
            transition: box-shadow 0.2s ease;
        }
        .ticket-list-card:hover {
            box-shadow: 0 8px 16px rgba(30, 10, 60, 0.08);
        }
        .ticket-info { flex-grow: 1; }
        .ticket-actions { text-align: right; min-width: 150px; }

        /* Badges de statut */
        .status-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        .status-actif { background-color: #dcfce7; color: #15803d; }
        .status-inactif { background-color: #f3f4f6; color: #6b7280; }

        @media (max-width: 768px) {
            .filter-bar { flex-direction: column; }
            .ticket-list-card { flex-direction: column; align-items: flex-start; gap: 15px; }
            .ticket-actions { text-align: left; width: 100%; }
            .ticket-actions .btn { width: 100%; }
        }
    </style>
</head>
<body>
    <jsp:include page="/nav.jsp" />

    <div class="container" style="margin-top: 40px; min-height: 60vh;">
        <h1 style="font-size: 32px; margin-bottom: 30px;">Mes Billets</h1>

        <form action="${pageContext.request.contextPath}/BilletController" method="GET" class="filter-bar">
            <input type="hidden" name="action" value="mesBillets">

            <div class="form-group" style="margin-bottom: 0; flex-grow: 2;">
                <input type="text" name="search" class="live-search" placeholder="Rechercher par nom d'événement..." value="${param.search}">
            </div>

            <div class="form-group" style="margin-bottom: 0; flex-grow: 1;">
                <select name="filter" onchange="this.form.submit()" style="width: 100%; padding: 12px; border: 1px solid #c8c6c4; border-radius: 4px; font-size: 16px;">
                    <option value="newest" ${param.filter == 'newest' ? 'selected' : ''}>Achats les plus récents</option>
                    <option value="oldest" ${param.filter == 'oldest' ? 'selected' : ''}>Achats les plus anciens</option>
                    <option value="soon" ${param.filter == 'soon' ? 'selected' : ''}>Événements à venir (Bientôt)</option>
                    <option value="later" ${param.filter == 'later' ? 'selected' : ''}>Événements lointains</option>
                    <option value="actif" ${param.filter == 'actif' ? 'selected' : ''}>Billets Valides (Actifs)</option>
                    <option value="inactif" ${param.filter == 'inactif' ? 'selected' : ''}>Billets Consommés (Inactifs)</option>
                    <option value="high_price" ${param.filter == 'high_price' ? 'selected' : ''}>Prix décroissant (Plus chers)</option>
                    <option value="low_price" ${param.filter == 'low_price' ? 'selected' : ''}>Prix croissant (Moins chers)</option>
                </select>
            </div>

            <button type="submit" class="btn" style="padding: 0 30px;">Filtrer</button>
        </form>

        <div>
            <c:if test="${empty billets}">
                <div style="text-align: center; padding: 60px 0; background: var(--white); border-radius: 8px; border: 1px dashed var(--border-color);">
                    <h3 style="color: var(--text-muted);">Vous n'avez aucun billet correspondant.</h3>
                    <a href="${pageContext.request.contextPath}/catalogue.jsp" class="btn" style="margin-top: 15px;">Découvrir des événements</a>
                </div>
            </c:if>

            <c:forEach var="billet" items="${billets}">
                <div class="ticket-list-card">
                    <div class="ticket-info">
                        <c:choose>
                            <c:when test="${billet.statut == 'VALIDE'}">
                                <span class="status-badge status-actif">Actif - Prêt à scanner</span>
                            </c:when>
                            <c:otherwise>
                                <span class="status-badge status-inactif">Inactif - Consommé</span>
                            </c:otherwise>
                        </c:choose>

                        <h2 style="margin: 0 0 5px 0; font-size: 20px;">${billet.evenementTitre}</h2>
                        <p style="color: var(--primary-orange); font-weight: bold; margin: 0 0 5px 0;">📅 ${billet.dateEvenement}</p>
                        <p style="color: var(--text-muted); font-size: 14px; margin: 0;">📍 ${billet.lieu}</p>
                        <p style="color: var(--text-muted); font-size: 14px; margin: 5px 0 0 0;">
                            Type: <strong style="text-transform: capitalize;">${billet.typePlace}</strong> | Prix payé: ${billet.prixPaye} MAD
                        </p>
                    </div>

                    <div class="ticket-actions">
                        <form action="${pageContext.request.contextPath}/BilletController" method="GET" style="margin: 0;">
                            <input type="hidden" name="action" value="viewQR">
                            <input type="hidden" name="idBillet" value="${billet.id}">
                            <button type="submit" class="btn">Afficher le QR Code</button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>