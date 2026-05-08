<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Administration - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-layout { margin-top: 40px; }

        /* Specific styles for the Admin Data Table to make it look professional */
        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        .data-table th, .data-table td {
            text-align: left;
            padding: 12px 15px;
            border-bottom: 1px solid var(--border-color);
        }
        .data-table th {
            background-color: var(--bg-light);
            color: var(--text-muted);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 12px;
        }
        .data-table tr:hover { background-color: #fcfcfd; }

        /* Badge styling for roles */
        .badge {
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: bold;
        }
        .badge-admin { background-color: #ffe0e0; color: #d10000; }
        .badge-org { background-color: #e0f2fe; color: #0284c7; }
        .badge-agent { background-color: #fef08a; color: #a16207; }
        .badge-client { background-color: #dcfce7; color: #15803d; }

        .action-link { color: var(--primary-orange); font-weight: 600; font-size: 14px; margin-right: 10px; }
        .action-link.danger { color: #d10000; }
    </style>
</head>
<body>
    <header>
        <div class="container header-content">
            <a href="#" class="logo">EventTix <span style="font-size: 14px; color: #d10000;">| SuperAdmin</span></a>
            <nav>
                <a href="${pageContext.request.contextPath}/AuthController?action=logout" class="btn btn-outline">Déconnexion</a>
            </nav>
        </div>
    </header>

    <div class="container admin-layout">

        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
            <h1 style="margin: 0;">Gestion de la Plateforme</h1>
            <!-- Action for Admin to add staff -->
            <button class="btn"> + Ajouter un Utilisateur</button>
        </div>

        <div class="card">
            <h2 style="margin-top: 0;">Utilisateurs Inscrits</h2>

            <table class="data-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Nom Complet</th>
                        <th>Email</th>
                        <th>Rôle</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- In reality, this loop gets data from your AdminController -->
                    <c:forEach var="user" items="${utilisateurs}">
                        <tr>
                            <td style="color: var(--text-muted);">#${user.id}</td>
                            <td style="font-weight: bold;">${user.nom} ${user.prenom}</td>
                            <td>${user.email}</td>
                            <td>
                                <!-- Dynamic logic to color code roles -->
                                <c:choose>
                                    <c:when test="${user.role == 'ADMIN'}"><span class="badge badge-admin">Admin</span></c:when>
                                    <c:when test="${user.role == 'ORGANISATEUR'}"><span class="badge badge-org">Organisateur</span></c:when>
                                    <c:when test="${user.role == 'AGENT_CONTROLE'}"><span class="badge badge-agent">Agent</span></c:when>
                                    <c:otherwise><span class="badge badge-client">Client</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <a href="#" class="action-link">Éditer</a>
                                <a href="#" class="action-link danger">Suspendre</a>
                            </td>
                        </tr>
                    </c:forEach>

                    <!-- Example row so you can see the design before hooking up the database -->
                    <c:if test="${empty utilisateurs}">
                         <tr>
                            <td style="color: var(--text-muted);">#1042</td>
                            <td style="font-weight: bold;">Sophie Martin</td>
                            <td>organisateur@test.com</td>
                            <td><span class="badge badge-org">Organisateur</span></td>
                            <td>
                                <a href="#" class="action-link">Éditer</a>
                                <a href="#" class="action-link danger">Suspendre</a>
                            </td>
                        </tr>
                        <tr>
                            <td style="color: var(--text-muted);">#1043</td>
                            <td style="font-weight: bold;">Marc Leroy</td>
                            <td>agent@test.com</td>
                            <td><span class="badge badge-agent">Agent</span></td>
                            <td>
                                <a href="#" class="action-link">Éditer</a>
                                <a href="#" class="action-link danger">Suspendre</a>
                            </td>
                        </tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>