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

@WebServlet("/AuthController")
public class AuthController extends HttpServlet {

    private UtilisateurDAO dao;

    @Override
    public void init() {
        dao = new UtilisateurDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = req.getParameter("email");
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

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if ("logout".equals(action)) {
            req.getSession().invalidate();
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }
}