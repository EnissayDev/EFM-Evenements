<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Mes Billets - EventTix</title>
</head>
<body class="flex min-h-screen flex-col overflow-x-hidden text-gray-900 bg-white">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 w-full max-w-7xl mx-auto px-5 py-10 lg:py-16">

        <div class="mb-10">
            <h1 class="font-bold text-3xl md:text-4xl text-gray-950 mb-2">Mes Billets</h1>
            <p class="text-gray-500 font-medium">Gérez vos réservations et affichez vos QR codes d'accès.</p>
        </div>

        <div class="bg-white border border-gray-200 rounded-xl p-3 mb-10 shadow-sm">
            <form action="${pageContext.request.contextPath}/BilletController" method="GET" class="flex flex-col md:flex-row gap-2">
                <input type="hidden" name="action" value="mesBillets">

                <div class="flex-grow">
                    <input type="text" name="search" class="live-search w-full h-12 rounded-lg bg-gray-50 px-4 font-semibold text-gray-900 hover:bg-gray-100 outline-none focus:ring-2 focus:ring-primary-500 transition-colors" placeholder="Rechercher un événement..." value="${param.search}">
                </div>

                <div class="md:w-64">
                    <select name="filter" onchange="this.form.submit()" class="w-full h-12 rounded-lg bg-gray-50 px-4 font-semibold text-gray-900 hover:bg-gray-100 outline-none focus:ring-2 focus:ring-primary-500 appearance-none cursor-pointer transition-colors">
                        <option value="newest" ${param.filter == 'newest' ? 'selected' : ''}>Achats récents</option>
                        <option value="oldest" ${param.filter == 'oldest' ? 'selected' : ''}>Achats anciens</option>
                        <option value="soon" ${param.filter == 'soon' ? 'selected' : ''}>Événements à venir</option>
                        <option value="later" ${param.filter == 'later' ? 'selected' : ''}>Événements lointains</option>
                        <option value="actif" ${param.filter == 'actif' ? 'selected' : ''}>Billets Valides</option>
                        <option value="inactif" ${param.filter == 'inactif' ? 'selected' : ''}>Billets Consommés</option>
                    </select>
                </div>
            </form>
        </div>

        <div class="flex flex-col gap-4">
            <c:if test="${empty billets}">
                <div class="text-center py-20 border border-gray-200 rounded-xl bg-gray-50">
                    <h3 class="font-bold text-xl text-gray-900 mb-2">Aucun billet trouvé</h3>
                    <p class="text-gray-500 font-medium mb-6">Vous n'avez pas de billets correspondant à ces critères.</p>
                    <a href="${pageContext.request.contextPath}/EvenementController?action=search" class="inline-flex items-center rounded-full justify-center whitespace-nowrap font-semibold h-11 px-6 text-white bg-primary-500 hover:bg-primary-300 transition-colors">
                        Découvrir des événements
                    </a>
                </div>
            </c:if>

            <c:forEach var="billet" items="${billets}">
                <div class="flex flex-col md:flex-row justify-between items-start md:items-center p-6 border ${billet.statut == 'VALIDE' ? 'border-gray-200' : 'border-gray-200 bg-gray-50 opacity-75'} rounded-xl transition-shadow hover:shadow-md relative overflow-hidden">

                    <div class="absolute left-0 top-0 bottom-0 w-1 ${billet.statut == 'VALIDE' ? 'bg-primary-500' : 'bg-gray-300'}"></div>

                    <div class="pl-3 flex-1 mb-4 md:mb-0">
                        <div class="mb-2">
                            <c:choose>
                                <c:when test="${billet.statut == 'VALIDE'}">
                                    <span class="text-xs font-bold uppercase tracking-wider text-green-700 bg-green-100 px-2 py-1 rounded">Valide</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="text-xs font-bold uppercase tracking-wider text-gray-600 bg-gray-200 px-2 py-1 rounded">Consommé</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <h2 class="font-bold text-xl text-gray-950 mb-1">${billet.evenementTitre}</h2>
                        <p class="text-primary-500 font-semibold text-sm uppercase tracking-wide mb-2">${billet.dateEvenement}</p>
                        <p class="text-gray-500 text-sm font-medium mb-3">${billet.lieu}</p>

                        <div class="inline-block bg-gray-100 px-3 py-1.5 rounded-md text-sm font-semibold text-gray-700">
                            <span class="uppercase">${billet.typePlace}</span> &bull; ${billet.prixPaye} MAD
                        </div>
                    </div>

                    <div class="w-full md:w-auto pl-3 md:pl-0">
                        <form action="${pageContext.request.contextPath}/BilletController" method="GET" class="m-0">
                            <input type="hidden" name="action" value="viewQR">
                            <input type="hidden" name="idBillet" value="${billet.id}">
                            <button type="submit" class="w-full md:w-auto inline-flex items-center rounded-full justify-center font-semibold h-11 px-8 transition-colors ${billet.statut == 'VALIDE' ? 'text-white bg-primary-500 hover:bg-primary-300' : 'text-gray-900 bg-gray-200 hover:bg-gray-300'}">
                                ${billet.statut == 'VALIDE' ? 'Voir le Billet' : 'Détails'}
                            </button>
                        </form>
                    </div>
                </div>
            </c:forEach>
        </div>
    </main>

    <script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>