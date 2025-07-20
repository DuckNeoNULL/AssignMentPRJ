<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo bài viết mới - Kid Social</title>
    <!-- Google Fonts: Space Grotesk & Orbitron for Space Theme -->
    <link href="https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;700&family=Orbitron:wght@700&display=swap" rel="stylesheet">
    <!-- Custom Space Theme CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/kid/css/style.css">
    <style>
        body {
            background: radial-gradient(ellipse at 70% 20%, #1a237e 0%, #0a1633 100%);
            min-height: 100vh;
            font-family: 'Baloo 2', cursive;
            color: #fff;
            position: relative;
        }
        body::before {
            content: '';
            position: fixed;
            z-index: 0;
            top: 0; left: 0; right: 0; bottom: 0;
            pointer-events: none;
            background: url('data:image/svg+xml;utf8,<svg width="100%25" height="100%25" xmlns="http://www.w3.org/2000/svg"><circle cx="10" cy="20" r="1.5" fill="%23fffbe7" opacity="0.7"/><circle cx="80" cy="120" r="1" fill="%23fffbe7" opacity="0.5"/><circle cx="200" cy="60" r="2" fill="%23ffe156" opacity="0.7"/><circle cx="300" cy="200" r="1.2" fill="%23fffbe7" opacity="0.6"/><circle cx="500" cy="100" r="1.5" fill="%23fffbe7" opacity="0.7"/><circle cx="700" cy="300" r="1.2" fill="%23fffbe7" opacity="0.5"/><circle cx="900" cy="80" r="1.5" fill="%23fffbe7" opacity="0.7"/></svg>');
            background-repeat: repeat;
            background-size: 400px 400px;
            animation: stars-move 60s linear infinite;
        }
        @keyframes stars-move {
            0% { background-position: 0 0; }
            100% { background-position: 400px 400px; }
        }
        .back-button {
            position: fixed;
            top: 20px;
            left: 20px;
            background: linear-gradient(135deg, #3cf2ff, #a259ff);
            border: 2.5px solid #3cf2ff;
            border-radius: 50%;
            width: 56px;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.5rem;
            color: #ffe156;
            box-shadow: 0 0 18px 0 #3cf2ff99;
            transition: transform 0.2s, box-shadow 0.2s;
            z-index: 1000;
            text-decoration: none;
        }
        .back-button:hover {
            transform: scale(1.12) rotate(-6deg);
            box-shadow: 0 0 32px 8px #3cf2ff;
            color: #fff;
        }
        .back-button svg { width: 32px; height: 32px; }
        .create-post-container {
            max-width: 800px;
            margin: 2rem auto;
            padding: 2.5rem 2rem;
            background: rgba(30,33,93,0.85);
            border-radius: 36px;
            box-shadow: 0 0 32px 0 #3cf2ff99;
            border: 3px solid #3cf2ff;
            position: relative;
            z-index: 1;
        }
        .page-header {
            text-align: center;
            margin-bottom: 2rem;
        }
        .page-header h1 {
            color: #ffe156;
            font-weight: 800;
            font-size: 2.2rem;
            background: linear-gradient(90deg, #ffe156, #3cf2ff, #a259ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: 2px;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }
        .page-header svg { width: 36px; height: 36px; }
        .page-header p {
            color: #b3c6ff;
            font-size: 1.1rem;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .form-label {
            font-weight: 700;
            color: #3cf2ff;
            margin-bottom: 0.5rem;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .form-label svg { width: 22px; height: 22px; }
        .form-control, .form-select {
            border-radius: 18px;
            border: 2px solid #a259ff;
            padding: 0.85rem 1.2rem;
            background: rgba(255,255,255,0.08);
            color: #fff;
            font-size: 1.1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus, .form-select:focus {
            border-color: #3cf2ff;
            box-shadow: 0 0 0 3px #3cf2ff44;
            outline: none;
        }
        .btn-primary {
            background: linear-gradient(135deg, #3cf2ff 0%, #a259ff 100%);
            border: none;
            border-radius: 50px;
            padding: 0.85rem 2.5rem;
            font-weight: 800;
            font-size: 1.1rem;
            color: #fff;
            box-shadow: 0 0 18px 0 #3cf2ff99;
            transition: transform 0.2s, box-shadow 0.2s;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .btn-primary:hover {
            transform: scale(1.08);
            box-shadow: 0 0 32px 8px #3cf2ff;
            background: linear-gradient(135deg, #a259ff 0%, #3cf2ff 100%);
        }
        .btn-secondary {
            background: #6b7280;
            border: none;
            border-radius: 50px;
            padding: 0.75rem 2rem;
            font-weight: 700;
            color: #fff;
        }
        .file-upload {
            border: 2.5px dashed #a259ff;
            border-radius: 18px;
            padding: 2rem;
            text-align: center;
            background: rgba(255,255,255,0.05);
            transition: border-color 0.2s, background 0.2s;
        }
        .file-upload:hover {
            border-color: #3cf2ff;
            background: rgba(60,242,255,0.08);
        }
        .file-upload input[type="file"] {
            display: none;
        }
        .file-upload-label {
            cursor: pointer;
            color: #b3c6ff;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
        }
        .file-upload-label:hover {
            color: #3cf2ff;
        }
        .file-upload-label svg { width: 32px; height: 32px; }
        .preview-image {
            max-width: 200px;
            max-height: 200px;
            border-radius: 12px;
            margin-top: 1rem;
            border: 2px solid #3cf2ff;
            box-shadow: 0 0 12px 0 #3cf2ff99;
        }
        .alert {
            border-radius: 18px;
            border: none;
            padding: 15px 20px;
            margin-bottom: 20px;
            font-size: 1.1rem;
        }
        .alert-success {
            background: #d4edda;
            color: #28a745;
        }
        .alert-danger {
            background: #f8d7da;
            color: #dc3545;
        }
        @media (max-width: 700px) {
            .create-post-container { padding: 1.2rem 0.5rem; }
        }
    </style>
</head>
<body>
    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/kid/home.jsp" class="back-button" title="Quay lại trang chủ">
        <!-- SVG: Mũi tên tàu vũ trụ -->
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="15" stroke="#3cf2ff" stroke-width="2" fill="none"/><path d="M20 16H12M16 12l-4 4 4 4" stroke="#ffe156" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </a>
    <div class="create-post-container">
        <div class="page-header">
            <h1>
                <!-- SVG: Sổ tay bay giữa các vì sao -->
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none"><rect x="8" y="10" width="28" height="28" rx="6" fill="#ffe156" stroke="#a259ff" stroke-width="2"/><path d="M12 14l20 20" stroke="#3cf2ff" stroke-width="2"/><circle cx="36" cy="12" r="4" fill="#3cf2ff" opacity="0.7"/></svg>
                Tạo bài viết mới
            </h1>
            <p class="text-muted">Chia sẻ những câu chuyện và suy nghĩ của bạn với bạn bè</p>
        </div>
        <!-- Thông báo -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <!-- SVG: Check -->
                <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><circle cx="11" cy="11" r="10" stroke="#28a745" stroke-width="2" fill="none"/><path d="M7 12l3 3 5-5" stroke="#28a745" stroke-width="2" stroke-linecap="round"/></svg>
                ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <!-- SVG: Warning -->
                <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><circle cx="11" cy="11" r="10" stroke="#dc3545" stroke-width="2" fill="none"/><path d="M11 7v5" stroke="#dc3545" stroke-width="2" stroke-linecap="round"/><circle cx="11" cy="15" r="1" fill="#dc3545"/></svg>
                ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>
        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <!-- SVG: Warning -->
                <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><circle cx="11" cy="11" r="10" stroke="#dc3545" stroke-width="2" fill="none"/><path d="M11 7v5" stroke="#dc3545" stroke-width="2" stroke-linecap="round"/><circle cx="11" cy="15" r="1" fill="#dc3545"/></svg>
                ${requestScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/kid/create-post">
            <div class="form-group">
                <label for="title" class="form-label">
                    <!-- SVG: Tiêu đề -->
                    <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><rect x="3" y="5" width="16" height="12" rx="3" fill="#3cf2ff"/><path d="M6 9h10" stroke="#ffe156" stroke-width="2"/><path d="M6 13h7" stroke="#ffe156" stroke-width="2"/></svg>
                    Tiêu đề bài viết
                </label>
                <input type="text" class="form-control" id="title" name="title" 
                       placeholder="Nhập tiêu đề bài viết..." required>
            </div>
            <div class="form-group">
                <label for="content" class="form-label">
                    <!-- SVG: Nội dung -->
                    <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><rect x="3" y="5" width="16" height="12" rx="3" fill="#a259ff"/><path d="M6 9h10" stroke="#ffe156" stroke-width="2"/><path d="M6 13h7" stroke="#ffe156" stroke-width="2"/></svg>
                    Nội dung
                </label>
                <textarea class="form-control" id="content" name="content" rows="6" 
                          placeholder="Viết nội dung bài viết của bạn..." required></textarea>
            </div>
            <div class="form-group">
                <label class="form-label">
                    <!-- SVG: Hình ảnh -->
                    <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><rect x="3" y="5" width="16" height="12" rx="3" fill="#ffe156"/><circle cx="8" cy="11" r="2" fill="#3cf2ff"/><path d="M5 15l4-4 4 4 4-6" stroke="#a259ff" stroke-width="2"/></svg>
                    Hình ảnh (tùy chọn)
                </label>
                <div class="file-upload">
                    <input type="file" id="image" name="image" accept="image/*" onchange="previewImage(this)">
                    <label for="image" class="file-upload-label">
                        <!-- SVG: Cloud upload -->
                        <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><ellipse cx="16" cy="24" rx="10" ry="4" fill="#3cf2ff" opacity="0.3"/><path d="M16 8v10" stroke="#a259ff" stroke-width="2" stroke-linecap="round"/><path d="M12 14l4-4 4 4" stroke="#ffe156" stroke-width="2" stroke-linecap="round"/><rect x="6" y="18" width="20" height="6" rx="3" fill="#ffe156"/></svg>
                        <div class="mt-2">
                            <strong>Chọn hình ảnh</strong>
                            <div class="text-muted">hoặc kéo thả file vào đây</div>
                        </div>
                    </label>
                    <img id="preview" class="preview-image" style="display: none;">
                </div>
            </div>
            <div class="d-flex gap-3 justify-content-end">
                <button type="submit" class="btn-primary">
                    <!-- SVG: Gửi -->
                    <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><polygon points="3,19 19,11 3,3 7,11" fill="#3cf2ff" stroke="#a259ff" stroke-width="1.5"/></svg>
                    Gửi bài viết
                </button>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function previewImage(input) {
            const preview = document.getElementById('preview');
            const file = input.files[0];
            if (file) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = 'block';
                }
                reader.readAsDataURL(file);
            } else {
                preview.style.display = 'none';
            }
        }
        // Drag and drop functionality
        const fileUpload = document.querySelector('.file-upload');
        const fileInput = document.getElementById('image');
        fileUpload.addEventListener('dragover', (e) => {
            e.preventDefault();
            fileUpload.style.borderColor = '#3cf2ff';
            fileUpload.style.backgroundColor = 'rgba(60,242,255,0.08)';
        });
        fileUpload.addEventListener('dragleave', (e) => {
            e.preventDefault();
            fileUpload.style.borderColor = '#a259ff';
            fileUpload.style.backgroundColor = 'rgba(255,255,255,0.05)';
        });
        fileUpload.addEventListener('drop', (e) => {
            e.preventDefault();
            fileUpload.style.borderColor = '#a259ff';
            fileUpload.style.backgroundColor = 'rgba(255,255,255,0.05)';
            const files = e.dataTransfer.files;
            if (files.length > 0) {
                fileInput.files = files;
                previewImage(fileInput);
            }
        });
    </script>
</body>
</html> 