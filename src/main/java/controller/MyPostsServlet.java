package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;
import model.Posts;
import dao.PostDAO;
import java.util.ArrayList;

@WebServlet(name = "MyPostsServlet", urlPatterns = {"/kid/my-posts"})
public class MyPostsServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(MyPostsServlet.class.getName());
    private PostDAO postDAO;
    
    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        List<Posts> myPosts = new ArrayList<>();
        String error = null;

        LOGGER.info("=== MyPostsServlet doGet started ===");

        // Kiểm tra session và childId
        if (session == null || session.getAttribute("parentId") == null) {
            LOGGER.warning("No session or parentId found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        if (session.getAttribute("childId") == null) {
            LOGGER.warning("No childId in session, redirecting to select child");
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }

        try {
            Integer childId = (Integer) session.getAttribute("childId");
            LOGGER.info("Processing my posts for childId: " + childId);
            
            // Lấy tất cả bài viết của trẻ em (cả APPROVED và PENDING)
            myPosts = postDAO.getPostsByChildId(childId);
            LOGGER.info("Found " + myPosts.size() + " posts for child");
            
            // Phân loại bài viết theo status
            List<Posts> approvedPosts = new ArrayList<>();
            List<Posts> pendingPosts = new ArrayList<>();
            List<Posts> rejectedPosts = new ArrayList<>();
            
            for (Posts post : myPosts) {
                switch (post.getStatus()) {
                    case "APPROVED":
                        approvedPosts.add(post);
                        break;
                    case "PENDING":
                        pendingPosts.add(post);
                        break;
                    case "REJECTED":
                        rejectedPosts.add(post);
                        break;
                }
            }
            
            request.setAttribute("approvedPosts", approvedPosts);
            request.setAttribute("pendingPosts", pendingPosts);
            request.setAttribute("rejectedPosts", rejectedPosts);
            request.setAttribute("totalPosts", myPosts.size());
            
            LOGGER.info("Posts categorized - Approved: " + approvedPosts.size() + 
                       ", Pending: " + pendingPosts.size() + 
                       ", Rejected: " + rejectedPosts.size());

        } catch (NumberFormatException e) {
            error = "ID của trẻ không hợp lệ.";
            LOGGER.severe("NumberFormatException: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            error = "Lỗi khi truy xuất bài viết từ cơ sở dữ liệu.";
            LOGGER.severe("SQLException: " + e.getMessage());
            e.printStackTrace();
        }

        if (error != null) {
            LOGGER.warning("Setting error: " + error);
            request.setAttribute("error", error);
        }
        
        LOGGER.info("Forwarding to my-posts.jsp");
        request.getRequestDispatcher("/kid/my-posts.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Handle any POST requests if needed (like deleting posts)
        response.sendRedirect(request.getContextPath() + "/kid/my-posts");
    }
} 