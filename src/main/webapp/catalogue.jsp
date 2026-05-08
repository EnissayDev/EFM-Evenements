<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
            <div class="logo">EventTix</div>
            <nav>
                <c:choose>
                    <c:when test="${empty sessionScope.utilisateur}">
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline">Connexion</a>
                    </c:when>
                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/AuthController?action=logout" class="btn btn-outline">Déconnexion</a>
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
                            <form action="${pageContext.request.contextPath}/evenements" method="GET">
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