package ma.ismagi.dao;

import ma.ismagi.model.Billet;

public class BilletDAO extends JdbcDao<Billet, Integer> {

    @Override
    protected String tableName() { return "billet"; }

    @Override
    protected String idColumn() { return "id"; }

    @Override
    protected Class<Billet> entityClass() { return Billet.class; }
}