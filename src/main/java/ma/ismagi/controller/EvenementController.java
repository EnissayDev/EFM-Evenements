package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.dao.BilletDAO;
import ma.ismagi.dao.CommandeDAO;
import ma.ismagi.dao.EvenementDAO;
import ma.ismagi.model.Commande;
import ma.ismagi.model.Evenement;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;

@WebServlet(urlPatterns = {"/catalogue", "/evenement/*", "/dashboard", "/evenements"})
public class EvenementController extends HttpServlet {

    private EvenementDAO evenementDAO;
    private CommandeDAO commandeDAO;
    private BilletDAO billetDAO;

    @Override
    public void init() {
        evenementDAO = new EvenementDAO();
        commandeDAO = new CommandeDAO();
        billetDAO = new BilletDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        switch (path) {
            case "/catalogue" -> handleCatalogue(req, resp);
            case "/evenement" -> handleDetail(req, resp);
            case "/dashboard" -> handleDashboard(req, resp);
            default -> resp.sendRedirect(req.getContextPath() + "/catalogue");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String action = req.getParameter("action");
        if ("create".equals(action)) {
            handleCreate(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Action inconnue: " + action);
        }
    }

    private void handleCatalogue(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Evenement> evenements = evenementDAO.findAll();
        req.setAttribute("evenements", evenements);
        req.getRequestDispatcher("/catalogue.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Utilisateur viewer = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        if (viewer == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (viewer.getRole() == Role.AGENT_CONTROLE) {
            resp.sendRedirect(req.getContextPath() + Role.AGENT_CONTROLE.getDefaultRedirect());
            return;
        }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            resp.sendRedirect(req.getContextPath() + "/catalogue");
            return;
        }

        Evenement evenement = evenementDAO.findById(Integer.parseInt(pathInfo.substring(1)));
        int billetsSold = commandeDAO.countBilletsByEvenement(evenement.getId());
        req.setAttribute("evenement", evenement);
        req.setAttribute("billetsSold", billetsSold);

        if (viewer.getRole() == Role.PARTICIPANT) {
            req.setAttribute("mesBillets",
                    billetDAO.findByParticipantAndEvenement(viewer.getId(), evenement.getId()));
        }

        req.getRequestDispatcher("/detail-evenement.jsp").forward(req, resp);
    }

    private void handleDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur organisateur = getOrganisateur(req, resp);
        if (organisateur == null) return;

        if ("created".equals(req.getParameter("success"))) {
            req.setAttribute("successMessage", "Événement publié avec succès !");
        }

        List<Commande> commandes = commandeDAO.findByOrganisateur(organisateur.getId());
        req.setAttribute("commandes", commandes);
        req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
    }

    private void handleCreate(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur organisateur = getOrganisateur(req, resp);
        if (organisateur == null) return;

        String titre = req.getParameter("titre");
        String description = req.getParameter("description");
        String dateStr = req.getParameter("date");
        String capStr = req.getParameter("capacite");
        String lieu = req.getParameter("lieu");

        if (titre == null || titre.isBlank()
                || dateStr == null || dateStr.isBlank()
                || capStr  == null || capStr.isBlank()
                || lieu    == null || lieu.isBlank()) {

            req.setAttribute("erreurMessage", "Tous les champs sont obligatoires.");
            handleDashboard(req, resp);
            return;
        }

        int capacite;
        try {
            capacite = Integer.parseInt(capStr);
            if (capacite <= 0) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            req.setAttribute("erreurMessage", "La capacité doit être un nombre positif.");
            handleDashboard(req, resp);
            return;
        }

        LocalDate date;
        try {
            date = LocalDate.parse(dateStr);
        } catch (Exception e) {
            req.setAttribute("erreurMessage", "Format de date invalide.");
            handleDashboard(req, resp);
            return;
        }

        Evenement evenement = Evenement.builder()
                .titre(titre)
                .description(description)
                .date(date)
                .capacite(capacite)
                .lieu(lieu)
                .organisateurId(organisateur.getId())
                .build();

        evenementDAO.create(evenement);
        resp.sendRedirect(req.getContextPath() + "/dashboard?success=created");
    }

    private Utilisateur getOrganisateur(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("utilisateur") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        Utilisateur u = (Utilisateur) session.getAttribute("utilisateur");
        if (u.getRole() != Role.ORGANISATEUR && u.getRole() != Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + u.getRole().getDefaultRedirect());
            return null;
        }
        return u;
    }
}
