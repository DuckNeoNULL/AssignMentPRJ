package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.Posts;
import dao.PostDAO;
import model.Children;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.logging.Logger;

@WebServlet(name = "FriendPostsServlet", urlPatterns = {"/kid/friend-posts"})
public class FriendPostsServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(FriendPostsServlet.class.getName());
    private PostDAO postDAO;
    
    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        List<Posts> friendPosts = new ArrayList<>();
        String error = null;

        LOGGER.info("=== FriendPostsServlet doGet started ===");

        // SỬA LỖI: Kiểm tra session và childId một cách chi tiết hơn
        if (session == null || session.getAttribute("parentId") == null) {
            LOGGER.warning("No session or parentId found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        // Đã đăng nhập nhưng chưa chọn profile con
        if (session.getAttribute("childId") == null) {
            LOGGER.warning("No childId in session, redirecting to select child");
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }

        // Đã có childId, tiếp tục xử lý
        try {
            Integer childId = (Integer) session.getAttribute("childId");
            LOGGER.info("Processing friend posts for childId: " + childId);
            
            friendPosts = postDAO.getApprovedFriendPosts(childId);
            LOGGER.info("Found " + friendPosts.size() + " friend posts");
            
            if (friendPosts.isEmpty()) {
                LOGGER.info("No friend posts found, setting message");
                request.setAttribute("message", "Chưa có bài viết nào từ bạn bè.");
            } else {
                LOGGER.info("Friend posts found, displaying them");
            }

        } catch (NumberFormatException e) {
            error = "ID của trẻ không hợp lệ.";
            LOGGER.severe("NumberFormatException: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            error = "Lỗi khi truy xuất bài viết bạn bè từ cơ sở dữ liệu.";
            LOGGER.severe("SQLException: " + e.getMessage());
            e.printStackTrace();
        }

        if (error != null) {
            LOGGER.warning("Setting error: " + error);
            request.setAttribute("error", error);
        }
        
        request.setAttribute("friendPosts", friendPosts);
        LOGGER.info("Forwarding to friend-posts.jsp with " + friendPosts.size() + " posts");
        request.getRequestDispatcher("/kid/friend-posts.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        try {
            // Validate session
            Integer childId = (Integer) request.getSession().getAttribute("childId");
            if (childId == null) {
                response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
                return;
            }
            
            // Validate required parameters
            String action = request.getParameter("action");
            String postIdStr = request.getParameter("postId");
            
            if (action == null || postIdStr == null) {
                sendError(request, response, "Thiếu thông tin cần thiết");
                return;
            }
            
            // Validate postId
            Integer postId;
            try {
                postId = Integer.parseInt(postIdStr);
            } catch (NumberFormatException e) {
                sendError(request, response, "Mã bài viết không hợp lệ");
                return;
            }
            
            String message = null;
            
            try {
                switch (action) {
                    case "like":
                        postDAO.addLike(postId, childId);
                        message = "Đã thích bài viết";
                        break;
                        
                    case "report":
                        String reason = request.getParameter("reason");
                        if (reason == null || reason.trim().isEmpty()) {
                            sendError(request, response, "Vui lòng chọn lý do báo cáo");
                            return;
                        }
                        postDAO.reportPost(postId, childId, reason.trim());
                        message = "Cảm ơn bạn đã báo cáo. Chúng tôi sẽ xem xét nội dung này.";
                        break;
                        
                    case "comment":
                        String comment = request.getParameter("comment");
                        if (comment == null || comment.trim().isEmpty()) {
                            sendError(request, response, "Nội dung bình luận không được để trống");
                            return;
                        }
                        
                        // Check comment length
                        if (comment.length() > 500) {
                            sendError(request, response, "Bình luận không được vượt quá 500 ký tự");
                            return;
                        }
                        
                        // Filter inappropriate content
                        if (!isAppropriateContent(comment)) {
                            sendError(request, response, "Bình luận chứa nội dung không phù hợp");
                            return;
                        }
                        
                        postDAO.addComment(postId, childId, comment.trim());
                        message = "Đã thêm bình luận";
                        break;
                        
                    default:
                        sendError(request, response, "Hành động không hợp lệ");
                        return;
                }
                
                // Set success message if applicable
                if (message != null) {
                    request.getSession().setAttribute("successMessage", message);
                }
                
                response.sendRedirect(request.getContextPath() + "/kid/friend-posts");
                
            } catch (SQLException e) {
                getServletContext().log("Database error in FriendPostsServlet", e);
                sendError(request, response, "Xin lỗi, đã có lỗi xảy ra. Vui lòng thử lại sau.");
            }
            
        } catch (Exception e) {
            getServletContext().log("Unexpected error in FriendPostsServlet", e);
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }
    
    private void sendError(HttpServletRequest request, HttpServletResponse response, String message) 
            throws ServletException, IOException {
        request.getSession().setAttribute("errorMessage", message);
        response.sendRedirect(request.getContextPath() + "/kid/friend-posts");
    }
    
    private boolean isAppropriateContent(String content) {
        if (content == null) return false;
        
        // Convert to lowercase for case-insensitive checking
        content = content.toLowerCase();
        
        // List of inappropriate words (có thể mở rộng)
        String[] inappropriateWords = {
            "bad", "hate", "stupid", "ugly", "kill", "die", "idiot",
            "damn", "hell", "shit", "fuck", "bitch", "ass",
            // Thêm từ tiếng Việt
            "ngu", "xấu", "chết", "đánh", "đồ", "khùng", "điên",
            "cút", "biến", "cứt", "đụ", "đm", "đéo", "lồn"
        };
        
        // Check for inappropriate words
        for (String word : inappropriateWords) {
            if (content.contains(word)) {
                return false;
            }
        }
        
        // Check for excessive punctuation (spam)
        int punctCount = content.replaceAll("[^!?.]", "").length();
        if (punctCount > 5) {
            return false;
        }
        
        // Check for excessive capitalization
        int upperCount = content.replaceAll("[^A-Z]", "").length();
        if (content.length() > 0 && (double)upperCount / content.length() > 0.7) {
            return false;
        }
        
        return true;
    }
} 