package controller;

import dao.PostDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Children;
import model.Posts;

import java.io.IOException;

@WebServlet(name = "StoryServlet", urlPatterns = {"/story"})
public class StoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/kid/create-story.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession();
        Children currentChild = (Children) session.getAttribute("currentChild");

        if (currentChild == null) {
            response.sendRedirect(request.getContextPath() + "/user/home");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");

        Posts newStory = new Posts();
        newStory.setTitle(title);
        newStory.setContent(content);
        newStory.setChildId(currentChild.getChildId());
        newStory.setPostType("STORY");
        newStory.setStatus("PENDING");

        PostDAO postDAO = new PostDAO();
        boolean success = postDAO.createPost(newStory);

        if (success) {
            session.setAttribute("message", "Câu chuyện của bạn đã được gửi đi duyệt! Phụ huynh sẽ sớm xem nó.");
        } else {
            session.setAttribute("error", "Đã có lỗi xảy ra khi gửi truyện. Vui lòng thử lại.");
        }
        response.sendRedirect(request.getContextPath() + "/kid/home");
    }
} 