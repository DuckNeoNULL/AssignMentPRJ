package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/kid/achievements")
public class AchievementServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("parentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }
        
        // Kiểm tra childId
        Integer childId = (Integer) session.getAttribute("childId");
        if (childId == null) {
            response.sendRedirect(request.getContextPath() + "/user/home?error=please_select_child");
            return;
        }
        
        try {
            // Tạo dữ liệu mẫu để test
            request.setAttribute("childId", childId);
            request.setAttribute("testMode", "true");
            
            // Forward to achievements page
            request.getRequestDispatcher("/kid/achievements.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("text/html;charset=UTF-8");
            response.getWriter().println("<html><body>");
            response.getWriter().println("<h1>Error in Achievement Servlet</h1>");
            response.getWriter().println("<p>Error: " + e.getMessage() + "</p>");
            response.getWriter().println("<pre>" + e.getStackTrace()[0] + "</pre>");
            response.getWriter().println("</body></html>");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
} 