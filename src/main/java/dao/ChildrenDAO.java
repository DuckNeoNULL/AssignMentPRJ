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
} 