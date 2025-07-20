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
    password             NVARCHAR(100) NOT NULL,
    full_name            NVARCHAR(100) NOT NULL,
    phone                NVARCHAR(20)  NULL,
    verification_code    NVARCHAR(10)  NULL,
    verification_code_expiry DATETIME,
    is_verified          BIT           NOT NULL DEFAULT 0,
    verification_expiry  DATETIME2     NULL,
    role                 NVARCHAR(20)  NOT NULL DEFAULT 'USER',
    status               NVARCHAR(20)  NOT NULL DEFAULT 'UNVERIFIED',
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
    title            NVARCHAR(255) NULL,
    content          NVARCHAR(MAX) NOT NULL,
    image_url        NVARCHAR(255) NULL,
    status           NVARCHAR(50)  NOT NULL DEFAULT 'PENDING',
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

-- Friendships Table
CREATE TABLE dbo.Friendships (
    friendship_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id_1    INT NOT NULL REFERENCES dbo.Children(child_id),
    child_id_2    INT NOT NULL REFERENCES dbo.Children(child_id),
    status        NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
    created_at    DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_Friendships_Status CHECK (status IN ('PENDING', 'ACCEPTED', 'REJECTED')),
    CONSTRAINT UQ_Friendships_Unique UNIQUE (child_id_1, child_id_2)
);
GO

-- Reactions Table
CREATE TABLE dbo.Reactions (
    reaction_id   INT IDENTITY(1,1) PRIMARY KEY,
    post_id       INT NOT NULL REFERENCES dbo.Posts(post_id) ON DELETE CASCADE,
    child_id      INT NOT NULL REFERENCES dbo.Children(child_id),
    reaction_type NVARCHAR(20) NOT NULL,
    created_at    DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT CK_Reactions_Type CHECK (reaction_type IN ('LIKE', 'HEART', 'SMILE', 'WOW')),
    CONSTRAINT UQ_Reactions_Unique UNIQUE (post_id, child_id)
);
GO

