<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Découvrez des Événements - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="${pageContext.request.contextPath}/" class="logo">EventTix</a>
            <nav>
                <c:choose>
                    <c:when test="${empty sessionScope.utilisateur}">
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">Connexion</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline">Déconnexion</a>
                    </c:otherwise>
                </c:choose>
            </nav>
        </div>
    </header>

    <div class="container">
        <h1 style="margin-top: 40px; font-size: 36px;">Événements populaires près de chez vous</h1>
        <div class="event-grid">
            <c:forEach var="evenement" items="${evenements}">
                <div class="card">
                    <div class="card-image" style="background-image: url('https://via.placeholder.com/400x200'); background-size: cover;"></div>
                    <div class="card-content">
                        <div class="card-date">${evenement.date}</div>
                        <h3 class="card-title">${evenement.titre}</h3>
                        <div class="card-location">${evenement.lieu}</div>
                        <div class="card-footer">
                            <a href="${pageContext.request.contextPath}/evenement/${evenement.id}" class="btn" style="width: 100%; display: block; text-align: center; box-sizing: border-box;">Réserver</a>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty evenements}">
                <p style="color: var(--text-muted); margin-top: 40px;">Aucun événement disponible pour le moment.</p>
            </c:if>
        </div>
    </div>
</body>
</html>
