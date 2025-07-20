<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Error - KidSocial</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="card">
                    <div class="card-body text-center">
                        <i class="bi bi-exclamation-triangle text-danger" style="font-size: 3rem;"></i>
                        <h3 class="mt-3">Admin Dashboard Error</h3>
                        <p class="text-muted">
                            <c:choose>
                                <c:when test="${not empty errorMessage}">
                                    ${errorMessage}
                                </c:when>
                                <c:otherwise>
                                    An unexpected error occurred while loading the admin dashboard.
                                </c:otherwise>
                            </c:choose>
                        </p>
                        <div class="mt-4">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">
                                <i class="bi bi-arrow-left"></i> Back to Dashboard
                            </a>
                            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-secondary">
                                <i class="bi bi-box-arrow-right"></i> Logout
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
