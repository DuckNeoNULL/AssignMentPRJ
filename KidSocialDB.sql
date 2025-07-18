USE master;
GO

-- 1) Drop the database if it exists to ensure a clean setup
IF DB_ID('KidSocialDB') IS NOT NULL
BEGIN
    ALTER DATABASE [KidSocialDB] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE [KidSocialDB];
END;
GO

-- 2) Create a new database
CREATE DATABASE [KidSocialDB];
GO
USE [KidSocialDB];
GO

-- 3) Create Tables in the correct order of dependency

-- Parents Table
CREATE TABLE dbo.Parents (
    parent_id            INT           IDENTITY(1,1) PRIMARY KEY,
    email                NVARCHAR(100) NOT NULL UNIQUE,
    password             NVARCHAR(100) NOT NULL, -- Changed from password_hash
    full_name            NVARCHAR(100) NOT NULL,
    phone                NVARCHAR(20)  NULL,
    verification_code    NVARCHAR(10)  NULL,
    verification_code_expiry DATETIME,
    is_verified          BIT           NOT NULL DEFAULT 0,
    verification_expiry  DATETIME2     NULL,
    role                 NVARCHAR(20)  NOT NULL DEFAULT 'USER',
    status               NVARCHAR(20)  NOT NULL DEFAULT 'UNVERIFIED', -- Added status
    created_at           DATETIME2     NOT NULL DEFAULT GETDATE(),
    last_login           DATETIME2     NULL,
    reset_token          NVARCHAR(255) NULL,
    reset_token_expiry   DATETIME2     NULL,
    CONSTRAINT CK_Parents_Role   CHECK (role IN ('USER','ADMIN')),
    CONSTRAINT CK_Parents_Status CHECK (status IN ('UNVERIFIED', 'ACTIVE', 'SUSPENDED', 'DELETED')),
    CONSTRAINT CK_Parents_Email  CHECK (email LIKE '%@%.%')
);
GO

-- Children Table
CREATE TABLE dbo.Children (
    child_id      INT           IDENTITY(1,1) PRIMARY KEY,
    parent_id     INT           NOT NULL REFERENCES dbo.Parents(parent_id) ON DELETE CASCADE,
    full_name     NVARCHAR(100) NOT NULL,
    date_of_birth DATE          NOT NULL,
    gender        NVARCHAR(10)  NOT NULL
);
GO

-- Posts Table
CREATE TABLE dbo.Posts (
    post_id          INT           IDENTITY(1,1) PRIMARY KEY,
    child_id         INT           NOT NULL REFERENCES dbo.Children(child_id),
    title            NVARCHAR(255) NULL, -- Added title
    content          NVARCHAR(MAX) NOT NULL,
    image_url        NVARCHAR(255) NULL,
    status           NVARCHAR(50)  NOT NULL DEFAULT 'PENDING', -- Added status
    is_approved      BIT           DEFAULT 0,
    approved_by      INT           NULL REFERENCES dbo.Parents(parent_id),
    approval_date    DATETIME2     NULL,
    moderation_score FLOAT         NULL,
    moderation_flag  BIT           DEFAULT 0,
    created_at       DATETIME2     NOT NULL DEFAULT GETDATE(),
    updated_at       DATETIME2     NULL,
    CONSTRAINT CK_Posts_Status CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED'))
);
GO

-- ContentReports Table
CREATE TABLE dbo.ContentReports (
    report_id   INT           IDENTITY(1,1) PRIMARY KEY,
    post_id     INT           NOT NULL REFERENCES dbo.Posts(post_id) ON DELETE CASCADE,
    reporter_id INT           NOT NULL REFERENCES dbo.Parents(parent_id),
    reason      NVARCHAR(MAX) NOT NULL,
    status      NVARCHAR(50)  NOT NULL DEFAULT 'PENDING',
    created_at  DATETIME2     NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_ContentReports_Status CHECK (status IN ('PENDING', 'REVIEWED', 'RESOLVED'))
);
GO

-- ActivityLog Table
CREATE TABLE dbo.activity_log (
    id             INT           IDENTITY(1,1) PRIMARY KEY,
    activity_type  NVARCHAR(50)  NOT NULL,
    description    NVARCHAR(MAX) NOT NULL,
    admin_email    NVARCHAR(100) NULL,
    admin_name     NVARCHAR(100) NULL,
    ip_address     NVARCHAR(45)  NULL,
    metadata       NVARCHAR(MAX) NULL,
    timestamp      DATETIME2     NOT NULL DEFAULT GETDATE()
);
GO

-- Create Indexes for performance
CREATE INDEX IDX_ActivityLog_Timestamp ON dbo.activity_log(timestamp DESC);
CREATE INDEX IDX_Posts_Status ON dbo.Posts(status);
GO

-- Settings Table
CREATE TABLE dbo.Settings (
    setting_key   NVARCHAR(100) PRIMARY KEY,
    setting_value NVARCHAR(MAX) NOT NULL
);
GO

-- 4) Seed Data

-- Seed sample settings
INSERT INTO dbo.Settings (setting_key, setting_value)
VALUES
('site_name', 'KidSocial Network'),
('maintenance_mode', 'false'),
('registration_enabled', 'true'),
('max_posts_per_day', '10');
GO

