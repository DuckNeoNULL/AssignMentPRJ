package dao;

import model.Parents;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.List;

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
            "SELECT parent_id, email, password, full_name, phone, verification_code, "
            + "is_verified, created_at, last_login, reset_token, reset_token_expiry, role, status "
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
                    
                    String stored = rs.getString("password");
                    LOGGER.info("Stored password=[" + stored + "]");
                    
                    Parents parent = new Parents();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setEmail(rs.getString("email"));
                    parent.setPassword(stored);
                    parent.setFullName(rs.getString("full_name"));
                    parent.setPhone(rs.getString("phone"));
                    parent.setVerificationCode(rs.getString("verification_code"));
                    parent.setIsVerified(rs.getBoolean("is_verified"));
                    parent.setCreatedAt(rs.getTimestamp("created_at"));
                    parent.setLastLogin(rs.getTimestamp("last_login"));
                    parent.setResetToken(rs.getString("reset_token"));
                    parent.setResetTokenExpiry(rs.getTimestamp("reset_token_expiry"));
                    parent.setRole(rs.getString("role"));
                    parent.setStatus(rs.getString("status"));
                    
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
        
        String sql = "INSERT INTO Parents (email, password, full_name, phone, role, created_at, status) VALUES (?, ?, ?, ?, ?, GETDATE(), ?)";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot create parent: Database connection failed");
                return false;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, parent.getEmail());
                ps.setString(2, parent.getPassword());
                ps.setString(3, parent.getFullName());
                ps.setString(4, parent.getPhone());
                ps.setString(5, parent.getRole());
                ps.setString(6, parent.getStatus());
                
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
    
    public boolean updatePassword(int parentId, String newPassword) {
        if (newPassword == null) {
            LOGGER.warning("Cannot update password: new password is null");
            return false;
        }
        
        String sql = "UPDATE Parents SET password = ? WHERE parent_id = ?";
        
        try (Connection con = DBConnection.getConnection()) {
            if (con == null) {
                LOGGER.severe("Cannot update password: Database connection failed");
                return false;
            }
            
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, newPassword);
                ps.setInt(2, parentId);
                
                int rowsUpdated = ps.executeUpdate();
                if (rowsUpdated > 0) {
                    LOGGER.info("Password updated for parent ID: " + parentId);
                    return true;
                } else {
                    LOGGER.warning("No parent found with ID: " + parentId);
                    return false;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Failed to update password for parent ID: " + parentId, ex);
            return false;
        }
    }

    public boolean updateProfile(Parents parent) throws SQLException {
        String sql = "UPDATE Parents SET full_name = ?, phone = ? WHERE parent_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, parent.getFullName());
            ps.setString(2, parent.getPhone());
            ps.setInt(3, parent.getParentId());
            return ps.executeUpdate() > 0;
        }
    }

    public Parents findParentById(int parentId) {
        String sql = "SELECT * FROM Parents WHERE parent_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Parents parent = new Parents();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setEmail(rs.getString("email"));
                    parent.setFullName(rs.getString("full_name"));
                    parent.setPhone(rs.getString("phone"));
                    parent.setPassword(rs.getString("password")); // Needed for change password validation
                    return parent;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding parent by ID", ex);
        }
        return null;
    }

    public boolean saveVerificationCode(String email, String code, Timestamp expiryTime) throws SQLException {
        String sql = "UPDATE Parents SET verification_code = ?, verification_code_expiry = ? WHERE email = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, code);
            ps.setTimestamp(2, expiryTime);
            ps.setString(3, email);
            return ps.executeUpdate() > 0;
        }
    }

    public Parents findByVerificationCode(String code) {
        String sql = "SELECT * FROM Parents WHERE verification_code = ? AND verification_code_expiry > GETDATE()";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, code);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    // Map rs to Parents object
                    Parents parent = new Parents();
                    parent.setParentId(rs.getInt("parent_id"));
                    parent.setEmail(rs.getString("email"));
                    parent.setStatus(rs.getString("status"));
                    // ... map other fields if needed
                    return parent;
                }
            }
        } catch (SQLException ex) {
            LOGGER.log(Level.SEVERE, "Error finding by verification code", ex);
        }
        return null;
    }

    public boolean activateAccount(int parentId) throws SQLException {
        String sql = "UPDATE Parents SET status = 'ACTIVE', is_verified = 1, verification_code = NULL, verification_code_expiry = NULL WHERE parent_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, parentId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public boolean createAdminAccount() {
        // This method should be reviewed. Storing plain text password is not secure.
        if (!emailExists("admin@gmail.com")) {
            Parents admin = new Parents();
            admin.setEmail("admin@gmail.com");
            admin.setPassword("admin123"); // Plain text password
            admin.setFullName("Administrator");
            admin.setRole("ADMIN");
            admin.setStatus("ACTIVE");
            admin.setIsVerified(true);
            return create(admin);
        }
        return true; // Already exists
    }

    public boolean updateUserStatus(int parentId, String status) throws SQLException {
        String sql = "UPDATE Parents SET status = ? WHERE parent_id = ?";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, parentId);
            return ps.executeUpdate() > 0;
        }
    }
    
    public List<Parents> getAllParents() throws SQLException {
        List<Parents> parentsList = new ArrayList<>();
        String sql = "SELECT parent_id, email, full_name, phone, is_verified, created_at, last_login, role, status FROM Parents";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Parents parent = new Parents();
                parent.setParentId(rs.getInt("parent_id"));
                parent.setEmail(rs.getString("email"));
                parent.setFullName(rs.getString("full_name"));
                parent.setPhone(rs.getString("phone"));
                parent.setIsVerified(rs.getBoolean("is_verified"));
                parent.setCreatedAt(rs.getTimestamp("created_at"));
                parent.setLastLogin(rs.getTimestamp("last_login"));
                parent.setRole(rs.getString("role"));
                parent.setStatus(rs.getString("status"));
                parentsList.add(parent);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error getting all parents", e);
        }
        return parentsList;
    }
    
    public int getTotalUsersCount() {
        String sql = "SELECT COUNT(*) FROM Parents";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting total users count: " + e.getMessage());
        }
        return 0;
    }
    
    public int getNewUsersCountThisMonth() {
        String sql = "SELECT COUNT(*) FROM Parents WHERE MONTH(created_at) = MONTH(GETDATE()) AND YEAR(created_at) = YEAR(GETDATE())";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting new users count this month: " + e.getMessage());
        }
        return 0;
    }

    public int getNewUsersCountLastMonth() {
        String sql = "SELECT COUNT(*) FROM Parents WHERE MONTH(created_at) = MONTH(DATEADD(month, -1, GETDATE())) AND YEAR(created_at) = YEAR(DATEADD(month, -1, GETDATE()))";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting new users count last month: " + e.getMessage());
        }
        return 0;
    }

    public int getActiveUsersCount() {
        String sql = "SELECT COUNT(*) FROM Parents WHERE status = 'active'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting active users count: " + e.getMessage());
        }
        return 0;
    }

    public int getNewUsersCountToday() {
        String sql = "SELECT COUNT(*) FROM Parents WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting new users count today: " + e.getMessage());
        }
        return 0;
    }

    public int getNewUsersCountThisWeek() {
        String sql = "SELECT COUNT(*) FROM Parents WHERE created_at >= DATEADD(week, -1, GETDATE())";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting new users count this week: " + e.getMessage());
        }
        return 0;
    }

    public int getTotalChildrenCount() {
        String sql = "SELECT COUNT(*) FROM Children";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting total children count: " + e.getMessage());
        }
        return 0;
    }

    public int getActiveUsersCountToday() {
        String sql = "SELECT COUNT(DISTINCT parent_id) FROM ActivityLogs WHERE CAST(timestamp AS DATE) = CAST(GETDATE() AS DATE)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting active users count today: " + e.getMessage());
        }
        return 0;
    }

    public int getVerifiedUsersCount() {
        String sql = "SELECT COUNT(*) FROM Parents WHERE email_verified = 1";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting verified users count: " + e.getMessage());
        }
        return 0;
    }

    public int getSuspendedUsersCount() {
        String sql = "SELECT COUNT(*) FROM Parents WHERE status = 'suspended'";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting suspended users count: " + e.getMessage());
        }
        return 0;
    }

    public boolean isDatabaseConnected() {
        try (Connection con = DBConnection.getConnection()) {
            return con != null && !con.isClosed();
        } catch (SQLException e) {
            LOGGER.severe("Database connection check failed: " + e.getMessage());
            return false;
        }
    }

    public int getNewUsersCountByDay(int daysAgo) {
        String sql = "SELECT COUNT(*) FROM Parents WHERE CAST(created_at AS DATE) = CAST(DATEADD(day, ?, GETDATE()) AS DATE)";
        
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, -daysAgo);
            
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            LOGGER.severe("Error getting new users count by day: " + e.getMessage());
        }
        
        return 0;
    }
}
