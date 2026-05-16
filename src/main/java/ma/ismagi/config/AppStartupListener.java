package ma.ismagi.config;

import com.mysql.cj.jdbc.AbandonedConnectionCleanupThread;
import ma.ismagi.utils.DBConnection;
import ma.ismagi.utils.DataSeeder;
import ma.ismagi.utils.SchemaInitializer;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.sql.Driver;
import java.sql.DriverManager;
import java.util.Enumeration;

@WebListener
public class AppStartupListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        System.out.println("AppStartupListener started");
        SchemaInitializer.init();
        DataSeeder.seedDefaultUsers();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        DBConnection.shutdown();

        AbandonedConnectionCleanupThread.checkedShutdown();

        Enumeration<Driver> drivers = DriverManager.getDrivers();
        while (drivers.hasMoreElements()) {
            Driver driver = drivers.nextElement();
            try {
                DriverManager.deregisterDriver(driver);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        System.out.println("App stopped");
    }
}