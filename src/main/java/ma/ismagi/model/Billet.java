package ma.ismagi.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Builder
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Billet {

    @Column
    private int id;

    @Column("commande_id")
    private int commandeId;

    @Column
    private String code;
}