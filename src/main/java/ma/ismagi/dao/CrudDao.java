package ma.ismagi.dao;

import java.util.List;

public interface CrudDao<T, ID>{

    void create(T entity);
    T findById(ID id);
    List<T> findAll();
    void update(T entity);
    void delete(ID id);
}
