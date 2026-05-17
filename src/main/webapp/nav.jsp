<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<header style="background-color: var(--white); border-bottom: 1px solid var(--border-color); padding: 15px 0; position: sticky; top: 0; z-index: 100;">
    <div class="container header-content" style="display: flex; justify-content: space-between; align-items: center;">

        <a href="${pageContext.request.contextPath}/" class="logo" style="font-size: 24px; font-weight: 800; color: var(--primary-orange); text-decoration: none;">EventTix</a>

        <nav style="display: flex; align-items: center; gap: 20px;">

            <c:if test="${sessionScope.user.role != 'AGENT_CONTROLE'}">
                <a href="${pageContext.request.contextPath}/" style="color: var(--text-dark); font-weight: 600; text-decoration: none;">Accueil</a>
                <a href="${pageContext.request.contextPath}/catalogue" style="color: var(--text-dark); font-weight: 600; text-decoration: none;">Catalogue</a>
            </c:if>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <div style="border-left: 2px solid var(--border-color); height: 24px; margin: 0 10px;"></div>

                    <c:choose>
                        <c:when test="${sessionScope.user.role == 'ADMIN'}">
                            <a href="${pageContext.request.contextPath}/admin-dashboard.jsp" style="color: #d10000; font-weight: bold; text-decoration: none;">⚙️ Panel Admin</a>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'ORGANISATEUR'}">
                            <a href="${pageContext.request.contextPath}/dashboard.jsp" style="color: var(--primary-orange); font-weight: bold; text-decoration: none;">📊 Mon Dashboard</a>
                        </c:when>
                        <c:when test="${sessionScope.user.role == 'AGENT_CONTROLE'}">
                            <a href="${pageContext.request.contextPath}/scanner.jsp" style="color: var(--primary-orange); font-weight: bold; text-decoration: none;">📷 Scanner de Billets</a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/BilletController?action=mesBillets" style="color: var(--text-dark); font-weight: bold; text-decoration: none;">🎟️ Mes Billets</a>
                        </c:otherwise>
                    </c:choose>

                    <span style="color: var(--text-muted); font-weight: 500; margin-left: 10px;">👤 ${sessionScope.user.prenom}</span>

                    <form action="${pageContext.request.contextPath}/AuthController" method="POST" style="margin: 0; margin-left: 10px;">
                        <input type="hidden" name="action" value="logout">
                        <button type="submit" class="btn btn-outline" style="padding: 8px 16px;">Déconnexion</button>
                    </form>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline" style="padding: 8px 16px;">Connexion</a>
                    <a href="${pageContext.request.contextPath}/register.jsp" class="btn" style="padding: 8px 16px;">S'inscrire</a>
                </c:otherwise>
            </c:choose>

        </nav>
    </div>
</header>