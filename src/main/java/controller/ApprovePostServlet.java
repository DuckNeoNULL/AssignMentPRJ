package controller;

import dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet(name = "ApprovePostServlet", urlPatterns = {"/admin/approve-post"})
public class ApprovePostServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(ApprovePostServlet.class.getName());
    
    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        postDAO = new PostDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Kiểm tra quyền admin
        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            // Lấy thông tin từ form
            String postIdStr = request.getParameter("postId");
            String action = request.getParameter("action"); // "approve" hoặc "reject"
            
            // Validate dữ liệu đầu vào
            if (postIdStr == null || postIdStr.trim().isEmpty()) {
                session.setAttribute("error", "ID bài viết không được để trống.");
                response.sendRedirect(request.getContextPath() + "/admin/posts");
                return;
            }
            
            if (action == null || action.trim().isEmpty()) {
                session.setAttribute("error", "Hành động không được để trống.");
                response.sendRedirect(request.getContextPath() + "/admin/posts");
                return;
            }

            // Parse postId
            int postId;
            try {
                postId = Integer.parseInt(postIdStr);
            } catch (NumberFormatException e) {
                LOGGER.warning("Invalid post ID: " + postIdStr);
                session.setAttribute("error", "ID bài viết không hợp lệ.");
                response.sendRedirect(request.getContextPath() + "/admin/posts");
                return;
            }

            // Xác định trạng thái mới
            String newStatus;
            String message;
            
            switch (action.toLowerCase()) {
                case "approve":
                    newStatus = "APPROVED";
                    message = "Bài viết đã được phê duyệt thành công!";
                    break;
                case "reject":
                    newStatus = "REJECTED";
                    message = "Bài viết đã bị từ chối.";
                    break;
                default:
                    session.setAttribute("error", "Hành động không hợp lệ.");
                    response.sendRedirect(request.getContextPath() + "/admin/posts");
                    return;
            }

            // Cập nhật trạng thái bài viết
            boolean success = postDAO.updatePostStatus(postId, newStatus);

            if (success) {
                session.setAttribute("message", message);
                LOGGER.info("Post " + postId + " status updated to " + newStatus + " by admin");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi cập nhật trạng thái bài viết.");
                LOGGER.warning("Failed to update post " + postId + " status to " + newStatus);
            }

            // Chuyển hướng về trang quản lý bài viết
            response.sendRedirect(request.getContextPath() + "/admin/posts");

        } catch (Exception e) {
            LOGGER.severe("Error approving post: " + e.getMessage());
            session.setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu. Vui lòng thử lại.");
            response.sendRedirect(request.getContextPath() + "/admin/posts");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Chuyển hướng GET request về trang quản lý bài viết
        response.sendRedirect(request.getContextPath() + "/admin/posts");
    }
} 