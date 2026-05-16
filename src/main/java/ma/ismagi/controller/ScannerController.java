package ma.ismagi.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.io.IOException;

@WebServlet("/scanner")
public class ScannerController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("utilisateur") : null;

        if (u == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }
        if (u.getRole() != Role.AGENT_CONTROLE) {
            resp.sendRedirect(req.getContextPath() + u.getRole().getDefaultRedirect());
            return;
        }

        req.getRequestDispatcher("/scanner.jsp").forward(req, resp);
    }

}