-- Comments Table
CREATE TABLE dbo.Comments (
    comment_id INT IDENTITY(1,1) PRIMARY KEY,
    post_id    INT NOT NULL REFERENCES dbo.Posts(post_id) ON DELETE CASCADE,
    child_id   INT NOT NULL REFERENCES dbo.Children(child_id),
    content    NVARCHAR(MAX) NOT NULL,
    created_at DATETIME2 NOT NULL DEFAULT GETDATE()
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

-- AudioStories Table
CREATE TABLE dbo.AudioStories (
    story_id         INT IDENTITY(1,1) PRIMARY KEY,
    title            NVARCHAR(255) NOT NULL,
    description      NVARCHAR(MAX),
    audio_path       NVARCHAR(255) NOT NULL,
    thumbnail_path   NVARCHAR(255),
    duration_seconds INT,
    created_at       DATETIME2 DEFAULT GETDATE()
);
GO

-- EducationalVideos Table
CREATE TABLE dbo.EducationalVideos (
    video_id         INT IDENTITY(1,1) PRIMARY KEY,
    title            NVARCHAR(255) NOT NULL,
    description      NVARCHAR(MAX),
    youtube_embed_url NVARCHAR(500) NOT NULL,
    thumbnail_path   NVARCHAR(500),
    category         NVARCHAR(100)
);
GO

-- Settings Table
CREATE TABLE dbo.Settings (
    setting_key   NVARCHAR(100) PRIMARY KEY,
    setting_value NVARCHAR(MAX) NOT NULL
);
GO

-- UserStats Table (for tracking achievements)
CREATE TABLE dbo.UserStats (
    child_id INT PRIMARY KEY REFERENCES dbo.Children(child_id),
    posts_count INT DEFAULT 0,
    drawings_count INT DEFAULT 0,
    stories_count INT DEFAULT 0,
    friends_count INT DEFAULT 0,
    audio_stories_heard INT DEFAULT 0,
    videos_watched INT DEFAULT 0,
    chat_sessions INT DEFAULT 0,
    total_xp INT DEFAULT 0,
    current_level INT DEFAULT 1,
    last_updated DATETIME2 DEFAULT GETDATE()
);
GO

-- Achievements Table
CREATE TABLE dbo.Achievements (
    achievement_id INT IDENTITY(1,1) PRIMARY KEY,
    child_id INT REFERENCES dbo.Children(child_id),
    badge_type NVARCHAR(50) NOT NULL,
    badge_name NVARCHAR(100) NOT NULL,
    description NVARCHAR(MAX),
    icon NVARCHAR(50),
    earned_date DATETIME2 DEFAULT GETDATE(),
    is_special BIT DEFAULT 0
);
GO

-- Create Indexes for performance
CREATE INDEX IDX_ActivityLog_Timestamp ON dbo.activity_log(timestamp DESC);
CREATE INDEX IDX_Posts_Status ON dbo.Posts(status);
CREATE INDEX IDX_Posts_ChildId ON dbo.Posts(child_id);
CREATE INDEX IDX_Friendships_Status ON dbo.Friendships(status);
CREATE INDEX IDX_Reactions_PostId ON dbo.Reactions(post_id);
CREATE INDEX IDX_Achievements_ChildId ON dbo.Achievements(child_id);
CREATE INDEX IDX_UserStats_ChildId ON dbo.UserStats(child_id);
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
('user3@gmail.com', 'user123', 'Mike Johnson', '0904567890', 0, 'USER', 'SUSPENDED'),
('user4@gmail.com', 'user123', 'John Smith', '0905678901', 1, 'USER', 'ACTIVE'),
('user5@gmail.com', 'user123', 'Michael Wilson', '0906789012', 1, 'USER', 'ACTIVE'),
('user6@gmail.com', 'user123', 'Sarah Brown', '0907890123', 1, 'USER', 'ACTIVE'),
('user7@gmail.com', 'user123', 'David Davis', '0908901234', 1, 'USER', 'ACTIVE');
GO

-- Seed sample children (including all missing children)
INSERT INTO dbo.Children(parent_id, full_name, date_of_birth, gender)
VALUES
((SELECT parent_id FROM dbo.Parents WHERE email='user1@gmail.com'), 'Emma Doe', '2018-06-01', 'Female'),
((SELECT parent_id FROM dbo.Parents WHERE email='user1@gmail.com'), 'Liam Doe', '2015-09-15', 'Male'),
((SELECT parent_id FROM dbo.Parents WHERE email='user2@gmail.com'), 'Sophia Smith', '2019-02-20', 'Female'),
((SELECT parent_id FROM dbo.Parents WHERE email='user3@gmail.com'), 'Noah Johnson', '2016-11-10', 'Male'),
((SELECT parent_id FROM dbo.Parents WHERE email='user4@gmail.com'), 'Liam Johnson', '2018-03-15', 'Male'),
((SELECT parent_id FROM dbo.Parents WHERE email='user5@gmail.com'), 'Oliver Wilson', '2017-08-22', 'Male'),
((SELECT parent_id FROM dbo.Parents WHERE email='user6@gmail.com'), 'Ava Brown', '2019-01-10', 'Female'),
((SELECT parent_id FROM dbo.Parents WHERE email='user7@gmail.com'), 'Noah Davis', '2018-11-05', 'Male');
GO

-- Seed sample posts (including test posts for all features)
INSERT INTO dbo.Posts(child_id, title, content, status, created_at)
VALUES
-- Original posts
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'My First Drawing', 'I drew a rainbow today!', 'APPROVED', GETDATE()),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'Fun at the Park', 'We went to the park and played!', 'PENDING', GETDATE()),
((SELECT child_id FROM dbo.Children WHERE full_name='Liam Doe'), 'Science Project', 'I made a volcano that erupts!', 'PENDING', GETDATE()),
((SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 'My Cute Cat', 'My cat Whiskers is very cute.', 'REJECTED', GETDATE()),

-- Test posts for "My Posts" feature
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'Chuyến đi công viên vui vẻ', 'Hôm nay em đi công viên với gia đình. Em đã chơi cầu trượt và xích đu. Thật là một ngày tuyệt vời!', 'APPROVED', GETDATE()),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'Vẽ tranh về gia đình', 'Em vẽ tranh về gia đình em. Có bố, mẹ, em và chú mèo con.', 'PENDING', GETDATE()),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'Bài viết không phù hợp', 'Nội dung này không phù hợp với trẻ em.', 'REJECTED', GETDATE()),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'Học vẽ hoa hướng dương', 'Hôm nay em học vẽ hoa hướng dương. Cô giáo khen em vẽ đẹp lắm!', 'APPROVED', DATEADD(day, -1, GETDATE())),

