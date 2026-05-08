<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Connexion - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .login-wrapper { display: flex; justify-content: center; align-items: center; min-height: 80vh; }
        .login-card { width: 100%; max-width: 400px; padding: 40px; }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="${pageContext.request.contextPath}/" class="logo">EventTix</a>
        </div>
    </header>

    <div class="container login-wrapper">
        <div class="card login-card">
            <h2 style="margin-top: 0; font-size: 28px;">Connectez-vous</h2>
            <form action="${pageContext.request.contextPath}/login" method="POST">
                <div class="form-group">
                    <label for="email">Adresse e-mail</label>
                    <input type="email" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" required>
                </div>
                <button type="submit" class="btn" style="width: 100%; margin-top: 10px;">Se connecter</button>
            </form>
            <p style="color: red; margin-top: 15px; text-align: center;">${erreurMessage}</p>
        </div>
    </div>
</body>
</html>
