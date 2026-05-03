<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>EventTix - La meilleure billetterie en ligne</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hero-home {
            background-image: linear-gradient(rgba(30, 10, 60, 0.8), rgba(30, 10, 60, 0.8)), url('https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            height: 60vh;
            display: flex;
            align-items: center;
            text-align: center;
            color: var(--white);
        }
        .hero-content {
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
        }
        .hero-content h1 {
            font-size: 56px;
            margin-bottom: 20px;
        }
        .hero-content p {
            font-size: 20px;
            margin-bottom: 40px;
        }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="index.jsp" class="logo">EventTix</a>
            <nav>
                <a href="login.jsp" class="btn btn-outline">Connexion</a>
            </nav>
        </div>
    </header>

    <div class="hero-home">
        <div class="hero-content">
            <h1>Vos prochains meilleurs souvenirs commencent ici.</h1>
            <p>Découvrez des concerts, des conférences et des événements exclusifs près de chez vous.</p>
            <form action="EvenementController" method="GET">
                <input type="hidden" name="action" value="listAll">
                <!-- Directs the user to the catalog -->
                <button type="submit" class="btn" style="font-size: 18px; padding: 15px 40px;">Parcourir les événements</button>
            </form>
        </div>
    </div>

    <div class="container" style="text-align: center; margin-top: 60px;">
        <h2 style="color: var(--text-muted);">Une plateforme conçue pour les passionnés.</h2>
    </div>
</body>
</html>