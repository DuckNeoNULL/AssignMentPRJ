package controller;

import dao.ParentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Parents;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "VerifyOtpServlet", urlPatterns = {"/verify-otp"})
public class VerifyOtpServlet extends HttpServlet {
    private static final Logger LOGGER = Logger.getLogger(VerifyOtpServlet.class.getName());

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String otp = request.getParameter("otp");
        String email = request.getParameter("email");

        if (otp == null || otp.trim().isEmpty() || email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Invalid request. Please provide OTP and email.");
            request.getRequestDispatcher("/auth/verify-otp.jsp").forward(request, response);
            return;
        }

        ParentDAO parentDAO = new ParentDAO();
        try {
            Parents parent = parentDAO.findByVerificationCode(otp.trim());

            if (parent != null && parent.getEmail().equals(email)) {
                // OTP is correct and not expired, activate account
                boolean activated = parentDAO.activateAccount(parent.getParentId());

                if (activated) {
                    // Redirect to login with a success message
                    response.sendRedirect(request.getContextPath() + "/auth/login.jsp?success_message=Account activated successfully! You can now log in.");
                } else {
                    request.setAttribute("error", "Failed to activate account. Please try again.");
                    request.getRequestDispatcher("/auth/verify-otp.jsp?email=" + email).forward(request, response);
                }

            } else {
                // Invalid or expired OTP
                request.setAttribute("error", "Invalid or expired OTP. Please check your code or request a new one.");
                request.getRequestDispatcher("/auth/verify-otp.jsp?email=" + email).forward(request, response);
            }
        } catch (SQLException e) {
            LOGGER.log(Level.SEVERE, "Database error during OTP verification", e);
            request.setAttribute("error", "A database error occurred during verification.");
            request.getRequestDispatcher("/auth/verify-otp.jsp?email=" + email).forward(request, response);
        }
    }
} 