package ma.ismagi.dao;

import ma.ismagi.model.Commande;
import ma.ismagi.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CommandeDAO extends JdbcDao<Commande, Integer> {

    @Override
    protected String tableName() { return "commande"; }

    @Override
    protected String idColumn() { return "id"; }

    @Override
    protected Class<Commande> entityClass() { return Commande.class; }

    /**
     * Returns all commandes for events belonging to a given organiser,
     * with the event title included (not a mapped column, filled manually).
     */
    public List<Commande> findByOrganisateur(int organisateurId) {
        List<Commande> commandes = new ArrayList<>();

        String sql = """
                SELECT c.id, c.evenement_id, c.participant_id,
                       c.quantite, c.montant_total,
                       e.titre AS evenement_titre
                FROM commande c
                JOIN evenement e ON e.id = c.evenement_id
                WHERE e.organisateur_id = ?
                ORDER BY c.id DESC
                """;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, organisateurId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Commande c = new Commande();
                    c.setId(rs.getInt("id"));
                    c.setEvenementId(rs.getInt("evenement_id"));
                    c.setParticipantId(rs.getInt("participant_id"));
                    c.setQuantite(rs.getInt("quantite"));
                    c.setMontantTotal(rs.getDouble("montant_total"));
                    c.setEvenementTitre(rs.getString("evenement_titre"));
                    commandes.add(c);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching commandes for organisateur " + organisateurId, e);
        }

        return commandes;
    }
}