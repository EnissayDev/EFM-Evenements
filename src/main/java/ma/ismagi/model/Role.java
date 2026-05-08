package ma.ismagi.model;

import java.util.List;

public enum Role {

    PARTICIPANT(
            List.of("/catalogue", "/evenement", "/paiement"),
            "/catalogue"
    ),
    AGENT_CONTROLE(
            List.of("/scanner"),
            "/scanner"
    ),
    ORGANISATEUR(
            List.of("/dashboard"),
            "/dashboard"
    ),
    ADMIN(
            List.of("/admin", "/dashboard"),
            "/admin"
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
