<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Truyện Audio - KidSocial</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body { background-color: #f0f8ff; font-family: 'Arial', sans-serif; }
        .story-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
            gap: 2rem;
        }
        .story-card {
            background: #fff;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .story-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.2);
        }
        .story-card .thumbnail {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
        .story-card .card-body {
            padding: 1.5rem;
        }
        .story-card .card-title {
            font-weight: bold;
            color: #333;
        }
        .modal-content {
            border-radius: 15px;
        }
        .modal-header .btn-close {
            position: absolute;
            right: 1.5rem;
            top: 1.5rem;
        }
        .modal-body .thumbnail {
            width: 100%;
            height: 300px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 1rem;
        }
        .modal-body audio {
            width: 100%;
            margin-top: 1rem;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <h1 class="text-center mb-5">Thế Giới Truyện Cổ Tích</h1>

        <%-- Display Database Error if it exists --%>
        <c:if test="${not empty dbError}">
            <div class="alert alert-danger" role="alert">
                <h4 class="alert-heading">Lỗi nghiêm trọng!</h4>
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
                            <div class="card-body text-center">
                                <h5 class="card-title">${story.title}</h5>
                                <button class="btn btn-primary mt-3" data-bs-toggle="modal" data-bs-target="#audioPlayerModal"
                                        data-title="${story.title}"
                                        data-thumbnail="${pageContext.request.contextPath}/${story.thumbnailPath}"
                                        data-audio="${pageContext.request.contextPath}/${story.audioPath}">
                                    <i class="fas fa-play me-2"></i>Nghe truyện
                                </button>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:when>
            <c:otherwise>
                <div class="text-center p-5 bg-light rounded">
                    <i class="fas fa-book-dead fa-3x text-muted mb-3"></i>
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
                    <h5 class="modal-title" id="audioPlayerModalLabel">Now Playing</h5>
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
            
            modalAudioPlayer.load(); // Important to load the new source
        });
        
        // Stop audio when modal is closed
        audioPlayerModal.addEventListener('hidden.bs.modal', () => {
            modalAudioPlayer.pause();
            modalAudioPlayer.currentTime = 0;
        });
    </script>
</body>
</html> 