<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Créer un compte - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .login-wrapper { display: flex; justify-content: center; align-items: center; min-height: 80vh; padding: 40px 0;}
        .login-card { width: 100%; max-width: 500px; padding: 40px; }
    </style>
</head>
<body>
    <jsp:include page="/nav.jsp" />

    <div class="container login-wrapper">
        <div class="card login-card">
            <h2 style="margin-top: 0; font-size: 28px;">Rejoignez EventTix</h2>

            <form action="${pageContext.request.contextPath}/AuthController" method="POST">
                <input type="hidden" name="action" value="register">

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px;">
                    <div class="form-group">
                        <label for="prenom">Prénom</label>
                        <input type="text" id="prenom" name="prenom" required>
                    </div>
                    <div class="form-group">
                        <label for="nom">Nom</label>
                        <input type="text" id="nom" name="nom" required>
                    </div>
                </div>

                <div class="form-group">
                    <label for="email">Adresse e-mail</label>
                    <input type="email" id="email" name="email" required>
                </div>

                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" required>
                </div>

                <div class="form-group">
                    <label for="role">Je souhaite utiliser EventTix pour :</label>
                    <select id="role" name="role" style="width: 100%; padding: 12px; border: 1px solid #c8c6c4; border-radius: 4px; font-size: 16px;">
                        <option value="CLIENT">Acheter des billets (Participant)</option>
                        <option value="ORGANISATEUR">Créer des événements (Organisateur)</option>
                    </select>
                </div>

                <button type="submit" class="btn" style="width: 100%; margin-top: 20px; padding: 15px; font-size: 16px;">Créer mon compte</button>
            </form>
            <p style="text-align: center; margin-top: 20px;">Déjà un compte ? <a href="${pageContext.request.contextPath}/login.jsp">Connectez-vous ici</a>.</p>
        </div>
    </div>
</body>
</html>