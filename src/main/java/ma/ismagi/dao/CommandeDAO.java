package ma.ismagi.dao;

import ma.ismagi.model.Commande;
import ma.ismagi.model.Table;
import ma.ismagi.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

@Table("commande")
public class CommandeDAO extends JdbcDao<Commande, Integer> {

    public int createAndGetId(Commande commande) {
        LinkedHashMap<String, Object> values = insertValues(commande);

        StringBuilder columns      = new StringBuilder();
        StringBuilder placeholders = new StringBuilder();
        int i = 0;
        for (String col : values.keySet()) {
            if (i++ > 0) { columns.append(", "); placeholders.append(", "); }
            columns.append(col);
            placeholders.append("?");
        }

        String sql = "INSERT INTO commande (" + columns + ") VALUES (" + placeholders + ")";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            int index = 1;
            for (Object value : values.values()) ps.setObject(index++, value);
            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) return keys.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error creating commande", e);
        }

        throw new RuntimeException("No generated key returned for commande");
    }

    public int countBilletsByEvenement(int evenementId) {
        String sql = "SELECT COALESCE(SUM(quantite), 0) FROM commande WHERE evenement_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, evenementId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting billets for evenement " + evenementId, e);
        }
        return 0;
    }

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
