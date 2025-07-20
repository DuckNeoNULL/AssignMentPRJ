package controller;

import dao.AudioStoryDAO;
import model.AudioStory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/stories/audio")
public class AudioServlet extends HttpServlet {

    private final AudioStoryDAO audioStoryDAO = new AudioStoryDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            List<AudioStory> stories = audioStoryDAO.getAllStories();
            request.setAttribute("stories", stories);
        } catch (SQLException e) {
            // Log the full error for debugging
            e.printStackTrace();
            // Set a user-friendly error message to be displayed on the JSP
            request.setAttribute("dbError", "Lỗi kết nối cơ sở dữ liệu. Vui lòng kiểm tra lại thông tin kết nối trong `DBConnection.java` hoặc đảm bảo SQL Server đang chạy. Chi tiết lỗi: " + e.getMessage());
        }
        
        request.getRequestDispatcher("/kid/audio-stories.jsp").forward(request, response);
    }
} 