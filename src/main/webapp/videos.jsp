<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Video Học tập</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Baloo+2:wght@400;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Baloo 2', cursive;
            background-color: #f0f8ff; /* AliceBlue */
        }
        .container {
            padding-top: 2rem;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
        }
        .card:hover {
            transform: translateY(-10px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }
        .card-img-top {
            border-top-left-radius: 15px;
            border-top-right-radius: 15px;
            aspect-ratio: 16 / 9;
            object-fit: cover;
        }
        .card-title {
            color: #0056b3;
            font-weight: 700;
        }
        .btn-watch {
            background-color: #ff6347; /* Tomato */
            border-color: #ff6347;
            color: white;
            font-weight: bold;
        }
        .btn-watch:hover {
            background-color: #e5533d;
            border-color: #e5533d;
        }
        .page-title {
            color: #0056b3;
            font-weight: 700;
            text-align: center;
            margin-bottom: 2rem;
        }
        .modal-content {
            border-radius: 15px;
        }
        .modal-header {
            border-bottom: none;
        }
        .video-container {
            position: relative;
            padding-bottom: 56.25%; /* 16:9 aspect ratio */
            height: 0;
            overflow: hidden;
            max-width: 100%;
            background: #000;
        }
        .video-container iframe {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1 class="page-title"><i class="bi bi-camera-reels-fill"></i> Thư viện Video Vui Học</h1>
        
        <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
            <c:forEach var="video" items="${videoList}">
                <div class="col">
                    <div class="card h-100">
                        <img src="<c:out value='${video.thumbnailPath}'/>" class="card-img-top" alt="<c:out value='${video.title}'/>">
                        <div class="card-body">
                            <h5 class="card-title"><c:out value='${video.title}'/></h5>
                            <p class="card-text"><c:out value='${video.description}'/></p>
                        </div>
                        <div class="card-footer bg-transparent border-0 text-center pb-3">
                            <button class="btn btn-watch" 
                                    data-bs-toggle="modal" 
                                    data-bs-target="#videoModal"
                                    data-url="<c:out value='${video.embeddableUrl}'/>?autoplay=1&mute=0">
                                <i class="bi bi-play-circle-fill"></i> Xem Video
                            </button>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Bootstrap Modal for Video Player -->
    <div class="modal fade" id="videoModal" tabindex="-1" aria-labelledby="videoModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-0">
                    <div class="video-container">
                        <iframe id="youtubeVideo" src="" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" allowfullscreen></iframe>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const videoModal = document.getElementById('videoModal');
            const youtubeVideoIframe = document.getElementById('youtubeVideo');

            // Event listener for when the modal is shown
            videoModal.addEventListener('show.bs.modal', function (event) {
                // Button that triggered the modal
                const button = event.relatedTarget;
                // Extract info from data-url attribute
                const videoUrl = button.getAttribute('data-url');
                // Update the iframe's src to start the video
                if(videoUrl) {
                    youtubeVideoIframe.setAttribute('src', videoUrl);
                }
            });

            // Event listener for when the modal is hidden
            videoModal.addEventListener('hide.bs.modal', function () {
                // Stop the video by clearing the src attribute
                youtubeVideoIframe.setAttribute('src', '');
            });
        });
    </script>
</body>
</html> 