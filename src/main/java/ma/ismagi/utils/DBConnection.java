package ma.ismagi.utils;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

import java.sql.Connection;
import java.sql.SQLException;

public final class DBConnection {

    private static HikariDataSource dataSource;

    private static synchronized HikariDataSource getDataSource() {
        if (dataSource == null) {
            HikariConfig config = new HikariConfig();
            config.setJdbcUrl(getEnvOrDefault("DB_URL", "jdbc:mysql://localhost:3306/efm_evenements?useSSL=false&serverTimezone=UTC"));
            config.setUsername(getEnvOrDefault("DB_USER", "root"));
            config.setPassword(getEnvOrDefault("DB_PASSWORD", ""));
            config.setDriverClassName(getEnvOrDefault("DB_DRIVER", "com.mysql.cj.jdbc.Driver"));
            config.setMaximumPoolSize(10);
            config.setMinimumIdle(2);
            config.setIdleTimeout(300000);
            config.setConnectionTimeout(30000);
            config.setMaxLifetime(1800000);
            config.setPoolName("EFM-Pool");
            config.setAutoCommit(true);
            dataSource = new HikariDataSource(config);
        }
        return dataSource;
    }

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        return getDataSource().getConnection();
    }

    public static void shutdown() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
            dataSource = null; // ← allow re-init (important for tests)
        }
    }

    private static String getEnvOrDefault(String key, String defaultValue) {
        String value = System.getenv(key);
        if (value == null || value.isEmpty()) value = System.getProperty(key);
        return (value == null || value.isEmpty()) ? defaultValue : value;
    }
}