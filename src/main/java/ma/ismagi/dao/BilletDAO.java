package ma.ismagi.dao;

import ma.ismagi.model.Billet;
import ma.ismagi.model.BilletDTO;
import ma.ismagi.model.Evenement;
import ma.ismagi.model.Table;
import ma.ismagi.utils.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

@Table("billet")
public class BilletDAO extends JdbcDao<Billet, Integer> {

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

    public List<BilletDTO> getBilletsFiltres(int clientId, String search, String filter) {
        List<Object> params = new ArrayList<>();
        params.add(clientId);

        StringBuilder where   = new StringBuilder(" AND 1=1");
        StringBuilder orderBy = new StringBuilder(" ORDER BY b.created_at DESC");

        if (search != null && !search.isBlank()) {
            where.append(" AND e.titre LIKE ?");
            params.add("%" + search.trim() + "%");
        }

        switch (filter == null ? "" : filter) {
            case "oldest"     -> orderBy = new StringBuilder(" ORDER BY b.created_at ASC");
            case "soon"       -> { where.append(" AND e.date >= CURDATE()");
                                   orderBy = new StringBuilder(" ORDER BY e.date ASC"); }
            case "later"      -> { where.append(" AND e.date >= CURDATE()");
                                   orderBy = new StringBuilder(" ORDER BY e.date DESC"); }
            case "actif"      -> where.append(" AND b.statut = 'ACTIF'");
            case "inactif"    -> where.append(" AND b.statut = 'VALIDE'");
            case "high_price" -> orderBy = new StringBuilder(" ORDER BY prix_paye DESC");
            case "low_price"  -> orderBy = new StringBuilder(" ORDER BY prix_paye ASC");
            default           -> { /* newest — default ORDER BY already set */ }
        }

        String sql = "SELECT b.id, b.code, b.statut, e.titre, e.date AS date_evenement, e.lieu, "
                   + "e.prix_standard, e.prix_vip, (c.montant_total / c.quantite) AS prix_paye "
                   + "FROM billet b "
                   + "JOIN commande c ON c.id = b.commande_id "
                   + "JOIN evenement e ON e.id = c.evenement_id "
                   + "WHERE c.participant_id = ?"
                   + where + orderBy;

        List<BilletDTO> list = new ArrayList<>();
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    double prixPaye = rs.getDouble("prix_paye");
                    double prixVip  = rs.getDouble("prix_vip");
                    String typePlace = Math.abs(prixPaye - prixVip) < 0.01 ? "VIP" : "Standard";

                    list.add(BilletDTO.builder()
                            .id(rs.getInt("id"))
                            .code(rs.getString("code"))
                            .evenementTitre(rs.getString("titre"))
                            .dateEvenement(rs.getDate("date_evenement").toLocalDate())
                            .lieu(rs.getString("lieu"))
                            .typePlace(typePlace)
                            .prixPaye(prixPaye)
                            .statut(rs.getString("statut"))
                            .build());
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching billets filtrés for client " + clientId, e);
        }
        return list;
    }

    public Evenement findEvenementByBilletId(int billetId, int clientId) {
        String sql = "SELECT e.* FROM evenement e "
                   + "JOIN commande c ON c.evenement_id = e.id "
                   + "JOIN billet b ON b.commande_id = c.id "
                   + "WHERE b.id = ? AND c.participant_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, billetId);
            ps.setInt(2, clientId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return Evenement.builder()
                            .id(rs.getInt("id"))
                            .titre(rs.getString("titre"))
                            .description(rs.getString("description"))
                            .date(rs.getDate("date").toLocalDate())
                            .capacite(rs.getInt("capacite"))
                            .lieu(rs.getString("lieu"))
                            .categorie(rs.getString("categorie"))
                            .prixStandard(rs.getDouble("prix_standard"))
                            .prixVip(rs.getDouble("prix_vip"))
                            .imagePath(rs.getString("image_path"))
                            .organisateurId(rs.getInt("organisateur_id"))
                            .build();
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching evenement for billet " + billetId, e);
        }
        return null;
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
