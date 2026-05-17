<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Espace Organisateur - EventTix</title>
</head>
<body class="flex min-h-screen flex-col overflow-x-hidden text-gray-900 bg-gray-50">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 w-full max-w-7xl mx-auto px-5 py-10 lg:py-16">

        <div class="mb-10 border-b border-gray-200 pb-6">
            <h1 class="font-bold text-3xl md:text-4xl text-gray-950 mb-2">Espace Organisateur</h1>
            <p class="text-gray-500 font-medium">Gérez vos événements, créez-en de nouveaux et suivez vos ventes.</p>
        </div>

        <c:if test="${not empty erreurMessage}">
            <div class="bg-red-50 border-l-4 border-red-500 p-4 mb-8 rounded-r-sm">
                <p class="text-red-800 font-bold">${erreurMessage}</p>
            </div>
        </c:if>
        <c:if test="${not empty successMessage}">
            <div class="bg-green-50 border-l-4 border-green-500 p-4 mb-8 rounded-r-sm">
                <p class="text-green-800 font-bold">${successMessage}</p>
            </div>
        </c:if>

        <div class="grid grid-cols-1 lg:grid-cols-12 gap-8 mb-12">

            <div class="lg:col-span-7 bg-white border border-gray-200 rounded-sm p-6 md:p-10 shadow-sm h-fit">
                <h2 class="font-bold text-2xl text-gray-900 mb-8 border-b border-gray-100 pb-4">➕ Nouvel Événement</h2>

                <form action="${pageContext.request.contextPath}/evenements" method="POST" accept-charset="UTF-8" enctype="multipart/form-data" class="flex flex-col gap-6">
                    <input type="hidden" name="action" value="create">

                    <div>
                        <label for="titre" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Titre de l'événement</label>
                        <input type="text" id="titre" name="titre" placeholder="Ex: Concert Symphonique..." class="w-full bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-sm px-4 py-3 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="date" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Date</label>
                            <input type="date" id="date" name="date" class="w-full bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-sm px-4 py-3 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                        </div>
                        <div>
                            <label for="capacite" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Capacité Totale (Billets)</label>
                            <input type="number" id="capacite" name="capacite" placeholder="Ex: 500" class="w-full bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-sm px-4 py-3 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="categorie" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Catégorie</label>
                            <select id="categorie" name="categorie" onchange="toggleCustomInput('categorie', 'customCategorie')" class="w-full bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-sm px-4 py-3 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors appearance-none cursor-pointer" required>
                                <c:forEach var="cat" items="${categoriesExistantes}">
                                    <option value="${cat}">${cat}</option>
                                </c:forEach>
                                <c:if test="${empty categoriesExistantes}">
                                    <option value="Musique">Musique</option>
                                    <option value="Technologie">Technologie</option>
                                    <option value="Sport">Sport</option>
                                    <option value="Art">Art & Culture</option>
                                </c:if>
                                <option value="Autre" class="font-bold text-primary-500">+ Ajouter une catégorie...</option>
                            </select>
                            <input type="text" id="customCategorie" name="customCategorie" placeholder="Entrez la catégorie..." class="hidden w-full mt-2 bg-white text-gray-900 border border-primary-500 rounded-sm px-4 py-2 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors">
                        </div>

                        <div>
                            <label for="lieu" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Lieu (Ville)</label>
                            <select id="lieu" name="lieu" onchange="toggleCustomInput('lieu', 'customLieu')" class="w-full bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-sm px-4 py-3 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors appearance-none cursor-pointer" required>
                                <c:forEach var="ville" items="${villesExistantes}">
                                    <option value="${ville}">${ville}</option>
                                </c:forEach>
                                <c:if test="${empty villesExistantes}">
                                    <option value="Casablanca">Casablanca</option>
                                    <option value="Rabat">Rabat</option>
                                    <option value="Marrakech">Marrakech</option>
                                    <option value="Tanger">Tanger</option>
                                    <option value="Agadir">Agadir</option>
                                    <option value="Oujda">Oujda</option>
                                </c:if>
                                <option value="Autre" class="font-bold text-primary-500">+ Ajouter une ville...</option>
                            </select>
                            <input type="text" id="customLieu" name="customLieu" placeholder="Entrez la ville..." class="hidden w-full mt-2 bg-white text-gray-900 border border-primary-500 rounded-sm px-4 py-2 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors">
                        </div>
                    </div>

                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label for="prixStandard" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Prix Standard (MAD)</label>
                            <input type="number" id="prixStandard" name="prixStandard" min="0" step="0.01" placeholder="0.00" class="w-full bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-sm px-4 py-3 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                        </div>
                        <div>
                            <label for="prixVip" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Prix VIP (MAD)</label>
                            <input type="number" id="prixVip" name="prixVip" min="0" step="0.01" placeholder="0.00" class="w-full bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-sm px-4 py-3 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors" required>
                        </div>
                    </div>

                    <div>
                        <label for="description" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Description</label>
                        <textarea id="description" name="description" rows="3" placeholder="Décrivez votre événement..." class="w-full bg-gray-50 text-gray-900 border border-gray-200 focus:border-primary-500 rounded-sm px-4 py-3 font-medium outline-none focus:ring-1 focus:ring-primary-500 transition-colors resize-y"></textarea>
                    </div>

                    <div>
                        <label for="imageEvent" class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-2">Affiche de l'événement</label>
                        <input type="file" id="imageEvent" name="imageEvent" accept="image/*" class="w-full bg-gray-50 border border-dashed border-gray-300 rounded-sm px-4 py-6 cursor-pointer hover:bg-gray-100 transition-colors">
                    </div>

                    <button type="submit" class="w-full mt-2 inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide h-14 text-white bg-primary-500 hover:bg-[#C1122B] transition-colors">
                        Publier l'événement
                    </button>
                </form>
            </div>

            <div class="lg:col-span-5 bg-white border border-gray-200 rounded-sm p-6 md:p-10 shadow-sm h-fit">
                <h2 class="font-bold text-2xl text-gray-900 mb-8 border-b border-gray-100 pb-4">📈 Dernières Ventes</h2>

                <c:if test="${empty commandes}">
                    <div class="text-center py-10 border border-dashed border-gray-200 bg-gray-50 rounded-sm">
                        <p class="text-gray-500 font-semibold">Aucune vente pour le moment.</p>
                    </div>
                </c:if>

                <ul class="flex flex-col">
                    <c:forEach var="commande" items="${commandes}">
                        <li class="flex justify-between items-center py-4 border-b border-gray-100 last:border-0">
                            <div class="flex-1 pr-4">
                                <strong class="block text-gray-900 font-bold leading-tight truncate">${commande.evenementTitre}</strong>
                                <span class="text-gray-500 font-medium text-sm">${commande.quantite} billets</span>
                            </div>
                            <div class="text-right">
                                <span class="block text-primary-500 font-black">${commande.montantTotal} MAD</span>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>

        <section class="bg-white border border-gray-200 rounded-sm p-6 md:p-10 shadow-sm">
            <div class="flex flex-col md:flex-row justify-between items-start md:items-center mb-8 border-b border-gray-100 pb-4 gap-4">
                <h2 class="font-bold text-2xl text-gray-900">Mes Événements Actifs</h2>

                <form action="${pageContext.request.contextPath}/dashboard" method="GET" class="flex w-full md:w-auto gap-2">
                    <input type="text" name="searchEvent" class="live-search h-11 w-full md:w-64 rounded-sm bg-gray-50 px-4 text-sm font-medium text-gray-900 border border-gray-200 focus:border-primary-500 outline-none" placeholder="Rechercher un événement..." value="${param.searchEvent}">

                    <select name="sortEvent" onchange="this.form.submit()" class="h-11 rounded-sm bg-gray-50 px-4 text-sm font-bold text-gray-900 border border-gray-200 focus:border-primary-500 outline-none appearance-none cursor-pointer">
                        <option value="dateDesc" ${param.sortEvent == 'dateDesc' ? 'selected' : ''}>Plus récents</option>
                        <option value="dateAsc" ${param.sortEvent == 'dateAsc' ? 'selected' : ''}>Plus anciens</option>
                        <option value="places" ${param.sortEvent == 'places' ? 'selected' : ''}>Places restantes</option>
                    </select>
                </form>
            </div>

            <div class="flex flex-col gap-4">
                <c:if test="${empty mesEvenements}">
                    <div class="text-center py-16 border border-dashed border-gray-200 bg-gray-50 rounded-sm">
                        <p class="text-gray-500 font-bold text-lg mb-2">Vous n'avez aucun événement actif.</p>
                        <p class="text-gray-400 text-sm">Utilisez le formulaire ci-dessus pour en créer un.</p>
                    </div>
                </c:if>

                <c:forEach var="ev" items="${mesEvenements}">
                    <c:set var="total" value="${ev.capacite}" />
                    <c:set var="vendus" value="${ev.billetsVendus != null ? ev.billetsVendus : 0}" />
                    <c:set var="restants" value="${total - vendus}" />

                    <div class="flex flex-col lg:flex-row justify-between border border-gray-200 p-5 rounded-sm hover:border-gray-300 transition-colors gap-6">

                        <div class="flex-1">
                            <h3 class="font-bold text-xl text-gray-900 mb-2 leading-tight">${ev.titre}</h3>
                            <div class="flex flex-wrap items-center gap-x-4 gap-y-2 text-sm text-gray-500 font-medium">
                                <span>📅 ${ev.date}</span>
                                <span class="hidden sm:block text-gray-300">|</span>
                                <span>📍 ${ev.lieu}</span>
                                <span class="hidden sm:block text-gray-300">|</span>
                                <span class="uppercase tracking-wider text-xs font-bold text-gray-900 bg-gray-100 px-2 py-1 rounded">${ev.categorie}</span>
                            </div>
                        </div>

                        <div class="flex gap-2 w-full lg:w-auto">
                            <div class="bg-gray-50 border border-gray-200 p-3 rounded-sm flex-1 text-center min-w-[90px]">
                                <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest mb-1">Total</p>
                                <p class="font-black text-xl text-gray-900">${total}</p>
                            </div>
                            <div class="bg-gray-50 border border-gray-200 p-3 rounded-sm flex-1 text-center min-w-[90px]">
                                <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest mb-1">Vendus</p>
                                <p class="font-black text-xl text-blue-600">${vendus}</p>
                            </div>
                            <div class="bg-gray-50 border border-gray-200 p-3 rounded-sm flex-1 text-center min-w-[90px]">
                                <p class="text-[10px] font-bold text-gray-500 uppercase tracking-widest mb-1">Reste</p>
                                <p class="font-black text-xl ${restants <= 0 ? 'text-red-500' : 'text-green-600'}">${restants}</p>
                            </div>
                        </div>

                        <div class="flex items-center justify-end w-full lg:w-auto">
                            <a href="${pageContext.request.contextPath}/EvenementController?action=details&id=${ev.id}" class="w-full lg:w-auto inline-flex items-center justify-center font-bold uppercase tracking-wide text-gray-900 bg-white border border-gray-300 hover:bg-gray-50 h-14 lg:h-full px-6 rounded-sm transition-colors text-xs">
                                Voir la page
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </section>

    </main>

    <script>
        function toggleCustomInput(selectId, inputId) {
            const selectElement = document.getElementById(selectId);
            const inputElement = document.getElementById(inputId);

            if (selectElement.value === 'Autre') {
                inputElement.classList.remove('hidden');
                inputElement.setAttribute('required', 'required');
            } else {
                inputElement.classList.add('hidden');
                inputElement.removeAttribute('required');
                inputElement.value = ''; // On vide le champ si l'utilisateur change d'avis
            }
        }

        // Script pour la recherche automatique (Live Search)
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