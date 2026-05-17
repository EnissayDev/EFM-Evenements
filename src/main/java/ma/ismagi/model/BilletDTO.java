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
public class BilletDTO {
    private int id;
    private String code;
    private String evenementTitre;
    private LocalDate dateEvenement;
    private String lieu;
    private String typePlace;
    private double prixPaye;
    private String statut;
}
