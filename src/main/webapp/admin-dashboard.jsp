<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr" class="antialiased">
<head>
    <meta charset="UTF-8">
    <title>Administration - EventTix</title>
</head>
<body class="flex min-h-screen flex-col text-gray-900 bg-gray-50">
    <jsp:include page="/nav.jsp" />

    <main class="flex-1 w-full max-w-7xl mx-auto px-5 py-10 lg:py-16">

        <div class="mb-10 border-b border-gray-200 pb-6">
            <h1 class="font-bold text-3xl md:text-4xl text-gray-950 mb-2">Panel d'Administration</h1>
            <p class="text-gray-500 font-medium">Gérez la plateforme, les utilisateurs et analysez les métriques globales.</p>
        </div>

        <div class="mb-8 space-y-4">
            <c:if test="${param.success == 'created'}">
                <div class="bg-green-50 border-l-4 border-green-500 p-4 rounded-r-md">
                    <p class="text-green-800 font-bold">Utilisateur créé avec succès.</p>
                </div>
            </c:if>
            <c:if test="${param.success == 'deleted'}">
                <div class="bg-green-50 border-l-4 border-green-500 p-4 rounded-r-md">
                    <p class="text-green-800 font-bold">Utilisateur supprimé.</p>
                </div>
            </c:if>
            <c:if test="${param.success == 'roleChanged'}">
                <div class="bg-green-50 border-l-4 border-green-500 p-4 rounded-r-md">
                    <p class="text-green-800 font-bold">Rôle mis à jour avec succès.</p>
                </div>
            </c:if>
            <c:if test="${param.error == 'self'}">
                <div class="bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                    <p class="text-red-800 font-bold">Vous ne pouvez pas modifier ou supprimer votre propre compte.</p>
                </div>
            </c:if>
            <c:if test="${param.error == 'emailExists'}">
                <div class="bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                    <p class="text-red-800 font-bold">Cet email est déjà utilisé.</p>
                </div>
            </c:if>
            <c:if test="${param.error == 'missing'}">
                <div class="bg-red-50 border-l-4 border-red-500 p-4 rounded-r-md">
                    <p class="text-red-800 font-bold">Tous les champs obligatoires doivent être remplis.</p>
                </div>
            </c:if>
        </div>

        <div class="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-5 gap-4 mb-10">
            <div class="bg-white border border-gray-200 rounded-xl p-6 text-center shadow-sm">
                <div class="font-black text-4xl text-primary-500 mb-1">${totalUtilisateurs}</div>
                <div class="text-xs font-bold text-gray-500 uppercase tracking-widest">Utilisateurs</div>
            </div>
            <div class="bg-white border border-gray-200 rounded-xl p-6 text-center shadow-sm">
                <div class="font-black text-4xl text-primary-500 mb-1">${totalEvenements}</div>
                <div class="text-xs font-bold text-gray-500 uppercase tracking-widest">Événements</div>
            </div>
            <div class="bg-white border border-gray-200 rounded-xl p-6 text-center shadow-sm">
                <div class="font-black text-4xl text-primary-500 mb-1">${totalCommandes}</div>
                <div class="text-xs font-bold text-gray-500 uppercase tracking-widest">Commandes</div>
            </div>
            <div class="bg-white border border-gray-200 rounded-xl p-6 text-center shadow-sm">
                <div class="font-black text-4xl text-primary-500 mb-1">${nbOrganisateurs}</div>
                <div class="text-xs font-bold text-gray-500 uppercase tracking-widest">Organisateurs</div>
            </div>
            <div class="bg-white border border-gray-200 rounded-xl p-6 text-center shadow-sm">
                <div class="font-black text-4xl text-primary-500 mb-1">${nbAgents}</div>
                <div class="text-xs font-bold text-gray-500 uppercase tracking-widest">Agents</div>
            </div>
        </div>

        <div class="bg-white border border-gray-200 rounded-xl shadow-sm overflow-hidden">

            <div class="p-6 md:p-8 flex flex-col md:flex-row justify-between items-start md:items-center border-b border-gray-100 gap-4">
                <h2 class="font-bold text-2xl text-gray-900">Utilisateurs Inscrits</h2>
                <button onclick="document.getElementById('addUserModal').classList.remove('hidden')" class="inline-flex items-center justify-center rounded-full font-bold uppercase tracking-wide text-white bg-gray-900 hover:bg-gray-800 transition-colors h-11 px-6 text-sm">
                    + Ajouter un Utilisateur
                </button>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50 border-b border-gray-200">
                            <th class="p-4 px-6 text-xs font-bold text-gray-500 uppercase tracking-widest">ID</th>
                            <th class="p-4 px-6 text-xs font-bold text-gray-500 uppercase tracking-widest">Nom Complet</th>
                            <th class="p-4 px-6 text-xs font-bold text-gray-500 uppercase tracking-widest">Email</th>
                            <th class="p-4 px-6 text-xs font-bold text-gray-500 uppercase tracking-widest">Rôle</th>
                            <th class="p-4 px-6 text-xs font-bold text-gray-500 uppercase tracking-widest text-right">Actions</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100">
                        <c:forEach var="user" items="${utilisateurs}">
                            <tr class="hover:bg-gray-50/50 transition-colors group">
                                <td class="p-4 px-6 text-gray-400 font-medium">#${user.id}</td>
                                <td class="p-4 px-6 font-bold text-gray-900">${user.nom} ${user.prenom}</td>
                                <td class="p-4 px-6 text-gray-600">${user.email}</td>
                                <td class="p-4 px-6">
                                    <c:choose>
                                        <c:when test="${user.role == 'ADMIN'}">
                                            <span class="inline-block bg-red-100 text-red-700 font-bold text-[11px] uppercase tracking-widest px-2 py-1 rounded">Admin</span>
                                        </c:when>
                                        <c:when test="${user.role == 'ORGANISATEUR'}">
                                            <span class="inline-block bg-blue-100 text-blue-700 font-bold text-[11px] uppercase tracking-widest px-2 py-1 rounded">Organisateur</span>
                                        </c:when>
                                        <c:when test="${user.role == 'AGENT_CONTROLE'}">
                                            <span class="inline-block bg-yellow-100 text-yellow-800 font-bold text-[11px] uppercase tracking-widest px-2 py-1 rounded">Agent</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="inline-block bg-green-100 text-green-700 font-bold text-[11px] uppercase tracking-widest px-2 py-1 rounded">Participant</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="p-4 px-6 text-right">
                                    <div class="flex justify-end items-center gap-3">
                                        <button onclick="toggleEdit(${user.id})" class="text-sm font-bold text-primary-500 hover:text-[#C1122B] transition-colors">Éditer</button>

                                        <form method="post" action="${pageContext.request.contextPath}/admin" class="m-0" onsubmit="return confirm('Supprimer ${user.nom} ${user.prenom} ? Cette action est irréversible.')">
                                            <input type="hidden" name="action" value="deleteUser">
                                            <input type="hidden" name="userId" value="${user.id}">
                                            <button type="submit" class="text-sm font-bold text-red-600 hover:text-red-800 transition-colors">Supprimer</button>
                                        </form>
                                    </div>

                                    <form method="post" action="${pageContext.request.contextPath}/admin" id="editForm_${user.id}" class="hidden mt-3 bg-white border border-gray-200 p-3 rounded-lg shadow-sm">
                                        <div class="flex flex-col sm:flex-row gap-2">
                                            <input type="hidden" name="action" value="changeRole">
                                            <input type="hidden" name="userId" value="${user.id}">

                                            <select name="role" class="flex-1 bg-gray-50 border border-gray-200 text-gray-900 text-sm font-bold rounded-md px-3 py-2 outline-none focus:border-primary-500">
                                                <option value="PARTICIPANT" ${user.role == 'PARTICIPANT' ? 'selected' : ''}>Participant</option>
                                                <option value="AGENT_CONTROLE" ${user.role == 'AGENT_CONTROLE' ? 'selected' : ''}>Agent</option>
                                                <option value="ORGANISATEUR" ${user.role == 'ORGANISATEUR' ? 'selected' : ''}>Organisateur</option>
                                                <option value="ADMIN" ${user.role == 'ADMIN' ? 'selected' : ''}>Admin</option>
                                            </select>

                                            <button type="submit" class="bg-primary-500 text-white font-bold text-xs uppercase tracking-wide px-4 py-2 rounded-md hover:bg-primary-300 transition-colors">Sauver</button>
                                            <button type="button" onclick="toggleEdit(${user.id})" class="bg-gray-100 text-gray-600 font-bold text-xs uppercase tracking-wide px-4 py-2 rounded-md hover:bg-gray-200 transition-colors">Annuler</button>
                                        </div>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty utilisateurs}">
                            <tr>
                                <td colspan="5" class="p-12 text-center text-gray-500 font-medium">Aucun utilisateur trouvé.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <div id="addUserModal" class="hidden fixed inset-0 z-50 bg-gray-900/50 flex items-center justify-center p-4 backdrop-blur-sm transition-opacity">
        <div class="bg-white rounded-xl shadow-2xl w-full max-w-md overflow-hidden" onclick="event.stopPropagation()">

            <div class="flex justify-between items-center p-6 border-b border-gray-100">
                <h2 class="font-bold text-xl text-gray-900">Ajouter un Utilisateur</h2>
                <button onclick="document.getElementById('addUserModal').classList.add('hidden')" class="text-gray-400 hover:text-gray-600 text-2xl leading-none">&times;</button>
            </div>

            <form method="post" action="${pageContext.request.contextPath}/admin" accept-charset="UTF-8" class="p-6 flex flex-col gap-4">
                <input type="hidden" name="action" value="createUser">

                <div class="grid grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-1">Nom *</label>
                        <input type="text" name="nom" class="w-full bg-gray-50 border border-gray-200 focus:border-primary-500 rounded-md px-3 py-2 text-sm font-medium outline-none transition-colors" required>
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-1">Prénom</label>
                        <input type="text" name="prenom" class="w-full bg-gray-50 border border-gray-200 focus:border-primary-500 rounded-md px-3 py-2 text-sm font-medium outline-none transition-colors">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-1">Email *</label>
                    <input type="email" name="email" class="w-full bg-gray-50 border border-gray-200 focus:border-primary-500 rounded-md px-3 py-2 text-sm font-medium outline-none transition-colors" required>
                </div>

                <div>
                    <label class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-1">Mot de passe *</label>
                    <input type="password" name="password" class="w-full bg-gray-50 border border-gray-200 focus:border-primary-500 rounded-md px-3 py-2 text-sm font-medium outline-none transition-colors" required minlength="6">
                </div>

                <div>
                    <label class="block text-xs font-bold text-gray-900 uppercase tracking-wide mb-1">Rôle *</label>
                    <select name="role" class="w-full bg-gray-50 border border-gray-200 focus:border-primary-500 rounded-md px-3 py-2 text-sm font-bold text-gray-900 outline-none transition-colors cursor-pointer appearance-none">
                        <option value="PARTICIPANT">Participant</option>
                        <option value="AGENT_CONTROLE">Agent de contrôle</option>
                        <option value="ORGANISATEUR">Organisateur</option>
                        <option value="ADMIN">Admin</option>
                    </select>
                </div>

                <button type="submit" class="w-full mt-4 bg-primary-500 hover:bg-[#C1122B] text-white font-bold uppercase tracking-widest py-3 rounded-full transition-colors text-sm">
                    Créer l'utilisateur
                </button>
            </form>
        </div>
    </div>

    <script>
        function toggleEdit(userId) {
            const form = document.getElementById('editForm_' + userId);
            form.classList.toggle('hidden');
            form.classList.toggle('flex');
        }

        // Fermer la modale si on clique à l'extérieur
        document.getElementById('addUserModal').addEventListener('click', function(e) {
            if (e.target === this) {
                this.classList.add('hidden');
            }
        });
    </script>
</body>
</html>