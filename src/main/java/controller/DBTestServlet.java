package controller;

import dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

@WebServlet("/admin/db-test")
public class DBTestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String status;
        String details = "";
        
        try (Connection conn = DBConnection.getConnection()) {
            if (conn != null && !conn.isClosed()) {
                status = "SUCCESS";
                DatabaseMetaData meta = conn.getMetaData();
                details += "Database: " + meta.getDatabaseProductName() + " " + meta.getDatabaseProductVersion() + "<br>";
                details += "URL: " + meta.getURL() + "<br>";
                details += "User: " + meta.getUserName();
            } else {
                status = "FAILURE";
                details = "Connection object is null or closed. Check server logs for initial driver loading issues.";
            }
        } catch (SQLException e) {
            status = "FAILURE";
            details = "SQLException caught: " + e.getMessage();
            e.printStackTrace();
        }
        
        request.setAttribute("status", status);
        request.setAttribute("details", details);
        
        request.getRequestDispatcher("/admin/db-test.jsp").forward(request, response);
    }
} 