package ma.ismagi.dao;

import java.util.List;

public interface CrudDao<T, ID>{

    void create(T entity);
    T findById(ID id);
    T findByAttribute(String attributeName, Object value);
    List<T> findAll();
    List<T> findAll(int limit);
    void update(T entity);
    void delete(ID id);
}
