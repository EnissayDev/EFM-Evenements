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
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.io.IOException;
import java.util.List;

@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_EXACT = List.of(
            "/",
            "/index.jsp",
            "/login.jsp"
    );

    private static final List<String> PUBLIC_PREFIXES = List.of(
            "/AuthController",
            "/css/",
            "/js/",
            "/images/"
    );

    @Override
    public void init(FilterConfig filterConfig) {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path  = req.getRequestURI().substring(req.getContextPath().length());
        String query = req.getQueryString();

        boolean isPublic = PUBLIC_EXACT.contains(path)
                || PUBLIC_PREFIXES.stream().anyMatch(path::startsWith)
                || (path.equals("/evenements") && "action=listAll".equals(query));

        if (isPublic) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        Utilisateur utilisateur = (session != null)
                ? (Utilisateur) session.getAttribute("utilisateur")
                : null;

        if (utilisateur == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        Role role = utilisateur.getRole();

        if (path.endsWith(".jsp") && !role.getAllowedPages().contains(path)) {
            resp.sendRedirect(req.getContextPath() + role.getDefaultRedirect());
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}
