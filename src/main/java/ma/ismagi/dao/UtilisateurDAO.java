package ma.ismagi.dao;

import ma.ismagi.model.Table;
import ma.ismagi.model.Utilisateur;

@Table("utilisateur")
public class UtilisateurDAO extends JdbcDao<Utilisateur, Integer> {
}
