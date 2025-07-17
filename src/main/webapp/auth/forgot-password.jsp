<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên Mật khẩu - Kid Social</title>
    
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

        .back-to-login {
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
                padding: var(--spacing-unit);
            }
            
            .auth-title {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>
    <div class="auth-container">
        <div class="auth-card">
            <!-- Header -->
            <div class="auth-header">
                <h1 class="auth-title">Quên Mật khẩu?</h1>
                <p class="auth-subtitle">Đừng lo lắng! Nhập email của bạn và chúng tôi sẽ gửi cho bạn một liên kết để đặt lại mật khẩu.</p>
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

            <!-- Forgot Password Form -->
            <form action="${pageContext.request.contextPath}/forgot-password" method="post" novalidate>
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
                    >
                </div>

                <button type="submit" class="btn-primary" id="forgotPasswordBtn">
                    Gửi liên kết đặt lại
                </button>
            </form>

            <!-- Back to Login Link -->
            <div class="back-to-login">
                Nhớ mật khẩu của bạn? 
                <a href="${pageContext.request.contextPath}/auth/login.jsp" class="auth-link">Quay lại đăng nhập</a>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Form submission with loading state
        document.getElementById('forgotPasswordBtn').addEventListener('click', function(e) {
            const form = this.closest('form');
            const email = form.querySelector('#email').value.trim();
            
            if (email) {
                this.classList.add('btn-loading');
                this.disabled = true;
                this.textContent = 'Sending...';
            }
        });

        // Remove loading state if form validation fails
        document.querySelector('form').addEventListener('invalid', function() {
            const btn = document.getElementById('forgotPasswordBtn');
            btn.classList.remove('btn-loading');
            btn.disabled = false;
            btn.textContent = 'Send Reset Instructions';
        }, true);
    </script>
</body>
</html>