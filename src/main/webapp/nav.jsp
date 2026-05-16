<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<header style="background-color: var(--white); border-bottom: 1px solid var(--border-color); padding: 15px 0; position: sticky; top: 0; z-index: 100;">
    <div class="container header-content" style="display: flex; justify-content: space-between; align-items: center;">
        <a href="${pageContext.request.contextPath}/index.jsp" class="logo" style="font-size: 24px; font-weight: 800; color: var(--primary-orange); text-decoration: none;">EventTix</a>

        <nav style="display: flex; align-items: center; gap: 15px;">
            <a href="${pageContext.request.contextPath}/catalogue.jsp" style="color: var(--text-dark); font-weight: 600; text-decoration: none;">Événements</a>

            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <c:if test="${sessionScope.user.role == 'ADMIN'}">
                        <a href="${pageContext.request.contextPath}/admin-dashboard.jsp" class="btn btn-outline" style="padding: 8px 16px;">Panel Admin</a>
                    </c:if>
                    <c:if test="${sessionScope.user.role == 'ORGANISATEUR'}">
                        <a href="${pageContext.request.contextPath}/dashboard.jsp" class="btn btn-outline" style="padding: 8px 16px;">Mon Dashboard</a>
                    </c:if>
                    <c:if test="${sessionScope.user.role == 'AGENT_CONTROLE'}">
                        <a href="${pageContext.request.contextPath}/scanner.jsp" class="btn btn-outline" style="padding: 8px 16px;">Ouvrir Scanner</a>
                    </c:if>

                    <span style="color: var(--text-muted); margin-left: 10px;">Salut, ${sessionScope.user.prenom}</span>

                    <form action="${pageContext.request.contextPath}/AuthController" method="POST" style="margin: 0;">
                        <input type="hidden" name="action" value="logout">
                        <button type="submit" class="btn" style="background-color: #1e0a3c; padding: 8px 16px;">Déconnexion</button>
                    </form>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline" style="padding: 8px 16px;">Connexion</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn" style="padding: 8px 16px;">S'inscrire</a>
                </c:otherwise>
            </c:choose>
        </nav>
    </div>
</header>