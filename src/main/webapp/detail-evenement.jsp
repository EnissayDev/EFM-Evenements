<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>${evenement.titre} - EventTix</title>
</head>
<body class="flex min-h-screen flex-col text-gray-900 bg-white">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 w-full pb-16">

        <div class="w-full h-64 md:h-96 bg-gray-200 bg-cover bg-center border-b border-gray-200"
             style="background-image: url('${not empty evenement.imagePath ? pageContext.request.contextPath.concat('/').concat(evenement.imagePath) : 'https://images.unsplash.com/photo-1540039155732-d68a916abda3?auto=format&fit=crop&q=80&w=1600'}');">
        </div>

        <div class="max-w-7xl mx-auto px-5 pt-10 grid grid-cols-1 lg:grid-cols-3 gap-10">

            <div class="lg:col-span-2 flex flex-col gap-8">
                <div>
                    <span class="inline-block bg-gray-900 text-white text-xs font-bold uppercase tracking-widest px-3 py-1 rounded-sm mb-4">
                        ${evenement.categorie}
                    </span>

                    <h1 class="font-bold text-4xl md:text-5xl text-gray-950 mb-6 leading-tight">
                        ${evenement.titre}
                    </h1>

                    <div class="flex flex-col sm:flex-row sm:items-center gap-4 text-gray-700 font-medium mb-8 p-4 bg-gray-50 border border-gray-200 rounded-sm">
                        <div class="flex items-center gap-2">
                            <span class="text-xl">📅</span>
                            <span class="font-bold text-primary-500">${evenement.date}</span>
                        </div>
                        <span class="hidden sm:block text-gray-300">|</span>
                        <div class="flex items-center gap-2">
                            <span class="text-xl">📍</span>
                            <span>${evenement.lieu}</span>
                        </div>
                        <span class="hidden sm:block text-gray-300">|</span>
                        <div class="flex items-center gap-2">
                            <span class="text-xl">🎟️</span>
                            <span>${billetsSold} / ${evenement.capacite} places</span>
                        </div>
                    </div>

                    <h2 class="font-bold text-2xl text-gray-900 mb-4 border-b border-gray-200 pb-2">À propos de cet événement</h2>
                    <p class="text-gray-600 leading-relaxed whitespace-pre-wrap text-lg">${evenement.description}</p>
                </div>

                <c:if test="${not empty mesBillets}">
                    <div class="mt-8">
                        <h2 class="font-bold text-2xl text-gray-900 mb-6 border-b border-gray-200 pb-2">Mes Billets pour cet événement</h2>
                        <div class="flex flex-col gap-3">
                            <c:forEach var="billet" items="${mesBillets}">
                                <div class="flex items-center justify-between border border-gray-200 p-4 rounded-sm bg-white shadow-sm hover:border-primary-500 transition-colors">
                                    <div>
                                        <div class="text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Code du billet</div>
                                        <code class="text-lg font-bold text-gray-900 bg-gray-100 px-2 py-0.5 rounded-sm">${billet.code}</code>
                                    </div>
                                    <c:choose>
                                        <c:when test="${billet.statut == 'ACTIF'}">
                                            <span class="bg-green-100 text-green-800 border border-green-200 px-3 py-1 text-xs font-bold uppercase rounded-sm">Actif</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="bg-gray-100 text-gray-600 border border-gray-200 px-3 py-1 text-xs font-bold uppercase rounded-sm">Utilisé</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </c:if>
            </div>

            <div class="lg:col-span-1">
                <div class="bg-white border border-gray-200 rounded-sm p-6 shadow-sm sticky top-24">
                    <h3 class="font-bold text-xl text-gray-900 mb-6 uppercase tracking-wide border-b border-gray-200 pb-2">Billetterie</h3>

                    <c:choose>
                        <c:when test="${billetsSold >= evenement.capacite}">
                            <div class="bg-red-50 border border-red-200 text-red-700 font-bold p-4 text-center rounded-sm uppercase tracking-wide">
                                Cet événement est complet.
                            </div>
                        </c:when>

                        <c:otherwise>
                            <c:if test="${param.error == 'complet'}">
                                <div class="bg-red-50 border border-red-200 p-3 mb-6 rounded-sm">
                                    <p class="text-red-700 font-bold text-sm text-center">La quantité demandée dépasse la capacité restante.</p>
                                </div>
                            </c:if>

                            <form action="${pageContext.request.contextPath}/paiement" method="GET" class="flex flex-col gap-5">
                                <input type="hidden" name="idEvenement" value="${evenement.id}">

                                <div>
                                    <label for="typePlace" class="block text-sm font-bold text-gray-900 mb-2 uppercase">Type de Billet</label>
                                    <select id="typePlace" name="typePlace" class="w-full p-3 bg-gray-50 border border-gray-300 rounded-sm focus:border-primary-500 outline-none appearance-none font-semibold text-gray-900 cursor-pointer">
                                        <option value="standard">Standard - ${evenement.prixStandard} MAD</option>
                                        <option value="vip">VIP - ${evenement.prixVip} MAD</option>
                                    </select>
                                </div>

                                <div>
                                    <label for="quantite" class="block text-sm font-bold text-gray-900 mb-2 uppercase">Quantité</label>
                                    <input type="number" id="quantite" name="quantite" value="1" min="1" max="${evenement.capacite - billetsSold}" class="w-full p-3 bg-gray-50 border border-gray-300 rounded-sm focus:border-primary-500 outline-none font-bold text-gray-900 text-lg" required>
                                </div>

                                <c:choose>
                                    <c:when test="${not empty sessionScope.user}">
                                        <button type="submit" class="w-full mt-2 bg-primary-500 hover:bg-[#C1122B] text-white font-bold uppercase tracking-widest py-4 rounded-sm transition-colors text-sm">
                                            Acheter des billets
                                        </button>
                                    </c:when>
                                    <c:otherwise>
                                        <a href="${pageContext.request.contextPath}/login.jsp" class="w-full mt-2 inline-flex justify-center items-center bg-gray-900 hover:bg-gray-800 text-white font-bold uppercase tracking-widest py-4 rounded-sm transition-colors text-sm text-center">
                                            Connectez-vous pour acheter
                                        </a>
                                    </c:otherwise>
                                </c:choose>
                            </form>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </main>
</body>
</html>