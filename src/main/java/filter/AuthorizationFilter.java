package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebFilter(urlPatterns = {"/admin/*", "/user/*"})
public class AuthorizationFilter implements Filter {
    
    private static final Logger LOGGER = Logger.getLogger(AuthorizationFilter.class.getName());

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        String uri = req.getRequestURI();
        String contextPath = req.getContextPath();
        String userRole = null;
        String userEmail = null;
        
        // Get user information from session
        if (session != null) {
            userRole = (String) session.getAttribute("userRole");
            userEmail = (String) session.getAttribute("parentEmail");
        }
        
        LOGGER.info("Authorization check - URI: " + uri + ", Role: " + userRole + ", User: " + userEmail);
        
        // Check admin access - only ADMIN role allowed
        if (uri.startsWith(contextPath + "/admin/")) {
            if (!"ADMIN".equals(userRole)) {
                LOGGER.warning("Unauthorized admin access attempt - URI: " + uri + ", Role: " + userRole + ", User: " + userEmail);
                
                if (userRole == null) {
                    // Not logged in - redirect to login
                    resp.sendRedirect(contextPath + "/login?error=login_required");
                } else {
                    // Logged in but not admin - show access denied
                    resp.sendRedirect(contextPath + "/access-denied.jsp?reason=insufficient_privileges");
                }
                return;
            }
            LOGGER.info("Admin access granted to user: " + userEmail);
        }
        
        // Check user access - any authenticated user allowed
        if (uri.startsWith(contextPath + "/user/")) {
            if (userRole == null) {
                LOGGER.warning("Unauthenticated user access attempt - URI: " + uri);
                resp.sendRedirect(contextPath + "/login?error=login_required");
                return;
            }
            LOGGER.info("User access granted to user: " + userEmail + " with role: " + userRole);
        }
        
        // Continue with the request
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        LOGGER.info("AuthorizationFilter initialized");
    }
    
    @Override
    public void destroy() {
        LOGGER.info("AuthorizationFilter destroyed");
    }
}