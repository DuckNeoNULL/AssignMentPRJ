package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class DBConnection {
    private static final Logger LOGGER = Logger.getLogger(DBConnection.class.getName());
    
    public static final String DRIVER_NAME = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
    public static final String DB_URL = "jdbc:sqlserver://localhost:1433;databaseName=KidSocialDB;encrypt=true;trustServerCertificate=true";
    public static final String USER_DB = "sa";
    public static final String PASS_DB = "sa";
    
    private static boolean driverLoaded = false;
    
    static {
        loadDriver();
    }
    
    private static synchronized void loadDriver() {
        if (!driverLoaded) {
            try {
                Class.forName(DRIVER_NAME);
                driverLoaded = true;
                LOGGER.info("SQL Server JDBC driver loaded successfully");
            } catch (ClassNotFoundException ex) {
                LOGGER.log(Level.SEVERE, "CRITICAL: Failed to load SQL Server JDBC driver. Check if mssql-jdbc JAR is in classpath.", ex);
                driverLoaded = false;
            }
        }
    }
    
    public static Connection getConnection() {
        if (!driverLoaded) {
            LOGGER.severe("Cannot get connection: JDBC driver not loaded");
            return null;
        }
        
        try {
            Connection con = DriverManager.getConnection(DB_URL, USER_DB, PASS_DB);
            if (con != null && !con.isClosed()) {
                LOGGER.fine("Database connection established successfully");
                return con;
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Failed to establish database connection: " + ex.getMessage(), ex);
        }
        return null;
    }
    
    public static boolean testConnection() {
        try (Connection con = getConnection()) {
            return con != null && !con.isClosed();
        } catch (SQLException ex) {
            LOGGER.log(Level.WARNING, "Connection test failed", ex);
            return false;
        }
    }
}
