package ma.ismagi.model;

import lombok.Builder;
import lombok.Getter;

@Getter @Builder
public class Utilisateur {

    private int id;
    private String nom, prenom, email, passwordHash;
    private Role role;
}
