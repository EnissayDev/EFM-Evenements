package ma.ismagi.dao;

import ma.ismagi.model.Role;
import ma.ismagi.model.Utilisateur;
import ma.ismagi.utils.DBConnection;
import org.junit.jupiter.api.*;

import java.sql.Connection;
import java.sql.Statement;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class UtilisateurDAOTest {

    private static UtilisateurDAO dao;

    @BeforeAll
    static void setup() throws Exception {
        System.setProperty("DB_URL", "jdbc:h2:mem:testdb;DB_CLOSE_DELAY=-1;MODE=MySQL");
        System.setProperty("DB_USER", "sa");
        System.setProperty("DB_PASSWORD", "");
        System.setProperty("DB_DRIVER", "org.h2.Driver");

        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            st.execute("""
            CREATE TABLE IF NOT EXISTS utilisateur (
                id INT AUTO_INCREMENT PRIMARY KEY,
                nom VARCHAR(100) NOT NULL,
                prenom VARCHAR(100) NOT NULL,
                email VARCHAR(150) NOT NULL UNIQUE,
                password_hash VARCHAR(255) NOT NULL,
                role VARCHAR(30) NOT NULL,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
        """);
        }

        dao = new UtilisateurDAO();
    }

    @BeforeEach
    void clearTable() throws Exception {
        try (Connection con = DBConnection.getConnection();
             Statement st = con.createStatement()) {
            st.execute("DELETE FROM utilisateur");
        }
    }

    private Utilisateur makeUser(String email) {
        return Utilisateur.builder()
                .nom("Test")
                .prenom("User")
                .email(email)
                .passwordHash("hashedpassword")
                .role(Role.PARTICIPANT)
                .build();
    }

    @Test
    void testCreate() {
        dao.create(makeUser("test@example.com"));
        List<Utilisateur> all = dao.findAll();
        assertEquals(1, all.size());
        assertEquals("test@example.com", all.get(0).getEmail());

        System.out.println("testCreate passed");
        System.out.println("  Created: " + all.get(0).getEmail() + " | Role: " + all.get(0).getRole());
    }

    @Test
    void testFindById() {
        dao.create(makeUser("find@example.com"));
        Utilisateur created = dao.findAll().get(0);
        Utilisateur found = dao.findById(created.getId());
        assertNotNull(found);
        assertEquals("find@example.com", found.getEmail());

        System.out.println("testFindById passed");
        System.out.println("  Found by id=" + found.getId() + ": " + found.getNom() + " " + found.getPrenom());
    }

    @Test
    void testFindById_notFound() {
        Utilisateur found = dao.findById(999);
        assertNull(found);

        System.out.println("testFindById_notFound passed");
        System.out.println("  id=999 correctly returned null");
    }

    @Test
    void testFindAll() {
        dao.create(makeUser("user1@example.com"));
        dao.create(makeUser("user2@example.com"));
        dao.create(makeUser("user3@example.com"));
        List<Utilisateur> all = dao.findAll();
        assertEquals(3, all.size());

        System.out.println("testFindAll passed -- " + all.size() + " utilisateurs found:");
        all.forEach(u -> System.out.println("  - [" + u.getId() + "] " + u.getNom() + " | " + u.getEmail() + " | " + u.getRole()));
    }

    @Test
    void testUpdate() {
        dao.create(makeUser("update@example.com"));
        Utilisateur created = dao.findAll().get(0);

        Utilisateur updated = Utilisateur.builder()
                .id(created.getId())
                .nom("Updated")
                .prenom("Name")
                .email("updated@example.com")
                .passwordHash("newhash")
                .role(Role.ADMIN)
                .build();

        dao.update(updated);
        Utilisateur found = dao.findById(created.getId());
        assertEquals("Updated", found.getNom());
        assertEquals(Role.ADMIN, found.getRole());

        System.out.println("testUpdate passed");
        System.out.println("  Before: update@example.com | PARTICIPANT");
        System.out.println("  After:  " + found.getEmail() + " | " + found.getRole());
    }

    @Test
    void testDelete() {
        dao.create(makeUser("delete@example.com"));
        Utilisateur created = dao.findAll().get(0);
        int id = created.getId();
        dao.delete(id);

        assertNull(dao.findById(id));
        assertEquals(0, dao.findAll().size());

        System.out.println("testDelete passed");
        System.out.println("  Utilisateur id=" + id + " deleted, findById returned null");
    }

    @Test
    void testCreate_duplicateEmail_throwsException() {
        dao.create(makeUser("dup@example.com"));
        Exception ex = assertThrows(RuntimeException.class, () -> dao.create(makeUser("dup@example.com")));

        System.out.println("testCreate_duplicateEmail_throwsException passed");
        System.out.println("  Exception caught: " + ex.getMessage());
    }
}