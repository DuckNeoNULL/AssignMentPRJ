<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Session validation --%>
<c:if test="${sessionScope.userRole != 'ADMIN'}">
    <c:redirect url="${pageContext.request.contextPath}/login?error=access_denied"/>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/admin/css/admin-dashboard.css" rel="stylesheet">
</head>
<body>
    <div class="admin-layout">
        <!-- Include Sidebar -->
        <%@ include file="includes/sidebar.jsp" %>
        
        <!-- Main Content -->
        <div class="main-content">
            <!-- Include Header -->
            <%@ include file="includes/header.jsp" %>
            
            <!-- Settings Content -->
            <div class="content-wrapper">
                <div class="page-header">
                    <h1 class="page-title">System Settings</h1>
                    <div class="page-actions">
                        <button class="btn btn-success" onclick="saveAllSettings()">
                            <i class="bi bi-check-circle"></i> Save All Changes
                        </button>
                        <button class="btn btn-outline-secondary" onclick="resetSettings()">
                            <i class="bi bi-arrow-clockwise"></i> Reset
                        </button>
                    </div>
                </div>
                
                <!-- Include Settings Section -->
                <%@ include file="sections/settings-section.jsp" %>
            </div>
        </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/admin/js/settings-management.js"></script>
</body>
</html>