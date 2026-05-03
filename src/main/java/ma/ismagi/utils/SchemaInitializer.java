package ma.ismagi.utils;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.sql.Connection;
import java.sql.Statement;

public final class SchemaInitializer {

    private SchemaInitializer() {}

    public static void init() {
        try (InputStream is = SchemaInitializer.class.getClassLoader().getResourceAsStream("schema.sql")) {
            if (is == null) {
                throw new IllegalStateException("schema.sql not found in resources");
            }

            StringBuilder sql = new StringBuilder();
            try (BufferedReader reader = new BufferedReader(new InputStreamReader(is, StandardCharsets.UTF_8))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    line = line.trim();
                    if (!line.isEmpty() && !line.startsWith("--")) {
                        sql.append(line).append("\n");
                    }
                }
            }

            try (Connection con = DBConnection.getConnection();
                 Statement st = con.createStatement()) {

                for (String statement : sql.toString().split(";")) {
                    String trimmed = statement.trim();
                    if (!trimmed.isEmpty()) {
                        st.execute(trimmed);
                    }
                }
            }

            System.out.println("Schema initialized successfully.");

        } catch (Exception e) {
            throw new RuntimeException("Failed to initialize schema", e);
        }
    }
}