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
import ma.ismagi.model.Billet;
import ma.ismagi.model.Commande;
import ma.ismagi.model.Evenement;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.io.IOException;
import java.util.UUID;

@WebServlet(urlPatterns = {"/paiement", "/commandes"})
public class CommandeController extends HttpServlet {

    private static final int PRIX_STANDARD = 150;
    private static final int PRIX_VIP      = 300;

    private CommandeDAO  commandeDAO;
    private BilletDAO    billetDAO;
    private EvenementDAO evenementDAO;

    @Override
    public void init() {
        commandeDAO  = new CommandeDAO();
        billetDAO    = new BilletDAO();
        evenementDAO = new EvenementDAO();
    }

    /** GET /paiement — show payment summary */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur participant = getParticipant(req, resp);
        if (participant == null) return;

        String idEvenement = req.getParameter("idEvenement");
        String typePlace   = req.getParameter("typePlace");
        String quantiteStr = req.getParameter("quantite");

        int quantite, idEvenementInt;
        try {
            idEvenementInt = Integer.parseInt(idEvenement);
            quantite = Integer.parseInt(quantiteStr);
            if (quantite < 1) throw new NumberFormatException();
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/catalogue");
            return;
        }

        Evenement evenement = evenementDAO.findById(idEvenementInt);
        int sold = commandeDAO.countBilletsByEvenement(idEvenementInt);
        if (sold + quantite > evenement.getCapacite()) {
            resp.sendRedirect(req.getContextPath() + "/evenement/" + idEvenement + "?error=complet");
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

    /** POST /commandes — confirm order and create billets */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Utilisateur participant = getParticipant(req, resp);
        if (participant == null) return;

        int idEvenement, quantite;
        double montant;
        try {
            idEvenement = Integer.parseInt(req.getParameter("idEvenement"));
            quantite    = Integer.parseInt(req.getParameter("quantite"));
            montant     = Double.parseDouble(req.getParameter("montant"));
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/catalogue");
            return;
        }

        Evenement evenement = evenementDAO.findById(idEvenement);
        int sold = commandeDAO.countBilletsByEvenement(idEvenement);
        if (sold + quantite > evenement.getCapacite()) {
            resp.sendRedirect(req.getContextPath() + "/evenement/" + idEvenement + "?error=complet");
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

        resp.sendRedirect(req.getContextPath() + "/catalogue?success=paid");
    }

    private Utilisateur getParticipant(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return null;
        }
        if (u.getRole() != Role.PARTICIPANT) {
            resp.sendRedirect(req.getContextPath() + u.getRole().getDefaultRedirect());
            return null;
        }
        return u;
    }
}
