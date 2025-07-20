package controller;

import dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import model.Posts;
import util.AchievementHelper;

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.logging.Logger;
import org.json.JSONObject;
import service.GeminiChatbotService;

@WebServlet(name = "CreatePostServlet", urlPatterns = {"/kid/create-post"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class CreatePostServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(CreatePostServlet.class.getName());
    private static final String UPLOAD_DIRECTORY = "uploads";
    
    private PostDAO postDAO;
    private GeminiChatbotService contentCheck;

    @Override
        public void init() throws ServletException {
        super.init();
        contentCheck = new GeminiChatbotService();
        postDAO = new PostDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Hiển thị form tạo bài viết
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("childId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }
        
        request.getRequestDispatcher("/kid/create-post.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("childId") == null) {
            LOGGER.warning("No session or childId found, redirecting to user home");
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }

        try {
            // Lấy dữ liệu form
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            Integer childId = (Integer) session.getAttribute("childId");
            
            LOGGER.info("Processing post creation - Title: " + title + ", ChildId: " + childId);
            
            // Validate dữ liệu
            if (title == null || title.trim().isEmpty()) {
                LOGGER.warning("Empty title provided");
                request.setAttribute("error", "Tiêu đề không được để trống.");
                doGet(request, response);
                return;
            }
            
            if (content == null || content.trim().isEmpty()) {
                LOGGER.warning("Empty content provided");
                request.setAttribute("error", "Nội dung không được để trống.");
                doGet(request, response);
                return;
            }

            // Xử lý upload file (nếu có)
            String imagePath = null;
            Part filePart = request.getPart("image");
            if (filePart != null && filePart.getSize() > 0) {
                LOGGER.info("Processing image upload - Size: " + filePart.getSize());
                
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (fileName != null && !fileName.isEmpty()) {
                    // Tạo thư mục upload nếu chưa có
                    String applicationPath = request.getServletContext().getRealPath("");
                    String uploadFilePath = applicationPath + File.separator + UPLOAD_DIRECTORY;
                    File uploadDir = new File(uploadFilePath);
                    if (!uploadDir.exists()) {
                        boolean created = uploadDir.mkdirs();
                        LOGGER.info("Upload directory created: " + created);
                    }
                    
                    // Tạo tên file unique
                    String uniqueFileName = UUID.randomUUID().toString() + "_" + fileName;
                    String fullPath = uploadFilePath + File.separator + uniqueFileName;
                    
                    LOGGER.info("Saving uploaded file to: " + fullPath);
                    filePart.write(fullPath);
                    imagePath = UPLOAD_DIRECTORY + "/" + uniqueFileName;
                    LOGGER.info("File uploaded successfully: " + imagePath);
                }
            }

            // Tạo đối tượng Posts
           
            try {
            JSONObject safetyCheck = contentCheck.checkContentSafety(content);
            if (!safetyCheck.getBoolean("is_appropriate")) {
                request.setAttribute("error","Nội dung không phù hợp: " + safetyCheck.getJSONArray("reasons"));
                response.sendRedirect(request.getContextPath() + "kid/create-post.jsp");
                return;
            }
                } catch (IOException e) {
                    // Xử lý lỗi
                    return;
                }
            Posts newPost = new Posts();
            newPost.setTitle(title.trim());
            newPost.setContent(content.trim());
            newPost.setAuthorId(childId);
            newPost.setImagePath(imagePath);
            newPost.setPostType("POST"); // Tự động set post_type = 'POST'
            
            LOGGER.info("Creating post with type: POST, imagePath: " + imagePath);

            // Lưu vào database
            boolean success = postDAO.createPost(newPost);

            if (success) {
                LOGGER.info("Post saved successfully to database");
                
                // Tích hợp Achievement System
                AchievementHelper.incrementPostCount(session);
                
                session.setAttribute("message", "Bài viết của bạn đã được gửi đi duyệt! Vui lòng chờ admin phê duyệt.");
                response.sendRedirect(request.getContextPath() + "/kid/home");
            } else {
                LOGGER.warning("Failed to save post to database");
                request.setAttribute("error", "Có lỗi xảy ra khi tạo bài viết. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            LOGGER.severe("Error creating post: " + e.getMessage());
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra khi tạo bài viết. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
} 