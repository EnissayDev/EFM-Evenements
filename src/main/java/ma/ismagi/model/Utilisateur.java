package ma.ismagi.model;

import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Utilisateur {

    @Column
    private int id;
    @Column
    private String nom;
    @Column
    private String prenom;
    @Column
    private String email;
    @Column("password_hash")
    private String passwordHash;
    @Column
    private Role role;
}