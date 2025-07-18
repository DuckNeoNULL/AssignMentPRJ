<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kiểm tra Kết nối Cơ sở dữ liệu</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .status-success { color: #198754; }
        .status-failure { color: #dc3545; }
    </style>
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Trạng thái Kết nối CSDL</h1>
        <div class="card">
            <div class="card-header">
                <h3>
                    Kết quả: 
                    <c:choose>
                        <c:when test="${status == 'SUCCESS'}">
                            <span class="status-success">THÀNH CÔNG</span>
                        </c:when>
                        <c:otherwise>
                            <span class="status-failure">THẤT BẠI</span>
                        </c:otherwise>
                    </c:choose>
                </h3>
            </div>
            <div class="card-body">
                <h5 class="card-title">Chi tiết:</h5>
                <p class="card-text">${details}</p>
            </div>
        </div>
    </div>
</body>
</html> 