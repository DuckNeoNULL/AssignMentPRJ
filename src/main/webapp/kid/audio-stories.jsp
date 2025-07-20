<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Audio Stories - Kid Social</title>
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
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 60px 20px 30px 20px;
            position: relative;
            z-index: 1;
        }
        .audio-title {
            text-align: center;
            font-size: 2.5rem;
            font-weight: 800;
            margin-bottom: 2.5rem;
            background: linear-gradient(90deg, #ffe156, #3cf2ff, #a259ff);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            letter-spacing: 2px;
        }
        .story-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 2.5rem;
        }
        .story-card {
            background: rgba(30,33,93,0.7);
            border-radius: 50% 50% 44% 44%/60% 60% 44% 44%;
            box-shadow: 0 0 24px 0 #a259ff, 0 0 0 6px #1e215d;
            border: 2.5px solid #a259ff;
            min-width: 220px;
            min-height: 220px;
            padding: 32px 18px 24px 18px;
            text-align: center;
            position: relative;
            overflow: visible;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .story-card:hover {
            transform: scale(1.06) rotate(-2deg);
            box-shadow: 0 0 48px 8px #a259ff;
        }
        .story-card .thumbnail {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            object-fit: cover;
            margin-bottom: 1.2rem;
            border: 3px solid #3cf2ff;
            box-shadow: 0 0 18px 0 #3cf2ff99;
            background: #fff;
        }
        .story-card .card-title {
            font-weight: 700;
            color: #ffe156;
            font-size: 1.2rem;
            margin-bottom: 1rem;
            text-shadow: 0 0 8px #ffe15699;
        }
        .btn-play {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: linear-gradient(90deg, #3cf2ff 60%, #a259ff 100%);
            color: #fff;
            border: none;
            border-radius: 50px;
            padding: 14px 32px;
            font-size: 1.1rem;
            font-weight: 800;
            cursor: pointer;
            box-shadow: 0 0 12px 0 #3cf2ff;
            transition: transform 0.18s, box-shadow 0.18s;
            letter-spacing: 1px;
            margin-top: 1rem;
        }
        .btn-play:hover {
            transform: scale(1.08);
            box-shadow: 0 0 24px 4px #3cf2ff;
            background: linear-gradient(90deg, #a259ff 60%, #3cf2ff 100%);
        }
        .btn-play svg { width: 28px; height: 28px; }
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #ffe156;
            background: rgba(30,33,93,0.7);
            border-radius: 30px;
            margin-top: 2rem;
        }
        .empty-state svg {
            width: 48px;
            height: 48px;
            margin-bottom: 15px;
            color: #ffe156;
        }
        /* Modal styles */
        .modal-content {
            border-radius: 28px;
            background: linear-gradient(120deg, #1e215d 80%, #3cf2ff 100%);
            box-shadow: 0 0 32px 0 #3cf2ff;
            border: 3px solid #3cf2ff;
            color: #fff;
        }
        .modal-header {
            border-bottom: 2px solid #3cf2ff;
            background: linear-gradient(135deg, #3cf2ff, #a259ff);
            color: #fff;
            padding: 18px;
            font-weight: 700;
            font-size: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .modal-title {
            flex: 1;
        }
        .modal-body .thumbnail {
            width: 120px;
            height: 120px;
            object-fit: cover;
            border-radius: 50%;
            border: 3px solid #ffe156;
            margin-bottom: 1rem;
            background: #fff;
        }
        .modal-body audio {
            width: 100%;
            margin-top: 1rem;
        }
        .modal-body h4 {
            color: #ffe156;
            margin-bottom: 0.5rem;
        }
        @media (max-width: 700px) {
            .container { padding: 30px 5px 10px 5px; }
            .story-grid { gap: 1.2rem; }
            .story-card { min-width: 140px; min-height: 140px; padding: 18px 6px 12px 6px; }
            .story-card .thumbnail { width: 60px; height: 60px; }
        }
    </style>
</head>
<body>
    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/kid/home.jsp" class="back-button" title="Quay lại trang chủ">
        <!-- SVG: Mũi tên tàu vũ trụ -->
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="15" stroke="#3cf2ff" stroke-width="2" fill="none"/><path d="M20 16H12M16 12l-4 4 4 4" stroke="#ffe156" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </a>
    <div class="container">
        <h1 class="audio-title">🌟 Thế Giới Truyện Cổ Tích 🌟</h1>
        <%-- Display Database Error if it exists --%>
        <c:if test="${not empty dbError}">
            <div class="empty-state">
                <svg width="48" height="48" viewBox="0 0 48 48" fill="none"><ellipse cx="24" cy="32" rx="14" ry="6" fill="#ffe156" opacity="0.5"/><rect x="14" y="18" width="20" height="16" rx="8" fill="#3cf2ff"/><circle cx="18" cy="26" r="3" fill="#a259ff"/><circle cx="30" cy="26" r="3" fill="#a259ff"/></svg>
                <h4>Lỗi nghiêm trọng!</h4>
                <p>${dbError}</p>
                <hr>
                <p class="mb-0">Hãy kiểm tra console log để xem chi tiết đầy đủ về lỗi.</p>
            </div>
        </c:if>
        <c:choose>
            <c:when test="${not empty stories}">
                <div class="story-grid">
                    <c:forEach var="story" items="${stories}">
                        <div class="story-card">
                            <img src="${pageContext.request.contextPath}/${story.thumbnailPath}" class="thumbnail" alt="${story.title}">
                            <div class="card-title">${story.title}</div>
                            <button class="btn-play" data-bs-toggle="modal" data-bs-target="#audioPlayerModal"
                                    data-title="${story.title}"
                                    data-thumbnail="${pageContext.request.contextPath}/${story.thumbnailPath}"
                                    data-audio="${pageContext.request.contextPath}/${story.audioPath}">
                                <!-- SVG: Nút play vũ trụ -->
                                <svg width="28" height="28" viewBox="0 0 28 28" fill="none"><circle cx="14" cy="14" r="13" stroke="#ffe156" stroke-width="2" fill="#3cf2ff"/><polygon points="11,9 21,14 11,19" fill="#ffe156"/></svg>
                                Nghe truyện
                            </button>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <svg width="48" height="48" viewBox="0 0 48 48" fill="none"><ellipse cx="24" cy="32" rx="14" ry="6" fill="#ffe156" opacity="0.5"/><rect x="14" y="18" width="20" height="16" rx="8" fill="#3cf2ff"/><circle cx="18" cy="26" r="3" fill="#a259ff"/><circle cx="30" cy="26" r="3" fill="#a259ff"/></svg>
                    <h4>Ôi, chưa có câu chuyện nào!</h4>
                    <p class="text-muted">Có vẻ như kho truyện đang được cập nhật. Vui lòng quay lại sau nhé!</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    <!-- Audio Player Modal -->
    <div class="modal fade" id="audioPlayerModal" tabindex="-1" aria-labelledby="audioPlayerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header border-0">
                    <!-- SVG: Đầu robot Kiki nhỏ -->
                    <svg width="32" height="32" viewBox="0 0 48 48" fill="none"><ellipse cx="24" cy="32" rx="14" ry="6" fill="#3cf2ff" opacity="0.5"/><circle cx="24" cy="20" r="10" fill="#ffe156" stroke="#a259ff" stroke-width="2"/><ellipse cx="20" cy="18" rx="2" ry="3" fill="#3cf2ff"/><ellipse cx="28" cy="18" rx="2" ry="3" fill="#3cf2ff"/><rect x="20" y="26" width="8" height="2" rx="1" fill="#a259ff"/></svg>
                    <h5 class="modal-title" id="audioPlayerModalLabel">Đang phát truyện</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body text-center">
                    <img src="" id="modalThumbnail" class="thumbnail" alt="Story Thumbnail">
                    <h4 id="modalTitle"></h4>
                    <audio id="modalAudioPlayer" controls autoplay>
                        <source src="" type="audio/mpeg">
                        Trình duyệt của bạn không hỗ trợ phát audio.
                    </audio>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        const audioPlayerModal = document.getElementById('audioPlayerModal');
        const modalAudioPlayer = document.getElementById('modalAudioPlayer');
        audioPlayerModal.addEventListener('show.bs.modal', event => {
            const button = event.relatedTarget;
            const title = button.getAttribute('data-title');
            const thumbnail = button.getAttribute('data-thumbnail');
            const audioSrc = button.getAttribute('data-audio');
            const modalTitle = audioPlayerModal.querySelector('#modalTitle');
            const modalThumbnail = audioPlayerModal.querySelector('#modalThumbnail');
            const audioSource = modalAudioPlayer.querySelector('source');
            modalTitle.textContent = title;
            modalThumbnail.src = thumbnail;
            audioSource.src = audioSrc;
            modalAudioPlayer.load();
        });
        audioPlayerModal.addEventListener('hidden.bs.modal', () => {
            modalAudioPlayer.pause();
            modalAudioPlayer.currentTime = 0;
        });
    </script>
</body>
</html> 