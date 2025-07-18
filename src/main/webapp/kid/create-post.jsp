<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create a New Post</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f0f4ff; }
        .form-container {
            max-width: 600px;
            margin: 50px auto;
            padding: 40px;
            background-color: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
        .form-container h1 { font-weight: 700; text-align: center; margin-bottom: 30px; }
        .form-label { font-weight: 600; }
        .form-control { border-radius: 12px; padding: 12px; }
        .btn-custom {
            width: 100%;
            padding: 12px;
            border-radius: 12px;
            font-size: 1.2rem;
            font-weight: 700;
        }
    </style>
</head>
<body>
    <div class="form-container">
        <h1><i class="bi bi-pencil-square"></i> What's on your mind?</h1>
        <form action="${pageContext.request.contextPath}/kid/create-post" method="post">
            <div class="mb-3">
                <label for="title" class="form-label">Title</label>
                <input type="text" class="form-control" id="title" name="title" required>
            </div>
            <div class="mb-3">
                <label for="content" class="form-label">Your Story</label>
                <textarea class="form-control" id="content" name="content" rows="6" required></textarea>
            </div>
            <button type="submit" class="btn btn-primary btn-custom">Share Post</button>
            <a href="${pageContext.request.contextPath}/kid/home?childId=${sessionScope.currentChild.childId}" class="btn btn-link d-block mt-3">Go Back</a>
        </form>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const postContent = localStorage.getItem('postContent');
            if (postContent) {
                const contentTextArea = document.getElementById('post-content'); // Make sure your textarea has this ID
                if(contentTextArea) {
                    contentTextArea.value = postContent;
                }
                // Clear the stored content so it doesn't reappear on a normal page load
                localStorage.removeItem('postContent');
            }
        });
    </script>
</body>
</html> 