-- Test posts for "Friend Posts" feature
((SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 'Bài viết test từ Sophia', 'Xin chào! Đây là bài viết test từ Sophia để Emma có thể xem.', 'APPROVED', GETDATE()),
((SELECT child_id FROM dbo.Children WHERE full_name='Oliver Wilson'), 'Bài viết từ Oliver', 'Chào các bạn! Tôi là Oliver và tôi thích chơi bóng đá.', 'APPROVED', DATEADD(day, -1, GETDATE())),
((SELECT child_id FROM dbo.Children WHERE full_name='Ava Brown'), 'Bài viết từ Ava', 'Hôm nay tôi học vẽ và tôi rất vui!', 'APPROVED', DATEADD(day, -2, GETDATE())),
((SELECT child_id FROM dbo.Children WHERE full_name='Liam Johnson'), 'Bài viết từ Liam', 'Tôi thích đọc sách và khám phá thế giới!', 'PENDING', GETDATE());
GO

-- Seed sample friendships (including all test friendships)
INSERT INTO dbo.Friendships(child_id_1, child_id_2, status, created_at)
VALUES
-- Original friendships
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 
 (SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 'ACCEPTED', GETDATE()),
((SELECT child_id FROM dbo.Children WHERE full_name='Liam Doe'), 
 (SELECT child_id FROM dbo.Children WHERE full_name='Noah Johnson'), 'PENDING', GETDATE()),

-- Test friendships for Emma
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 
 (SELECT child_id FROM dbo.Children WHERE full_name='Liam Johnson'), 'PENDING', DATEADD(hour, -1, GETDATE())),
((SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 
 (SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'PENDING', DATEADD(hour, -2, GETDATE())),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 
 (SELECT child_id FROM dbo.Children WHERE full_name='Oliver Wilson'), 'ACCEPTED', DATEADD(day, -1, GETDATE())),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 
 (SELECT child_id FROM dbo.Children WHERE full_name='Ava Brown'), 'ACCEPTED', DATEADD(day, -2, GETDATE())),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 
 (SELECT child_id FROM dbo.Children WHERE full_name='Noah Davis'), 'REJECTED', DATEADD(day, -3, GETDATE()));
GO

-- Seed sample audio stories
INSERT INTO dbo.AudioStories (title, description, audio_path, thumbnail_path, duration_seconds)
VALUES
(N'Cô Bé Quàng Khăn Đỏ', N'Bài học cảnh giác cho các em nhỏ qua câu chuyện về cô bé quàng khăn đỏ và con sói gian ác.', 'assets/audio/khan-do.mp3', 'assets/images/khan-do.jpg', 240),
(N'Chú Mèo Đi Hia', N'Một câu chuyện cổ tích kinh điển về chú mèo thông minh và người chủ của mình.', 'assets/audio/meo-di-hia.mp3', 'assets/images/meo-di-hia.jpg', 300),
(N'Sự Tích Cây Vú Sữa', N'Câu chuyện cảm động về tình mẫu tử thiêng liêng.', 'assets/audio/vu-sua.mp3', 'assets/images/vu-sua.jpg', 360);
GO

-- Seed sample educational videos
INSERT INTO dbo.EducationalVideos (title, description, youtube_embed_url, thumbnail_path, category)
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

-- Seed sample content reports
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

