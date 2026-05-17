<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Connexion - EventTix</title>
</head>
<body class="flex min-h-screen flex-col text-gray-900 bg-gray-50">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 flex items-center justify-center p-5">
        <div class="w-full max-w-md bg-white border border-gray-200 rounded-xl p-8 sm:p-10 shadow-sm">
            <h1 class="font-bold text-3xl text-gray-950 mb-2 text-center">Connectez-vous</h1>
            <p class="text-gray-500 font-medium text-center mb-8">Accédez à votre espace sécurisé EventTix.</p>

            <form action="${pageContext.request.contextPath}/AuthController" method="POST" class="flex flex-col gap-5">
                <div>
                    <label for="email" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Adresse e-mail</label>
                    <input type="email" id="email" name="email" class="w-full h-12 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                </div>

                <div>
                    <label for="password" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Mot de passe</label>
                    <input type="password" id="password" name="password" class="w-full h-12 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                </div>

                <button type="submit" class="w-full h-14 mt-2 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide text-white bg-primary-500 hover:bg-[#C1122B] transition-colors">
                    Se connecter
                </button>
            </form>

            <c:if test="${not empty erreurMessage}">
                <p class="text-red-600 font-bold mt-4 text-center text-sm">${erreurMessage}</p>
            </c:if>

            <div class="mt-8 pt-6 border-t border-gray-100 text-center">
                <p class="text-gray-500 font-medium leading-relaxed">
                    Pas encore de compte ? <br>
                    <a href="${pageContext.request.contextPath}/register" class="text-primary-500 font-bold hover:underline mt-1 inline-block">S'inscrire gratuitement</a>
                </p>
            </div>

        </div>
    </main>
</body>
</html>