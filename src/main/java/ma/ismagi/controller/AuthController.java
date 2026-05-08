package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.dao.UtilisateurDAO;
import ma.ismagi.model.Utilisateur;
import ma.ismagi.utils.PasswordUtils;

import java.io.IOException;

@WebServlet("/login")
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
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;
        if (u != null) {
            resp.sendRedirect(req.getContextPath() + u.getRole().getDefaultRedirect());
            return;
        }
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        Utilisateur utilisateur = dao.findByAttribute("email", email);

        if (utilisateur != null && PasswordUtils.verify(password, utilisateur.getPasswordHash())) {
            HttpSession session = req.getSession();
            session.setAttribute("utilisateur", utilisateur);
            session.setAttribute("role", utilisateur.getRole().name());
            resp.sendRedirect(req.getContextPath() + utilisateur.getRole().getDefaultRedirect());
        } else {
            req.setAttribute("erreurMessage", "Email ou mot de passe incorrect.");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }
    }
}
