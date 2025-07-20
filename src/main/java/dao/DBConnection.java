package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    
    // Database configuration
    private static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=KidSocialDB;encrypt=false;trustServerCertificate=true";
    private static final String USER_DB = "sa";
    private static final String PASS_DB = "sa";
    
    private static boolean driverLoaded = false;
    
    static {
        try {
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            driverLoaded = true;
            LOGGER.info("SQL Server JDBC driver loaded successfully");
        } catch (ClassNotFoundException ex) {
            LOGGER.severe("Failed to load SQL Server JDBC driver: " + ex.getMessage());
            driverLoaded = false;
        }
    }
    
    public static Connection getConnection() {
        if (!driverLoaded) {
            LOGGER.severe("Cannot get connection: JDBC driver not loaded");
            return null;
        }
        
        try {
            LOGGER.info("Attempting database connection to: " + DB_URL);
            Connection con = DriverManager.getConnection(DB_URL, USER_DB, PASS_DB);
            if (con != null && !con.isClosed()) {
                LOGGER.info("Database connection established successfully");
                return con;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to establish database connection: " + ex.getMessage(), ex);
            LOGGER.severe("Connection URL: " + DB_URL);
            LOGGER.severe("Username: " + USER_DB);
        }
        return null;
    }
    
    public static boolean testConnection() {
        LOGGER.info("=== DATABASE CONNECTION TEST STARTED ===");
        try (Connection con = getConnection()) {
            boolean isValid = con != null && !con.isClosed();
            LOGGER.info("Connection test result: " + isValid);
            
            if (isValid) {
                LOGGER.info("✅ Database connection test PASSED");
            } else {
                LOGGER.severe("❌ Database connection test FAILED - connection is null or closed");
            }
            
            LOGGER.info("=== DATABASE CONNECTION TEST COMPLETED ===");
            return isValid;
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "❌ Connection test failed with SQLException", ex);
            LOGGER.info("=== DATABASE CONNECTION TEST COMPLETED ===");
            return false;
        }
    }
}
