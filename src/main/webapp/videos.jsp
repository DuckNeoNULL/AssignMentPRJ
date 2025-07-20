<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Video giáo dục - Kid Social</title>
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
        .videos-container {
            max-width: 1200px;
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
        .video-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        .video-card {
            background: rgba(60,242,255,0.1);
            border: 2px solid #a259ff;
            border-radius: 24px;
            padding: 1.5rem;
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            cursor: pointer;
        }
        .video-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(60,242,255,0.1), transparent);
            transition: left 0.5s;
        }
        .video-card:hover::before {
            left: 100%;
        }
        .video-card:hover {
            border-color: #3cf2ff;
            box-shadow: 0 0 24px 0 #3cf2ff99;
            transform: translateY(-4px);
        }
        .video-thumbnail {
            position: relative;
            width: 100%;
            height: 180px;
            border-radius: 16px;
            overflow: hidden;
            margin-bottom: 1rem;
            background: linear-gradient(135deg, #3cf2ff, #a259ff);
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .video-thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        .play-button {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 60px;
            height: 60px;
            background: rgba(255,255,255,0.9);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            box-shadow: 0 0 20px 0 rgba(0,0,0,0.3);
            transition: all 0.2s;
        }
        .video-card:hover .play-button {
            transform: translate(-50%, -50%) scale(1.1);
            background: #fff;
            box-shadow: 0 0 30px 0 rgba(60,242,255,0.5);
        }
        .play-button svg {
            width: 24px;
            height: 24px;
            margin-left: 2px;
        }
        .video-info h5 {
            color: #3cf2ff;
            font-weight: 700;
            margin-bottom: 0.5rem;
            font-size: 1.1rem;
        }
        .video-info p {
            color: #b3c6ff;
            margin-bottom: 0.5rem;
            line-height: 1.4;
        }
        .video-meta {
            display: flex;
            align-items: center;
            gap: 1rem;
            font-size: 0.9rem;
            color: #ffe156;
        }
        .video-meta span {
            display: flex;
            align-items: center;
            gap: 4px;
        }
        .video-meta svg {
            width: 16px;
            height: 16px;
        }
        .category-filter {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            justify-content: center;
        }
        .filter-btn {
            background: rgba(255,255,255,0.08);
            border: 2px solid #a259ff;
            border-radius: 18px;
            padding: 0.5rem 1rem;
            color: #b3c6ff;
            font-weight: 700;
            transition: all 0.2s;
            cursor: pointer;
        }
        .filter-btn:hover, .filter-btn.active {
            border-color: #3cf2ff;
            color: #3cf2ff;
            background: rgba(60,242,255,0.1);
            transform: scale(1.05);
        }
        .no-videos {
            text-align: center;
            padding: 3rem 1rem;
            color: #b3c6ff;
        }
        .no-videos svg {
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
            .videos-container { padding: 1.2rem 0.5rem; }
            .video-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/kid/home.jsp" class="back-button" title="Quay lại trang chủ">
        <!-- SVG: Mũi tên tàu vũ trụ -->
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="15" stroke="#3cf2ff" stroke-width="2" fill="none"/><path d="M20 16H12M16 12l-4 4 4 4" stroke="#ffe156" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </a>
    <div class="videos-container">
        <div class="page-header">
            <h1>
                <!-- SVG: Video giáo dục -->
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none"><rect x="8" y="12" width="32" height="24" rx="4" fill="#3cf2ff" opacity="0.3" stroke="#a259ff" stroke-width="2"/><polygon points="20,24 32,18 20,12" fill="#ffe156"/><circle cx="24" cy="24" r="8" fill="#3cf2ff" opacity="0.2"/></svg>
                Video giáo dục
            </h1>
            <p class="text-muted">Khám phá những video học tập thú vị và bổ ích</p>
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
        <!-- Bộ lọc danh mục -->
        <div class="category-filter">
            <button class="filter-btn active" data-category="all">
                <!-- SVG: Tất cả -->
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="currentColor" stroke-width="2" fill="none"/><path d="M4 8h8" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M8 4v8" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                Tất cả
            </button>
            <button class="filter-btn" data-category="math">
                <!-- SVG: Toán học -->
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M8 2v12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M2 8h12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><circle cx="8" cy="8" r="6" stroke="currentColor" stroke-width="2" fill="none"/></svg>
                Toán học
            </button>
            <button class="filter-btn" data-category="science">
                <!-- SVG: Khoa học -->
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="6" fill="currentColor" opacity="0.3"/><path d="M8 2v12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M2 8h12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                Khoa học
            </button>
            <button class="filter-btn" data-category="language">
                <!-- SVG: Ngôn ngữ -->
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><rect x="2" y="4" width="12" height="8" rx="2" stroke="currentColor" stroke-width="2" fill="none"/><path d="M4 8h8" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M6 6h4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M6 10h4" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                Ngôn ngữ
            </button>
        </div>
        <!-- Danh sách video -->
        <c:choose>
            <c:when test="${not empty videos}">
                <div class="video-grid">
                    <c:forEach var="video" items="${videos}">
                        <div class="video-card" data-category="${video.category.toLowerCase()}">
                            <div class="video-thumbnail" onclick="playVideo('${video.videoUrl}', '${video.title}')">
                                <c:if test="${not empty video.thumbnailUrl}">
                                    <img src="${pageContext.request.contextPath}/uploads/${video.thumbnailUrl}" 
                                         alt="${video.title}">
                                </c:if>
                                <div class="play-button">
                                    <!-- SVG: Play -->
                                    <svg width="24" height="24" viewBox="0 0 24 24" fill="none"><polygon points="5,3 19,12 5,21" fill="#333"/></svg>
                                </div>
                            </div>
                            <div class="video-info">
                                <h5>${video.title}</h5>
                                <p>${video.description}</p>
                                <div class="video-meta">
                                    <span>
                                        <!-- SVG: Thời gian -->
                                        <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><circle cx="8" cy="8" r="7" stroke="currentColor" stroke-width="2" fill="none"/><path d="M8 4v4l3 3" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                                        ${video.duration}
                                    </span>
                                    <span>
                                        <!-- SVG: Lượt xem -->
                                        <svg width="16" height="16" viewBox="0 0 16 16" fill="none"><path d="M8 2C4.5 2 2 4.5 2 8s2.5 6 6 6 6-2.5 6-6-2.5-6-6-6z" stroke="currentColor" stroke-width="2" fill="none"/><path d="M8 5v6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M5 8h6" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                                        ${video.viewCount} lượt xem
                                    </span>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="no-videos">
                    <!-- SVG: Không có video -->
                    <svg width="64" height="64" viewBox="0 0 64 64" fill="none"><rect x="12" y="16" width="40" height="32" rx="4" fill="#3cf2ff" opacity="0.2" stroke="#a259ff" stroke-width="2"/><polygon points="28,32 44,24 28,16" fill="#ffe156"/><circle cx="32" cy="32" r="16" fill="#3cf2ff" opacity="0.1"/></svg>
                    <h4 style="color: #3cf2ff; margin-bottom: 0.5rem;">Chưa có video nào</h4>
                    <p>Hiện tại chưa có video giáo dục nào được đăng tải</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- Video Modal -->
    <div id="videoModal" class="modal" style="display: none;">
        <div class="modal-content" style="max-width: 800px; width: 90%;">
            <div class="modal-header">
                <h5 id="modalTitle" style="color: #3cf2ff; margin: 0;"></h5>
                <button type="button" class="btn-close" onclick="closeVideoModal()"></button>
            </div>
            <div class="modal-body">
                <video id="videoPlayer" controls style="width: 100%; border-radius: 12px;">
                    Your browser does not support the video tag.
                </video>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        .modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2000;
        }
        .modal-content {
            background: rgba(30,33,93,0.95);
            border-radius: 24px;
            padding: 1.5rem;
            border: 3px solid #3cf2ff;
            box-shadow: 0 0 32px 0 #3cf2ff99;
        }
        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        .btn-close {
            background: none;
            border: none;
            color: #b3c6ff;
            font-size: 1.5rem;
            cursor: pointer;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s;
        }
        .btn-close:hover {
            background: rgba(255,255,255,0.1);
            color: #3cf2ff;
        }
    </style>
    <script>
        // Filter functionality
        document.querySelectorAll('.filter-btn').forEach(btn => {
            btn.addEventListener('click', function() {
                const category = this.dataset.category;
                
                // Update active button
                document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');
                
                // Filter videos
                document.querySelectorAll('.video-card').forEach(card => {
                    if (category === 'all' || card.dataset.category === category) {
                        card.style.display = 'block';
                    } else {
                        card.style.display = 'none';
                    }
                });
            });
        });
        
        // Video modal functionality
        function playVideo(videoUrl, title) {
            const modal = document.getElementById('videoModal');
            const videoPlayer = document.getElementById('videoPlayer');
            const modalTitle = document.getElementById('modalTitle');
            
            modalTitle.textContent = title;
            videoPlayer.src = videoUrl;
            modal.style.display = 'flex';
            
            // Play video
            videoPlayer.play();
        }
        
        function closeVideoModal() {
            const modal = document.getElementById('videoModal');
            const videoPlayer = document.getElementById('videoPlayer');
            
            videoPlayer.pause();
            videoPlayer.src = '';
            modal.style.display = 'none';
        }
        
        // Close modal when clicking outside
        document.getElementById('videoModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeVideoModal();
            }
        });
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                closeVideoModal();
            }
        });
    </script>
</body>
</html> 