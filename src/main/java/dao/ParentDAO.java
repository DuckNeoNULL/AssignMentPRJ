package dao;

import model.Parents;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ParentDAO {
    private static final Logger LOGGER = Logger.getLogger(ParentDAO.class.getName());
    
    public ParentDAO() {
        LOGGER.info("ParentDAO initialized");
        // Test connection on initialization
        if (!DBConnection.testConnection()) {
            LOGGER.severe("Database connection test failed during ParentDAO initialization");
        }
    }
    
    public Parents findByEmail(String email) {
        LOGGER.info("Finding parent by email: " + (email != null ? email.trim() : "null"));
        
        if (email == null || email.trim().isEmpty()) {
            LOGGER.warning("Cannot find parent: email is null or empty");
            return null;
        }
        
        String sql = 
            "SELECT parent_id, email, password_hash, full_name, phone, verification_code, "
            + "is_verified, created_at, last_login, reset_token, reset_token_expiry "
            + "FROM Parents WHERE email = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot find parent: Database connection failed");
                return null;
            }
            
            LOGGER.info("Database connection successful, executing query");
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, email.trim());
                
                LOGGER.info("findByEmail SQL: " + sql);
                LOGGER.info("findByEmail param: email=" + email.trim());
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        LOGGER.warning("No user found for email=" + email);
                        return null;
                    }
                    
                    String stored = rs.getString("password_hash");
                    LOGGER.info("Stored password_hash=[" + stored + "]");
                    
                    Parents parent = new Parents();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setEmail(rs.getString("email"));
                    parent.setPasswordHash(stored);
                    parent.setFullName(rs.getString("full_name"));
                    parent.setPhone(rs.getString("phone"));
                    parent.setVerificationCode(rs.getString("verification_code"));
                    parent.setIsVerified(rs.getBoolean("is_verified"));
                    parent.setCreatedAt(rs.getTimestamp("created_at"));
                    parent.setLastLogin(rs.getTimestamp("last_login"));
                    parent.setResetToken(rs.getString("reset_token"));
                    parent.setResetTokenExpiry(rs.getTimestamp("reset_token_expiry"));
                    
                    // Set default role if not specified
                    String role = "USER";
                    if (parent.getEmail().equals("admin@gmail.com")) {
                        role = "ADMIN";
                    }
                    parent.setRole(role);
                    
                    LOGGER.info("Parent object created successfully for email: " + email);
                    return parent;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database error while finding parent by email: " + email, ex);
            return null;
        }
    }
    
    public boolean emailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            LOGGER.warning("Cannot check email existence: email is null or empty");
            return false;
        }
        
        String sql = "SELECT COUNT(*) FROM Parents WHERE email = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot check email existence: Database connection failed");
                return false;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, email.trim());
                
                LOGGER.info("emailExists SQL: " + sql);
                LOGGER.info("emailExists param: email=" + email.trim());
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        int count = rs.getInt(1);
                        boolean exists = count > 0;
                        LOGGER.info("Email existence check result for " + email + ": " + exists);
                        return exists;
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to check email existence for: " + email, ex);
        }
        return false;
    }
    
    public boolean create(Parents parent) {
        if (parent == null) {
            LOGGER.warning("Cannot create parent: parent object is null");
            return false;
        }
        
        // Validate role
        String role = parent.getRole();
        if (role == null || (!role.equals("USER") && !role.equals("ADMIN"))) {
            role = "USER";
            parent.setRole(role);
            LOGGER.info("Invalid or null role provided, defaulting to USER for email: " + parent.getEmail());
        }
        
        String sql = "INSERT INTO Parents (email, password_hash, full_name, phone, role, created_at) VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot create parent: Database connection failed");
                return false;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, parent.getEmail());
                ps.setString(2, parent.getPasswordHash());
                ps.setString(3, parent.getFullName());
                ps.setString(4, parent.getPhone());
                ps.setString(5, role);
                
                int result = ps.executeUpdate();
                if (result > 0) {
                    LOGGER.info("Parent created successfully - Email: " + parent.getEmail() + ", Role: " + role);
                    return true;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to create parent for email: " + (parent.getEmail() != null ? parent.getEmail() : "null"), ex);
        }
        return false;
    }
    
    public boolean updateVerificationCode(String email, String verificationCode) {
        if (email == null || email.trim().isEmpty() || verificationCode == null) {
            LOGGER.warning("Cannot update verification code: invalid parameters");
            return false;
        }
        
        String sql = "UPDATE Parents SET verification_code = ? WHERE email = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot update verification code: Database connection failed");
                return false;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, verificationCode);
                ps.setString(2, email.trim());
                
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    LOGGER.info("Verification code updated for email: " + email + " with code: " + verificationCode);
                    return true;
                } else {
                    LOGGER.warning("No parent found with email: " + email);
                    return false;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to update verification code for email: " + email, ex);
            return false;
        }
    }
    
    public boolean updatePassword(String email, String newPassword) {
        if (email == null || email.trim().isEmpty() || newPassword == null) {
            LOGGER.warning("Cannot update password: invalid parameters");
            return false;
        }
        
        String sql = "UPDATE Parents SET password_hash = ? WHERE email = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot update password: Database connection failed");
                return false;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, newPassword); // Store plaintext password directly
                ps.setString(2, email.trim());
                
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    LOGGER.info("Password updated for email: " + email + " (new password: " + newPassword + ")");
                    return true;
                } else {
                    LOGGER.warning("No parent found with email: " + email);
                    return false;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to update password for email: " + email, ex);
            return false;
        }
    }
    
    public boolean createAdminAccount() {
        Parents admin = new Parents();
        admin.setEmail("admin@gmail.com");
        admin.setPasswordHash("123");
        admin.setFullName("Administrator");
        admin.setRole("ADMIN");
        
        if (!emailExists("admin@gmail.com")) {
            return create(admin);
        }
        return true; // Already exists
    }
    
    public int getTotalUsersCount() {
        String sql = "SELECT COUNT(*) FROM Parents";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot get total users count: Database connection failed");
                return 0;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.info("Total users count: " + count);
                    return count;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to get total users count", ex);
        }
        
        return 0;
    }
    
    public int getNewUsersCountThisMonth() {
        String sql = "SELECT COUNT(*) FROM Parents WHERE created_at >= DATEADD(MONTH, -1, GETDATE())";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot get new users count: Database connection failed");
                return 0;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {
                
                if (rs.next()) {
                    int count = rs.getInt(1);
                    LOGGER.info("New users this month: " + count);
                    return count;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to get new users count this month", ex);
        }
        
        return 0;
    }
    
    public boolean checkConnection() {
        try (Connection con = DBConnection.getConnection()) {
            return con != null && !con.isClosed();
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Database connection check failed", ex);
            return false;
        }
    }
}
