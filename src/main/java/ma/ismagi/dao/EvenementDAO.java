package ma.ismagi.dao;

import ma.ismagi.model.Evenement;
import ma.ismagi.model.Table;

@Table("evenement")
public class EvenementDAO extends JdbcDao<Evenement, Integer> {
}
