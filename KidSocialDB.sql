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
    is_verified          BIT           NOT NULL DEFAULT 0,
    verification_expiry  DATETIME2     NULL,
    role                 NVARCHAR(20)  NOT NULL DEFAULT 'USER',
    status               NVARCHAR(20)  NOT NULL DEFAULT 'ACTIVE', -- Added status
    created_at           DATETIME2     NOT NULL DEFAULT GETDATE(),
    last_login           DATETIME2     NULL,
    reset_token          NVARCHAR(255) NULL,
    reset_token_expiry   DATETIME2     NULL,
    CONSTRAINT CK_Parents_Role   CHECK (role IN ('USER','ADMIN')),
    CONSTRAINT CK_Parents_Status CHECK (status IN ('ACTIVE', 'SUSPENDED', 'DELETED')),
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