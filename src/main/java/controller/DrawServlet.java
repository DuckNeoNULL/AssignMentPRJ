package controller;

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

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Base64;
import java.util.UUID;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "DrawServlet", urlPatterns = {"/draw"})
@MultipartConfig
public class DrawServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(DrawServlet.class.getName());
    private static final String UPLOAD_DIRECTORY = "uploads";

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        Children currentChild = (Children) session.getAttribute("currentChild");

        if (session == null || currentChild == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            String base64Image = request.getParameter("imageData").split(",")[1];
            byte[] imageBytes = Base64.getDecoder().decode(base64Image);

            String relativePath = File.separator + "uploads";
            String absolutePath = getServletContext().getRealPath(relativePath);
            File uploadDir = new File(absolutePath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String fileName = "drawing-" + UUID.randomUUID().toString() + ".png";
            File file = new File(uploadDir, fileName);
            try (FileOutputStream fos = new FileOutputStream(file)) {
                fos.write(imageBytes);
            }

            String imagePath = "uploads" + "/" + fileName;

            Posts newPost = new Posts();
            newPost.setTitle("Bức vẽ của bé");
            newPost.setContent("Đây là tác phẩm mới của bé!");
            newPost.setImagePath(imagePath);
            newPost.setChildId(currentChild.getChildId());
            newPost.setStatus("PENDING");
            newPost.setPostType("DRAWING");

            PostDAO postDAO = new PostDAO();
            boolean success = postDAO.createPost(newPost);

            if (success) {
                session.setAttribute("message", "Bức vẽ của bạn đã được gửi đi duyệt!");
            } else {
                session.setAttribute("error", "Lỗi khi gửi tác phẩm của bạn.");
            }
            
            response.sendRedirect(request.getContextPath() + "/kid/home");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error saving drawing", e);
            response.sendRedirect(request.getContextPath() + "/kid/draw.jsp?error=savefailed");
        }
    }
}