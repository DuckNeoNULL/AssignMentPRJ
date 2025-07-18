<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Tài khoản - KidSocial</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f4ff; }
        .form-container {
            max-width: 700px;
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
        <h2 class="text-center mb-4">Quản lý Tài khoản</h2>

        <c:if test="${not empty success_message}">
            <div class="alert alert-success"><c:out value="${success_message}"/></div>
        </c:if>
        <c:if test="${not empty error_message}">
            <div class="alert alert-danger"><c:out value="${error_message}"/></div>
        </c:if>

        <!-- Update Profile Form -->
        <form id="update-profile-form" action="${pageContext.request.contextPath}/user/home" method="post" class="mb-5">
            <input type="hidden" name="action" value="update_profile">
            <h4>Thông tin cá nhân</h4>
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" class="form-control" id="email" value="${parent.email}" disabled readonly>
            </div>
            <div class="mb-3">
                <label for="fullName" class="form-label">Họ và Tên</label>
                <input type="text" class="form-control" id="fullName" name="fullName" value="${parent.fullName}" required>
            </div>
            <div class="mb-3">
                <label for="phone" class="form-label">Số điện thoại</label>
                <input type="tel" class="form-control" id="phone" name="phone" value="${parent.phone}">
            </div>
            <button type="submit" class="btn btn-primary">Cập nhật thông tin</button>
        </form>

        <hr>

        <!-- Change Password Form -->
        <form id="change-password-form" action="${pageContext.request.contextPath}/user/home" method="post" class="mt-5">
            <input type="hidden" name="action" value="change_password">
            <h4>Đổi mật khẩu</h4>
            <div class="mb-3">
                <label for="currentPassword" class="form-label">Mật khẩu hiện tại</label>
                <input type="password" class="form-control" id="currentPassword" name="currentPassword" required>
            </div>
            <div class="mb-3">
                <label for="newPassword" class="form-label">Mật khẩu mới</label>
                <input type="password" class="form-control" id="newPassword" name="newPassword" required>
            </div>
            <div class="mb-3">
                <label for="confirmNewPassword" class="form-label">Xác nhận mật khẩu mới</label>
                <input type="password" class="form-control" id="confirmNewPassword" name="confirmNewPassword" required>
            </div>
            <button type="submit" class="btn btn-primary">Đổi mật khẩu</button>
        </form>
        
        <div class="text-center mt-4">
            <a href="${pageContext.request.contextPath}/user/home" class="btn btn-secondary">Quay lại</a>
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const action = localStorage.getItem('accountAction');
            if (action) {
                let targetForm;
                if (action === 'update_info') {
                    targetForm = document.getElementById('update-profile-form');
                } else if (action === 'change_password') {
                    targetForm = document.getElementById('change-password-form');
                }

                if (targetForm) {
                    targetForm.scrollIntoView({ behavior: 'smooth', block: 'center' });
                    targetForm.style.transition = 'background-color 0.5s ease';
                    targetForm.style.backgroundColor = '#e7f3ff'; // A light blue highlight
                    setTimeout(() => {
                        targetForm.style.backgroundColor = '';
                    }, 2000); // Highlight for 2 seconds
                }

                localStorage.removeItem('accountAction');
            }
        });
    </script>
</body>
</html> 