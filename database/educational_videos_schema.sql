-- Use the correct database
USE KidSocialDB;
GO

-- Drop the table if it already exists to ensure a clean start
IF OBJECT_ID('dbo.EducationalVideos', 'U') IS NOT NULL
    DROP TABLE dbo.EducationalVideos;
GO

-- Create the EducationalVideos table
CREATE TABLE EducationalVideos (
    video_id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    youtube_embed_url NVARCHAR(500) NOT NULL,
    thumbnail_path NVARCHAR(500),
    category NVARCHAR(100)
);
GO

-- Insert 3 sample educational videos for kids
INSERT INTO EducationalVideos (title, description, youtube_embed_url, thumbnail_path, category)
VALUES
(
    N'Bảng chữ cái Tiếng Việt cho bé',
    N'Cùng bé học bảng chữ cái Tiếng Việt qua bài hát vui nhộn và hình ảnh sinh động.',
    N'https://youtu.be/hzSa-dUKl5o',
    N'https://img.youtube.com/vi/hzSa-dUKl5o/maxresdefault.jpg',
    N'Học tập'
),
(
    N'Bé học các loài động vật',
    N'Video giúp bé nhận biết và gọi tên các loài động vật quen thuộc trong trang trại và trong rừng.',
    N'https://youtu.be/pyg2pqMYB2I',
    N'https://img.youtube.com/vi/pyg2pqMYB2I/maxresdefault.jpg',
    N'Khám phá'
),
(
    N'Dạy bé vẽ các hình cơ bản',
    N'Hướng dẫn bé từng bước vẽ các hình đơn giản như hình tròn, hình vuông, tam giác và ngôi sao.',
    N'https://youtu.be/duo3YZ2OA8g',
    N'https://img.youtube.com/vi/duo3YZ2OA8g/maxresdefault.jpg',
    N'Nghệ thuật'
);
GO

SELECT * FROM EducationalVideos;
GO 