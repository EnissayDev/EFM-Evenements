package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.Part;
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

import java.io.File;
import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;

@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 10 * 1024 * 1024,
        maxRequestSize    = 15 * 1024 * 1024
)
@WebServlet(urlPatterns = {"/catalogue", "/EvenementController", "/evenements/*", "/evenement/*", "/dashboard"})
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
            case "/EvenementController" -> {
                String id = req.getParameter("id");
                if (id != null) {
                    resp.sendRedirect(req.getContextPath() + "/evenements/" + id);
                } else {
                    handleCatalogue(req, resp);
                }
            }
            case "/evenements", "/evenement" -> handleDetail(req, resp);
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

        String keyword = req.getParameter("keyword");
        String category = req.getParameter("category");

        List<Evenement> evenements;
        if ((keyword != null && !keyword.isBlank()) || (category != null && !category.isBlank())) {
            evenements = evenementDAO.rechercher(keyword, category);
        } else {
            evenements = evenementDAO.findAll();
        }

        req.setAttribute("evenements", evenements);
        req.getRequestDispatcher("/catalogue.jsp").forward(req, resp);
    }

    private void handleDetail(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Utilisateur viewer = (session != null) ? (Utilisateur) session.getAttribute("user") : null;

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

        String titre       = req.getParameter("titre");
        String description = req.getParameter("description");
        String dateStr     = req.getParameter("date");
        String capStr      = req.getParameter("capacite");
        String lieu        = req.getParameter("lieu");
        String categorie   = req.getParameter("categorie");
        String prixStdStr  = req.getParameter("prixStandard");
        String prixVipStr  = req.getParameter("prixVip");

        if (titre == null || titre.isBlank()
                || dateStr    == null || dateStr.isBlank()
                || capStr     == null || capStr.isBlank()
                || lieu       == null || lieu.isBlank()
                || prixStdStr == null || prixStdStr.isBlank()
                || prixVipStr == null || prixVipStr.isBlank()) {

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

        double prixStandard, prixVip;
        try {
            prixStandard = Double.parseDouble(prixStdStr);
            prixVip      = Double.parseDouble(prixVipStr);
        } catch (NumberFormatException e) {
            req.setAttribute("erreurMessage", "Les prix doivent être des nombres valides.");
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

        String imagePath = null;
        Part filePart = req.getPart("imageEvent");
        if (filePart != null && filePart.getSize() > 0) {
            String uploadDir = getServletContext().getRealPath("/uploads/events");
            new File(uploadDir).mkdirs();

            String original  = filePart.getSubmittedFileName();
            String ext       = original.contains(".") ? original.substring(original.lastIndexOf('.')) : "";
            String fileName  = UUID.randomUUID() + ext;

            filePart.write(uploadDir + File.separator + fileName);
            imagePath = "/uploads/events/" + fileName;
        }

        Evenement evenement = Evenement.builder()
                .titre(titre)
                .description(description)
                .date(date)
                .capacite(capacite)
                .lieu(lieu)
                .categorie(categorie)
                .prixStandard(prixStandard)
                .prixVip(prixVip)
                .imagePath(imagePath)
                .organisateurId(organisateur.getId())
                .build();

        evenementDAO.create(evenement);
        resp.sendRedirect(req.getContextPath() + "/dashboard?success=created");
    }

    private Utilisateur getOrganisateur(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        Utilisateur u = (Utilisateur) session.getAttribute("user");
        if (u.getRole() != Role.ORGANISATEUR && u.getRole() != Role.ADMIN) {
            resp.sendRedirect(req.getContextPath() + u.getRole().getDefaultRedirect());
            return null;
        }
        return u;
    }
}
