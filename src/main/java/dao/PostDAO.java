package dao;

import dao.DBConnection;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PostDAO {
    private static final Logger LOGGER = Logger.getLogger(PostDAO.class.getName());
    
    public PostDAO() {
        LOGGER.info("PostDAO initialized");
    }
    
    public int getTotalPostsCount() {
        String sql = "SELECT COUNT(*) FROM Posts";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot get total posts count: Database connection failed");
                return 0;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.info("Total posts count: " + count);
                    return count;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to get total posts count", ex);
        }
        
        return 0;
    }
    
    public int getNewPostsCountThisMonth() {
        String sql = "SELECT COUNT(*) FROM Posts WHERE created_at >= DATEADD(MONTH, -1, GETDATE())";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot get new posts count: Database connection failed");
                return 0;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.info("New posts this month: " + count);
                    return count;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to get new posts count this month", ex);
        }
        
        return 0;
    }
    
    public int getPendingApprovalsCount() {
        String sql = "SELECT COUNT(*) FROM Posts WHERE is_approved = 0";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot get pending approvals count: Database connection failed");
                return 0;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.info("Pending approvals count: " + count);
                    return count;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to get pending approvals count", ex);
        }
        
        return 0;
    }
    
    public int getPendingApprovalsCountLastWeek() {
        String sql = "SELECT COUNT(*) FROM Posts WHERE is_approved = 0 AND created_at <= DATEADD(WEEK, -1, GETDATE())";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot get pending approvals count last week: Database connection failed");
                return 0;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.info("Pending approvals count last week: " + count);
                    return count;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to get pending approvals count last week", ex);
        }
        
        return 0;
    }
}
