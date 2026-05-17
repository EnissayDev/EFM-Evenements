package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.dao.BilletDAO;
import ma.ismagi.model.Billet;
import ma.ismagi.model.BilletDTO;
import ma.ismagi.model.Evenement;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/billets", "/BilletController"})
public class BilletController extends HttpServlet {

    private BilletDAO billetDAO;

    @Override
    public void init() {
        billetDAO = new BilletDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Utilisateur user = (session != null) ? (Utilisateur) session.getAttribute("user") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (user.getRole() != Role.PARTICIPANT) {
            resp.sendRedirect(req.getContextPath() + user.getRole().getDefaultRedirect());
            return;
        }

        String action = req.getParameter("action");
        if ("viewQR".equals(action)) {
            handleViewQR(req, resp, user);
        } else {
            handleMesBillets(req, resp, user);
        }
    }

    private void handleMesBillets(HttpServletRequest req, HttpServletResponse resp, Utilisateur user)
            throws ServletException, IOException {

        String search = req.getParameter("search");
        String filter = req.getParameter("filter");

        List<BilletDTO> billets = billetDAO.getBilletsFiltres(user.getId(), search, filter);
        req.setAttribute("billets", billets);
        req.getRequestDispatcher("/mes-billets.jsp").forward(req, resp);
    }

    private void handleViewQR(HttpServletRequest req, HttpServletResponse resp, Utilisateur user)
            throws ServletException, IOException {

        String idStr = req.getParameter("idBillet");
        if (idStr == null) {
            resp.sendRedirect(req.getContextPath() + "/billets");
            return;
        }

        int billetId;
        try {
            billetId = Integer.parseInt(idStr);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/billets");
            return;
        }

        Billet billet = billetDAO.findById(billetId);
        Evenement evenement = billetDAO.findEvenementByBilletId(billetId, user.getId());

        if (billet == null || evenement == null) {
            resp.sendRedirect(req.getContextPath() + "/billets");
            return;
        }

        req.setAttribute("billet", billet);
        req.setAttribute("evenement", evenement);
        req.getRequestDispatcher("/billet.jsp").forward(req, resp);
    }
}