-- Seed sample user stats for achievements
INSERT INTO dbo.UserStats (child_id, posts_count, drawings_count, stories_count, friends_count, audio_stories_heard, videos_watched, chat_sessions, total_xp, current_level)
VALUES
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 8, 12, 5, 7, 25, 18, 15, 2450, 3),
((SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 5, 8, 3, 4, 15, 12, 8, 1800, 2),
((SELECT child_id FROM dbo.Children WHERE full_name='Liam Johnson'), 3, 6, 2, 3, 10, 8, 5, 1200, 2),
((SELECT child_id FROM dbo.Children WHERE full_name='Oliver Wilson'), 6, 10, 4, 5, 20, 15, 12, 2100, 3);
GO

-- Seed sample achievements
INSERT INTO dbo.Achievements (child_id, badge_type, badge_name, description, icon, is_special)
VALUES
-- Emma's achievements
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'POSTS', 'Nhà văn nhí', 'Viết được 5 bài viết', '✍️', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'DRAWINGS', 'Họa sĩ nhí', 'Vẽ được 10 bức tranh', '🎨', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'FRIENDS', 'Bạn bè tốt', 'Kết bạn với 5 người', '🤝', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'AUDIO', 'Mọt sách', 'Nghe 20 truyện audio', '📚', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'VIDEOS', 'Người xem chăm chỉ', 'Xem 15 video học tập', '🎬', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'CHAT', 'Người trò chuyện', 'Chat với Kiki 10 lần', '💬', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Emma Doe'), 'SPECIAL', 'Người đầu tiên', 'Là người đầu tiên viết bài trong ngày', '🥇', 1),

-- Sophia's achievements
((SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 'POSTS', 'Nhà văn nhí', 'Viết được 5 bài viết', '✍️', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 'DRAWINGS', 'Họa sĩ nhí', 'Vẽ được 10 bức tranh', '🎨', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Sophia Smith'), 'FRIENDS', 'Bạn bè tốt', 'Kết bạn với 5 người', '🤝', 0),

-- Liam's achievements
((SELECT child_id FROM dbo.Children WHERE full_name='Liam Johnson'), 'POSTS', 'Nhà văn nhí', 'Viết được 5 bài viết', '✍️', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Liam Johnson'), 'DRAWINGS', 'Họa sĩ nhí', 'Vẽ được 10 bức tranh', '🎨', 0),

-- Oliver's achievements
((SELECT child_id FROM dbo.Children WHERE full_name='Oliver Wilson'), 'POSTS', 'Nhà văn nhí', 'Viết được 5 bài viết', '✍️', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Oliver Wilson'), 'DRAWINGS', 'Họa sĩ nhí', 'Vẽ được 10 bức tranh', '🎨', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Oliver Wilson'), 'FRIENDS', 'Bạn bè tốt', 'Kết bạn với 5 người', '🤝', 0),
((SELECT child_id FROM dbo.Children WHERE full_name='Oliver Wilson'), 'AUDIO', 'Mọt sách', 'Nghe 20 truyện audio', '📚', 0);
GO

-- 5) Verification and Test Queries

PRINT '=== KIỂM TRA DỮ LIỆU SAU KHI TẠO ===';

-- Check all tables and record counts
PRINT '--- Số lượng bản ghi trong các bảng ---';
SELECT 'Parents' as TableName, COUNT(*) as RecordCount FROM dbo.Parents
UNION ALL
SELECT 'Children', COUNT(*) FROM dbo.Children
UNION ALL
SELECT 'Posts', COUNT(*) FROM dbo.Posts
UNION ALL
SELECT 'Friendships', COUNT(*) FROM dbo.Friendships
UNION ALL
SELECT 'AudioStories', COUNT(*) FROM dbo.AudioStories
UNION ALL
SELECT 'EducationalVideos', COUNT(*) FROM dbo.EducationalVideos
UNION ALL
SELECT 'ContentReports', COUNT(*) FROM dbo.ContentReports
UNION ALL
SELECT 'ActivityLog', COUNT(*) FROM dbo.activity_log;

-- Check children data
PRINT '--- Danh sách trẻ em ---';
SELECT 
    c.child_id,
    c.full_name as child_name,
    c.gender,
    c.date_of_birth,
    p.full_name as parent_name
FROM dbo.Children c
INNER JOIN dbo.Parents p ON c.parent_id = p.parent_id
ORDER BY c.full_name;

-- Check posts by status
PRINT '--- Bài viết theo status ---';
SELECT 
    p.post_id,
    c.full_name as child_name,
    p.title,
    p.status,
    p.created_at
FROM dbo.Posts p
INNER JOIN dbo.Children c ON p.child_id = c.child_id
ORDER BY p.created_at DESC;

-- Check friendships
PRINT '--- Friendships ---';
SELECT 
    f.friendship_id,
    c1.full_name as child1_name,
    c2.full_name as child2_name,
    f.status,
    f.created_at,
    CASE 
        WHEN f.status = 'ACCEPTED' THEN '✅ Đã chấp nhận'
        WHEN f.status = 'PENDING' THEN '⏳ Đang chờ'
        WHEN f.status = 'REJECTED' THEN '❌ Bị từ chối'
        ELSE f.status
    END as status_vn
FROM dbo.Friendships f
INNER JOIN dbo.Children c1 ON f.child_id_1 = c1.child_id
INNER JOIN dbo.Children c2 ON f.child_id_2 = c2.child_id
ORDER BY f.created_at DESC;

-- Test: Emma's friends and their posts
PRINT '--- Test: Bạn bè của Emma và bài viết của họ ---';
DECLARE @emma_id INT = (SELECT child_id FROM dbo.Children WHERE full_name = 'Emma Doe');

-- Emma's accepted friends
SELECT 'Bạn bè đã chấp nhận của Emma:' as Info;
SELECT c.full_name
FROM dbo.Children c
INNER JOIN dbo.Friendships f ON (c.child_id = f.child_id_1 OR c.child_id = f.child_id_2)
WHERE f.status = 'ACCEPTED'
AND c.child_id != @emma_id
AND (f.child_id_1 = @emma_id OR f.child_id_2 = @emma_id);

-- Posts from Emma's friends
SELECT 'Bài viết từ bạn bè Emma:' as Info;
SELECT 
    p.post_id,
    c.full_name as author_name,
    p.title,
    p.content,
    p.status,
    p.created_at
FROM dbo.Posts p
INNER JOIN dbo.Children c ON p.child_id = c.child_id
WHERE p.status = 'APPROVED' 
AND p.child_id IN (
    SELECT child_id_1 FROM dbo.Friendships WHERE child_id_2 = @emma_id AND status = 'ACCEPTED'
    UNION 
    SELECT child_id_2 FROM dbo.Friendships WHERE child_id_1 = @emma_id AND status = 'ACCEPTED'
)
ORDER BY p.created_at DESC;

-- Emma's own posts by status
SELECT 'Bài viết của Emma theo status:' as Info;
SELECT 
    p.post_id,
    p.title,
    p.status,
    p.created_at,
    CASE 
        WHEN p.status = 'APPROVED' THEN '✅ Đã duyệt'
        WHEN p.status = 'PENDING' THEN '⏳ Đang chờ'
        WHEN p.status = 'REJECTED' THEN '❌ Bị từ chối'
        ELSE p.status
    END as status_vn
FROM dbo.Posts p
WHERE p.child_id = @emma_id
ORDER BY p.created_at DESC;

PRINT '=== DATABASE HOÀN TẤT ===';
PRINT 'Database KidSocialDB đã được tạo thành công với đầy đủ dữ liệu!';
PRINT 'Bạn có thể đăng nhập với:';
PRINT '- Admin: admin@gmail.com / admin123';
PRINT '- User: user1@gmail.com / user123 (Emma Doe)';
PRINT '- User: user2@gmail.com / user123 (Sophia Smith)';
PRINT 'Và test các tính năng:';
PRINT '1. Friend Posts (bài viết từ bạn bè)';
PRINT '2. My Posts (bài viết của tôi)';
PRINT '3. Friendship (kết bạn)';
GO 