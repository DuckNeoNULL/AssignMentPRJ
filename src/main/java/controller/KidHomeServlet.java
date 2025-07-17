package controller;

import dao.ChildrenDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Children;

import java.io.IOException;
import java.util.logging.Logger;

@WebServlet("/kid/home")
public class KidHomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(KidHomeServlet.class.getName());
    private ChildrenDAO childrenDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        childrenDAO = new ChildrenDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("parentId") == null) {
            LOGGER.warning("Unauthorized access attempt to /kid/home. Redirecting to login.");
            response.sendRedirect(request.getContextPath() + "/login?error=auth_required");
            return;
        }

        try {
            int childId = Integer.parseInt(request.getParameter("childId"));
            Children child = childrenDAO.findChildById(childId);

            if (child != null) {
                // For security, you might want to verify that this child belongs to the logged-in parent
                session.setAttribute("currentChild", child); // Store child in session for other features
                request.setAttribute("child", child);
                LOGGER.info("Child profile loaded for: " + child.getFullName());
                request.getRequestDispatcher("/kid/home.jsp").forward(request, response);
            } else {
                LOGGER.warning("Child profile not found for ID: " + childId);
                response.sendRedirect(request.getContextPath() + "/user/home?error=child_not_found");
            }
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid childId parameter.");
            response.sendRedirect(request.getContextPath() + "/user/home?error=invalid_child_id");
        }
    }
} 