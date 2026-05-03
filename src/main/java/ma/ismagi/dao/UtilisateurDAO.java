package ma.ismagi.dao;

import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashMap;

public class UtilisateurDAO extends JdbcDao<Utilisateur, Integer> {

    @Override
    protected String tableName() {
        return "utilisateur";
    }

    @Override
    protected String idColumn() {
        return "id";
    }

    @Override
    protected Utilisateur mapRow(ResultSet rs) throws SQLException {
        return Utilisateur.builder()
                .id(rs.getInt("id"))
                .nom(rs.getString("nom"))
                .prenom(rs.getString("prenom"))
                .email(rs.getString("email"))
                .passwordHash(rs.getString("password_hash"))
                .role(Role.valueOf(rs.getString("role")))
                .build();
    }

    @Override
    protected LinkedHashMap<String, Object> insertValues(Utilisateur u) {
        LinkedHashMap<String, Object> values = new LinkedHashMap<>();
        values.put("nom", u.getNom());
        values.put("prenom", u.getPrenom());
        values.put("email", u.getEmail());
        values.put("password_hash", u.getPasswordHash());
        values.put("role", u.getRole().name());
        return values;
    }

    @Override
    protected LinkedHashMap<String, Object> updateValues(Utilisateur u) {
        LinkedHashMap<String, Object> values = new LinkedHashMap<>();
        values.put("nom", u.getNom());
        values.put("prenom", u.getPrenom());
        values.put("email", u.getEmail());
        values.put("password_hash", u.getPasswordHash());
        values.put("role", u.getRole().name());
        return values;
    }

    @Override
    protected Integer getId(Utilisateur u) {
        return u.getId();
    }
}