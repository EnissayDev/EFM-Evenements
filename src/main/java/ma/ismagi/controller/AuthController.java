package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.dao.UtilisateurDAO;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;
import ma.ismagi.utils.PasswordUtils;

import java.io.IOException;

@WebServlet(urlPatterns = {"/login", "/register", "/AuthController"})
public class AuthController extends HttpServlet {

    private UtilisateurDAO dao;

    @Override
    public void init() {
        dao = new UtilisateurDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("user") : null;
        if (u != null) {
            resp.sendRedirect(req.getContextPath() + u.getRole().getDefaultRedirect());
            return;
        }

        String path = req.getServletPath();
        if ("/register".equals(path)) {
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
        } else {
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");

        if ("logout".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session != null) session.invalidate();
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        if ("register".equals(action)) {
            handleRegister(req, resp);
            return;
        }

        handleLogin(req, resp);
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        Utilisateur utilisateur = dao.findByAttribute("email", email);

        if (utilisateur != null && PasswordUtils.verify(password, utilisateur.getPasswordHash())) {
            HttpSession session = req.getSession();
            session.setAttribute("user", utilisateur);
            resp.sendRedirect(req.getContextPath() + utilisateur.getRole().getDefaultRedirect());
        } else {
            req.setAttribute("erreurMessage", "Email ou mot de passe incorrect.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String roleParam = req.getParameter("role");

        if (nom == null || nom.isBlank() || email == null || email.isBlank()
                || password == null || password.isBlank()) {
            req.setAttribute("erreurMessage", "Tous les champs sont obligatoires.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        if (dao.findByAttribute("email", email) != null) {
            req.setAttribute("erreurMessage", "Cet email est déjà utilisé.");
            req.getRequestDispatcher("/register.jsp").forward(req, resp);
            return;
        }

        Role role = "ORGANISATEUR".equals(roleParam) ? Role.ORGANISATEUR : Role.PARTICIPANT;

        Utilisateur newUser = Utilisateur.builder()
                .nom(nom)
                .prenom(prenom == null ? "" : prenom)
                .email(email)
                .passwordHash(PasswordUtils.hash(password))
                .role(role)
                .build();

        dao.create(newUser);

        Utilisateur created = dao.findByAttribute("email", email);
        HttpSession session = req.getSession();
        session.setAttribute("user", created);
        resp.sendRedirect(req.getContextPath() + role.getDefaultRedirect());
    }
}
