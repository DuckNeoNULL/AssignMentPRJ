<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực Tài khoản - Kid Social</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <style>
        body {
            background-color: #f0f8ff;
        }
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .auth-card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 450px;
            padding: 40px;
        }
        .auth-header {
            text-align: center;
            margin-bottom: 30px;
        }
        .otp-inputs {
            display: flex;
            justify-content: center;
            gap: 10px;
            margin-bottom: 20px;
        }
        .otp-input {
            width: 50px;
            height: 60px;
            text-align: center;
            font-size: 1.5rem;
            font-weight: 600;
            border: 1px solid #ced4da;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h2>Xác thực tài khoản của bạn</h2>
                <p class="text-muted">
                    Một mã OTP đã được gửi đến <strong><c:out value="${param.email}"/></strong>.
                    Vui lòng nhập mã để tiếp tục.
                </p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <i class="bi bi-x-circle-fill"></i> <c:out value="${error}"/>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/verify-otp" method="post">
                <input type="hidden" name="email" value="<c:out value="${param.email}"/>">
                <div class="form-group mb-4">
                    <label for="otp" class="form-label">Nhập mã OTP</label>
                    <input type="text" id="otp" name="otp" class="form-control form-control-lg text-center" 
                           placeholder="_ _ _ _ _ _" maxlength="6" required>
                </div>
                
                <button type="submit" class="btn btn-primary w-100">Xác thực</button>
            </form>

            <div class="text-center mt-3">
                <a href="#">Gửi lại mã</a>
            </div>
        </div>
    </div>
</body>
</html> 