package ma.ismagi.dao;

import ma.ismagi.model.Utilisateur;
import ma.ismagi.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UtilisateurDAO extends JdbcDao<Utilisateur, Integer> {

    @Override
    protected String tableName() { return "utilisateur"; }

    @Override
    protected String idColumn() { return "id"; }

    @Override
    protected Class<Utilisateur> entityClass() { return Utilisateur.class; }

    public Utilisateur findByEmail(String email) {
        String sql = "SELECT * FROM utilisateur WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setObject(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error finding utilisateur by email", e);
        }
        return null;
    }
}