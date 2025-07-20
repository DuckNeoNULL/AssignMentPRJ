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

import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.logging.Logger;

@WebServlet(name = "StoryServlet", urlPatterns = {"/kid/story"})
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 50    // 50MB
)
public class StoryServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(StoryServlet.class.getName());
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
        // Hiển thị form tạo truyện
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("childId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }
        
        request.getRequestDispatcher("/kid/create-story.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("childId") == null) {
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }

        try {
            // Lấy dữ liệu form
            String title = request.getParameter("title");
            String content = request.getParameter("content");
            Integer childId = (Integer) session.getAttribute("childId");
            
            // Validate dữ liệu
            if (title == null || title.trim().isEmpty()) {
                request.setAttribute("error", "Tiêu đề truyện không được để trống.");
                doGet(request, response);
                return;
            }
            
            if (content == null || content.trim().isEmpty()) {
                request.setAttribute("error", "Nội dung truyện không được để trống.");
                doGet(request, response);
                return;
            }
            
            // Kiểm tra độ dài nội dung (truyện nên có ít nhất 50 ký tự)
            if (content.trim().length() < 50) {
                request.setAttribute("error", "Nội dung truyện phải có ít nhất 50 ký tự.");
                doGet(request, response);
                return;
            }

            // Xử lý upload file ảnh minh họa (nếu có)
            String imagePath = null;
            Part filePart = request.getPart("illustration");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                if (fileName != null && !fileName.isEmpty()) {
                    // Tạo thư mục upload nếu chưa có
                    String applicationPath = request.getServletContext().getRealPath("");
                    String uploadFilePath = applicationPath + File.separator + UPLOAD_DIRECTORY;
                    File uploadDir = new File(uploadFilePath);
                    if (!uploadDir.exists()) {
                        uploadDir.mkdirs();
                    }
                    
                    // Tạo tên file unique
                    String uniqueFileName = "story_" + UUID.randomUUID().toString() + "_" + fileName;
                    filePart.write(uploadFilePath + File.separator + uniqueFileName);
                    imagePath = UPLOAD_DIRECTORY + "/" + uniqueFileName;
                }
            }

            // Tạo đối tượng Posts
            Posts newPost = new Posts();
            newPost.setTitle(title.trim());
            newPost.setContent(content.trim());
            newPost.setAuthorId(childId);
            newPost.setImagePath(imagePath);
            newPost.setPostType("STORY"); // Tự động set post_type = 'STORY'

            // Lưu vào database
            boolean success = postDAO.createPost(newPost);

            if (success) {
                session.setAttribute("message", "Truyện của bạn đã được gửi đi duyệt! Vui lòng chờ admin phê duyệt.");
                response.sendRedirect(request.getContextPath() + "/kid/home");
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi tạo truyện. Vui lòng thử lại.");
                doGet(request, response);
            }

        } catch (Exception e) {
            LOGGER.severe("Error creating story: " + e.getMessage());
            request.setAttribute("error", "Có lỗi xảy ra khi tạo truyện. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
} 