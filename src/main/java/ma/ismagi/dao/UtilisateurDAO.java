package ma.ismagi.dao;

import ma.ismagi.model.Utilisateur;

public class UtilisateurDAO extends JdbcDao<Utilisateur, Integer> {

    @Override
    protected String tableName() { return "utilisateur"; }

    @Override
    protected String idColumn() { return "id"; }

    @Override
    protected Class<Utilisateur> entityClass() { return Utilisateur.class; }
}