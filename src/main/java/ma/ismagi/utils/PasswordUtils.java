package ma.ismagi.utils;

import java.security.MessageDigest;
import java.security.SecureRandom;
import java.util.Base64;

public final class PasswordUtils {

    private PasswordUtils() {}

    public static String hash(String password) {
        try {
            SecureRandom random = new SecureRandom();
            byte[] salt = new byte[16];
            random.nextBytes(salt);

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(password.getBytes());

            String saltB64 = Base64.getEncoder().encodeToString(salt);
            String hashB64 = Base64.getEncoder().encodeToString(hashed);

            return saltB64 + ":" + hashB64;
        } catch (Exception e) {
            throw new RuntimeException("Error hashing password", e);
        }
    }

    public static boolean verify(String password, String stored) {
        try {
            String[] parts = stored.split(":");
            byte[] salt = Base64.getDecoder().decode(parts[0]);

            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(salt);
            byte[] hashed = md.digest(password.getBytes());

            return parts[1].equals(Base64.getEncoder().encodeToString(hashed));
        } catch (Exception e) {
            throw new RuntimeException("Error verifying password", e);
        }
    }
}