package controller;

import dao.ChildrenDAO;
import dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Children;
import model.Posts;
import dao.DashboardDAO;
import jakarta.servlet.http.Part;
import java.io.File;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;

import java.io.IOException;
import java.util.logging.Logger;
import java.util.List;
import java.util.UUID;

@WebServlet(name = "KidHomeServlet", urlPatterns = {"/kid/home"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
                 maxFileSize = 1024 * 1024 * 10,      // 10MB
                 maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class KidHomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(KidHomeServlet.class.getName());
    private static final String UPLOAD_DIRECTORY = "uploads";
    private ChildrenDAO childrenDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        childrenDAO = new ChildrenDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("parentId") == null) {
            LOGGER.warning("Unauthorized access attempt to /kid/home. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        try {
            int childId = Integer.parseInt(request.getParameter("childId"));
            Children child = childrenDAO.findChildById(childId);

            if (child != null) {
                // For security, you might want to verify that this child belongs to the logged-in parent
                session.setAttribute("currentChild", child); // Store child in session for other features
                // SỬA LỖI: Thêm dòng này để lưu childId vào session
                session.setAttribute("childId", child.getChildId());
                request.setAttribute("child", child);
                LOGGER.info("Child profile loaded for: " + child.getFullName());
                request.getRequestDispatcher("/kid/home.jsp").forward(request, response);
            } else {
                LOGGER.warning("Child profile not found for ID: " + childId);
                response.sendRedirect(request.getContextPath() + "/user/home?error=child_not_found");
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid childId parameter.");
            response.sendRedirect(request.getContextPath() + "/user/home?error=invalid_child_id");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("create_post".equals(action)) {
            createPost(request, response);
        } else {
            doGet(request, response);
        }
    }

    private void createPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("childId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            int childId = (int) session.getAttribute("childId");
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            Part filePart = request.getPart("image");
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uniqueFileName = "";
            String imagePath = null;

            if (fileName != null && !fileName.isEmpty()) {
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadFilePath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                filePart.write(uploadFilePath + File.separator + uniqueFileName);
                imagePath = UPLOAD_DIRECTORY + "/" + uniqueFileName;
            }

            Children child = new Children();
            child.setChildId(childId);

            Posts newPost = new Posts();
            newPost.setTitle(title);
            newPost.setContent(content);
            newPost.setChild(child);
            if (imagePath != null && !imagePath.isEmpty()) {
                newPost.setImagePath(imagePath);
            }
            newPost.setStatus("PENDING");
            newPost.setPostType("POST");

            PostDAO postDAO = new PostDAO();
            boolean success = postDAO.createPost(newPost);

            if (success) {
                session.setAttribute("message", "Bài viết của bạn đã được gửi đi duyệt!");
            } else {
                session.setAttribute("error", "Có lỗi xảy ra khi tạo bài viết.");
            }
            
            response.sendRedirect(request.getContextPath() + "/kid/home");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error creating post", e);
            // Optionally, forward to an error page
            request.setAttribute("error", "Failed to create post.");
            doGet(request, response);
        }
    }
} 