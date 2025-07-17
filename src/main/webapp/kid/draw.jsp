<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng vẽ diệu kỳ - KidSocial</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f0f4ff; text-align: center; padding-top: 20px; }
        .drawing-container { 
            display: inline-block; 
            background: white; 
            border-radius: 20px; 
            padding: 20px; 
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
        }
        canvas { 
            border: 2px dashed #ccc; 
            cursor: crosshair; 
            border-radius: 15px;
        }
        .controls { 
            margin: 20px 0; 
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 15px;
        }
    </style>
</head>
<body>
    <div class="drawing-container">
        <h2 class="mb-3">Bảng vẽ diệu kỳ</h2>
        <canvas id="drawing-board" width="800" height="600"></canvas>
        <div class="controls">
            <label for="colorPicker">Màu bút:</label>
            <input type="color" id="colorPicker" value="#000000">
            
            <label for="brushSize">Cỡ bút:</label>
            <input type="range" id="brushSize" min="1" max="20" value="5">

            <button id="clear-btn" class="btn btn-secondary"><i class="bi bi-trash"></i> Vẽ lại</button>
            <button id="save-btn" class="btn btn-primary"><i class="bi bi-save"></i> Lưu tác phẩm</button>
        </div>
        <a href="${pageContext.request.contextPath}/kid/home" class="btn btn-outline-secondary">Quay về trang chủ</a>
    </div>

    <form id="save-form" action="${pageContext.request.contextPath}/kid/draw" method="post" style="display: none;">
        <input type="hidden" name="imageData" id="imageData">
    </form>

    <script src="https://cdn.jsdelivr.net/npm/signature_pad@4.0.0/dist/signature_pad.umd.min.js"></script>
    <script>
        const canvas = document.getElementById('drawing-board');
        const signaturePad = new SignaturePad(canvas, {
            backgroundColor: 'rgb(255, 255, 255)'
        });

        const colorPicker = document.getElementById('colorPicker');
        const brushSize = document.getElementById('brushSize');
        const clearButton = document.getElementById('clear-btn');
        const saveButton = document.getElementById('save-btn');
        const saveForm = document.getElementById('save-form');
        const imageDataInput = document.getElementById('imageData');

        function updatePen() {
            signaturePad.penColor = colorPicker.value;
            signaturePad.minWidth = brushSize.value;
            signaturePad.maxWidth = brushSize.value;
        }

        colorPicker.addEventListener('input', updatePen);
        brushSize.addEventListener('input', updatePen);
        
        clearButton.addEventListener('click', () => {
            signaturePad.clear();
        });

        saveButton.addEventListener('click', () => {
            if (signaturePad.isEmpty()) {
                alert("Hãy vẽ một chút gì đó trước khi lưu nhé!");
            } else {
                const dataURL = signaturePad.toDataURL("image/png");
                imageDataInput.value = dataURL;
                saveForm.submit();
            }
        });

        updatePen(); // Initial setup
    </script>
</body>
</html> 