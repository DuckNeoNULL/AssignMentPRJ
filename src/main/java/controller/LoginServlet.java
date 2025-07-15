package controller;

import dao.ParentDAO;
import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import model.Parents;

public class LoginServlet extends HttpServlet {
    
    @Inject
    private ParentDAO parentDao;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String registered = req.getParameter("registered");
        if ("true".equals(registered)) {
            req.setAttribute("message", "Registration successful! Please login.");
        }
        req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        Parents parent = parentDao.findByEmail(email);
        
        if (parent == null || !(password == parent.getPasswordHash())) {
            req.setAttribute("error", "Invalid email or password");
            req.getRequestDispatcher("/auth/login.jsp").forward(req, resp);
            return;
        }
        
        HttpSession session = req.getSession();
        session.setAttribute("parentId", parent.getParentId());
        
        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}