package filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.logging.Logger;

@WebFilter(urlPatterns = {"/admin/*", "/user/*", "/quiz/*"})
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
        
        // Centralized handler for unauthorized AJAX requests
        Runnable handleUnauthorizedAjax = () -> {
            try {
                LOGGER.warning("Unauthorized AJAX access attempt - URI: " + uri);
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{\"error\":\"Authentication required. Please log in to continue.\"}");
            } catch (IOException e) {
                e.printStackTrace();
            }
        };

        // Check admin access
        if (uri.startsWith(contextPath + "/admin/")) {
            if (!"ADMIN".equals(userRole)) {
                LOGGER.warning("Unauthorized admin access attempt - URI: " + uri + ", Role: " + userRole + ", User: " + userEmail);
                resp.sendRedirect(contextPath + "/access-denied.jsp?reason=insufficient_privileges");
                return;
            }
        }
        
        // Check authenticated access for /user/ and /quiz/ paths
        if (uri.startsWith(contextPath + "/user/") || uri.startsWith(contextPath + "/quiz/")) {
            if (userRole == null) {
                // If it's our quiz API, handle it as an AJAX request, otherwise redirect
                if (uri.contains("/quiz")) {
                    handleUnauthorizedAjax.run();
                } else {
                    resp.sendRedirect(contextPath + "/auth/login.jsp?error=login_required");
                }
                return;
            }
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