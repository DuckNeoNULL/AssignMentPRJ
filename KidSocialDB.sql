-- Tạo CSDL
CREATE DATABASE KidSocialDBb;
GO
USE KidSocialDBb;
GO

-- 1. Bảng Parents
CREATE TABLE Parents (
    parent_id INT PRIMARY KEY IDENTITY(1,1),
    email NVARCHAR(100) UNIQUE NOT NULL,
    password_hash NVARCHAR(100) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    verification_code NVARCHAR(10),
    is_verified BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    last_login DATETIME,
    reset_token NVARCHAR(100),
    reset_token_expiry DATETIME
);

-- 2. Bảng Children
CREATE TABLE Children (
    child_id INT PRIMARY KEY IDENTITY(1,1),
    parent_id INT NOT NULL,
    name NVARCHAR(100) NOT NULL,
    age INT NOT NULL CHECK (age BETWEEN 3 AND 12),
    avatar_url NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_Children_Parents FOREIGN KEY (parent_id) REFERENCES Parents(parent_id)
);

-- 3. Bảng Posts
CREATE TABLE Posts (
    post_id INT PRIMARY KEY IDENTITY(1,1),
    child_id INT NOT NULL,
    content NVARCHAR(MAX),
    image_url NVARCHAR(255),
    is_approved BIT DEFAULT 0,
    approved_by INT NULL,
    approval_date DATETIME,
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME,
    moderation_score FLOAT,
    moderation_flag BIT DEFAULT 0,
    CONSTRAINT FK_Posts_Children FOREIGN KEY (child_id) REFERENCES Children(child_id),
    CONSTRAINT FK_Posts_ApprovedBy FOREIGN KEY (approved_by) REFERENCES Parents(parent_id)
);

-- 4. Bảng Courses
CREATE TABLE Courses (
    course_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    description NVARCHAR(MAX),
    content_url NVARCHAR(255),
    age_min INT NOT NULL DEFAULT 3,
    age_max INT NOT NULL DEFAULT 12,
    thumbnail_url NVARCHAR(255),
    created_by INT,
    created_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1,
    CONSTRAINT FK_Courses_Parents FOREIGN KEY (created_by) REFERENCES Parents(parent_id),
    CONSTRAINT CHK_Age_Range CHECK (age_min <= age_max)
);

-- 5. Bảng Drawings
CREATE TABLE Drawings (
    drawing_id INT PRIMARY KEY IDENTITY(1,1),
    child_id INT NOT NULL,
    image_url NVARCHAR(255) NOT NULL,
    title NVARCHAR(100),
    created_at DATETIME DEFAULT GETDATE(),
    is_approved BIT DEFAULT 1,
    approved_by INT NULL,
    CONSTRAINT FK_Drawings_Child FOREIGN KEY (child_id) REFERENCES Children(child_id),
    CONSTRAINT FK_Drawings_Approved FOREIGN KEY (approved_by) REFERENCES Parents(parent_id)
);

-- 6. Bảng ContentReports
CREATE TABLE ContentReports (
    report_id INT PRIMARY KEY IDENTITY(1,1),
    post_id INT NULL,
    drawing_id INT NULL,
    reporter_id INT NOT NULL,
    reason NVARCHAR(MAX) NOT NULL,
    status NVARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'reviewed', 'resolved')),
    reviewed_by INT NULL,
    review_notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    resolved_at DATETIME,
    CONSTRAINT FK_Report_Post FOREIGN KEY (post_id) REFERENCES Posts(post_id),
    CONSTRAINT FK_Report_Drawing FOREIGN KEY (drawing_id) REFERENCES Drawings(drawing_id),
    CONSTRAINT FK_Report_Reporter FOREIGN KEY (reporter_id) REFERENCES Parents(parent_id),
    CONSTRAINT FK_Report_Reviewer FOREIGN KEY (reviewed_by) REFERENCES Parents(parent_id),
    CONSTRAINT CHK_Report_HasContent CHECK (post_id IS NOT NULL OR drawing_id IS NOT NULL)
);

-- 7. Bảng SensitiveKeywords
CREATE TABLE SensitiveKeywords (
    keyword_id INT PRIMARY KEY IDENTITY(1,1),
    keyword NVARCHAR(100) NOT NULL UNIQUE,
    severity INT DEFAULT 1 CHECK (severity BETWEEN 1 AND 3),
    added_by INT,
    added_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1,
    CONSTRAINT FK_Keywords_Parent FOREIGN KEY (added_by) REFERENCES Parents(parent_id)
);

-- 8. Bảng RecommendedBooks
CREATE TABLE RecommendedBooks (
    book_id INT PRIMARY KEY IDENTITY(1,1),
    title NVARCHAR(255) NOT NULL,
    author NVARCHAR(100),
    age_min INT DEFAULT 3,
    age_max INT DEFAULT 12,
    description NVARCHAR(MAX),
    cover_url NVARCHAR(255),
    amazon_url NVARCHAR(255),
    added_at DATETIME DEFAULT GETDATE(),
    is_active BIT DEFAULT 1
);

-- 9. Bảng BookSearches
CREATE TABLE BookSearches (
    search_id INT PRIMARY KEY IDENTITY(1,1),
    child_id INT,
    search_term NVARCHAR(255) NOT NULL,
    search_date DATETIME DEFAULT GETDATE(),
    results_count INT,
    CONSTRAINT FK_Search_Child FOREIGN KEY (child_id) REFERENCES Children(child_id)
);

-- 10. Bảng Activities
CREATE TABLE Activities (
    activity_id INT PRIMARY KEY IDENTITY(1,1),
    child_id INT NOT NULL,
    activity_type NVARCHAR(50) NOT NULL CHECK (activity_type IN ('post', 'drawing', 'course_view', 'book_search')),
    target_id INT,
    activity_date DATETIME DEFAULT GETDATE(),
    details NVARCHAR(MAX),
    CONSTRAINT FK_Activity_Child FOREIGN KEY (child_id) REFERENCES Children(child_id)
);

-- 🔍 Tối ưu hiệu năng bằng chỉ mục
CREATE INDEX IDX_Posts_Child ON Posts(child_id);
CREATE INDEX IDX_Posts_Approval ON Posts(is_approved);
CREATE INDEX IDX_Children_Parent ON Children(parent_id);
CREATE INDEX IDX_ContentReports_Status ON ContentReports(status);
CREATE INDEX IDX_BookSearches_Child ON BookSearches(child_id);

-- Parents mẫu
INSERT INTO Parents (email, password_hash, full_name, phone, is_verified)
VALUES
('admin@gmail.com', '123', N'Nguyễn Văn An', '0912345678', 1),
('phu1@gmail.com', 'abc123', N'Trần Thị Bình', '0987654321', 1);

-- Children mẫu
INSERT INTO Children (parent_id, name, age, avatar_url)
VALUES
(1, N'Bé A', 7, 'https://example.com/avatars/a.png'),
(2, N'Bé B', 10, 'https://example.com/avatars/b.png');

-- Posts mẫu
INSERT INTO Posts (child_id, content, image_url, is_approved)
VALUES
(1, N'Con thích vẽ tranh về thiên nhiên!', 'https://example.com/images/forest.png', 1);


