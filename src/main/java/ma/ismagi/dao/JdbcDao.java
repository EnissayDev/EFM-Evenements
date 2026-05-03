package ma.ismagi.dao;

import ma.ismagi.utils.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

public abstract class JdbcDao<T, ID> implements CrudDao<T, ID> {

    protected abstract String tableName();
    protected abstract String idColumn();
    protected abstract T mapRow(ResultSet rs) throws SQLException;
    protected abstract LinkedHashMap<String, Object> insertValues(T entity);
    protected abstract LinkedHashMap<String, Object> updateValues(T entity);
    protected abstract ID getId(T entity);

    public void create(T entity) {
        LinkedHashMap<String, Object> values = insertValues(entity);

        StringBuilder columns = new StringBuilder();
        StringBuilder placeholders = new StringBuilder();

        int i = 0;
        for (String column : values.keySet()) {
            if (i++ > 0) {
                columns.append(", ");
                placeholders.append(", ");
            }
            columns.append(column);
            placeholders.append("?");
        }

        String sql = "INSERT INTO " + tableName() +
                " (" + columns + ") VALUES (" + placeholders + ")";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            int index = 1;
            for (Object value : values.values()) {
                ps.setObject(index++, value);
            }

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error while creating entity in " + tableName(), e);
        }
    }

    public T findById(ID id) {
        String sql = "SELECT * FROM " + tableName() + " WHERE " + idColumn() + " = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setObject(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRow(rs);
                }
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error while finding entity by id in " + tableName(), e);
        }

        return null;
    }

    public List<T> findAll() {
        List<T> list = new ArrayList<>();
        String sql = "SELECT * FROM " + tableName();

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }

        } catch (SQLException e) {
            throw new RuntimeException("Error while finding all entities in " + tableName(), e);
        }

        return list;
    }

    public void update(T entity) {
        LinkedHashMap<String, Object> values = updateValues(entity);

        StringBuilder setClause = new StringBuilder();
        int i = 0;

        for (String column : values.keySet()) {
            if (i++ > 0) {
                setClause.append(", ");
            }
            setClause.append(column).append(" = ?");
        }

        String sql = "UPDATE " + tableName() +
                " SET " + setClause +
                " WHERE " + idColumn() + " = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            int index = 1;
            for (Object value : values.values()) {
                ps.setObject(index++, value);
            }

            ps.setObject(index, getId(entity));

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error while updating entity in " + tableName(), e);
        }
    }

    public void delete(ID id) {
        String sql = "DELETE FROM " + tableName() + " WHERE " + idColumn() + " = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setObject(1, id);
            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException("Error while deleting entity from " + tableName(), e);
        }
    }
}