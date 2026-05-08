package ma.ismagi.dao;

import ma.ismagi.model.Billet;
import ma.ismagi.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

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
