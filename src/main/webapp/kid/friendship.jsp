<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bạn bè - Kid Social</title>
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
        .friendship-container {
            max-width: 900px;
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
        .section-header {
            color: #3cf2ff;
            font-weight: 700;
            font-size: 1.5rem;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .section-header svg { width: 28px; height: 28px; }
        .friend-card {
            background: rgba(60,242,255,0.1);
            border: 2px solid #a259ff;
            border-radius: 24px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        .friend-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(60,242,255,0.1), transparent);
            transition: left 0.5s;
        }
        .friend-card:hover::before {
            left: 100%;
        }
        .friend-card:hover {
            border-color: #3cf2ff;
            box-shadow: 0 0 24px 0 #3cf2ff99;
            transform: translateY(-4px);
        }
        .friend-info {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 1rem;
        }
        .friend-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #3cf2ff, #a259ff);
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 800;
            font-size: 1.5rem;
            color: #fff;
            border: 3px solid #ffe156;
        }
        .friend-details h5 {
            color: #3cf2ff;
            font-weight: 700;
            margin-bottom: 0.25rem;
        }
        .friend-details p {
            color: #b3c6ff;
            margin-bottom: 0;
        }
        .friend-actions {
            display: flex;
            gap: 0.5rem;
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
        .btn-action.accept {
            background: #28a745;
            border-color: #28a745;
            color: #fff;
        }
        .btn-action.accept:hover {
            background: #218838;
            border-color: #218838;
        }
        .btn-action.reject {
            background: #dc3545;
            border-color: #dc3545;
            color: #fff;
        }
        .btn-action.reject:hover {
            background: #c82333;
            border-color: #c82333;
        }
        .btn-action svg { width: 18px; height: 18px; }
        .empty-state {
            text-align: center;
            padding: 3rem 1rem;
            color: #b3c6ff;
        }
        .empty-state svg {
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
            .friendship-container { padding: 1.2rem 0.5rem; }
            .friend-actions { flex-direction: column; }
        }
    </style>
</head>
<body>
    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/kid/home.jsp" class="back-button" title="Quay lại trang chủ">
        <!-- SVG: Mũi tên tàu vũ trụ -->
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="15" stroke="#3cf2ff" stroke-width="2" fill="none"/><path d="M20 16H12M16 12l-4 4 4 4" stroke="#ffe156" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </a>
    <div class="friendship-container">
        <div class="page-header">
            <h1>
                <!-- SVG: Nhóm bạn bè vũ trụ -->
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none"><circle cx="24" cy="16" r="8" fill="#3cf2ff"/><circle cx="12" cy="32" r="6" fill="#a259ff"/><circle cx="36" cy="32" r="6" fill="#ffe156"/><path d="M16 28 Q24 32 32 28" stroke="#3cf2ff" stroke-width="2"/><circle cx="40" cy="8" r="2" fill="#fffbe7" opacity="0.7"/><circle cx="8" cy="8" r="1.5" fill="#fffbe7" opacity="0.5"/></svg>
                Quản lý bạn bè
            </h1>
            <p class="text-muted">Kết nối và quản lý danh sách bạn bè của bạn</p>
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
        <!-- Lời mời kết bạn -->
        <div class="section-header">
            <!-- SVG: Lời mời -->
            <svg width="28" height="28" viewBox="0 0 28 28" fill="none"><circle cx="14" cy="14" r="12" fill="#ffe156" opacity="0.3"/><path d="M14 8v12" stroke="#3cf2ff" stroke-width="2" stroke-linecap="round"/><path d="M10 12l4-4 4 4" stroke="#a259ff" stroke-width="2" stroke-linecap="round"/></svg>
            Lời mời kết bạn
        </div>
        <c:choose>
            <c:when test="${not empty friendRequests}">
                <c:forEach var="request" items="${friendRequests}">
                    <div class="friend-card">
                        <div class="friend-info">
                            <div class="friend-avatar">
                                ${request.senderName.charAt(0).toUpperCase()}
                            </div>
                            <div class="friend-details">
                                <h5>${request.senderName}</h5>
                                <p>Muốn kết bạn với bạn</p>
                            </div>
                        </div>
                        <div class="friend-actions">
                            <form method="post" action="${pageContext.request.contextPath}/kid/friendship" style="display: inline;">
                                <input type="hidden" name="action" value="accept">
                                <input type="hidden" name="requestId" value="${request.id}">
                                <button type="submit" class="btn-action accept">
                                    <!-- SVG: Chấp nhận -->
                                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="9" r="8" stroke="currentColor" stroke-width="2" fill="none"/><path d="M6 9l2 2 4-4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                                    Chấp nhận
                                </button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/kid/friendship" style="display: inline;">
                                <input type="hidden" name="action" value="reject">
                                <input type="hidden" name="requestId" value="${request.id}">
                                <button type="submit" class="btn-action reject">
                                    <!-- SVG: Từ chối -->
                                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="9" r="8" stroke="currentColor" stroke-width="2" fill="none"/><path d="M6 6l6 6M12 6l-6 6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                                    Từ chối
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <!-- SVG: Không có lời mời -->
                    <svg width="64" height="64" viewBox="0 0 64 64" fill="none"><circle cx="32" cy="32" r="24" fill="#3cf2ff" opacity="0.2"/><path d="M24 24h16v16H24z" stroke="#a259ff" stroke-width="2" fill="none"/><path d="M28 28h8" stroke="#ffe156" stroke-width="2"/><path d="M28 32h8" stroke="#ffe156" stroke-width="2"/><path d="M28 36h6" stroke="#ffe156" stroke-width="2"/></svg>
                    <h4 style="color: #3cf2ff; margin-bottom: 0.5rem;">Không có lời mời kết bạn</h4>
                    <p>Chưa có ai gửi lời mời kết bạn cho bạn</p>
                </div>
            </c:otherwise>
        </c:choose>
        <!-- Danh sách bạn bè -->
        <div class="section-header" style="margin-top: 2rem;">
            <!-- SVG: Bạn bè -->
            <svg width="28" height="28" viewBox="0 0 28 28" fill="none"><circle cx="14" cy="10" r="6" fill="#3cf2ff"/><circle cx="8" cy="20" r="4" fill="#a259ff"/><circle cx="20" cy="20" r="4" fill="#ffe156"/><path d="M10 18 Q14 22 18 18" stroke="#3cf2ff" stroke-width="2"/></svg>
            Danh sách bạn bè (${friends.size()})
        </div>
        <c:choose>
            <c:when test="${not empty friends}">
                <c:forEach var="friend" items="${friends}">
                    <div class="friend-card">
                        <div class="friend-info">
                            <div class="friend-avatar">
                                ${friend.name.charAt(0).toUpperCase()}
                            </div>
                            <div class="friend-details">
                                <h5>${friend.name}</h5>
                                <p>Bạn bè từ ${friend.friendshipDate}</p>
                            </div>
                        </div>
                        <div class="friend-actions">
                            <a href="#" class="btn-action" onclick="viewProfile(${friend.id})">
                                <!-- SVG: Xem hồ sơ -->
                                <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><circle cx="9" cy="9" r="8" stroke="currentColor" stroke-width="2" fill="none"/><path d="M9 5a2 2 0 1 0 0 4 2 2 0 0 0 0-4z" fill="currentColor"/><path d="M6 13c0-1.5 1.5-3 3-3s3 1.5 3 3" stroke="currentColor" stroke-width="2" fill="none"/></svg>
                                Xem hồ sơ
                            </a>
                            <a href="#" class="btn-action" onclick="sendMessage(${friend.id})">
                                <!-- SVG: Nhắn tin -->
                                <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><path d="M3 6h12v8H3V6z" stroke="currentColor" stroke-width="2" fill="none"/><path d="M6 14l-2 2v-2" stroke="currentColor" stroke-width="2" fill="none"/></svg>
                                Nhắn tin
                            </a>
                            <form method="post" action="${pageContext.request.contextPath}/kid/friendship" style="display: inline;">
                                <input type="hidden" name="action" value="unfriend">
                                <input type="hidden" name="friendId" value="${friend.id}">
                                <button type="submit" class="btn-action reject" onclick="return confirm('Bạn có chắc chắn muốn hủy kết bạn?')">
                                    <!-- SVG: Hủy kết bạn -->
                                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><path d="M3 6h12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M6 6v10a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2V6" stroke="currentColor" stroke-width="2"/><path d="M8 3h2" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                                    Hủy kết bạn
                                </button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <!-- SVG: Không có bạn bè -->
                    <svg width="64" height="64" viewBox="0 0 64 64" fill="none"><circle cx="32" cy="32" r="24" fill="#3cf2ff" opacity="0.2"/><circle cx="24" cy="24" r="6" fill="#a259ff"/><circle cx="40" cy="24" r="6" fill="#ffe156"/><path d="M20 36 Q32 44 44 36" stroke="#3cf2ff" stroke-width="2"/></svg>
                    <h4 style="color: #3cf2ff; margin-bottom: 0.5rem;">Chưa có bạn bè</h4>
                    <p>Hãy kết bạn với những người khác để bắt đầu cuộc trò chuyện!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function viewProfile(friendId) {
            // Implement view profile functionality
            alert('Xem hồ sơ của bạn bè (ID: ' + friendId + ')');
        }
        function sendMessage(friendId) {
            // Implement send message functionality
            const message = prompt('Nhập tin nhắn:');
            if (message) {
                alert('Tin nhắn đã được gửi!');
            }
        }
    </script>
</body>
</html> 