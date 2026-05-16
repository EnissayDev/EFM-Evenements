<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Administration - EventTix</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .admin-layout { margin-top: 40px; padding-bottom: 60px; }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        .stat-card {
            background: #fff;
            border: 1px solid var(--border-color);
            border-radius: 10px;
            padding: 20px;
            text-align: center;
        }
        .stat-card .stat-number {
            font-size: 36px;
            font-weight: 700;
            color: var(--primary-orange);
            line-height: 1;
        }
        .stat-card .stat-label {
            font-size: 13px;
            color: var(--text-muted);
            margin-top: 6px;
        }

        .data-table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 16px;
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

        .badge {
            padding: 3px 9px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
        }
        .badge-admin   { background: #ffe0e0; color: #d10000; }
        .badge-org     { background: #e0f2fe; color: #0284c7; }
        .badge-agent   { background: #fef08a; color: #a16207; }
        .badge-client  { background: #dcfce7; color: #15803d; }

        .action-btn {
            background: none;
            border: none;
            cursor: pointer;
            font-size: 14px;
            font-weight: 600;
            padding: 0;
            margin-right: 10px;
            color: var(--primary-orange);
        }
        .action-btn.danger { color: #d10000; }

        .edit-form { display: none; margin-top: 6px; }
        .edit-form select {
            padding: 4px 8px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 13px;
        }
        .edit-form .save-btn {
            padding: 4px 10px;
            background: var(--primary-orange);
            color: #fff;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            margin-left: 6px;
        }
        .edit-form .cancel-btn {
            padding: 4px 10px;
            background: #eee;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 13px;
            margin-left: 4px;
        }

        /* Modal */
        .modal-overlay {
            display: none;
            position: fixed; inset: 0;
            background: rgba(0,0,0,0.45);
            z-index: 1000;
            align-items: center;
            justify-content: center;
        }
        .modal-overlay.open { display: flex; }

        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            font-weight: 500;
        }
        .alert-success { background: #dcfce7; color: #15803d; border: 1px solid #bbf7d0; }
        .alert-error   { background: #fee2e2; color: #b91c1c; border: 1px solid #fecaca; }
        .modal-box {
            background: #fff;
            border-radius: 12px;
            padding: 32px;
            width: 100%;
            max-width: 480px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.18);
        }
        .modal-box h2 { margin: 0 0 24px; font-size: 20px; }
        .modal-close {
            float: right;
            background: none;
            border: none;
            font-size: 22px;
            cursor: pointer;
            color: var(--text-muted);
            line-height: 1;
        }
    </style>
</head>
<body>
<jsp:include page="/nav.jsp" />

<div class="container admin-layout">

    <%-- Alerts --%>
    <c:if test="${param.success == 'created'}">
        <div class="alert alert-success" style="margin-bottom:20px;">Utilisateur créé avec succès.</div>
    </c:if>
    <c:if test="${param.success == 'deleted'}">
        <div class="alert alert-success" style="margin-bottom:20px;">Utilisateur supprimé.</div>
    </c:if>
    <c:if test="${param.success == 'roleChanged'}">
        <div class="alert alert-success" style="margin-bottom:20px;">Rôle mis à jour.</div>
    </c:if>
    <c:if test="${param.error == 'self'}">
        <div class="alert alert-error" style="margin-bottom:20px;">Vous ne pouvez pas modifier ou supprimer votre propre compte.</div>
    </c:if>
    <c:if test="${param.error == 'emailExists'}">
        <div class="alert alert-error" style="margin-bottom:20px;">Cet email est déjà utilisé.</div>
    </c:if>
    <c:if test="${param.error == 'missing'}">
        <div class="alert alert-error" style="margin-bottom:20px;">Tous les champs obligatoires doivent être remplis.</div>
    </c:if>

    <%-- Stats --%>
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-number">${totalUtilisateurs}</div>
            <div class="stat-label">Utilisateurs</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${totalEvenements}</div>
            <div class="stat-label">Événements</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${totalCommandes}</div>
            <div class="stat-label">Commandes</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${nbOrganisateurs}</div>
            <div class="stat-label">Organisateurs</div>
        </div>
        <div class="stat-card">
            <div class="stat-number">${nbAgents}</div>
            <div class="stat-label">Agents</div>
        </div>
    </div>

    <%-- Users table --%>
    <div class="card">
        <div style="display:flex; justify-content:space-between; align-items:center;">
            <h2 style="margin:0;">Utilisateurs Inscrits</h2>
            <button class="btn" onclick="document.getElementById('addUserModal').classList.add('open')">
                + Ajouter un Utilisateur
            </button>
        </div>

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
                <c:forEach var="user" items="${utilisateurs}">
                    <tr>
                        <td style="color:var(--text-muted);">#${user.id}</td>
                        <td style="font-weight:bold;">${user.nom} ${user.prenom}</td>
                        <td>${user.email}</td>
                        <td>
                            <c:choose>
                                <c:when test="${user.role == 'ADMIN'}"><span class="badge badge-admin">Admin</span></c:when>
                                <c:when test="${user.role == 'ORGANISATEUR'}"><span class="badge badge-org">Organisateur</span></c:when>
                                <c:when test="${user.role == 'AGENT_CONTROLE'}"><span class="badge badge-agent">Agent</span></c:when>
                                <c:otherwise><span class="badge badge-client">Participant</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <%-- Edit role --%>
                            <button class="action-btn" onclick="toggleEdit(${user.id})">Éditer</button>

                            <%-- Delete --%>
                            <form method="post" action="${pageContext.request.contextPath}/admin"
                                  style="display:inline;"
                                  onsubmit="return confirm('Supprimer ${user.nom} ${user.prenom} ? Cette action est irréversible.')">
                                <input type="hidden" name="action" value="deleteUser">
                                <input type="hidden" name="userId" value="${user.id}">
                                <button type="submit" class="action-btn danger">Supprimer</button>
                            </form>

                            <%-- Inline role-change form --%>
                            <form method="post" action="${pageContext.request.contextPath}/admin"
                                  id="editForm_${user.id}" class="edit-form">
                                <input type="hidden" name="action" value="changeRole">
                                <input type="hidden" name="userId" value="${user.id}">
                                <select name="role">
                                    <option value="PARTICIPANT"    ${user.role == 'PARTICIPANT'    ? 'selected' : ''}>Participant</option>
                                    <option value="AGENT_CONTROLE" ${user.role == 'AGENT_CONTROLE' ? 'selected' : ''}>Agent</option>
                                    <option value="ORGANISATEUR"   ${user.role == 'ORGANISATEUR'   ? 'selected' : ''}>Organisateur</option>
                                    <option value="ADMIN"          ${user.role == 'ADMIN'          ? 'selected' : ''}>Admin</option>
                                </select>
                                <button type="submit" class="save-btn">Sauvegarder</button>
                                <button type="button" class="cancel-btn" onclick="toggleEdit(${user.id})">Annuler</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>

                <c:if test="${empty utilisateurs}">
                    <tr>
                        <td colspan="5" style="text-align:center; padding:40px; color:var(--text-muted);">
                            Aucun utilisateur trouvé.
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<%-- Add user modal --%>
<div id="addUserModal" class="modal-overlay">
    <div class="modal-box">
        <button class="modal-close" onclick="document.getElementById('addUserModal').classList.remove('open')">&times;</button>
        <h2>Ajouter un Utilisateur</h2>
        <form method="post" action="${pageContext.request.contextPath}/admin" accept-charset="UTF-8">
            <input type="hidden" name="action" value="createUser">
            <div class="form-group">
                <label>Nom *</label>
                <input type="text" name="nom" required>
            </div>
            <div class="form-group">
                <label>Prénom</label>
                <input type="text" name="prenom">
            </div>
            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" required>
            </div>
            <div class="form-group">
                <label>Mot de passe *</label>
                <input type="password" name="password" required minlength="6">
            </div>
            <div class="form-group">
                <label>Rôle *</label>
                <select name="role" style="width:100%; padding:10px; border:1px solid var(--border-color); border-radius:8px;">
                    <option value="PARTICIPANT">Participant</option>
                    <option value="AGENT_CONTROLE">Agent de contrôle</option>
                    <option value="ORGANISATEUR">Organisateur</option>
                    <option value="ADMIN">Admin</option>
                </select>
            </div>
            <button type="submit" class="btn" style="width:100%; margin-top:8px;">Créer l'utilisateur</button>
        </form>
    </div>
</div>

<script>
    function toggleEdit(userId) {
        const form = document.getElementById('editForm_' + userId);
        form.style.display = form.style.display === 'block' ? 'none' : 'block';
    }

    // Close modal on overlay click
    document.getElementById('addUserModal').addEventListener('click', function(e) {
        if (e.target === this) this.classList.remove('open');
    });
</script>
</body>
</html>
