package dao;

import model.Posts;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.List;
import java.util.ArrayList;
import java.sql.ResultSet;
import model.Children;
import model.Parents;

public class PostDAO {
    private static final Logger LOGGER = Logger.getLogger(PostDAO.class.getName());

    public boolean createPost(Posts post) {
        String sql = "INSERT INTO Posts (Content, ImagePath, Status, ChildID, Title, PostType) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, post.getContent());
            ps.setString(2, post.getImagePath());
            ps.setString(3, post.getStatus());
            ps.setInt(4, post.getChildId());
            ps.setString(5, post.getTitle());
            ps.setString(6, post.getPostType());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Posts> getPendingPosts() {
        List<Posts> list = new ArrayList<>();
        String sql = "SELECT p.PostID, p.Content, p.ImagePath, p.PostTime, p.Status, p.Title, p.PostType, " +
                     "c.ChildID, c.ChildName, c.Avatar, " +
                     "pa.ParentID, pa.Username " +
                     "FROM Posts p " +
                     "JOIN Children c ON p.ChildID = c.ChildID " +
                     "JOIN Parents pa ON c.ParentID = pa.ParentID " +
                     "WHERE p.Status = 'PENDING' ORDER BY p.PostTime DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Posts post = new Posts();
                post.setPostId(rs.getInt("PostID"));
                post.setContent(rs.getString("Content"));
                post.setImagePath(rs.getString("ImagePath"));
                post.setPostTime(rs.getTimestamp("PostTime").toLocalDateTime());
                post.setStatus(rs.getString("Status"));
                post.setTitle(rs.getString("Title"));
                post.setPostType(rs.getString("PostType"));

                Children child = new Children();
                child.setChildId(rs.getInt("ChildID"));
                child.setFullName(rs.getString("ChildName"));
                // child.setAvatar(rs.getString("Avatar")); // Avatar field does not exist in Children model
                
                Parents parent = new Parents();
                parent.setParentId(rs.getInt("ParentID"));
                parent.setFullName(rs.getString("Username"));
                
                child.setParent(parent);
                post.setChild(child);
                post.setParent(parent);

                list.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Posts> getPostsByChildId(int childId) {
        List<Posts> list = new ArrayList<>();
        String sql = "SELECT PostID, Title, Content, ImagePath, PostTime, Status, PostType FROM Posts WHERE ChildID = ? AND Status = 'APPROVED' ORDER BY PostTime DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, childId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Posts post = new Posts();
                post.setPostId(rs.getInt("PostID"));
                post.setTitle(rs.getString("Title"));
                post.setContent(rs.getString("Content"));
                post.setImagePath(rs.getString("ImagePath"));
                post.setPostTime(rs.getTimestamp("PostTime").toLocalDateTime());
                post.setStatus(rs.getString("Status"));
                post.setPostType(rs.getString("PostType"));
                list.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updatePostStatus(int postId, String status) {
        String sql = "UPDATE Posts SET Status = ? WHERE PostID = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
} 