package controller;

import dao.VideoDAO;
import model.EducationalVideo;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/videos")
public class VideoServlet extends HttpServlet {

    private final VideoDAO videoDAO = new VideoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        List<EducationalVideo> videoList = videoDAO.getAllVideos();
        
        request.setAttribute("videoList", videoList);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("/videos.jsp");
        dispatcher.forward(request, response);
    }
} 