package ma.ismagi.dao;

import ma.ismagi.model.Evenement;
import ma.ismagi.model.Table;
import ma.ismagi.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@Table("evenement")
public class EvenementDAO extends JdbcDao<Evenement, Integer> {

    public List<Evenement> rechercher(String keyword, String category, String lieu) {
        List<Evenement> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM evenement WHERE 1=1");
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.isBlank()) {
            sql.append(" AND titre LIKE ?");
            params.add("%" + keyword.trim() + "%");
        }
        if (category != null && !category.isBlank()) {
            sql.append(" AND categorie = ?");
            params.add(category.trim());
        }
        if (lieu != null && !lieu.isBlank()) {
            sql.append(" AND lieu = ?");
            params.add(lieu.trim());
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRow(rs));
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error searching evenements", e);
        }

        return list;
    }

    public List<Evenement> findByOrganisateur(int organisateurId, String search, String sort) {
        List<Evenement> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT e.*, COALESCE((SELECT SUM(c.quantite) FROM commande c WHERE c.evenement_id = e.id), 0) AS billets_vendus " +
                "FROM evenement e WHERE e.organisateur_id = ?");
        List<Object> params = new ArrayList<>();
        params.add(organisateurId);

        if (search != null && !search.isBlank()) {
            sql.append(" AND e.titre LIKE ?");
            params.add("%" + search.trim() + "%");
        }

        switch (sort == null ? "dateDesc" : sort) {
            case "dateAsc" -> sql.append(" ORDER BY e.date ASC");
            case "places"  -> sql.append(" ORDER BY billets_vendus ASC");
            default        -> sql.append(" ORDER BY e.date DESC");
        }

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Evenement ev = mapRow(rs);
                    ev.setBilletsVendus(rs.getInt("billets_vendus"));
                    list.add(ev);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error fetching evenements for organisateur " + organisateurId, e);
        }

        return list;
    }

    public List<String> getVillesDistinctes() {
        List<String> villes = new ArrayList<>();
        String sql = "SELECT DISTINCT lieu FROM evenement WHERE lieu IS NOT NULL ORDER BY lieu";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) villes.add(rs.getString("lieu"));
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching villes distinctes", e);
        }
        return villes;
    }

    public List<String> getCategoriesDistinctes() {
        List<String> categories = new ArrayList<>();
        String sql = "SELECT DISTINCT categorie FROM evenement WHERE categorie IS NOT NULL ORDER BY categorie";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) categories.add(rs.getString("categorie"));
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching categories distinctes", e);
        }
        return categories;
    }
}
