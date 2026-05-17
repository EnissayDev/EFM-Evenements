<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>EventTix | Billets pour Concerts, Sports & Spectacles</title>
</head>
<body class="flex min-h-screen flex-col overflow-x-hidden text-gray-900 bg-white">
    <jsp:include page="/nav.jsp" />

    <main id="main">
        <section class="relative bg-gray-950 text-white" style="background-color: #0E1E49;">
            <div class="relative z-0 mx-auto max-w-7xl px-5 py-24 md:py-32 text-center lg:text-left flex flex-col lg:flex-row items-center gap-12">
                <div class="flex-1">
                    <h1 class="font-bold text-4xl md:text-5xl lg:text-6xl text-balance leading-tight mb-6">
                        Des moments inoubliables commencent ici.
                    </h1>
                    <p class="text-lg md:text-xl font-semibold opacity-90 mb-8 max-w-2xl mx-auto lg:mx-0">
                        EventTix est la plus grande plateforme au Maroc pour acheter vos billets de concerts, spectacles et événements sportifs. 100% garanti.
                    </p>
                    <div class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start">
                        <a href="${pageContext.request.contextPath}/EvenementController?action=search" class="inline-flex items-center rounded-full justify-center whitespace-nowrap font-bold h-14 px-8 text-white bg-primary-500 hover:bg-primary-300 transition-colors text-lg">
                            Voir les événements
                        </a>
                        <c:if test="${empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/register.jsp" class="inline-flex items-center rounded-full justify-center whitespace-nowrap font-bold h-14 px-8 text-white bg-white/20 hover:bg-white/30 transition-colors text-lg border border-white/30">
                                Créer un compte
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </section>

        <section class="border-b border-gray-200 bg-gray-50 py-10">
            <div class="max-w-7xl mx-auto px-5 grid grid-cols-1 md:grid-cols-3 gap-8 text-center">
                <div>
                    <h3 class="font-bold text-xl text-gray-900 mb-2">100% Sécurisé</h3>
                    <p class="text-gray-500 font-medium">Vos billets sont garantis authentiques et livrés à temps.</p>
                </div>
                <div>
                    <h3 class="font-bold text-xl text-gray-900 mb-2">Achat Facile</h3>
                    <p class="text-gray-500 font-medium">Trouvez et réservez vos places en moins de 3 minutes.</p>
                </div>
                <div>
                    <h3 class="font-bold text-xl text-gray-900 mb-2">Support Local</h3>
                    <p class="text-gray-500 font-medium">Une équipe dédiée pour vous assister 7j/7 au Maroc.</p>
                </div>
            </div>
        </section>
    </main>
</body>
</html>