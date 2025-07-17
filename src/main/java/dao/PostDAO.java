package dao;

import model.Posts;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class PostDAO {
    private static final Logger LOGGER = Logger.getLogger(PostDAO.class.getName());

    public boolean create(Posts post) {
        String sql = "INSERT INTO Posts (child_id, title, content, status, is_approved) VALUES (?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, post.getChild().getChildId());
            ps.setString(2, post.getTitle());
            ps.setString(3, post.getContent());
            ps.setString(4, post.getStatus());
            ps.setBoolean(5, false); // New posts are not approved by default

            int result = ps.executeUpdate();
            if (result > 0) {
                LOGGER.info("A new post was created successfully.");
                return true;
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Error creating a new post", e);
        }
        return false;
    }
} 