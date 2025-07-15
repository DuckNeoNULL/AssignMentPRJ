package controller;

import dao.ParentDAO;
import model.Parents;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    
    @Inject
    private ParentDAO parentDao;
    
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
    }
    
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String phone = req.getParameter("phone");
        
        if (parentDao.emailExists(email)) {
            req.setAttribute("error", "Email already registered");
            req.getRequestDispatcher("/auth/register.jsp").forward(req, resp);
            return;
        }
        
        Parents parent = new Parents();
        parent.setEmail(email);
        parent.setPasswordHash(password);
        parent.setFullName(fullName);
        parent.setPhone(phone);
        
        parentDao.create(parent);
        
        resp.sendRedirect(req.getContextPath() + "/login?registered=true");
    }
}