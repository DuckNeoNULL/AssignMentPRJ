package dao;

import model.Parents;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ParentDAO {
    private static final Logger LOGGER = Logger.getLogger(ParentDAO.class.getName());
    
    // Safe constructor - no database operations during instantiation
    public ParentDAO() {
        LOGGER.fine("ParentDAO instance created");
    }
    
    public boolean create(Parents parent) {
        if (parent == null) {
            LOGGER.warning("Cannot create parent: parent object is null");
            return false;
        }
        
        String sql = "INSERT INTO Parents (email, password_hash, full_name, phone, created_at) VALUES (?, ?, ?, ?, GETDATE())";
        
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
                
                int result = ps.executeUpdate();
                if (result > 0) {
                    LOGGER.info("Parent created successfully for email: " + parent.getEmail());
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
                    LOGGER.info("Verification code updated for email: " + email);
                    return true;
                } else {
                    LOGGER.warning("No parent found with email: " + email);
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to update verification code for email: " + email, ex);
        }
        return false;
    }
    
    public Parents findByEmail(String email) {
        if (email == null || email.trim().isEmpty()) {
            LOGGER.warning("Cannot find parent: email is null or empty");
            return null;
        }
        
        String sql = "SELECT parent_id, email, password_hash, full_name, phone, verification_code, is_verified, created_at, last_login, reset_token, reset_token_expiry FROM Parents WHERE email = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot find parent: Database connection failed");
                return null;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, email.trim());
                
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        Parents parent = new Parents();
                        parent.setParentId(rs.getInt("parent_id"));
                        parent.setEmail(rs.getString("email"));
                        parent.setPasswordHash(rs.getString("password_hash"));
                        parent.setFullName(rs.getString("full_name"));
                        parent.setPhone(rs.getString("phone"));
                        parent.setVerificationCode(rs.getString("verification_code"));
                        parent.setIsVerified(rs.getBoolean("is_verified"));
                        parent.setCreatedAt(rs.getTimestamp("created_at"));
                        parent.setLastLogin(rs.getTimestamp("last_login"));
                        parent.setResetToken(rs.getString("reset_token"));
                        parent.setResetTokenExpiry(rs.getTimestamp("reset_token_expiry"));
                        return parent;
                    }
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to find parent by email: " + email, ex);
        }
        return null;
    }
    
    public boolean emailExists(String email) {
        return findByEmail(email) != null;
    }
}
