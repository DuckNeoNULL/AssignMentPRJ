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
    <title>Reports Management - Admin Dashboard</title>
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
            
            <!-- Reports Content -->
            <div class="content-wrapper">
                <div class="page-header">
                    <h1 class="page-title">Reports Management</h1>
                    <div class="page-actions">
                        <button class="btn btn-danger" onclick="handleActiveReports()">
                            <i class="bi bi-flag"></i> Handle Active (${reportsOverview.activeReports})
                        </button>
                        <button class="btn btn-outline-primary" onclick="exportReports()">
                            <i class="bi bi-download"></i> Export
                        </button>
                    </div>
                </div>
                
                <!-- Include Reports Section -->
                <%@ include file="sections/reports-section.jsp" %>
            </div>
        </div>
    </div>
    
    <!-- Include Modals -->
    <%@ include file="modals/report-modals.jsp" %>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="${pageContext.request.contextPath}/admin/js/reports-management.js"></script>
</body>
</html>