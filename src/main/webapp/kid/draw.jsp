<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng vẽ - Kid Social</title>
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
        .drawing-container {
            max-width: 1000px;
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
        .canvas-container {
            text-align: center;
            margin: 2rem 0;
        }
        #drawingCanvas {
            border: 3px solid #a259ff;
            border-radius: 18px;
            cursor: crosshair;
            background-color: white;
            box-shadow: 0 0 24px 0 #a259ff99;
        }
        .tools-panel {
            background: rgba(60,242,255,0.1);
            border-radius: 18px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            border: 2px solid #3cf2ff;
        }
        .color-palette {
            display: flex;
            gap: 0.5rem;
            margin-bottom: 1rem;
            justify-content: center;
            flex-wrap: wrap;
        }
        .color-option {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            border: 3px solid #a259ff;
            cursor: pointer;
            transition: all 0.2s;
        }
        .color-option:hover {
            transform: scale(1.1);
            box-shadow: 0 0 12px 0 #3cf2ff;
        }
        .color-option.active {
            border-color: #3cf2ff;
            transform: scale(1.1);
            box-shadow: 0 0 16px 0 #3cf2ff;
        }
        .brush-size {
            display: flex;
            gap: 1rem;
            align-items: center;
            justify-content: center;
            margin-bottom: 1rem;
        }
        .brush-size label {
            font-weight: 700;
            color: #3cf2ff;
        }
        .brush-size input {
            width: 100px;
        }
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            justify-content: center;
            margin-bottom: 1rem;
        }
        .btn-tool {
            padding: 0.5rem 1rem;
            border-radius: 18px;
            border: 2px solid #a259ff;
            background: rgba(255,255,255,0.08);
            color: #b3c6ff;
            font-weight: 700;
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        .btn-tool:hover {
            border-color: #3cf2ff;
            color: #3cf2ff;
            background: rgba(60,242,255,0.1);
        }
        .btn-tool.active {
            background: #3cf2ff;
            border-color: #3cf2ff;
            color: #fff;
            box-shadow: 0 0 12px 0 #3cf2ff;
        }
        .btn-tool svg { width: 18px; height: 18px; }
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
        .form-control {
            border-radius: 18px;
            border: 2px solid #a259ff;
            padding: 0.85rem 1.2rem;
            background: rgba(255,255,255,0.08);
            color: #fff;
            font-size: 1.1rem;
            transition: border-color 0.2s, box-shadow 0.2s;
        }
        .form-control:focus {
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
            .drawing-container { padding: 1.2rem 0.5rem; }
            #drawingCanvas { width: 100%; height: auto; }
        }
    </style>
</head>
<body>
    <!-- Back Button -->
    <a href="${pageContext.request.contextPath}/kid/home.jsp" class="back-button" title="Quay lại trang chủ">
        <!-- SVG: Mũi tên tàu vũ trụ -->
        <svg width="32" height="32" viewBox="0 0 32 32" fill="none"><circle cx="16" cy="16" r="15" stroke="#3cf2ff" stroke-width="2" fill="none"/><path d="M20 16H12M16 12l-4 4 4 4" stroke="#ffe156" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/></svg>
    </a>
    <div class="drawing-container">
        <div class="page-header">
            <h1>
                <!-- SVG: Ngôi sao vẽ dải ngân hà -->
                <svg width="36" height="36" viewBox="0 0 48 48" fill="none"><polygon points="24,8 27,20 40,20 29,28 32,40 24,32 16,40 19,28 8,20 21,20" fill="#3cf2ff" stroke="#a259ff" stroke-width="1.5"/><path d="M24 32 Q28 36 36 36" stroke="#ffe156" stroke-width="2"/></svg>
                Bảng vẽ
            </h1>
            <p class="text-muted">Tạo ra những tác phẩm nghệ thuật tuyệt đẹp của riêng bạn</p>
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
        <!-- Tools Panel -->
        <div class="tools-panel">
            <div class="color-palette">
                <div class="color-option active" style="background-color: #000000;" data-color="#000000"></div>
                <div class="color-option" style="background-color: #ff0000;" data-color="#ff0000"></div>
                <div class="color-option" style="background-color: #00ff00;" data-color="#00ff00"></div>
                <div class="color-option" style="background-color: #0000ff;" data-color="#0000ff"></div>
                <div class="color-option" style="background-color: #ffff00;" data-color="#ffff00"></div>
                <div class="color-option" style="background-color: #ff00ff;" data-color="#ff00ff"></div>
                <div class="color-option" style="background-color: #00ffff;" data-color="#00ffff"></div>
                <div class="color-option" style="background-color: #ffa500;" data-color="#ffa500"></div>
                <div class="color-option" style="background-color: #800080;" data-color="#800080"></div>
                <div class="color-option" style="background-color: #008000;" data-color="#008000"></div>
            </div>
            <div class="brush-size">
                <label for="brushSize">Kích thước cọ:</label>
                <input type="range" id="brushSize" min="1" max="20" value="5" class="form-range">
                <span id="brushSizeValue">5px</span>
            </div>
            <div class="action-buttons">
                <button type="button" class="btn-tool active" id="brushTool">
                    <!-- SVG: Cọ vẽ -->
                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><path d="M3 15l12-12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><circle cx="14" cy="4" r="2" fill="currentColor"/></svg>
                    Cọ vẽ
                </button>
                <button type="button" class="btn-tool" id="eraserTool">
                    <!-- SVG: Tẩy -->
                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><rect x="2" y="6" width="14" height="8" rx="2" fill="currentColor"/><path d="M4 8h10" stroke="#fff" stroke-width="1.5"/></svg>
                    Tẩy
                </button>
                <button type="button" class="btn-tool" id="clearCanvas">
                    <!-- SVG: Xóa -->
                    <svg width="18" height="18" viewBox="0 0 18 18" fill="none"><path d="M3 6h12" stroke="currentColor" stroke-width="2" stroke-linecap="round"/><path d="M6 6v10a2 2 0 0 0 2 2h2a2 2 0 0 0 2-2V6" stroke="currentColor" stroke-width="2"/><path d="M8 3h2" stroke="currentColor" stroke-width="2" stroke-linecap="round"/></svg>
                    Xóa tất cả
                </button>
            </div>
        </div>
        <!-- Canvas -->
        <div class="canvas-container">
            <canvas id="drawingCanvas" width="800" height="600"></canvas>
        </div>
        <!-- Save Form -->
        <form method="post" action="${pageContext.request.contextPath}/kid/draw" id="saveForm">
            <div class="form-group">
                <label for="title" class="form-label">
                    <!-- SVG: Tiêu đề -->
                    <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><rect x="3" y="5" width="16" height="12" rx="3" fill="#3cf2ff"/><path d="M6 9h10" stroke="#ffe156" stroke-width="2"/><path d="M6 13h7" stroke="#ffe156" stroke-width="2"/></svg>
                    Tiêu đề bức vẽ
                </label>
                <input type="text" class="form-control" id="title" name="title" 
                       placeholder="Nhập tiêu đề cho bức vẽ..." required>
            </div>
            <div class="form-group">
                <label for="content" class="form-label">
                    <!-- SVG: Mô tả -->
                    <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><rect x="3" y="5" width="16" height="12" rx="3" fill="#a259ff"/><path d="M6 9h10" stroke="#ffe156" stroke-width="2"/><path d="M6 13h7" stroke="#ffe156" stroke-width="2"/></svg>
                    Mô tả (tùy chọn)
                </label>
                <textarea class="form-control" id="content" name="content" rows="3" 
                          placeholder="Mô tả về bức vẽ của bạn..."></textarea>
            </div>
            <input type="hidden" id="canvasData" name="canvasData">
            <div class="d-flex gap-3 justify-content-end">
                <button type="submit" class="btn-primary" id="saveButton">
                    <!-- SVG: Lưu -->
                    <svg width="22" height="22" viewBox="0 0 22 22" fill="none"><rect x="3" y="5" width="16" height="12" rx="3" fill="#3cf2ff"/><path d="M6 9h10" stroke="#ffe156" stroke-width="2"/><path d="M6 13h7" stroke="#ffe156" stroke-width="2"/></svg>
                    Lưu bức vẽ
                </button>
            </div>
        </form>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Canvas setup
        const canvas = document.getElementById('drawingCanvas');
        const ctx = canvas.getContext('2d');
        let isDrawing = false;
        let currentTool = 'brush';
        let currentColor = '#000000';
        let brushSize = 5;
        // Initialize canvas
        ctx.fillStyle = 'white';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        // Color palette
        document.querySelectorAll('.color-option').forEach(option => {
            option.addEventListener('click', function() {
                document.querySelector('.color-option.active').classList.remove('active');
                this.classList.add('active');
                currentColor = this.dataset.color;
            });
        });
        // Brush size
        const brushSizeSlider = document.getElementById('brushSize');
        const brushSizeValue = document.getElementById('brushSizeValue');
        brushSizeSlider.addEventListener('input', function() {
            brushSize = this.value;
            brushSizeValue.textContent = this.value + 'px';
        });
        // Tools
        document.getElementById('brushTool').addEventListener('click', function() {
            setActiveTool('brush', this);
        });
        document.getElementById('eraserTool').addEventListener('click', function() {
            setActiveTool('eraser', this);
        });
        document.getElementById('clearCanvas').addEventListener('click', function() {
            if (confirm('Bạn có chắc chắn muốn xóa tất cả?')) {
                ctx.fillStyle = 'white';
                ctx.fillRect(0, 0, canvas.width, canvas.height);
            }
        });
        function setActiveTool(tool, button) {
            currentTool = tool;
            document.querySelectorAll('.btn-tool').forEach(btn => btn.classList.remove('active'));
            button.classList.add('active');
        }
        // Drawing events
        canvas.addEventListener('mousedown', startDrawing);
        canvas.addEventListener('mousemove', draw);
        canvas.addEventListener('mouseup', stopDrawing);
        canvas.addEventListener('mouseout', stopDrawing);
        function startDrawing(e) {
            isDrawing = true;
            draw(e);
        }
        function draw(e) {
            if (!isDrawing) return;
            const rect = canvas.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;
            ctx.lineWidth = brushSize;
            ctx.lineCap = 'round';
            ctx.lineJoin = 'round';
            if (currentTool === 'brush') {
                ctx.strokeStyle = currentColor;
            } else if (currentTool === 'eraser') {
                ctx.strokeStyle = 'white';
            }
            ctx.lineTo(x, y);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(x, y);
        }
        function stopDrawing() {
            isDrawing = false;
            ctx.beginPath();
        }
        // Save form
        document.getElementById('saveForm').addEventListener('submit', function(e) {
            const canvasData = canvas.toDataURL('image/png');
            document.getElementById('canvasData').value = canvasData;
        });
    </script>
</body>
</html> 