package dao;

import dao.DBConnection;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReportDAO {
    private static final Logger LOGGER = Logger.getLogger(ReportDAO.class.getName());
    
    public ReportDAO() {
        LOGGER.info("ReportDAO initialized");
    }
    
    public int getActiveReportsCount() {
        String sql = "SELECT COUNT(*) FROM ContentReports WHERE status = 'pending'";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot get active reports count: Database connection failed");
                return 0;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.info("Active reports count: " + count);
                    return count;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to get active reports count", ex);
        }
        
        return 0;
    }
    
    public int getNewReportsCountToday() {
        String sql = "SELECT COUNT(*) FROM ContentReports WHERE created_at >= CAST(GETDATE() AS DATE)";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot get new reports count today: Database connection failed");
                return 0;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.info("New reports today: " + count);
                    return count;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to get new reports count today", ex);
        }
        
        return 0;
    }
}
