<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ma.ismagi.dao.UtilisateurDAO" %>
<%@ page import="ma.ismagi.model.Utilisateur" %>
<%@ page import="java.util.List" %>
<%
    UtilisateurDAO dao = new UtilisateurDAO();
    List<Utilisateur> utilisateurs = dao.findAll();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Liste des Utilisateurs</title>
    <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ccc; padding: 10px; text-align: left; }
        th { background-color: #4CAF50; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
    </style>
</head>
<body>
    <h2>Liste des Utilisateurs</h2>
    <table>
        <thead>
            <tr>
                <th>ID</th>
                <th>Nom</th>
                <th>Prénom</th>
                <th>Email</th>
                <th>Rôle</th>
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
            </tr>
            <% } %>
        </tbody>
    </table>
</body>
</html>