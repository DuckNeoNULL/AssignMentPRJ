<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - Kid Social</title>
    
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary-color: #3b82f6;
            --primary-hover: #2563eb;
            --success-color: #10b981;
            --error-color: #ef4444;
            --text-primary: #1f2937;
            --text-secondary: #6b7280;
            --border-color: #e5e7eb;
            --bg-light: #f9fafb;
            --shadow-sm: 0 1px 2px 0 rgba(0, 0, 0, 0.05);
            --shadow-md: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --shadow-lg: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
            --border-radius: 8px;
            --spacing-unit: 16px;
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', 'Poppins', 'Roboto', -apple-system, BlinkMacSystemFont, sans-serif;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            color: var(--text-primary);
            line-height: 1.6;
            background-image: url('${pageContext.request.contextPath}/assets/images/KidsSocialMedia-1-Share.png.webp');
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            background-attachment: fixed;
        }

        /* Background overlay */
        body::before {
            content: '';
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.9);
            z-index: -1;
        }

        /* Auth Container */
        .auth-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: var(--spacing-unit);
        }

        .auth-card {
            background: white;
            border-radius: var(--border-radius);
            box-shadow: var(--shadow-lg);
            width: 100%;
            max-width: 400px;
            padding: calc(var(--spacing-unit) * 2);
            border: 1px solid var(--border-color);
        }

        /* Header */
        .auth-header {
            text-align: center;
            margin-bottom: calc(var(--spacing-unit) * 2);
        }

        .auth-title {
            font-size: 1.875rem;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: calc(var(--spacing-unit) / 2);
            letter-spacing: -0.025em;
        }

        .auth-subtitle {
            color: var(--text-secondary);
            font-size: 0.875rem;
            margin: 0;
        }

        /* Form Elements */
        .form-group {
            margin-bottom: calc(var(--spacing-unit) * 1.5);
        }

        .form-label {
            display: block;
            font-weight: 500;
            color: var(--text-primary);
            margin-bottom: calc(var(--spacing-unit) / 2);
            font-size: 0.875rem;
        }

        .form-control {
            width: 100%;
            padding: calc(var(--spacing-unit) * 0.75) var(--spacing-unit);
            border: 1px solid var(--border-color);
            border-radius: var(--border-radius);
            font-size: 1rem;
            transition: all 0.2s ease-in-out;
            background-color: white;
        }

        .form-control:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .form-control::placeholder {
            color: var(--text-secondary);
        }

        /* Buttons */
        .btn-primary {
            width: 100%;
            padding: calc(var(--spacing-unit) * 0.75) var(--spacing-unit);
            background-color: var(--primary-color);
            border: 1px solid var(--primary-color);
            border-radius: var(--border-radius);
            color: white;
            font-weight: 500;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s ease-in-out;
            position: relative;
            overflow: hidden;
        }

        .btn-primary:hover {
            background-color: var(--primary-hover);
            border-color: var(--primary-hover);
            transform: translateY(-1px);
            box-shadow: var(--shadow-md);
        }

        .btn-primary:active {
            transform: translateY(0);
        }

        .btn-primary:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none;
        }

        /* Loading state */
        .btn-loading::after {
            content: '';
            position: absolute;
            width: 16px;
            height: 16px;
            margin: auto;
            border: 2px solid transparent;
            border-top-color: #ffffff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* Links */
        .auth-link {
            color: var(--primary-color);
            text-decoration: none;
            font-weight: 500;
            transition: color 0.2s ease-in-out;
        }

        .auth-link:hover {
            color: var(--primary-hover);
            text-decoration: underline;
        }

        .forgot-password {
            text-align: right;
            margin-top: calc(var(--spacing-unit) / 2);
        }

        .forgot-password .auth-link {
            font-size: 0.875rem;
            font-weight: 400;
        }

        .register-link {
            text-align: center;
            margin-top: calc(var(--spacing-unit) * 1.5);
            padding-top: calc(var(--spacing-unit) * 1.5);
            border-top: 1px solid var(--border-color);
            color: var(--text-secondary);
            font-size: 0.875rem;
        }

        /* Alert Messages */
        .alert {
            padding: var(--spacing-unit);
            border-radius: var(--border-radius);
            margin-bottom: calc(var(--spacing-unit) * 1.5);
            border: 1px solid;
            font-size: 0.875rem;
            font-weight: 500;
        }

        .alert-success {
            background-color: #f0fdf4;
            border-color: #bbf7d0;
            color: #166534;
        }

        .alert-error {
            background-color: #fef2f2;
            border-color: #fecaca;
            color: #dc2626;
        }

        .alert-icon {
            margin-right: calc(var(--spacing-unit) / 2);
        }

        /* Responsive Design */
        @media (max-width: 576px) {
            .auth-container {
                padding: calc(var(--spacing-unit) / 2);
            }
            
            .auth-card {
                padding: calc(var(--spacing-unit) * 1.5);
            }
            
            .auth-title {
                font-size: 1.5rem;
            }
        }

        @media (min-width: 768px) {
            .auth-card {
                padding: calc(var(--spacing-unit) * 2.5);
            }
        }

        /* Accessibility */
        @media (prefers-reduced-motion: reduce) {
            * {
                animation-duration: 0.01ms !important;
                animation-iteration-count: 1 !important;
                transition-duration: 0.01ms !important;
            }
        }

        /* Focus visible for keyboard navigation */
        .form-control:focus-visible,
        .btn-primary:focus-visible,
        .auth-link:focus-visible {
            outline: 2px solid var(--primary-color);
            outline-offset: 2px;
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <h1 class="auth-title">Chào mừng trở lại!</h1>
                <p class="auth-subtitle">Đăng nhập để tiếp tục đến Kid Social.</p>
            </div>

            <%-- General error from servlet --%>
            <c:if test="${not empty error}">
                <div class="alert alert-error">
                    <i class="bi bi-x-circle-fill alert-icon"></i>
                    <c:out value="${error}"/>
                </div>
            </c:if>

            <%-- Success message from another page (e.g., registration) --%>
            <c:if test="${param.registered == 'true'}">
                 <div class="alert alert-success">
                     <i class="bi bi-check-circle-fill alert-icon"></i>
                     <span>Đăng ký thành công! Vui lòng đăng nhập.</span>
                </div>
            </c:if>
            <c:if test="${not empty param.success_message}">
                <div class="alert alert-success">
                    <i class="bi bi-check-circle-fill alert-icon"></i>
                    <c:out value="${param.success_message}"/>
                </div>
            </c:if>

            <form id="login-form" action="${pageContext.request.contextPath}/login" method="post">
                <div class="form-group">
                    <label for="email" class="form-label">Địa chỉ Email</label>
                    <input type="email" id="email" name="email" class="form-control" placeholder="you@example.com" required autofocus>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <input type="password" id="password" name="password" class="form-control" placeholder="Nhập mật khẩu của bạn" required>
                    <div class="forgot-password">
                        <a href="${pageContext.request.contextPath}/auth/forgot-password.jsp" class="auth-link">Quên mật khẩu?</a>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">Đăng nhập</button>
            </form>

            <div class="register-link">
                Chưa có tài khoản? <a href="${pageContext.request.contextPath}/auth/register.jsp" class="auth-link">Đăng ký ngay</a>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Simple form submission without loading state complications
        document.querySelector('form').addEventListener('submit', function(e) {
            console.log('Form submitted');
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            console.log('Email:', email, 'Password:', password);
        });
    </script>
</body>
</html>
