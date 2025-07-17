<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký - Kid Social</title>
    
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

        .form-control.is-invalid {
            border-color: var(--error-color);
            box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
        }

        .form-control.is-valid {
            border-color: var(--success-color);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
        }

        .invalid-feedback {
            display: block;
            color: var(--error-color);
            font-size: 0.75rem;
            margin-top: calc(var(--spacing-unit) / 4);
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

        .login-link {
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
            <!-- Header -->
            <div class="auth-header">
                <h1 class="auth-title">Tạo tài khoản mới</h1>
                <p class="auth-subtitle">Tham gia cộng đồng Kid Social an toàn và vui nhộn!</p>
            </div>

            <!-- Success Message -->
            <c:if test="${not empty message}">
                <div class="alert alert-success" role="alert">
                    <i class="bi bi-check-circle-fill alert-icon" aria-hidden="true"></i>
                    <span>${message}</span>
                </div>
            </c:if>

            <!-- Error Message -->
            <c:if test="${not empty error}">
                <div class="alert alert-error" role="alert">
                    <i class="bi bi-exclamation-triangle-fill alert-icon" aria-hidden="true"></i>
                    <span>${error}</span>
                </div>
            </c:if>

            <!-- Registration Form -->
            <form action="${pageContext.request.contextPath}/register" method="post" novalidate id="registerForm">
                <div class="form-group">
                    <label for="fullName" class="form-label">Họ và Tên</label>
                    <input 
                        type="text" 
                        id="fullName" 
                        name="fullName" 
                        class="form-control" 
                        placeholder="Nhập họ và tên của bạn"
                        required 
                        autocomplete="name"
                        aria-describedby="fullName-error"
                    >
                    <div class="invalid-feedback" id="fullName-error"></div>
                </div>

                <div class="form-group">
                    <label for="email" class="form-label">Địa chỉ Email</label>
                    <input 
                        type="email" 
                        id="email" 
                        name="email" 
                        class="form-control" 
                        placeholder="you@example.com"
                        required 
                        autocomplete="email"
                        aria-describedby="email-error"
                    >
                    <div class="invalid-feedback" id="email-error"></div>
                </div>

                <div class="form-group">
                    <label for="password" class="form-label">Mật khẩu</label>
                    <input 
                        type="password" 
                        id="password" 
                        name="password" 
                        class="form-control" 
                        placeholder="Tạo mật khẩu mạnh"
                        required 
                        autocomplete="new-password"
                        aria-describedby="password-error"
                        minlength="6"
                    >
                    <div class="invalid-feedback" id="password-error"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword" class="form-label">Xác nhận Mật khẩu</label>
                    <input 
                        type="password" 
                        id="confirmPassword" 
                        name="confirmPassword" 
                        class="form-control" 
                        placeholder="Nhập lại mật khẩu"
                        required 
                        autocomplete="new-password"
                        aria-describedby="confirmPassword-error"
                    >
                    <div class="invalid-feedback" id="confirmPassword-error"></div>
                </div>

                <div class="form-group">
                    <label for="phone" class="form-label">Số điện thoại <span class="text-muted">(Không bắt buộc)</span></label>
                    <input 
                        type="tel" 
                        id="phone" 
                        name="phone" 
                        class="form-control" 
                        placeholder="Nhập số điện thoại của bạn"
                        autocomplete="tel"
                        aria-describedby="phone-error"
                    >
                    <div class="invalid-feedback" id="phone-error"></div>
                </div>

                <button type="submit" class="btn-primary" id="registerBtn">
                    Tạo tài khoản
                </button>
            </form>

            <!-- Login Link -->
            <div class="login-link">
                Đã có tài khoản? 
                <a href="${pageContext.request.contextPath}/auth/login.jsp" class="auth-link">Đăng nhập ngay</a>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Form validation and submission
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const form = this;
            const submitBtn = document.getElementById('registerBtn');
            let isValid = true;

            // Clear previous validation states
            form.querySelectorAll('.form-control').forEach(input => {
                input.classList.remove('is-invalid', 'is-valid');
                const feedback = document.getElementById(input.name + '-error');
                if (feedback) feedback.textContent = '';
            });

            // Validate full name
            const fullName = form.fullName.value.trim();
            if (!fullName) {
                showError('fullName', 'Họ và tên là bắt buộc');
                isValid = false;
            } else if (fullName.length < 2) {
                showError('fullName', 'Họ và tên phải có ít nhất 2 ký tự');
                isValid = false;
            } else {
                showValid('fullName');
            }

            // Validate email
            const email = form.email.value.trim();
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!email) {
                showError('email', 'Địa chỉ email là bắt buộc');
                isValid = false;
            } else if (!emailRegex.test(email)) {
                showError('email', 'Vui lòng nhập địa chỉ email hợp lệ');
                isValid = false;
            } else {
                showValid('email');
            }

            // Validate password
            const password = form.password.value;
            if (!password) {
                showError('password', 'Mật khẩu là bắt buộc');
                isValid = false;
            } else if (password.length < 6) {
                showError('password', 'Mật khẩu phải có ít nhất 6 ký tự');
                isValid = false;
            } else {
                showValid('password');
            }

            // Validate confirm password
            const confirmPassword = form.confirmPassword.value;
            if (!confirmPassword) {
                showError('confirmPassword', 'Vui lòng xác nhận mật khẩu');
                isValid = false;
            } else if (password !== confirmPassword) {
                showError('confirmPassword', 'Mật khẩu không khớp');
                isValid = false;
            } else {
                showValid('confirmPassword');
            }

            // Validate phone (optional)
            const phone = form.phone.value.trim();
            if (phone) {
                const phoneRegex = /^[\+]?[1-9][\d]{0,15}$/;
                if (!phoneRegex.test(phone.replace(/[\s\-\(\)]/g, ''))) {
                    showError('phone', 'Vui lòng nhập số điện thoại hợp lệ');
                    isValid = false;
                } else {
                    showValid('phone');
                }
            }

            if (isValid) {
                // Show loading state
                submitBtn.classList.add('btn-loading');
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span> Đang tạo...';
                
                // Submit form
                form.submit();
            }
        });

        function showError(fieldName, message) {
            const input = document.getElementById(fieldName);
            const feedback = document.getElementById(fieldName + '-error');
            input.classList.add('is-invalid');
            if (feedback) feedback.textContent = message;
        }

        function showValid(fieldName) {
            const input = document.getElementById(fieldName);
            input.classList.add('is-valid');
        }

        // Real-time password confirmation validation
        document.getElementById('confirmPassword').addEventListener('input', function() {
            const password = document.getElementById('password').value;
            const confirmPassword = this.value;
            
            if (confirmPassword && password !== confirmPassword) {
                this.classList.add('is-invalid');
                this.classList.remove('is-valid');
                document.getElementById('confirmPassword-error').textContent = 'Mật khẩu không khớp';
            } else if (confirmPassword && password === confirmPassword) {
                this.classList.add('is-valid');
                this.classList.remove('is-invalid');
                document.getElementById('confirmPassword-error').textContent = '';
            }
        });
    </script>
</body>
</html>
