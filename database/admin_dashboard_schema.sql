-- Create Activity Log table for tracking admin activities
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='activity_log' AND xtype='U')
CREATE TABLE activity_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    activity_type VARCHAR(50) NOT NULL,
    description NVARCHAR(500) NOT NULL,
    admin_email VARCHAR(255) NOT NULL,
    admin_name VARCHAR(255),
    timestamp DATETIME2 DEFAULT GETDATE(),
    ip_address VARCHAR(45),
    metadata NVARCHAR(MAX) -- JSON for additional data
);

-- Create indexes for performance
CREATE INDEX IX_activity_log_timestamp ON activity_log(timestamp DESC);
CREATE INDEX IX_activity_log_admin ON activity_log(admin_email);
CREATE INDEX IX_posts_status ON Posts(status);
CREATE INDEX IX_reports_status ON Reports(status);
CREATE INDEX IX_parents_created_at ON Parents(created_at);

-- Dashboard statistics view for optimized queries
CREATE VIEW vw_dashboard_stats AS
SELECT 
    (SELECT COUNT(*) FROM Parents WHERE status != 'DELETED') as total_users,
    (SELECT COUNT(*) FROM Posts) as total_posts,
    (SELECT COUNT(*) FROM Posts WHERE status = 'PENDING') as pending_posts,
    (SELECT COUNT(*) FROM Reports WHERE status = 'ACTIVE') as active_reports,
    (SELECT COUNT(*) FROM Parents WHERE created_at >= DATEADD(month, -1, GETDATE()) AND status != 'DELETED') as users_this_month,
    (SELECT COUNT(*) FROM Parents WHERE created_at >= DATEADD(month, -2, GETDATE()) AND created_at < DATEADD(month, -1, GETDATE()) AND status != 'DELETED') as users_last_month,
    (SELECT COUNT(*) FROM Posts WHERE created_at >= DATEADD(month, -1, GETDATE())) as posts_this_month,
    (SELECT COUNT(*) FROM Posts WHERE created_at >= DATEADD(month, -2, GETDATE()) AND created_at < DATEADD(month, -1, GETDATE())) as posts_last_month;