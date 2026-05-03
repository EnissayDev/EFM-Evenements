package ma.ismagi.model;

import lombok.Getter;

@Getter
public class Utilisateur {

    private int id;
    private String nom, prenom, email, passwordHash;
    private Role role;
}
