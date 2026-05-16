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

    public List<Evenement> rechercher(String keyword, String category) {
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
}
