<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Billets pour Concerts, Sports, Arts - EventTix</title>
</head>
<body class="flex min-h-screen flex-col overflow-x-hidden text-gray-900 bg-white">
    <jsp:include page="/nav.jsp" />

    <main id="main">
        <section class="relative">
            <div class="bg-gray-950 text-white" style="background:#0E1E49; color:#FFFFFF">
                <div class="relative z-0 mx-auto max-w-7xl gap-6 pt-24 pb-20 px-5 text-center flex flex-col items-center justify-center min-h-[40vh]">

                    <h1 class="font-bold text-[2rem]/none md:text-4xl/none lg:text-[2.75rem]/none xl:text-5xl/none text-balance mb-4">
                        Trouvez vos billets
                    </h1>
                    <p class="text-balance sm:text-lg md:text-xl font-semibold mb-10 opacity-90">
                        Des milliers d'événements vous attendent.
                    </p>

                    <div class="w-full max-w-4xl relative mx-auto flex flex-col gap-2 rounded-3xl md:rounded-full bg-white p-2 shadow-lg md:flex-row">
                        <form action="${pageContext.request.contextPath}/EvenementController" method="GET" class="flex flex-col md:flex-row w-full gap-2">
                            <input type="hidden" name="action" value="search">

                            <input type="text" name="keyword" class="live-search flex h-12 md:h-14 w-full flex-1 cursor-text items-center truncate whitespace-nowrap rounded-full bg-gray-50 px-6 font-semibold text-gray-900 hover:bg-gray-100 outline-none focus:ring-2 focus:ring-primary-500" placeholder="Artiste, équipe ou événement..." value="${param.keyword}">

                            <select name="lieu" onchange="this.form.submit()" class="live-search flex h-12 md:h-14 w-full md:w-48 cursor-pointer items-center truncate rounded-full bg-gray-50 px-6 font-semibold text-gray-900 hover:bg-gray-100 outline-none focus:ring-2 focus:ring-primary-500 appearance-none">
                                <option value="">Toutes les villes</option>
                                <c:forEach var="ville" items="${villesExistantes}">
                                    <option value="${ville}" ${param.lieu == ville ? 'selected' : ''}>${ville}</option>
                                </c:forEach>
                                <c:if test="${empty villesExistantes}">
                                    <option value="Casablanca" ${param.lieu == 'Casablanca' ? 'selected' : ''}>Casablanca</option>
                                    <option value="Rabat" ${param.lieu == 'Rabat' ? 'selected' : ''}>Rabat</option>
                                    <option value="Marrakech" ${param.lieu == 'Marrakech' ? 'selected' : ''}>Marrakech</option>
                                    <option value="Tanger" ${param.lieu == 'Tanger' ? 'selected' : ''}>Tanger</option>
                                </c:if>
                            </select>

                            <select name="category" onchange="this.form.submit()" class="live-search flex h-12 md:h-14 w-full md:w-48 cursor-pointer items-center truncate rounded-full bg-gray-50 px-6 font-semibold text-gray-900 hover:bg-gray-100 outline-none focus:ring-2 focus:ring-primary-500 appearance-none">
                                <option value="">Catégories</option>
                                <c:forEach var="cat" items="${categoriesExistantes}">
                                    <option value="${cat}" ${param.category == cat ? 'selected' : ''}>${cat}</option>
                                </c:forEach>
                                <c:if test="${empty categoriesExistantes}">
                                    <option value="Musique" ${param.category == 'Musique' ? 'selected' : ''}>Musique</option>
                                    <option value="Sport" ${param.category == 'Sport' ? 'selected' : ''}>Sport</option>
                                    <option value="Art" ${param.category == 'Art' ? 'selected' : ''}>Art & Culture</option>
                                </c:if>
                            </select>

                            <button type="submit" class="inline-flex flex-none items-center rounded-full justify-center whitespace-nowrap font-semibold outline-none h-12 md:h-14 text-base text-white bg-primary-500 hover:bg-primary-300 px-8 transition-colors">
                                Rechercher
                            </button>
                        </form>
                    </div>

                </div>
            </div>
        </section>

        <section class="mx-auto flex flex-col gap-9 py-16 xl:gap-12 w-full max-w-7xl px-5">
            <h2 class="font-bold text-[2rem]/none md:text-3xl/none text-balance">Événements à la une</h2>

            <div class="grid w-full grid-cols-1 gap-8 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4">

                <c:if test="${empty evenements}">
                    <div class="col-span-full text-center py-20 border border-gray-200 rounded-xl bg-gray-50">
                        <p class="font-semibold text-lg text-gray-500">Aucun événement ne correspond à votre recherche.</p>
                    </div>
                </c:if>

                <c:forEach var="evenement" items="${evenements}">
                    <a class="group flex gap-2 text-left flex-col lg:gap-4" href="${pageContext.request.contextPath}/EvenementController?action=details&id=${evenement.id}">
                        <div class="relative aspect-video w-full flex-none overflow-clip rounded-lg bg-gray-100">
                            <img alt="${evenement.titre}" loading="lazy" class="max-w-full transform-cpu transition duration-300 ease-in-out size-full object-cover group-hover:scale-110" src="${not empty evenement.imagePath ? pageContext.request.contextPath.concat('/').concat(evenement.imagePath) : 'https://images.unsplash.com/photo-1540039155732-d68a916abda3?auto=format&fit=crop&q=80&w=600'}">
                        </div>

                        <div class="flex flex-1 flex-col justify-start gap-1">
                            <span class="text-primary-500 font-bold text-sm uppercase tracking-wider">${evenement.date}</span>
                            <h3 class="font-bold text-lg leading-tight line-clamp-2 text-gray-900 group-hover:text-primary-500 transition-colors">
                                ${evenement.titre}
                            </h3>
                            <div class="truncate text-sm text-gray-500 mt-1">${evenement.lieu} • ${evenement.categorie}</div>
                        </div>
                    </a>
                </c:forEach>

            </div>
        </section>
    </main>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const searchInputs = document.querySelectorAll('.live-search');
            let timeout;
            searchInputs.forEach(input => {
                input.addEventListener('input', function() {
                    clearTimeout(timeout);
                    timeout = setTimeout(() => this.closest('form').submit(), 800);
                });
            });
        });
    </script>
</body>
</html>