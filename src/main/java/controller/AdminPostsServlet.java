package controller;

import dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Posts;

import java.io.IOException;
import java.util.List;
import java.util.logging.Logger;

@WebServlet(name = "AdminPostsServlet", urlPatterns = {"/admin/posts"})
public class AdminPostsServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(AdminPostsServlet.class.getName());
    
    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            LOGGER.warning("Unauthorized access attempt to admin posts page");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            LOGGER.info("Loading pending posts for admin...");
            
            // Lấy danh sách bài viết đang chờ duyệt
            List<Posts> pendingPosts = postDAO.getPendingPosts();
            
            LOGGER.info("Found " + (pendingPosts != null ? pendingPosts.size() : 0) + " pending posts");
            
            // Đính kèm danh sách vào request attribute
            request.setAttribute("pendingPosts", pendingPosts);
            
            // Hiển thị trang quản lý bài viết
            request.getRequestDispatcher("/admin/post-review.jsp").forward(request, response);
            
        } catch (Exception e) {
            LOGGER.severe("Error loading pending posts: " + e.getMessage());
            e.printStackTrace(); // In stack trace để debug
            request.setAttribute("error", "Có lỗi xảy ra khi tải danh sách bài viết chờ duyệt: " + e.getMessage());
            request.getRequestDispatcher("/admin/post-review.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển POST request về GET để hiển thị lại trang
        doGet(request, response);
    }
} 