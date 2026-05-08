package ma.ismagi.model;

import java.util.List;

public enum Role {

    PARTICIPANT(
            List.of("/catalogue.jsp", "/detail-evenement.jsp", "/paiement.jsp"),
            "/evenements?action=listAll"
    ),
    AGENT_CONTROLE(
            List.of("/scanner.jsp"),
            "/scanner.jsp"
    ),
    ORGANISATEUR(
            List.of("/dashboard.jsp"),
            "/evenements"
    ),
    ADMIN(
            List.of("/admin-dashboard.jsp", "/dashboard.jsp"),
            "/admin-dashboard.jsp"
    );

    private final List<String> allowedPages;
    private final String defaultRedirect;

    Role(List<String> allowedPages, String defaultRedirect) {
        this.allowedPages = allowedPages;
        this.defaultRedirect = defaultRedirect;
    }

    public List<String> getAllowedPages() { return allowedPages; }
    public String getDefaultRedirect()    { return defaultRedirect; }
}
