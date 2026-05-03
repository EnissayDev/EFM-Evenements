<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Découvrez des Événements - Billetterie</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <!-- Modern Header -->
    <header>
        <div class="container header-content">
            <div class="logo">EventTix</div>
            <nav>
                <a href="login.jsp" class="btn btn-outline">Connexion</a>
            </nav>
        </div>
    </header>

    <div class="container">
        <h1 style="margin-top: 40px; font-size: 36px;">Événements populaires près de chez vous</h1>

        <!-- The Grid Layout for Cards -->
        <div class="event-grid">

            <c:forEach var="evenement" items="${evenements}">
                <!-- The Individual Card -->
                <div class="card">
                    <!-- A placeholder div for the event image -->
                    <div class="card-image" style="background-image: url('https://via.placeholder.com/400x200'); background-size: cover;"></div>

                    <div class="card-content">
                        <div class="card-date">${evenement.date}</div>
                        <h3 class="card-title">${evenement.titre}</h3>
                        <div class="card-location">${evenement.lieu}</div>

                        <div class="card-footer">
                            <form action="EvenementController" method="GET">
                                <input type="hidden" name="id" value="${evenement.id}">
                                <!-- Using style="width: 100%;" makes the button stretch across the card bottom like on modern sites -->
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