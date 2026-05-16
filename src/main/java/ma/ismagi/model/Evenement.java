package ma.ismagi.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Evenement {

    @Column
    private int id;

    @Column
    private String titre;

    @Column
    private String description;

    @Column
    private LocalDate date;

    @Column
    private int capacite;

    @Column
    private String lieu;

    @Column("organisateur_id")
    private int organisateurId;

    @Column
    private String categorie;
}