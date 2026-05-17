<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Créer un compte - EventTix</title>
</head>
<body class="flex min-h-screen flex-col text-gray-900 bg-gray-50">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 flex items-center justify-center p-5 py-12">
        <div class="w-full max-w-lg bg-white border border-gray-200 rounded-xl p-8 sm:p-10 shadow-sm">
            <h1 class="font-bold text-3xl text-gray-950 mb-2 text-center">Rejoignez EventTix</h1>
            <p class="text-gray-500 font-medium text-center mb-8">Créez votre compte en quelques secondes.</p>

            <form action="${pageContext.request.contextPath}/AuthController" method="POST" class="flex flex-col gap-5">
                <input type="hidden" name="action" value="register">

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                    <div>
                        <label for="prenom" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Prénom</label>
                        <input type="text" id="prenom" name="prenom" class="w-full h-12 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                    </div>
                    <div>
                        <label for="nom" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Nom</label>
                        <input type="text" id="nom" name="nom" class="w-full h-12 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                    </div>
                </div>

                <div>
                    <label for="email" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Adresse e-mail</label>
                    <input type="email" id="email" name="email" class="w-full h-12 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                </div>

                <div>
                    <label for="password" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Mot de passe</label>
                    <input type="password" id="password" name="password" class="w-full h-12 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                </div>

                <div>
                    <label for="role" class="block text-sm font-bold text-gray-900 uppercase tracking-wide mb-2">Je souhaite utiliser EventTix pour :</label>
                    <select id="role" name="role" class="w-full h-12 bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-lg px-4 font-bold outline-none focus:ring-1 focus:ring-primary-500 transition-colors appearance-none cursor-pointer">
                        <option value="CLIENT">Acheter des billets (Participant)</option>
                        <option value="ORGANISATEUR">Créer des événements (Organisateur)</option>
                    </select>
                </div>

                <button type="submit" class="w-full h-14 mt-4 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide text-white bg-primary-500 hover:bg-[#C1122B] transition-colors">
                    Créer mon compte
                </button>
            </form>

            <div class="mt-8 pt-6 border-t border-gray-100 text-center">
                <p class="text-gray-500 font-medium">Déjà un compte ? <a href="${pageContext.request.contextPath}/login.jsp" class="text-primary-500 font-bold hover:underline">Connectez-vous ici</a></p>
            </div>

        </div>
    </main>
</body>
</html>