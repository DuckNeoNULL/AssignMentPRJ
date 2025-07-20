package dao;

import model.Children;
import model.Parents;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.sql.Date;

public class ChildrenDAO {
    private static final Logger LOGGER = Logger.getLogger(ChildrenDAO.class.getName());

    public List<Children> findChildrenByParentId(int parentId) {
        List<Children> childrenList = new ArrayList<>();
        String sql = "SELECT * FROM Children WHERE parent_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, parentId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Children child = new Children();
                    child.setChildId(rs.getInt("child_id"));
                    child.setFullName(rs.getString("full_name"));
                    child.setDateOfBirth(rs.getDate("date_of_birth"));
                    child.setGender(rs.getString("gender"));
                    
                    // Set the parent object if needed, though parentId is the key here
                    // Parents parent = new Parents();
                    // parent.setParentId(parentId);
                    // child.setParentId(parent);
                    
                    childrenList.add(child);
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding children by parent ID: " + parentId, e);
        }
        return childrenList;
    }

    public Children findChildById(int childId) {
        String sql = "SELECT * FROM Children WHERE child_id = ?";
        Children child = null;

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, childId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    child = new Children();
                    child.setChildId(rs.getInt("child_id"));
                    child.setFullName(rs.getString("full_name"));
                    child.setDateOfBirth(rs.getDate("date_of_birth"));
                    child.setGender(rs.getString("gender"));
                    
                    // You can also fetch and set the parent object if needed
                    // int parentId = rs.getInt("parent_id");
                    // ParentDAO parentDAO = new ParentDAO();
                    // child.setParentId(parentDAO.findParentById(parentId)); 
                }
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error finding child by ID: " + childId, e);
        }
        return child;
    }

    public boolean createChild(Children child) throws SQLException {
        String sql = "INSERT INTO Children (parent_id, full_name, date_of_birth, gender) VALUES (?, ?, ?, ?)";
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setInt(1, child.getParent().getParentId());
            ps.setString(2, child.getFullName());
            ps.setDate(3, new java.sql.Date(child.getDateOfBirth().getTime()));
            ps.setString(4, child.getGender());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                LOGGER.info("A new child was created successfully for parent ID: " + child.getParent().getParentId());
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating child for parent ID: " + child.getParent().getParentId(), e);
            throw e;
        }
        return false;
    }

    // =============== FRIENDSHIP METHODS ===============
    
    /**
     * Lấy danh sách trẻ em có thể kết bạn (trừ chính mình và đã kết bạn)
     */
    public List<Children> getPotentialFriends(Integer childId) throws SQLException {
        List<Children> potentialFriends = new ArrayList<>();
        String sql = "SELECT c.* FROM Children c " +
                    "WHERE c.child_id != ? " +
                    "AND c.child_id NOT IN (" +
                    "    SELECT child_id_1 FROM Friendships WHERE child_id_2 = ? " +
                    "    UNION " +
                    "    SELECT child_id_2 FROM Friendships WHERE child_id_1 = ?" +
                    ") " +
                    "ORDER BY c.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, childId);
            stmt.setInt(2, childId);
            stmt.setInt(3, childId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Children child = new Children();
                    child.setChildId(rs.getInt("child_id"));
                    child.setFullName(rs.getString("full_name"));
                    child.setDateOfBirth(rs.getDate("date_of_birth"));
                    child.setGender(rs.getString("gender"));
                    potentialFriends.add(child);
                }
            }
        }
        return potentialFriends;
    }
    
    /**
     * Lấy danh sách bạn bè hiện tại
     */
    public List<Children> getCurrentFriends(Integer childId) throws SQLException {
        List<Children> friends = new ArrayList<>();
        String sql = "SELECT c.* FROM Children c " +
                    "INNER JOIN Friendships f ON (c.child_id = f.child_id_1 OR c.child_id = f.child_id_2) " +
                    "WHERE f.status = 'ACCEPTED' " +
                    "AND c.child_id != ? " +
                    "AND (f.child_id_1 = ? OR f.child_id_2 = ?) " +
                    "ORDER BY c.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, childId);
            stmt.setInt(2, childId);
            stmt.setInt(3, childId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Children child = new Children();
                    child.setChildId(rs.getInt("child_id"));
                    child.setFullName(rs.getString("full_name"));
                    child.setDateOfBirth(rs.getDate("date_of_birth"));
                    child.setGender(rs.getString("gender"));
                    friends.add(child);
                }
            }
        }
        return friends;
    }
    
    /**
     * Lấy danh sách lời mời kết bạn đã gửi
     */
    public List<Children> getSentFriendRequests(Integer childId) throws SQLException {
        List<Children> sentRequests = new ArrayList<>();
        String sql = "SELECT c.* FROM Children c " +
                    "INNER JOIN Friendships f ON c.child_id = f.child_id_2 " +
                    "WHERE f.child_id_1 = ? AND f.status = 'PENDING' " +
                    "ORDER BY c.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, childId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Children child = new Children();
                    child.setChildId(rs.getInt("child_id"));
                    child.setFullName(rs.getString("full_name"));
                    child.setDateOfBirth(rs.getDate("date_of_birth"));
                    child.setGender(rs.getString("gender"));
                    sentRequests.add(child);
                }
            }
        }
        return sentRequests;
    }
    
    /**
     * Lấy danh sách lời mời kết bạn đã nhận
     */
    public List<Children> getReceivedFriendRequests(Integer childId) throws SQLException {
        List<Children> receivedRequests = new ArrayList<>();
        String sql = "SELECT c.* FROM Children c " +
                    "INNER JOIN Friendships f ON c.child_id = f.child_id_1 " +
                    "WHERE f.child_id_2 = ? AND f.status = 'PENDING' " +
                    "ORDER BY c.full_name";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, childId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Children child = new Children();
                    child.setChildId(rs.getInt("child_id"));
                    child.setFullName(rs.getString("full_name"));
                    child.setDateOfBirth(rs.getDate("date_of_birth"));
                    child.setGender(rs.getString("gender"));
                    receivedRequests.add(child);
                }
            }
        }
        return receivedRequests;
    }
    
    /**
     * Gửi lời mời kết bạn
     */
    public void sendFriendRequest(Integer fromChildId, Integer toChildId) throws SQLException {
        String sql = "INSERT INTO Friendships (child_id_1, child_id_2, status, created_at) VALUES (?, ?, 'PENDING', GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, fromChildId);
            stmt.setInt(2, toChildId);
            stmt.executeUpdate();
        }
    }
    
    /**
     * Chấp nhận lời mời kết bạn
     */
    public void acceptFriendRequest(Integer childId, Integer fromChildId) throws SQLException {
        String sql = "UPDATE Friendships SET status = 'ACCEPTED' " +
                    "WHERE child_id_1 = ? AND child_id_2 = ? AND status = 'PENDING'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, fromChildId);
            stmt.setInt(2, childId);
            stmt.executeUpdate();
        }
    }
    
    /**
     * Từ chối lời mời kết bạn
     */
    public void rejectFriendRequest(Integer childId, Integer fromChildId) throws SQLException {
        String sql = "UPDATE Friendships SET status = 'REJECTED' " +
                    "WHERE child_id_1 = ? AND child_id_2 = ? AND status = 'PENDING'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, fromChildId);
            stmt.setInt(2, childId);
            stmt.executeUpdate();
        }
    }
    
    /**
     * Hủy lời mời kết bạn đã gửi
     */
    public void cancelFriendRequest(Integer childId, Integer toChildId) throws SQLException {
        String sql = "DELETE FROM Friendships " +
                    "WHERE child_id_1 = ? AND child_id_2 = ? AND status = 'PENDING'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, childId);
            stmt.setInt(2, toChildId);
            stmt.executeUpdate();
        }
    }
    
    /**
     * Hủy kết bạn
     */
    public void unfriend(Integer childId, Integer friendId) throws SQLException {
        String sql = "DELETE FROM Friendships " +
                    "WHERE (child_id_1 = ? AND child_id_2 = ?) OR (child_id_1 = ? AND child_id_2 = ?)";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, childId);
            stmt.setInt(2, friendId);
            stmt.setInt(3, friendId);
            stmt.setInt(4, childId);
            stmt.executeUpdate();
        }
    }
} 