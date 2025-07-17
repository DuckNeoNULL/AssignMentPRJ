<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Viết Truyện - KidSocial</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/kid/css/style.css">
    <style>
        .story-form-container {
            background-color: #fff;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            max-width: 800px;
            margin: 40px auto;
        }

        .story-form h2 {
            color: #ff6f61;
            text-align: center;
            margin-bottom: 25px;
        }

        .story-form .form-group {
            margin-bottom: 20px;
        }

        .story-form label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }

        .story-form input[type="text"],
        .story-form textarea {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            box-sizing: border-box;
            font-size: 16px;
        }

        .story-form textarea {
            height: 300px;
            resize: vertical;
        }

        .story-form button {
            background-color: #ff6f61;
            color: white;
            padding: 12px 25px;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-size: 18px;
            width: 100%;
            transition: background-color 0.3s;
        }

        .story-form button:hover {
            background-color: #e65a50;
        }
        
        .back-link {
            display: inline-block;
            margin-bottom: 20px;
            color: #ff6f61;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="story-form-container">
        <a href="${pageContext.request.contextPath}/kid/home" class="back-link">&larr; Quay lại trang chủ</a>
        <form class="story-form" action="${pageContext.request.contextPath}/story" method="post">
            <h2>Sáng Tác Câu Chuyện Của Bé</h2>
            <div class="form-group">
                <label for="title">Tiêu đề câu chuyện</label>
                <input type="text" id="title" name="title" required placeholder="Ví dụ: Cuộc phiêu lưu của Gấu con">
            </div>
            <div class="form-group">
                <label for="content">Nội dung câu chuyện</label>
                <textarea id="content" name="content" required placeholder="Ngày xửa ngày xưa..."></textarea>
            </div>
            <button type="submit">Gửi truyện đi duyệt</button>
        </form>
    </div>
</body>
</html> 