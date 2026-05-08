package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.dao.BilletDAO;
import ma.ismagi.model.Billet;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.io.IOException;

@WebServlet("/validation")
public class ValidationController extends HttpServlet {

    private BilletDAO billetDAO;

    @Override
    public void init() {
        billetDAO = new BilletDAO();
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json;charset=UTF-8");

        HttpSession session = req.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;
        if (user == null || user.getRole() != Role.AGENT_CONTROLE) {
            resp.setStatus(HttpServletResponse.SC_FORBIDDEN);
            resp.getWriter().write("{\"status\":\"FORBIDDEN\"}");
            return;
        }

        String code = req.getParameter("qrCode");

        if (code == null || code.isBlank()) {
            resp.getWriter().write("{\"status\":\"INVALID\"}");
            return;
        }

        Billet billet = billetDAO.findByCode(code.trim());

        if (billet == null || !"ACTIF".equals(billet.getStatut())) {
            resp.getWriter().write("{\"status\":\"INVALID\"}");
            return;
        }

        billetDAO.valider(billet.getId());
        resp.getWriter().write("{\"status\":\"OK\"}");
    }
}
