package controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import java.util.logging.Logger;
import java.util.ArrayList;
import dao.ChildrenDAO;
import model.Children;

@WebServlet(name = "FriendshipServlet", urlPatterns = {"/kid/friendship"})
public class FriendshipServlet extends HttpServlet {
    
    private static final Logger LOGGER = Logger.getLogger(FriendshipServlet.class.getName());
    private ChildrenDAO childrenDAO;
    
    @Override
    public void init() throws ServletException {
        childrenDAO = new ChildrenDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String error = null;
        String success = null;

        LOGGER.info("=== FriendshipServlet doGet started ===");

        // Kiểm tra session và childId
        if (session == null || session.getAttribute("parentId") == null) {
            LOGGER.warning("No session or parentId found, redirecting to login");
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        if (session.getAttribute("childId") == null) {
            LOGGER.warning("No childId in session, redirecting to select child");
            response.sendRedirect(request.getContextPath() + "/user/home?message=please_select_child");
            return;
        }

        try {
            Integer currentChildId = (Integer) session.getAttribute("childId");
            LOGGER.info("Processing friendship for childId: " + currentChildId);
            
            // Lấy danh sách trẻ em có thể kết bạn (trừ chính mình)
            List<Children> potentialFriends = childrenDAO.getPotentialFriends(currentChildId);
            LOGGER.info("Found " + potentialFriends.size() + " potential friends");
            
            // Lấy danh sách bạn bè hiện tại
            List<Children> currentFriends = childrenDAO.getCurrentFriends(currentChildId);
            LOGGER.info("Found " + currentFriends.size() + " current friends");
            
            // Lấy danh sách lời mời kết bạn đã gửi
            List<Children> sentRequests = childrenDAO.getSentFriendRequests(currentChildId);
            LOGGER.info("Found " + sentRequests.size() + " sent requests");
            
            // Lấy danh sách lời mời kết bạn đã nhận
            List<Children> receivedRequests = childrenDAO.getReceivedFriendRequests(currentChildId);
            LOGGER.info("Found " + receivedRequests.size() + " received requests");
            
            request.setAttribute("potentialFriends", potentialFriends);
            request.setAttribute("currentFriends", currentFriends);
            request.setAttribute("sentRequests", sentRequests);
            request.setAttribute("receivedRequests", receivedRequests);

        } catch (SQLException e) {
            error = "Lỗi khi truy xuất dữ liệu bạn bè từ cơ sở dữ liệu.";
            LOGGER.severe("SQLException: " + e.getMessage());
            e.printStackTrace();
        }

        if (error != null) {
            LOGGER.warning("Setting error: " + error);
            request.setAttribute("error", error);
        }
        
        if (success != null) {
            LOGGER.info("Setting success: " + success);
            request.setAttribute("success", success);
        }
        
        LOGGER.info("Forwarding to friendship.jsp");
        request.getRequestDispatcher("/kid/friendship.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        String action = request.getParameter("action");
        String targetChildIdStr = request.getParameter("targetChildId");
        
        LOGGER.info("=== FriendshipServlet doPost started ===");
        LOGGER.info("Action: " + action + ", TargetChildId: " + targetChildIdStr);

        // Kiểm tra session
        if (session == null || session.getAttribute("childId") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        Integer currentChildId = (Integer) session.getAttribute("childId");
        Integer targetChildId = null;
        
        try {
            targetChildId = Integer.parseInt(targetChildIdStr);
        } catch (NumberFormatException e) {
            LOGGER.warning("Invalid targetChildId: " + targetChildIdStr);
            response.sendRedirect(request.getContextPath() + "/kid/friendship?error=invalid_id");
            return;
        }

        try {
            String message = null;
            
            switch (action) {
                case "send_request":
                    childrenDAO.sendFriendRequest(currentChildId, targetChildId);
                    message = "Đã gửi lời mời kết bạn!";
                    break;
                    
                case "accept_request":
                    childrenDAO.acceptFriendRequest(currentChildId, targetChildId);
                    message = "Đã chấp nhận lời mời kết bạn!";
                    break;
                    
                case "reject_request":
                    childrenDAO.rejectFriendRequest(currentChildId, targetChildId);
                    message = "Đã từ chối lời mời kết bạn.";
                    break;
                    
                case "cancel_request":
                    childrenDAO.cancelFriendRequest(currentChildId, targetChildId);
                    message = "Đã hủy lời mời kết bạn.";
                    break;
                    
                case "unfriend":
                    childrenDAO.unfriend(currentChildId, targetChildId);
                    message = "Đã hủy kết bạn.";
                    break;
                    
                default:
                    LOGGER.warning("Unknown action: " + action);
                    response.sendRedirect(request.getContextPath() + "/kid/friendship?error=unknown_action");
                    return;
            }
            
            LOGGER.info("Action completed successfully: " + action);
            response.sendRedirect(request.getContextPath() + "/kid/friendship?success=" + 
                                java.net.URLEncoder.encode(message, "UTF-8"));
            
        } catch (SQLException e) {
            LOGGER.severe("SQLException in doPost: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/kid/friendship?error=database_error");
        }
    }
} 