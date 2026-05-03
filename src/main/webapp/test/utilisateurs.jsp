<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ma.ismagi.dao.UtilisateurDAO" %>
<%@ page import="ma.ismagi.model.Utilisateur" %>
<%@ page import="ma.ismagi.model.Role" %>
<%@ page import="java.util.List" %>
<%@ page import="ma.ismagi.utils.PasswordUtils" %>
<%
    UtilisateurDAO dao = new UtilisateurDAO();
    String action = request.getParameter("action");

    if ("create".equals(action)) {
        Utilisateur u = Utilisateur.builder()
                .nom(request.getParameter("nom"))
                .prenom(request.getParameter("prenom"))
                .email(request.getParameter("email"))
                .passwordHash(PasswordUtils.hash(request.getParameter("password"))) // hashed
                .role(Role.valueOf(request.getParameter("role")))
                .build();
        dao.create(u);
        response.sendRedirect("utilisateurs.jsp");
        return;
    }

    if ("delete".equals(action)) {
        dao.delete(Integer.parseInt(request.getParameter("id")));
        response.sendRedirect("utilisateurs.jsp");
        return;
    }

    if ("update".equals(action)) {
        String newPassword = request.getParameter("password");
        Utilisateur existing = dao.findById(Integer.parseInt(request.getParameter("id")));

        String passwordHash = (newPassword == null || newPassword.isEmpty())
                ? existing.getPasswordHash()
                : PasswordUtils.hash(newPassword);

        Utilisateur u = Utilisateur.builder()
                .id(Integer.parseInt(request.getParameter("id")))
                .nom(request.getParameter("nom"))
                .prenom(request.getParameter("prenom"))
                .email(request.getParameter("email"))
                .passwordHash(passwordHash)
                .role(Role.valueOf(request.getParameter("role")))
                .build();
        dao.update(u);
        response.sendRedirect("utilisateurs.jsp");
        return;
    }

    // editing state
    Utilisateur editing = null;
    if ("edit".equals(action)) {
        editing = dao.findById(Integer.parseInt(request.getParameter("id")));
    }

    List<Utilisateur> utilisateurs = dao.findAll();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Gestion des Utilisateurs</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; margin-top: 20px; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
        input, select { padding: 6px; margin: 4px 0; width: 100%; box-sizing: border-box; }
        .form-box { background: #f9f9f9; border: 1px solid #ccc; padding: 20px; margin-bottom: 20px; }
        .form-box h3 { margin-top: 0; }
        .btn { padding: 6px 12px; cursor: pointer; border: none; border-radius: 4px; }
        .btn-green { background: #4CAF50; color: white; }
        .btn-blue { background: #2196F3; color: white; }
        .btn-red { background: #f44336; color: white; }
        .form-row { display: flex; gap: 10px; flex-wrap: wrap; }
        .form-row > div { flex: 1; min-width: 150px; }
    </style>
</head>
<body>
<h2>Gestion des Utilisateurs</h2>

<!-- CREATE / EDIT FORM -->
<div class="form-box">
    <h3><%= editing != null ? "Modifier l'utilisateur" : "Ajouter un utilisateur" %></h3>
    <form method="post" action="utilisateurs.jsp">
        <input type="hidden" name="action" value="<%= editing != null ? "update" : "create" %>"/>
        <% if (editing != null) { %>
        <input type="hidden" name="id" value="<%= editing.getId() %>"/>
        <% } %>
        <div class="form-row">
            <div>
                <label>Nom</label>
                <input type="text" name="nom" required value="<%= editing != null ? editing.getNom() : "" %>"/>
            </div>
            <div>
                <label>Prénom</label>
                <input type="text" name="prenom" required value="<%= editing != null ? editing.getPrenom() : "" %>"/>
            </div>
            <div>
                <label>Email</label>
                <input type="email" name="email" required value="<%= editing != null ? editing.getEmail() : "" %>"/>
            </div>
            <div>
                <label>Mot de passe</label>
                <input type="password" name="password" required value="<%= editing != null ? editing.getPasswordHash() : "" %>"/>
            </div>
            <div>
                <label>Rôle</label>
                <select name="role">
                    <% for (Role r : Role.values()) { %>
                    <option value="<%= r %>" <%= (editing != null && editing.getRole() == r) ? "selected" : "" %>><%= r %></option>
                    <% } %>
                </select>
            </div>
        </div>
        <br/>
        <button type="submit" class="btn <%= editing != null ? "btn-blue" : "btn-green" %>">
            <%= editing != null ? "Mettre a jour" : "Ajouter" %>
        </button>
        <% if (editing != null) { %>
        <a href="utilisateurs.jsp"><button type="button" class="btn">Annuler</button></a>
        <% } %>
    </form>
</div>

<!-- TABLE -->
<table>
    <thead>
        <tr>
            <th>ID</th>
            <th>Nom</th>
            <th>Prénom</th>
            <th>Email</th>
            <th>Rôle</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% for (Utilisateur u : utilisateurs) { %>
        <tr>
            <td><%= u.getId() %></td>
            <td><%= u.getNom() %></td>
            <td><%= u.getPrenom() %></td>
            <td><%= u.getEmail() %></td>
            <td><%= u.getRole() %></td>
            <td>
                <a href="utilisateurs.jsp?action=edit&id=<%= u.getId() %>">
                    <button class="btn btn-blue">Modifier</button>
                </a>
                <form method="post" action="utilisateurs.jsp" style="display:inline"
                      onsubmit="return confirm('Supprimer cet utilisateur ?')">
                    <input type="hidden" name="action" value="delete"/>
                    <input type="hidden" name="id" value="<%= u.getId() %>"/>
                    <button type="submit" class="btn btn-red">Supprimer</button>
                </form>
            </td>
        </tr>
        <% } %>
    </tbody>
</table>
</body>
</html>