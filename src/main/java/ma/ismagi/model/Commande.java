package ma.ismagi.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Commande {

    @Column
    private int id;

    @Column("evenement_id")
    private int evenementId;

    @Column("participant_id")
    private int participantId;

    @Column
    private int quantite;

    @Column("montant_total")
    private double montantTotal;

    // Not a DB column — populated by custom JOIN query in CommandeDAO
    private String evenementTitre;
}