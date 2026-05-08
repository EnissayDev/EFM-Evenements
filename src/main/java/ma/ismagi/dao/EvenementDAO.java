package ma.ismagi.dao;

import ma.ismagi.model.Evenement;

public class EvenementDAO extends JdbcDao<Evenement, Integer> {

    @Override
    protected String tableName() { return "evenement"; }

    @Override
    protected String idColumn() { return "id"; }

    @Override
    protected Class<Evenement> entityClass() { return Evenement.class; }
}