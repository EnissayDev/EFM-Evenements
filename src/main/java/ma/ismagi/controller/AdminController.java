package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.dao.CommandeDAO;
import ma.ismagi.dao.EvenementDAO;
import ma.ismagi.dao.UtilisateurDAO;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;
import ma.ismagi.utils.PasswordUtils;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin")
public class AdminController extends HttpServlet {

    private UtilisateurDAO utilisateurDAO;
    private EvenementDAO   evenementDAO;
    private CommandeDAO    commandeDAO;

    @Override
    public void init() {
        utilisateurDAO = new UtilisateurDAO();
        evenementDAO   = new EvenementDAO();
        commandeDAO    = new CommandeDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        if (getAdmin(req, resp) == null) return;

        List<Utilisateur> utilisateurs = utilisateurDAO.findAll();

        long nbOrganisateurs = utilisateurs.stream().filter(u -> u.getRole() == Role.ORGANISATEUR).count();
        long nbAgents        = utilisateurs.stream().filter(u -> u.getRole() == Role.AGENT_CONTROLE).count();

        req.setAttribute("utilisateurs",      utilisateurs);
        req.setAttribute("totalUtilisateurs", utilisateurs.size());
        req.setAttribute("totalEvenements",   evenementDAO.findAll().size());
        req.setAttribute("totalCommandes",    commandeDAO.findAll().size());
        req.setAttribute("nbOrganisateurs",   nbOrganisateurs);
        req.setAttribute("nbAgents",          nbAgents);

        req.getRequestDispatcher("/admin-dashboard.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        Utilisateur admin = getAdmin(req, resp);
        if (admin == null) return;

        String action = req.getParameter("action");
        switch (action == null ? "" : action) {
            case "changeRole"  -> handleChangeRole(req, resp, admin);
            case "deleteUser"  -> handleDeleteUser(req, resp, admin);
            case "createUser"  -> handleCreateUser(req, resp);
            default            -> resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
        }
    }

    private void handleChangeRole(HttpServletRequest req, HttpServletResponse resp, Utilisateur admin)
            throws IOException {

        int    userId  = Integer.parseInt(req.getParameter("userId"));
        String roleStr = req.getParameter("role");

        if (userId == admin.getId()) {
            resp.sendRedirect(req.getContextPath() + "/admin?error=self");
            return;
        }

        Utilisateur user = utilisateurDAO.findById(userId);
        if (user != null) {
            user.setRole(Role.valueOf(roleStr));
            utilisateurDAO.update(user);
        }
        resp.sendRedirect(req.getContextPath() + "/admin?success=roleChanged");
    }

    private void handleDeleteUser(HttpServletRequest req, HttpServletResponse resp, Utilisateur admin)
            throws IOException {

        int userId = Integer.parseInt(req.getParameter("userId"));

        if (userId == admin.getId()) {
            resp.sendRedirect(req.getContextPath() + "/admin?error=self");
            return;
        }

        utilisateurDAO.delete(userId);
        resp.sendRedirect(req.getContextPath() + "/admin?success=deleted");
    }

    private void handleCreateUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String nom      = req.getParameter("nom");
        String prenom   = req.getParameter("prenom");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String roleStr  = req.getParameter("role");

        if (nom == null || nom.isBlank()
                || email == null || email.isBlank()
                || password == null || password.isBlank()
                || roleStr == null || roleStr.isBlank()) {
            resp.sendRedirect(req.getContextPath() + "/admin?error=missing");
            return;
        }

        if (utilisateurDAO.findByAttribute("email", email) != null) {
            resp.sendRedirect(req.getContextPath() + "/admin?error=emailExists");
            return;
        }

        Utilisateur newUser = Utilisateur.builder()
                .nom(nom)
                .prenom(prenom == null ? "" : prenom)
                .email(email)
                .passwordHash(PasswordUtils.hash(password))
                .role(Role.valueOf(roleStr))
                .build();

        utilisateurDAO.create(newUser);
        resp.sendRedirect(req.getContextPath() + "/admin?success=created");
    }

    private Utilisateur getAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return null;
        }
        if (u.getRole() != Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + u.getRole().getDefaultRedirect());
            return null;
        }
        return u;
    }
}
