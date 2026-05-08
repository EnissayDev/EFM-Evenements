package ma.ismagi.dao;

import ma.ismagi.model.Billet;
import ma.ismagi.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BilletDAO extends JdbcDao<Billet, Integer> {

    @Override
    protected String tableName() { return "billet"; }

    @Override
    protected String idColumn() { return "id"; }

    @Override
    protected Class<Billet> entityClass() { return Billet.class; }

    public Billet findByCode(String code) {
        return findByAttribute("code", code);
    }

    public List<Billet> findByParticipantAndEvenement(int participantId, int evenementId) {
        List<Billet> billets = new ArrayList<>();
        String sql = """
                SELECT b.id, b.commande_id, b.code, b.statut
                FROM billet b
                JOIN commande c ON c.id = b.commande_id
                WHERE c.participant_id = ? AND c.evenement_id = ?
                ORDER BY b.id
                """;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, participantId);
            ps.setInt(2, evenementId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    billets.add(mapRow(rs));
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching billets for participant " + participantId, e);
        }
        return billets;
    }

    public void valider(int id) {
        String sql = "UPDATE billet SET statut = 'VALIDE' WHERE id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error validating billet " + id, e);
        }
    }
}
