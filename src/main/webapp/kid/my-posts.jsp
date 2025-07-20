<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bài viết của tôi - Kid Social</title>
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
        .posts-container {
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
        .post-card {
            background: rgba(60,242,255,0.1);
            border: 2px solid #a259ff;
            border-radius: 24px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .post-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(60,242,255,0.1), transparent);
            transition: left 0.5s;
        }
        .post-card:hover::before {
            left: 100%;
        }
        .post-card:hover {
            border-color: #3cf2ff;
            box-shadow: 0 0 24px 0 #3cf2ff99;
            transform: translateY(-4px);
        }
        .post-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        .post-info {
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .post-avatar {
            width: 48px;
            height: 48px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3cf2ff, #a259ff);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 1.2rem;
            color: #fff;
            border: 2px solid #ffe156;
        }
        .post-details h5 {
            color: #3cf2ff;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }
        .post-details small {
            color: #b3c6ff;
            font-size: 0.9rem;
        }
        .post-status {
            padding: 0.25rem 0.75rem;
            border-radius: 12px;
            font-size: 0.8rem;
            font-weight: 700;
        }
        .post-status.pending {
            background: #ffe156;
            color: #333;
        }
        .post-status.approved {
            background: #28a745;
            color: #fff;
        }
        .post-status.rejected {
            background: #dc3545;
            color: #fff;
        }
        .post-content {
            color: #fff;
            margin-bottom: 1rem;
            line-height: 1.6;
        }
        .post-image {
            width: 100%;
            max-height: 400px;
            object-fit: cover;
            border-radius: 16px;
            margin-bottom: 1rem;
            border: 2px solid #a259ff;
            box-shadow: 0 0 16px 0 #a259ff99;
        }
        .post-actions {
            display: flex;
            gap: 0.5rem;
            align-items: center;
            flex-wrap: wrap;
        }
        .btn-action {
            background: rgba(255,255,255,0.08);
            border: 2px solid #a259ff;
            border-radius: 18px;
            padding: 0.5rem 1rem;
            color: #b3c6ff;
            font-weight: 700;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
            text-decoration: none;
            cursor: pointer;
        }
        .btn-action:hover {
            border-color: #3cf2ff;
            color: #3cf2ff;
            background: rgba(60,242,255,0.1);
            transform: scale(1.05);
        }
        .btn-action.edit {
            background: #ffc107;
            border-color: #ffc107;
            color: #333;
        }
        .btn-action.edit:hover {
            background: #e0a800;
            border-color: #e0a800;
        }
        .btn-action.delete {
            background: #dc3545;
            border-color: #dc3545;
            color: #fff;
        }
        .btn-action.delete:hover {
            background: #c82333;
            border-color: #c82333;
        }
        .btn-action svg { width: 18px; height: 18px; }
        .no-posts {
            text-align: center;
            padding: 3rem 1rem;
            color: #b3c6ff;
        }
        .no-posts svg {
            width: 64px;
            height: 64px;
            margin-bottom: 1rem;
            opacity: 0.7;
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
            .posts-container { padding: 1.2rem 0.5rem; }
            .post-header { flex-direction: column; align-items: flex-start; gap: 1rem; }
            .post-actions { flex-direction: column; align-items: stretch; }
        }
    </style>
</head>
<body>
    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/kid/home.jsp" class="back-button" title="Quay lại trang chủ">
        <!-- SVG: Mũi tên tàu vũ trụ -->
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="15" stroke="#3cf2ff" stroke-width="2" fill="none"/><path d="M20 16H12M16 12l-4 4 4 4" stroke="#ffe156" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </a>
    <div class="posts-container">
        <div class="page-header">
            <h1>
                <!-- SVG: Bài viết cá nhân -->
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none"><rect x="8" y="10" width="28" height="28" rx="6" fill="#ffe156" stroke="#a259ff" stroke-width="2"/><path d="M12 14l20 20" stroke="#3cf2ff" stroke-width="2"/><circle cx="36" cy="12" r="4" fill="#3cf2ff" opacity="0.7"/><path d="M16 20h8" stroke="#a259ff" stroke-width="2"/><path d="M16 26h6" stroke="#a259ff" stroke-width="2"/></svg>
                Bài viết của tôi
            </h1>
            <p class="text-muted">Quản lý và xem lại những bài viết bạn đã đăng</p>
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
        <!-- Danh sách bài viết -->
        <c:choose>
            <c:when test="${not empty posts}">
                <c:forEach var="post" items="${posts}">
                    <div class="post-card">
                        <div class="post-header">
                            <div class="post-info">
                                <div class="post-avatar">
                                    ${post.authorName.charAt(0).toUpperCase()}
                                </div>
                                <div class="post-details">
                                    <h5>${post.title}</h5>
                                    <small>Đăng lúc ${post.createdAt}</small>
                                </div>
                            </div>
                            <div class="post-status ${post.status.toLowerCase()}">
                                <c:choose>
                                    <c:when test="${post.status == 'PENDING'}">Đang chờ duyệt</c:when>
                                    <c:when test="${post.status == 'APPROVED'}">Đã duyệt</c:when>
                                    <c:when test="${post.status == 'REJECTED'}">Từ chối</c:when>
                                    <c:otherwise>${post.status}</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                        <div class="post-content">
                            <p>${post.content}</p>
                        </div>
                        <c:if test="${not empty post.imageUrl}">
                            <img src="${pageContext.request.contextPath}/uploads/${post.imageUrl}" 
                                 alt="Post image" class="post-image">
                        </c:if>
                        <div class="post-actions">
                            <c:if test="${post.status == 'PENDING'}">
                                <a href="#" class="btn-action edit" onclick="editPost(${post.id})">
                                    <!-- SVG: Chỉnh sửa -->
                                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><path d="M3 15l12-12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><circle cx="14" cy="4" r="2" fill="currentColor"/></svg>
                                    Chỉnh sửa
                                </a>
                                <form method="post" action="${pageContext.request.contextPath}/kid/my-posts" style="display: inline;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="postId" value="${post.id}">
                                    <button type="submit" class="btn-action delete" onclick="return confirm('Bạn có chắc chắn muốn xóa bài viết này?')">
                                        <!-- SVG: Xóa -->
                                        <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><path d="M3 6h12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M6 6v10a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2V6" stroke="currentColor" stroke-width="2"/><path d="M8 3h2" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                                        Xóa
                                    </button>
                                </form>
                            </c:if>
                            <c:if test="${post.status == 'REJECTED'}">
                                <div style="color: #ff6bcb; font-weight: 700; margin-top: 0.5rem;">
                                    Lý do từ chối: ${post.rejectionReason != null ? post.rejectionReason : 'Không có lý do cụ thể'}
                                </div>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="no-posts">
                    <!-- SVG: Không có bài viết -->
                    <svg width="64" height="64" viewBox="0 0 64 64" fill="none"><circle cx="32" cy="32" r="24" fill="#3cf2ff" opacity="0.2"/><path d="M24 24h16v16H24z" stroke="#a259ff" stroke-width="2" fill="none"/><path d="M28 28h8" stroke="#ffe156" stroke-width="2"/><path d="M28 32h8" stroke="#ffe156" stroke-width="2"/><path d="M28 36h6" stroke="#ffe156" stroke-width="2"/></svg>
                    <h4 style="color: #3cf2ff; margin-bottom: 0.5rem;">Chưa có bài viết nào</h4>
                    <p>Bạn chưa đăng bài viết nào. Hãy tạo bài viết đầu tiên của mình!</p>
                    <a href="${pageContext.request.contextPath}/kid/create-post.jsp" class="btn-action" style="margin-top: 1rem; display: inline-flex;">
                        <!-- SVG: Tạo bài viết -->
                        <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="9" r="8" stroke="currentColor" stroke-width="2" fill="none"/><path d="M9 5v8" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M5 9h8" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                        Tạo bài viết mới
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editPost(postId) {
            // Implement edit functionality
            if (confirm('Bạn có muốn chỉnh sửa bài viết này?')) {
                // Redirect to edit page or show edit modal
                alert('Chức năng chỉnh sửa đang được phát triển!');
            }
        }
    </script>
</body>
</html> 