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
    <title>Content Management - Admin Dashboard</title>
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
            
            <!-- Posts Content -->
            <div class="content-wrapper">
                <div class="page-header">
                    <h1 class="page-title">Content Management</h1>
                    <div class="page-actions">
                        <button class="btn btn-warning" onclick="reviewPendingPosts()">
                            <i class="bi bi-clock"></i> Review Pending (${postsOverview.pendingPosts})
                        </button>
                        <button class="btn btn-outline-primary" onclick="exportPosts()">
                            <i class="bi bi-download"></i> Export
                        </button>
                    </div>
                </div>
                
                <!-- Include Posts Section -->
                <%@ include file="sections/posts-section.jsp" %>
            </div>
        </div>
    </div>
    
    <!-- Include Modals -->
    <%@ include file="modals/post-modals.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/admin/js/posts-management.js"></script>
</body>
</html>