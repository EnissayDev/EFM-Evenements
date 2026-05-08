package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.dao.BilletDAO;
import ma.ismagi.dao.CommandeDAO;
import ma.ismagi.model.Billet;
import ma.ismagi.model.Commande;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/commandes")
public class CommandeController extends HttpServlet {

    private static final int PRIX_STANDARD = 150;
    private static final int PRIX_VIP      = 300;

    private CommandeDAO commandeDAO;
    private BilletDAO   billetDAO;

    @Override
    public void init() {
        commandeDAO = new CommandeDAO();
        billetDAO   = new BilletDAO();
    }

    /** GET: calculate total and forward to paiement.jsp */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur currentUser = getUser(req);
        if (currentUser == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
        if (currentUser.getRole() != Role.PARTICIPANT) {
            resp.sendRedirect(req.getContextPath() + currentUser.getRole().getDefaultRedirect());
            return;
        }

        String action = req.getParameter("action");

        if (!"preparePayment".equals(action)) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String idEvenement = req.getParameter("idEvenement");
        String typePlace   = req.getParameter("typePlace");
        String quantiteStr = req.getParameter("quantite");

        int quantite;
        try {
            quantite = Integer.parseInt(quantiteStr);
            if (quantite < 1) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/evenements?action=listAll");
            return;
        }

        int prixUnitaire = "vip".equalsIgnoreCase(typePlace) ? PRIX_VIP : PRIX_STANDARD;
        double montant   = (double) prixUnitaire * quantite;

        req.setAttribute("idEvenement",  idEvenement);
        req.setAttribute("placeChoisie", typePlace);
        req.setAttribute("quantite",     quantite);
        req.setAttribute("montant",      montant);

        req.getRequestDispatcher("/paiement.jsp").forward(req, resp);
    }

    /** POST: create commande + billets, redirect to catalogue */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur participant = getUser(req);
        if (participant == null) { resp.sendRedirect(req.getContextPath() + "/login.jsp"); return; }
        if (participant.getRole() != Role.PARTICIPANT) {
            resp.sendRedirect(req.getContextPath() + participant.getRole().getDefaultRedirect());
            return;
        }

        int idEvenement, quantite;
        double montant;
        try {
            idEvenement = Integer.parseInt(req.getParameter("idEvenement"));
            quantite    = Integer.parseInt(req.getParameter("quantite"));
            montant     = Double.parseDouble(req.getParameter("montant"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/evenements?action=listAll");
            return;
        }

        Commande commande = Commande.builder()
                .evenementId(idEvenement)
                .participantId(participant.getId())
                .quantite(quantite)
                .montantTotal(montant)
                .build();

        int commandeId = commandeDAO.createAndGetId(commande);

        for (int i = 0; i < quantite; i++) {
            Billet billet = Billet.builder()
                    .commandeId(commandeId)
                    .code(UUID.randomUUID().toString())
                    .statut("ACTIF")
                    .build();
            billetDAO.create(billet);
        }

        resp.sendRedirect(req.getContextPath() + "/evenements?action=listAll&success=paid");
    }

    private Utilisateur getUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) return null;
        return (Utilisateur) session.getAttribute("utilisateur");
    }
}
