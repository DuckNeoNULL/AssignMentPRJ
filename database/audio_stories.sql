-- Tạo lại bảng với cú pháp chuẩn cho SQL Server
CREATE TABLE AudioStories (
    story_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    audio_path VARCHAR(255) NOT NULL,
    thumbnail_path VARCHAR(255),
    duration_seconds INT,
    created_at DATETIME DEFAULT GETDATE()
);
GO

INSERT INTO AudioStories (title, description, audio_path, thumbnail_path, duration_seconds)
VALUES
(N'Cô Bé Quàng Khăn Đỏ', N'Bài học cảnh giác cho các em nhỏ...', 'assets/audio/khan-do.mp3', 'assets/images/khan-do.jpg', 240);
GO

-- Kiểm tra lại dữ liệu đã được thêm
SELECT * FROM AudioStories;
GO