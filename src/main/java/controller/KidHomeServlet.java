package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/kid/home")
public class KidHomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(KidHomeServlet.class.getName());

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);

        // Basic session validation: Check if a user is logged in.
        // For a real application, you would have more robust logic to ensure 
        // a child profile is selected.
        if (session == null || session.getAttribute("parentId") == null) {
            LOGGER.warning("Unauthorized access attempt to /kid/home. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        LOGGER.info("User session found. Forwarding to Kid's Interface homepage.");
        
        // Forward to the Kid's Interface homepage
        request.getRequestDispatcher("/kid/home.jsp").forward(request, response);
    }
} 