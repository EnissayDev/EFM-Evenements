<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Découvrez des Événements - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .search-bar-container {
            background: var(--white);
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.05);
            margin: 20px 0 40px 0;
            display: flex;
            gap: 15px;
            border: 1px solid var(--border-color);
        }
        .search-input { flex-grow: 2; }
        .search-select { flex-grow: 1; }
        @media (max-width: 768px) {
            .search-bar-container { flex-direction: column; }
        }
    </style>
</head>
<body>
    <jsp:include page="/nav.jsp" />

    <div class="container">
        <h1 style="margin-top: 40px; font-size: 36px;">Trouvez votre prochain événement</h1>

        <form action="${pageContext.request.contextPath}/EvenementController" method="GET" class="search-bar-container">
            <input type="hidden" name="action" value="search">

            <div class="search-input form-group" style="margin-bottom: 0;">
                <input type="text" name="keyword" placeholder="Rechercher par nom (ex: Concert, Conférence...)" value="${param.keyword}">
            </div>

            <div class="search-select form-group" style="margin-bottom: 0;">
                <select name="category" style="width: 100%; padding: 12px; border: 1px solid #c8c6c4; border-radius: 4px; font-size: 16px;">
                    <option value="">Toutes les catégories</option>
                    <option value="Musique" ${param.category == 'Musique' ? 'selected' : ''}>Musique</option>
                    <option value="Technologie" ${param.category == 'Technologie' ? 'selected' : ''}>Technologie</option>
                    <option value="Sport" ${param.category == 'Sport' ? 'selected' : ''}>Sport</option>
                    <option value="Art" ${param.category == 'Art' ? 'selected' : ''}>Art & Culture</option>
                </select>
            </div>

            <button type="submit" class="btn" style="padding: 0 30px;">Rechercher</button>
        </form>

        <div class="event-grid">
            <c:if test="${empty evenements}">
                <p>Aucun événement ne correspond à votre recherche.</p>
            </c:if>
            <c:forEach var="evenement" items="${evenements}">
                <div class="card">
                    <div class="card-image" style="background-image: url('https://via.placeholder.com/400x200'); background-size: cover;"></div>
                    <div class="card-content">
                        <div class="card-date">${evenement.date}</div>
                        <h3 class="card-title">${evenement.titre}</h3>
                        <div class="card-location">${evenement.lieu}</div>
                        <div class="card-footer">
                            <form action="${pageContext.request.contextPath}/EvenementController" method="GET">
                                <input type="hidden" name="id" value="${evenement.id}">
                                <button type="submit" class="btn" style="width: 100%;">Réserver</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>
</body>
</html>