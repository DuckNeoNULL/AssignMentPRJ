<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Access Denied - Kid Social</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
</head>
<body class="bg-light">
    <div class="container">
        <div class="row justify-content-center align-items-center min-vh-100">
            <div class="col-md-6">
                <div class="card shadow">
                    <div class="card-body text-center p-5">
                        <i class="bi bi-shield-exclamation text-danger" style="font-size: 4rem;"></i>
                        <h1 class="mt-3 text-danger">Access Denied</h1>
                        
                        <c:choose>
                            <c:when test="${param.reason == 'insufficient_privileges'}">
                                <p class="text-muted mt-3">
                                    You don't have sufficient privileges to access this page. 
                                    Administrator access is required.
                                </p>
                            </c:when>
                            <c:when test="${param.reason == 'session_expired'}">
                                <p class="text-muted mt-3">
                                    Your session has expired. Please log in again.
                                </p>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted mt-3">
                                    You don't have permission to access this page.
                                </p>
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="mt-4">
                            <c:choose>
                                <c:when test="${sessionScope.userRole != null}">
                                    <!-- User is logged in but lacks privileges -->
                                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-primary me-2">
                                        <i class="bi bi-house"></i> Go to Dashboard
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <!-- User is not logged in -->
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-primary me-2">
                                        <i class="bi bi-box-arrow-in-right"></i> Login
                                    </a>
                                </c:otherwise>
                            </c:choose>
                            <a href="javascript:history.back()" class="btn btn-secondary">
                                <i class="bi bi-arrow-left"></i> Go Back
                            </a>
                        </div>
                        
                        <c:if test="${sessionScope.userRole != null}">
                            <div class="mt-3">
                                <small class="text-muted">
                                    Logged in as: ${sessionScope.parentEmail} (${sessionScope.userRole})
                                </small>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>