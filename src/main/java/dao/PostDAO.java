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
import java.util.Map;
import java.util.HashMap;

public class PostDAO {
    private static final Logger LOGGER = Logger.getLogger(PostDAO.class.getName());

    /**
     * Tạo bài viết mới với status = 'PENDING'
     */
    public boolean createPost(Posts post) throws SQLException {
        String sql = "INSERT INTO Posts (child_id, title, content, image_url, status, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, GETDATE())";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, post.getAuthorId());
            stmt.setString(2, post.getTitle());
            stmt.setString(3, post.getContent());
            stmt.setString(4, post.getImagePath());
            stmt.setString(5, "PENDING"); // Luôn set status = PENDING khi tạo mới
            
            int result = stmt.executeUpdate();
            return result > 0;
        }
    }

    /**
     * Lấy tất cả bài viết đang chờ duyệt (status = 'PENDING')
     * Dành cho Admin để kiểm duyệt
     */
    public List<Posts> getPendingPosts() throws SQLException {
        List<Posts> pendingPosts = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name as author_name " +
                    "FROM Posts p " +
                    "INNER JOIN Children c ON p.child_id = c.child_id " +
                    "WHERE p.status = 'PENDING' " +
                    "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {
            
            while (rs.next()) {
                Posts post = new Posts();
                post.setPostId(rs.getInt("post_id"));
                post.setTitle(rs.getString("title"));
                post.setContent(rs.getString("content"));
                post.setImagePath(rs.getString("image_url"));
                post.setAuthorId(rs.getInt("child_id"));
                post.setAuthorName(rs.getString("author_name"));
                post.setPostTime(rs.getTimestamp("created_at").toLocalDateTime());
                post.setStatus(rs.getString("status"));
                pendingPosts.add(post);
            }
        }
        return pendingPosts;
    }

    /**
     * Lấy bài viết theo ID (dành cho Admin xem chi tiết)
     */
    public Posts getPostById(int postId) throws SQLException {
        String sql = "SELECT p.*, c.full_name as author_name " +
                    "FROM Posts p " +
                    "INNER JOIN Children c ON p.child_id = c.child_id " +
                    "WHERE p.post_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, postId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Posts post = new Posts();
                    post.setPostId(rs.getInt("post_id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setImagePath(rs.getString("image_url"));
                    post.setAuthorId(rs.getInt("child_id"));
                    post.setAuthorName(rs.getString("author_name"));
                    post.setPostTime(rs.getTimestamp("created_at").toLocalDateTime());
                    post.setStatus(rs.getString("status"));
                    return post;
                }
            }
        }
        return null;
    }

    /**
     * Lấy bài viết của một trẻ em cụ thể (dành cho trang cá nhân)
     */
    public List<Posts> getPostsByChildId(int childId) throws SQLException {
        List<Posts> posts = new ArrayList<>();
        String sql = "SELECT p.*, c.full_name as author_name " +
                    "FROM Posts p " +
                    "INNER JOIN Children c ON p.child_id = c.child_id " +
                    "WHERE p.child_id = ? " +
                    "ORDER BY p.created_at DESC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setInt(1, childId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Posts post = new Posts();
                    post.setPostId(rs.getInt("post_id"));
                    post.setTitle(rs.getString("title"));
                    post.setContent(rs.getString("content"));
                    post.setImagePath(rs.getString("image_url"));
                    post.setAuthorId(rs.getInt("child_id"));
                    post.setAuthorName(rs.getString("author_name"));
                    post.setPostTime(rs.getTimestamp("created_at").toLocalDateTime());
                    post.setStatus(rs.getString("status"));
                    posts.add(post);
                }
            }
        }
        return posts;
    }

    /**
     * Cập nhật trạng thái bài viết (PENDING -> APPROVED hoặc REJECTED)
     */
    public boolean updatePostStatus(int postId, String newStatus) throws SQLException {
        String sql = "UPDATE Posts SET status = ? WHERE post_id = ?";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            
            stmt.setString(1, newStatus);
            stmt.setInt(2, postId);
            
            int result = stmt.executeUpdate();
            return result > 0;
        }
    }

    /**
     * SỬA LỖI: Viết lại hoàn toàn để truy vấn hiệu quả và chính xác hơn.
     * 1. Lấy danh sách ID bạn bè.
     * 2. Truy vấn tất cả bài viết từ danh sách ID bạn bè đó.
     */
    public List<Posts> getApprovedFriendPosts(Integer childId) throws SQLException {
        List<Posts> posts = new ArrayList<>();
        
        // Bước 1: Lấy danh sách ID của tất cả bạn bè đã được 'ACCEPTED'
        List<Integer> friendIds = new ArrayList<>();
        String friendSql = "SELECT child_id_1 FROM Friendships WHERE child_id_2 = ? AND status = 'ACCEPTED' " +
                         "UNION SELECT child_id_2 FROM Friendships WHERE child_id_1 = ? AND status = 'ACCEPTED'";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement friendStmt = conn.prepareStatement(friendSql)) {
            friendStmt.setInt(1, childId);
            friendStmt.setInt(2, childId);
            try (ResultSet rs = friendStmt.executeQuery()) {
                while (rs.next()) {
                    friendIds.add(rs.getInt(1));
                }
            }
        }
        
        // Nếu không có bạn bè, trả về danh sách trống
        if (friendIds.isEmpty()) {
            return posts;
        }

        // Bước 2: Lấy bài viết từ danh sách bạn bè
        // Sử dụng IN (...) để truy vấn hiệu quả hơn
        StringBuilder postSql = new StringBuilder(
            "SELECT TOP 20 p.*, c.full_name as author_name, " +
            "(SELECT COUNT(*) FROM Reactions r WHERE r.post_id = p.post_id AND r.reaction_type IN ('LIKE', 'HEART')) as like_count " +
            "FROM Posts p " +
            "INNER JOIN Children c ON p.child_id = c.child_id " +
            "WHERE p.status = 'APPROVED' AND p.child_id IN ("
        );
        for (int i = 0; i < friendIds.size(); i++) {
            postSql.append("?");
            if (i < friendIds.size() - 1) {
                postSql.append(",");
            }
        }
        postSql.append(") ORDER BY p.created_at DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement postStmt = conn.prepareStatement(postSql.toString())) {
            
            for (int i = 0; i < friendIds.size(); i++) {
                postStmt.setInt(i + 1, friendIds.get(i));
            }

            try (ResultSet rs = postStmt.executeQuery()) {
                while (rs.next()) {
                    Posts post = new Posts();
                    post.setPostId(rs.getInt("post_id")); 
                    post.setContent(rs.getString("content"));
                    post.setImagePath(rs.getString("image_url"));
                    post.setAuthorId(rs.getInt("child_id"));
                    post.setAuthorName(rs.getString("author_name"));
                    post.setPostTime(rs.getTimestamp("created_at").toLocalDateTime());
                    post.setLikeCount(rs.getInt("like_count"));
                    post.setComments(getPostComments(post.getPostId()));
                    posts.add(post);
                }
            }
        }
        return posts;
    }

    /**
     * Check if post exists
     */
    private boolean postExists(Connection conn, Integer postId) throws SQLException {
        String sql = "SELECT 1 FROM Posts WHERE post_id = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Check if user already liked the post
     */
    private boolean hasUserLiked(Connection conn, Integer postId, Integer childId) throws SQLException {
        String sql = "SELECT 1 FROM Reactions WHERE post_id = ? AND child_id = ? AND reaction_type IN ('LIKE', 'HEART')";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            stmt.setInt(2, childId);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    /**
     * Add a like to a post
     */
    public void addLike(Integer postId, Integer childId) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            // Check if post exists
            if (!postExists(conn, postId)) {
                throw new SQLException("Post not found");
            }
            
            // Check if already liked
            if (hasUserLiked(conn, postId, childId)) {
                return; // Already liked, do nothing
            }
            
            String sql = "INSERT INTO Reactions (post_id, child_id, reaction_type) VALUES (?, ?, 'LIKE')";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, postId);
                stmt.setInt(2, childId);
                stmt.executeUpdate();
            }
        }
    }

    /**
     * Report a post
     */
    public void reportPost(Integer postId, Integer reporterId, String reason) throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            // Check if post exists
            if (!postExists(conn, postId)) {
                throw new SQLException("Post not found");
            }
            
            String sql = "INSERT INTO ContentReports (post_id, reporter_id, reason, status) VALUES (?, ?, ?, 'PENDING')";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, postId);
                stmt.setInt(2, reporterId);
                stmt.setString(3, reason);
                stmt.executeUpdate();
            }
        }
    }

    /**
     * Add a comment to a post
     */
    public void addComment(Integer postId, Integer authorId, String content) throws SQLException {
        if (content == null || content.trim().isEmpty()) {
            throw new SQLException("Comment content cannot be empty");
        }
        
        try (Connection conn = DBConnection.getConnection()) {
            // Check if post exists
            if (!postExists(conn, postId)) {
                throw new SQLException("Post not found");
            }
            
            String sql = "INSERT INTO Comments (post_id, child_id, content) VALUES (?, ?, ?)";
            try (PreparedStatement stmt = conn.prepareStatement(sql)) {
                stmt.setInt(1, postId);
                stmt.setInt(2, authorId);
                stmt.setString(3, content.trim());
                stmt.executeUpdate();
            }
        }
    }

    /**
     * SỬA LỖI: Đảm bảo truy vấn đúng bảng Comments
     */
    private List<Map<String, Object>> getPostComments(Integer postId) throws SQLException {
        List<Map<String, Object>> comments = new ArrayList<>();
        String sql = "SELECT cm.*, c.full_name as author_name " +
                    "FROM Comments cm " +
                    "INNER JOIN Children c ON cm.child_id = c.child_id " +
                    "WHERE cm.post_id = ? " +
                    "ORDER BY cm.created_at ASC";
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, postId);
            
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> comment = new HashMap<>();
                    comment.put("id", rs.getInt("comment_id"));
                    comment.put("content", rs.getString("content"));
                    comment.put("authorId", rs.getInt("child_id"));
                    comment.put("authorName", rs.getString("author_name"));
                    comment.put("createdAt", rs.getTimestamp("created_at"));
                    comments.add(comment);
                }
            }
        }
        return comments;
    }
} 