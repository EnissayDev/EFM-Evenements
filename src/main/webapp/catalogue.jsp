<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Catalogue des Événements</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <header>
        <div class="container">
            <h1>Événements Disponibles</h1>
        </div>
    </header>
    <div class="container">
        <c:forEach var="evenement" items="${evenements}">
            <div class="card">
                <h3>${evenement.titre}</h3>
                <p>Date: ${evenement.date}</p>
                <p>Lieu: ${evenement.lieu}</p>
                <form action="EvenementController" method="GET">
                    <input type="hidden" name="id" value="${evenement.id}">
                    <button type="submit" class="btn">Voir les détails</button>
                </form>
            </div>
        </c:forEach>
    </div>
</body>
</html>