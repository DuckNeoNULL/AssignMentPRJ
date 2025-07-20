-- Script test đơn giản để kiểm tra database
USE KidSocialDB;

PRINT '=== KIỂM TRA DATABASE ĐƠN GIẢN ===';

-- 1. Kiểm tra số lượng bản ghi trong các bảng chính
PRINT '--- Số lượng bản ghi ---';
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
SELECT 'EducationalVideos', COUNT(*) FROM dbo.EducationalVideos;

-- 2. Kiểm tra bài viết mới nhất
PRINT '--- Bài viết mới nhất ---';
SELECT TOP 5
    p.post_id,
    c.full_name as child_name,
    p.title,
    p.status,
    p.created_at
FROM dbo.Posts p
INNER JOIN dbo.Children c ON p.child_id = c.child_id
ORDER BY p.created_at DESC;

-- 3. Test tạo bài viết mới (không dùng biến)
PRINT '--- Test tạo bài viết mới ---';
INSERT INTO dbo.Posts (child_id, title, content, image_url, status)
SELECT 
    child_id,
    'Test Post - ' + CAST(GETDATE() AS VARCHAR(20)),
    'Bài viết test được tạo lúc ' + CAST(GETDATE() AS VARCHAR(20)),
    'uploads/test_' + CAST(GETDATE() AS VARCHAR(20)) + '.jpg',
    'PENDING'
FROM dbo.Children 
WHERE full_name = 'Emma Doe';

-- 4. Kiểm tra bài viết vừa tạo
PRINT '--- Bài viết test vừa tạo ---';
SELECT TOP 1
    p.post_id,
    c.full_name as child_name,
    p.title,
    p.content,
    p.image_url,
    p.status,
    p.created_at
FROM dbo.Posts p
INNER JOIN dbo.Children c ON p.child_id = c.child_id
WHERE p.title LIKE 'Test Post - %'
ORDER BY p.created_at DESC;

PRINT '=== TEST HOÀN TẤT ==='; 