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

@WebServlet("/kid/create-post")
public class CreatePostServlet extends HttpServlet {
    private PostDAO postDAO;

    @Override
    public void init() throws ServletException {
        postDAO = new PostDAO();
    }

    // Show the form to create a post
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentChild") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }
        request.getRequestDispatcher("/kid/create-post.jsp").forward(request, response);
    }

    // Handle the submission of the post
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("currentChild") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        String title = request.getParameter("title");
        String content = request.getParameter("content");
        Children currentChild = (Children) session.getAttribute("currentChild");

        if (title == null || title.trim().isEmpty() || content == null || content.trim().isEmpty()) {
            request.setAttribute("error", "Title and content are required!");
            request.getRequestDispatcher("/kid/create-post.jsp").forward(request, response);
            return;
        }

        Posts newPost = new Posts();
        newPost.setTitle(title);
        newPost.setContent(content);
        newPost.setChild(currentChild);
        newPost.setStatus("PENDING"); // All new posts need approval
        newPost.setPostType("POST");

        boolean success = postDAO.createPost(newPost);

        if (success) {
            session.setAttribute("message", "Bài viết của bạn đã được gửi đi duyệt!");
            // Redirect to a success page or back to the kid's home
            response.sendRedirect(request.getContextPath() + "/kid/home?childId=" + currentChild.getChildId() + "&post_success=true");
        } else {
            request.setAttribute("error", "Something went wrong! Please try again.");
            request.getRequestDispatcher("/kid/create-post.jsp").forward(request, response);
        }
    }
} 