package controller;

import dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Posts;

import java.io.File;
import java.io.IOException;
import java.util.Base64;
import java.util.UUID;
import java.util.logging.Logger;

@WebServlet(name = "DrawServlet", urlPatterns = {"/kid/draw"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class DrawServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DrawServlet.class.getName());
    private static final String UPLOAD_DIRECTORY = "uploads";
    
    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị trang bảng vẽ
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("childId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }
        
        request.getRequestDispatcher("/kid/draw.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("childId") == null) {
            LOGGER.warning("No session or childId found, redirecting to user home");
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }

        try {
            // Lấy dữ liệu từ form
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            String canvasData = request.getParameter("canvasData"); // Base64 image data
            Integer childId = (Integer) session.getAttribute("childId");
            
            LOGGER.info("Processing drawing submission - Title: " + title + ", ChildId: " + childId);
            
            // Validate dữ liệu
            if (title == null || title.trim().isEmpty()) {
                LOGGER.warning("Empty title provided");
                request.setAttribute("error", "Tiêu đề không được để trống.");
                doGet(request, response);
                return;
            }
            
            if (canvasData == null || canvasData.trim().isEmpty()) {
                LOGGER.warning("Empty canvas data provided");
                request.setAttribute("error", "Vui lòng vẽ một bức tranh trước khi lưu.");
                doGet(request, response);
                return;
            }

            // Xử lý lưu canvas data thành file ảnh
            String imagePath = null;
            if (canvasData.startsWith("data:image")) {
                LOGGER.info("Processing canvas data for image save");
                
                // Tạo thư mục upload nếu chưa có
                String applicationPath = request.getServletContext().getRealPath("");
                String uploadFilePath = applicationPath + File.separator + UPLOAD_DIRECTORY;
                File uploadDir = new File(uploadFilePath);
                if (!uploadDir.exists()) {
                    boolean created = uploadDir.mkdirs();
                    LOGGER.info("Upload directory created: " + created);
                }
                
                // Tạo tên file unique
                String uniqueFileName = "drawing_" + UUID.randomUUID().toString() + ".png";
                String fullPath = uploadFilePath + File.separator + uniqueFileName;
                
                LOGGER.info("Saving image to: " + fullPath);
                
                // Decode Base64 và lưu file
                try {
                    String base64Data = canvasData.split(",")[1];
                    byte[] imageBytes = Base64.getDecoder().decode(base64Data);
                    
                    java.nio.file.Files.write(new File(fullPath).toPath(), imageBytes);
                    imagePath = UPLOAD_DIRECTORY + "/" + uniqueFileName;
                    LOGGER.info("Image saved successfully: " + imagePath);
                } catch (Exception e) {
                    LOGGER.severe("Error saving canvas data: " + e.getMessage());
                    e.printStackTrace();
                    request.setAttribute("error", "Có lỗi xảy ra khi lưu bức vẽ. Vui lòng thử lại.");
                    doGet(request, response);
                    return;
                }
            }

            // Tạo đối tượng Posts
            Posts newPost = new Posts();
            newPost.setTitle(title.trim());
            newPost.setContent(content != null ? content.trim() : "");
            newPost.setAuthorId(childId);
            newPost.setImagePath(imagePath);
            newPost.setPostType("DRAWING"); // Tự động set post_type = 'DRAWING'

            LOGGER.info("Creating post with type: DRAWING, imagePath: " + imagePath);

            // Lưu vào database
            boolean success = postDAO.createPost(newPost);

            if (success) {
                LOGGER.info("Drawing saved successfully to database");
                session.setAttribute("message", "Bức vẽ của bạn đã được gửi đi duyệt! Vui lòng chờ admin phê duyệt.");
                response.sendRedirect(request.getContextPath() + "/kid/home");
            } else {
                LOGGER.warning("Failed to save drawing to database");
                request.setAttribute("error", "Có lỗi xảy ra khi lưu bức vẽ. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            LOGGER.severe("Error creating drawing: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi lưu bức vẽ. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}