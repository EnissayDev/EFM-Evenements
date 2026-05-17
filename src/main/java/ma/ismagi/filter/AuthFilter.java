package ma.ismagi.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ma.ismagi.model.Utilisateur;

import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_EXACT = List.of(
            "/",
            "/index.jsp",
            "/login",
            "/register",
            "/AuthController",
            "/catalogue"
    );

    private static final List<String> PUBLIC_PREFIXES = List.of(
            "/logout",
            "/css/",
            "/js/",
            "/images/",
            "/uploads/"
    );

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        if (path.endsWith(".jsp")) {
            HttpSession session = req.getSession(false);
            Utilisateur u = (session != null) ? (Utilisateur) session.getAttribute("user") : null;
            if (u != null) {
                resp.sendRedirect(req.getContextPath() + u.getRole().getDefaultRedirect());
            } else {
                resp.sendRedirect(req.getContextPath() + "/login");
            }
            return;
        }

        boolean isPublic = PUBLIC_EXACT.contains(path)
                || PUBLIC_PREFIXES.stream().anyMatch(path::startsWith);

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Utilisateur utilisateur = (session != null)
                ? (Utilisateur) session.getAttribute("user")
                : null;

        if (utilisateur == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
