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
import java.util.List;
import java.util.logging.Logger;

@WebServlet("/user/home")
public class UserHomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UserHomeServlet.class.getName());
    private ChildrenDAO childrenDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        childrenDAO = new ChildrenDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        
        if (session == null || session.getAttribute("parentId") == null) {
            LOGGER.warning("User home access without session");
            resp.sendRedirect(req.getContextPath() + "/login?error=session_expired");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        Integer parentId = (Integer) session.getAttribute("parentId");
        
        LOGGER.info("User home access by parentId: " + parentId + " with role: " + userRole);
        
        if (!"USER".equals(userRole) && !"ADMIN".equals(userRole)) {
            LOGGER.warning("Invalid role trying to access user home: " + parentId + " with role: " + userRole);
            resp.sendRedirect(req.getContextPath() + "/login?error=invalid_role");
            return;
        }

        // Fetch the list of children for the logged-in parent
        List<Children> childrenList = childrenDAO.findChildrenByParentId(parentId);
        req.setAttribute("childrenList", childrenList);
        
        req.getRequestDispatcher("/user/home.jsp").forward(req, resp);
    }
}