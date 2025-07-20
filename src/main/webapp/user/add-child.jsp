<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Hồ sơ Bé - KidSocial</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f4ff; }
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 40px;
            background-color: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h2 class="text-center mb-4">Tạo Hồ sơ cho Bé</h2>
        <p class="text-center text-muted mb-4">Thêm thông tin của bé để bắt đầu hành trình vui học!</p>

        <c:if test="${not empty error}">
            <div class="alert alert-danger"><c:out value="${error}"/></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/home" method="post">
            <input type="hidden" name="action" value="save_child">
            <div class="mb-3">
                <label for="fullName" class="form-label">Họ và Tên của Bé</label>
                <input type="text" class="form-control" id="fullName" name="fullName" required>
            </div>
            <div class="mb-3">
                <label for="dateOfBirth" class="form-label">Ngày sinh</label>
                <input type="date" class="form-control" id="dateOfBirth" name="dateOfBirth" required>
            </div>
            <div class="mb-3">
                <label class="form-label">Giới tính</label>
                <div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="gender" id="male" value="MALE" checked>
                        <label class="form-check-label" for="male">Bé trai</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="gender" id="female" value="FEMALE">
                        <label class="form-check-label" for="female">Bé gái</label>
                    </div>
                     <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="gender" id="other" value="OTHER">
                        <label class="form-check-label" for="other">Khác</label>
                    </div>
                </div>
            </div>
            <div class="d-grid gap-2 mt-4">
                 <button type="submit" class="btn btn-primary">Lưu Hồ sơ</button>
                 <a href="${pageContext.request.contextPath}/user/home" class="btn btn-secondary">Quay lại</a>
            </div>
        </form>
    </div>
</body>
</html> 