-- Seed sample parents
INSERT INTO dbo.Parents (email, password, full_name, phone, is_verified, role, status)
VALUES
('admin@gmail.com', 'admin123', 'Admin User', '0901234567', 1, 'ADMIN', 'ACTIVE'),
('user1@gmail.com', 'user123', 'John Doe', '0902345678', 1, 'USER', 'ACTIVE'),
('user2@gmail.com', 'user123', 'Jane Smith', '0903456789', 1, 'USER', 'ACTIVE'),
('user3@gmail.com', 'user123', 'Mike Johnson', '0904567890', 0, 'USER', 'SUSPENDED');
GO

-- Seed sample children
INSERT INTO dbo.Children(parent_id, full_name, date_of_birth, gender)
VALUES
((SELECT parent_id FROM dbo.Parents WHERE email='user1@gmail.com'), 'Emma Doe', '2018-06-01', 'Female'),
((SELECT parent_id FROM dbo.Parents WHERE email='user1@gmail.com'), 'Liam Doe', '2015-09-15', 'Male'),
((SELECT parent_id FROM dbo.Parents WHERE email='user2@gmail.com'), 'Sophia Smith', '2019-02-20', 'Female'),
((SELECT parent_id FROM dbo.Parents WHERE email='user3@gmail.com'), 'Noah Johnson', '2016-11-10', 'Male');
GO

-- Seed sample posts
INSERT INTO dbo.Posts(child_id, title, content, status)
VALUES
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'My First Drawing', 'I drew a rainbow today!', 'APPROVED'),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'Fun at the Park', 'We went to the park and played!', 'PENDING'),
((SELECT child_id FROM dbo.Children WHERE full_name='Liam Doe'), 'Science Project', 'I made a volcano that erupts!', 'PENDING'),
((SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 'My Cute Cat', 'My cat Whiskers is very cute.', 'REJECTED');
GO

-- Seed sample reports
INSERT INTO dbo.ContentReports(post_id, reporter_id, reason, status)
VALUES
((SELECT post_id FROM dbo.Posts WHERE title='Fun at the Park'), (SELECT parent_id FROM dbo.Parents WHERE email='user2@gmail.com'), 'This seems a bit vague.', 'PENDING'),
((SELECT post_id FROM dbo.Posts WHERE title='Science Project'), (SELECT parent_id FROM dbo.Parents WHERE email='user1@gmail.com'), 'Could be unsafe for kids to replicate.', 'PENDING');
GO

-- Seed sample activity logs
INSERT INTO dbo.activity_log (activity_type, description, admin_email, admin_name)
VALUES 
('USER_REGISTRATION', 'New user registered: user2@gmail.com', 'SYSTEM', 'System'),
('POST_APPROVED', 'Post "My First Drawing" was approved', 'admin@gmail.com', 'Admin User'),
('CONTENT_REPORTED', 'Post "Fun at the Park" was reported', 'user2@gmail.com', 'Jane Smith');
GO

PRINT 'Database KidSocialDB created and seeded successfully.';
GO


-- ... existing code ...
CREATE TABLE Posts (
    post_id INT PRIMARY KEY IDENTITY(1,1),
    child_id INT NOT NULL,
    title NVARCHAR(255),
    content NVARCHAR(MAX),
    image_url VARCHAR(255), -- For storing the path to the uploaded image
    status VARCHAR(50) DEFAULT 'PENDING', -- PENDING, APPROVED, REJECTED
    created_at DATETIME DEFAULT GETDATE(),
    reviewed_by INT, -- Admin (parent_id) who reviewed the post
-- ... existing code ...

ALTER TABLE Posts
ADD image_url VARCHAR(255);



-- Design for the AudioStories table
CREATE TABLE AudioStories (
    story_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    audio_path VARCHAR(255) NOT NULL,
    thumbnail_path VARCHAR(255),
    duration_seconds INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Design for the AudioStories table
CREATE TABLE AudioStories (
    story_id INT PRIMARY KEY IDENTITY(1,1),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    audio_path VARCHAR(255) NOT NULL,
    thumbnail_path VARCHAR(255),
    duration_seconds INT,
    created_at DATETIME DEFAULT GETDATE()
);
USE [KidSocialDB];
GO
-- Xóa bảng cũ nếu tồn tại để tránh lỗi khi chạy lại script
IF OBJECT_ID('AudioStories', 'U') IS NOT NULL
    DROP TABLE AudioStories;
GO
USE [KidSocialDB];
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
(N'Cô Bé Quàng Khăn Đỏ', N'Bài học cảnh giác cho các em nhỏ qua câu chuyện về cô bé quàng khăn đỏ và con sói gian ác.', 'assets/audio/khan-do.mp3', 'assets/images/khan-do.jpg', 240),
(N'Chú Mèo Đi Hia', N'Một câu chuyện cổ tích kinh điển về chú mèo thông minh và người chủ của mình.', 'assets/audio/meo-di-hia.mp3', 'assets/images/meo-di-hia.jpg', 300),
(N'Sự Tích Cây Vú Sữa', N'Câu chuyện cảm động về tình mẫu tử thiêng liêng.', 'assets/audio/vu-sua.mp3', 'assets/images/vu-sua.jpg', 360);
GO

USE KidSocialDB;
GO

-- Xóa các bảng theo đúng thứ tự để không vi phạm ràng buộc khóa ngoại
DROP TABLE IF EXISTS Answers;
DROP TABLE IF EXISTS Questions;
DROP TABLE IF EXISTS Quizzes;
GO

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

DELETE FROM EducationalVideos;
GO


SELECT * FROM EducationalVideos;
GO 