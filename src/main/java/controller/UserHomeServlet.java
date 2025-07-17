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
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.logging.Level;
import model.Parents;
import dao.ParentDAO;
import java.sql.SQLException;

@WebServlet(name = "UserHomeServlet", urlPatterns = {"/user/home"})
public class UserHomeServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(UserHomeServlet.class.getName());
    private ChildrenDAO childrenDAO;

    @Override
    public void init() throws ServletException {
        super.init();
        childrenDAO = new ChildrenDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("add_child".equals(action)) {
            request.getRequestDispatcher("/user/add-child.jsp").forward(request, response);
            return;
        }
        if ("manage_account".equals(action)) {
            showManageAccountPage(request, response);
            return;
        }

        // Existing logic to show child profiles
        showChildProfiles(request, response);
    }
    
    private void showChildProfiles(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        
        if (session == null || session.getAttribute("parentId") == null) {
            LOGGER.warning("User home access without session");
            response.sendRedirect(request.getContextPath() + "/login?error=session_expired");
            return;
        }
        
        String userRole = (String) session.getAttribute("userRole");
        Integer parentId = (Integer) session.getAttribute("parentId");
        
        LOGGER.info("User home access by parentId: " + parentId + " with role: " + userRole);
        
        if (!"USER".equals(userRole) && !"ADMIN".equals(userRole)) {
            LOGGER.warning("Invalid role trying to access user home: " + parentId + " with role: " + userRole);
            response.sendRedirect(request.getContextPath() + "/login?error=invalid_role");
            return;
        }

        // Fetch the list of children for the logged-in parent
        List<Children> childrenList = childrenDAO.findChildrenByParentId(parentId);
        request.setAttribute("childrenList", childrenList);
        
        request.getRequestDispatcher("/user/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if ("save_child".equals(action)) {
            saveChildProfile(request, response);
            return;
        }
        if ("update_profile".equals(action)) {
            updateProfile(request, response);
            return;
        }
        if ("change_password".equals(action)) {
            changePassword(request, response);
            return;
        }
        
        // Handle other post actions if necessary
        doGet(request, response);
    }

    private void showManageAccountPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        int parentId = (int) session.getAttribute("parentId");
        
        ParentDAO parentDAO = new ParentDAO();
        Parents parent = parentDAO.findParentById(parentId);
        
        request.setAttribute("parent", parent);
        request.getRequestDispatcher("/user/manage-account.jsp").forward(request, response);
    }
    
    private void updateProfile(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        int parentId = (int) session.getAttribute("parentId");
        String fullName = request.getParameter("fullName");
        String phone = request.getParameter("phone");
        
        Parents parent = new Parents();
        parent.setParentId(parentId);
        parent.setFullName(fullName);
        parent.setPhone(phone);
        
        ParentDAO parentDAO = new ParentDAO();
        try {
            parentDAO.updateProfile(parent);
            request.setAttribute("success_message", "Thông tin đã được cập nhật thành công!");
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Profile update failed", e);
            request.setAttribute("error_message", "Lỗi cập nhật thông tin.");
        }
        showManageAccountPage(request, response);
    }

    private void changePassword(HttpServletRequest request, HttpServletResponse response) 
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        int parentId = (int) session.getAttribute("parentId");
        String currentPassword = request.getParameter("currentPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmNewPassword = request.getParameter("confirmNewPassword");

        if (!newPassword.equals(confirmNewPassword)) {
            request.setAttribute("error_message", "Mật khẩu mới không khớp.");
            showManageAccountPage(request, response);
            return;
        }
        
        ParentDAO parentDAO = new ParentDAO();
        Parents parent = parentDAO.findParentById(parentId);

        // NOTE: This assumes plaintext passwords. In a real app, use a password encoder.
        if (parent != null && parent.getPassword().equals(currentPassword)) {
            try {
                parentDAO.updatePassword(parentId, newPassword);
                request.setAttribute("success_message", "Mật khẩu đã được thay đổi thành công!");
            } catch (Exception e) {
                LOGGER.log(Level.SEVERE, "Password change failed", e);
                request.setAttribute("error_message", "Lỗi khi đổi mật khẩu.");
            }
        } else {
            request.setAttribute("error_message", "Mật khẩu hiện tại không đúng.");
        }
        showManageAccountPage(request, response);
    }
    
    private void saveChildProfile(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("parentId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            String fullName = request.getParameter("fullName");
            String dateOfBirthStr = request.getParameter("dateOfBirth");
            String gender = request.getParameter("gender");
            int parentId = (int) session.getAttribute("parentId");

            // Simple validation
            if (fullName == null || fullName.trim().isEmpty() || dateOfBirthStr == null || dateOfBirthStr.isEmpty()) {
                request.setAttribute("error", "Vui lòng điền đầy đủ họ tên và ngày sinh.");
                request.getRequestDispatcher("/user/add-child.jsp").forward(request, response);
                return;
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date dateOfBirth = sdf.parse(dateOfBirthStr);

            Parents parent = new Parents();
            parent.setParentId(parentId);

            Children newChild = new Children();
            newChild.setFullName(fullName);
            newChild.setDateOfBirth(dateOfBirth);
            newChild.setGender(gender);
            newChild.setParent(parent);

            ChildrenDAO childrenDAO = new ChildrenDAO();
            childrenDAO.createChild(newChild);

            response.sendRedirect(request.getContextPath() + "/user/home");

        } catch (Exception e) {
            LOGGER.log(Level.SEVERE, "Error saving child profile", e);
            request.setAttribute("error", "Đã có lỗi xảy ra. Vui lòng thử lại.");
            request.getRequestDispatcher("/user/add-child.jsp").forward(request, response);
        }
    }
}