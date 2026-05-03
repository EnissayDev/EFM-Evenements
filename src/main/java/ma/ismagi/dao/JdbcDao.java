package ma.ismagi.dao;

import java.sql.ResultSet;
import java.sql.SQLException;

public abstract class JdbcDao<T, ID> implements CrudDao<T, ID> {
    protected abstract String tableName();
    protected abstract T mapRow(ResultSet rs) throws SQLException;
}