package util;

public class RoleValidator {
    public static final String ROLE_USER = "USER";
    public static final String ROLE_ADMIN = "ADMIN";
    
    public static boolean isValidRole(String role) {
        return role != null && (ROLE_USER.equals(role) || ROLE_ADMIN.equals(role));
    }
    
    public static String getDefaultRole() {
        return ROLE_USER;
    }
    
    public static String validateAndNormalizeRole(String role) {
        if (role == null || role.trim().isEmpty()) {
            return ROLE_USER;
        }
        
        String normalizedRole = role.trim().toUpperCase();
        return isValidRole(normalizedRole) ? normalizedRole : ROLE_USER;
    }
}