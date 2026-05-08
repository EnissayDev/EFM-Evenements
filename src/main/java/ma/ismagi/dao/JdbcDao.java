package ma.ismagi.dao;

import ma.ismagi.model.Column;
import ma.ismagi.utils.DBConnection;

import java.lang.reflect.Field;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;

public abstract class JdbcDao<T, ID> implements CrudDao<T, ID> {

    protected abstract String tableName();
    protected abstract String idColumn();
    protected abstract Class<T> entityClass();

    protected T mapRow(ResultSet rs) throws SQLException {
        try {
            T entity = entityClass().getDeclaredConstructor().newInstance();
            for (Field field : entityClass().getDeclaredFields()) {
                if (!field.isAnnotationPresent(Column.class)) continue;
                String col = getColumnName(field);
                field.setAccessible(true);
                Object value = rs.getObject(col);
                if (value != null) {
                    if (field.getType() == LocalDate.class && value instanceof Date) {
                        value = ((Date) value).toLocalDate();
                    } else if (field.getType() == LocalDateTime.class && value instanceof Timestamp) {
                        value = ((Timestamp) value).toLocalDateTime();
                    } else if (field.getType().isEnum()) {
                        value = Enum.valueOf((Class<Enum>) field.getType(), value.toString());
                    } else if (value instanceof Number n) {
                        Class<?> t = field.getType();
                        if      (t == double.class || t == Double.class)  value = n.doubleValue();
                        else if (t == float.class  || t == Float.class)   value = n.floatValue();
                        else if (t == int.class    || t == Integer.class) value = n.intValue();
                        else if (t == long.class   || t == Long.class)    value = n.longValue();
                    }
                }
                field.set(entity, value);
            }
            return entity;
        } catch (Exception e) {
            throw new SQLException("Error mapping row to " + entityClass().getSimpleName(), e);
        }
    }

    protected LinkedHashMap<String, Object> insertValues(T entity) {
        return columnValues(entity);
    }

    protected LinkedHashMap<String, Object> updateValues(T entity) {
        return columnValues(entity);
    }

    protected ID getId(T entity) {
        try {
            for (Field field : entityClass().getDeclaredFields()) {
                if (!field.isAnnotationPresent(Column.class)) continue;
                String col = getColumnName(field);
                if (col.equals(idColumn())) {
                    field.setAccessible(true);
                    return (ID) field.get(entity);
                }
            }
        } catch (Exception e) {
            throw new RuntimeException("Error getting id from " + entityClass().getSimpleName(), e);
        }
        return null;
    }

    private LinkedHashMap<String, Object> columnValues(T entity) {
        LinkedHashMap<String, Object> values = new LinkedHashMap<>();
        try {
            for (Field field : entityClass().getDeclaredFields()) {
                if (!field.isAnnotationPresent(Column.class)) continue;
                String col = getColumnName(field);
                if (col.equals(idColumn())) continue; // skip id on insert/update
                field.setAccessible(true);
                Object value = field.get(entity);
                values.put(col, value instanceof Enum ? ((Enum<?>) value).name() : value);
            }
        } catch (Exception e) {
            throw new RuntimeException("Error reading fields from " + entityClass().getSimpleName(), e);
        }
        return values;
    }

    @Override
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

    @Override
    public T findById(ID id) {
        return findByAttribute(idColumn(), id);
    }

    @Override
    public T findByAttribute(String attributeName, Object value) {
        String sql = "SELECT * FROM " + tableName() + " WHERE " + attributeName + " = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setObject(1, value);

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

    @Override
    public List<T> findAll(int limit) {
        List<T> list = new ArrayList<>();
        String sql = "SELECT * FROM " + tableName() + (limit > 0 ? " LIMIT " + limit : "");

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

    @Override
    public List<T> findAll() {
        return findAll(-1);
    }

    @Override
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

    @Override
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

    private String getColumnName(Field field) {
        String col = field.getAnnotation(Column.class).value();
        return col.isEmpty() ? field.getName() : col;
    }
}