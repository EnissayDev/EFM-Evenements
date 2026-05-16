package ma.ismagi.utils;

import ma.ismagi.dao.UtilisateurDAO;
import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

public final class DataSeeder {

    private DataSeeder() {}

    public static void seedDefaultUsers() {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement();
             ResultSet rs = st.executeQuery("SELECT COUNT(*) FROM utilisateur")) {

            if (rs.next() && rs.getInt(1) > 0) return;

        } catch (Exception e) {
            throw new RuntimeException("Failed to check utilisateur count", e);
        }

        UtilisateurDAO dao = new UtilisateurDAO();
        String password = PasswordUtils.hash("123");

        dao.create(Utilisateur.builder().nom("Admin").prenom("Admin")
                .email("admin@gmail.com").passwordHash(password).role(Role.ADMIN).build());

        dao.create(Utilisateur.builder().nom("Organisateur").prenom("Organisateur")
                .email("organisateur@gmail.com").passwordHash(password).role(Role.ORGANISATEUR).build());

        dao.create(Utilisateur.builder().nom("Participant").prenom("Participant")
                .email("participant@gmail.com").passwordHash(password).role(Role.PARTICIPANT).build());

        dao.create(Utilisateur.builder().nom("Agent").prenom("Controle")
                .email("agent_controle@gmail.com").passwordHash(password).role(Role.AGENT_CONTROLE).build());

        System.out.println("Default users seeded.");
    }
}
