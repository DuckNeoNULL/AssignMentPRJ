-- Drop the view if it already exists
IF OBJECT_ID('vw_dashboard_stats', 'v') IS NOT NULL
    DROP VIEW vw_dashboard_stats;
GO

-- Create the view
CREATE VIEW vw_dashboard_stats AS
WITH UserCounts AS (
    SELECT
        COUNT(*) AS total_users,
        SUM(CASE 
            WHEN created_at >= DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
            THEN 1 ELSE 0 
        END) AS users_this_month,
        SUM(CASE 
            WHEN created_at >= DATEADD(month, DATEDIFF(month, 0, GETDATE()) - 1, 0) AND created_at < DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
            THEN 1 ELSE 0 
        END) AS users_last_month
    FROM Parents
),
PostCounts AS (
    SELECT
        COUNT(*) AS total_posts,
        SUM(CASE WHEN status = 'PENDING' THEN 1 ELSE 0 END) AS pending_posts,
        SUM(CASE 
            WHEN created_at >= DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
            THEN 1 ELSE 0 
        END) AS posts_this_month,
        SUM(CASE 
            WHEN created_at >= DATEADD(month, DATEDIFF(month, 0, GETDATE()) - 1, 0) AND created_at < DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)
            THEN 1 ELSE 0 
        END) AS posts_last_month
    FROM Posts
),
ReportCounts AS (
    SELECT
        COUNT(*) AS active_reports,
        SUM(CASE WHEN CAST(created_at AS DATE) = CAST(GETDATE() AS DATE) THEN 1 ELSE 0 END) AS new_reports_today
    FROM ContentReports
    WHERE status = 'ACTIVE'
)
SELECT 
    ISNULL(uc.total_users, 0) AS total_users,
    ISNULL(pc.total_posts, 0) AS total_posts,
    ISNULL(pc.pending_posts, 0) AS pending_posts,
    ISNULL(rc.active_reports, 0) AS active_reports,
    ISNULL(uc.users_this_month, 0) AS users_this_month,
    ISNULL(uc.users_last_month, 0) AS users_last_month,
    ISNULL(pc.posts_this_month, 0) AS posts_this_month,
    ISNULL(pc.posts_last_month, 0) AS posts_last_month,
    ISNULL(rc.new_reports_today, 0) AS new_reports_today
FROM UserCounts uc, PostCounts pc, ReportCounts rc;
GO 