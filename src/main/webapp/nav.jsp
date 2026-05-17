<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<script src="https://cdn.tailwindcss.com"></script>
<script>
  tailwind.config = {
    theme: {
      extend: {
        colors: {
          primary: { 300: '#ff4d4f', 500: '#E31837' }, // Tickets.ca exact red
          foreground: '#111111'
        }
      }
    }
  }
</script>

<header class="top-0 z-30 w-full transition-colors duration-200 sticky bg-white text-gray-950 border-b border-gray-200 shadow-sm">
    <div class="mx-auto flex min-h-20 items-center justify-between gap-8 px-6 max-w-7xl">

        <div class="flex-1">
            <div class="flex items-center gap-8">
                <a rel="home" href="${pageContext.request.contextPath}/index.jsp" class="flex items-center gap-2">
                    <span style="font-size: 26px; font-weight: 900; color: #111; letter-spacing: -1px; font-family: sans-serif;">
                        EVENT<span style="color: #E31837;">TIX</span>
                    </span>
                </a>

                <div class="font-semibold hidden lg:block">
                    <ul class="flex items-center justify-center gap-6">
                        <c:if test="${empty sessionScope.user or sessionScope.user.role != 'AGENT_CONTROLE'}">
                            <li><a class="opacity-80 hover:opacity-100 transition-opacity" href="${pageContext.request.contextPath}/index.jsp">Accueil</a></li>
                            <li><a class="opacity-80 hover:opacity-100 transition-opacity" href="${pageContext.request.contextPath}/EvenementController?action=search">Catalogue</a></li>
                        </c:if>
                    </ul>
                </div>
            </div>
        </div>

        <div class="flex-1">
            <div class="flex items-center justify-end gap-6 font-semibold">

                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <ul class="flex items-center justify-center gap-6">
                            <c:choose>
                                <c:when test="${sessionScope.user.role == 'ADMIN'}">
                                    <li><a class="opacity-80 hover:opacity-100 text-primary-500" href="${pageContext.request.contextPath}/admin-dashboard.jsp">Panel Admin</a></li>
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'ORGANISATEUR'}">
                                    <li><a class="opacity-80 hover:opacity-100 text-primary-500" href="${pageContext.request.contextPath}/dashboard.jsp">Espace Organisateur</a></li>
                                </c:when>
                                <c:when test="${sessionScope.user.role == 'AGENT_CONTROLE'}">
                                    <li><a class="opacity-80 hover:opacity-100 text-primary-500" href="${pageContext.request.contextPath}/scanner.jsp">Scanner d'Accès</a></li>
                                </c:when>
                                <c:otherwise>
                                    <li><a class="opacity-80 hover:opacity-100 text-primary-500" href="${pageContext.request.contextPath}/BilletController?action=mesBillets">Mes Billets</a></li>
                                </c:otherwise>
                            </c:choose>
                        </ul>

                        <span class="text-sm text-gray-500 border-l border-gray-300 pl-6">${sessionScope.user.prenom}</span>

                        <form action="${pageContext.request.contextPath}/AuthController" method="POST" class="m-0">
                            <input type="hidden" name="action" value="logout">
                            <button type="submit" class="inline-flex items-center rounded-full justify-center whitespace-nowrap font-semibold outline-none h-11 text-base text-gray-950 bg-gray-100 hover:bg-gray-200 px-5 transition-colors">
                                Déconnexion
                            </button>
                        </form>
                    </c:when>

                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="opacity-80 hover:opacity-100">Se connecter</a>

                        <a href="${pageContext.request.contextPath}/register" class="inline-flex items-center rounded-full justify-center whitespace-nowrap font-semibold outline-none h-11 text-base text-white bg-primary-500 hover:bg-primary-300 px-5 transition-colors">
                            S'inscrire
                        </a>
                    </c:otherwise>
                </c:choose>

            </div>
        </div>
    </div>
</header>