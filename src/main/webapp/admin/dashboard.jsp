<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%-- Session validation --%>
<c:if test="${sessionScope.userRole != 'ADMIN'}">
    <c:redirect url="${pageContext.request.contextPath}/login?error=access_denied"/>
</c:if>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Kid Social</title>
    
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        :root {
            --primary-color: #3b82f6;
            --primary-dark: #2563eb;
            --primary-light: #dbeafe;
            --secondary-color: #64748b;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
            --dark-color: #1e293b;
            --light-color: #f8fafc;
            --border-color: #e2e8f0;
            --text-primary: #0f172a;
            --text-secondary: #64748b;
            --sidebar-width: 280px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--light-color);
            color: var(--text-primary);
            line-height: 1.6;
        }

        /* Sidebar Styles */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            height: 100vh;
            width: var(--sidebar-width);
            background: linear-gradient(135deg, var(--primary-color) 0%, var(--primary-dark) 100%);
            color: white;
            z-index: 1000;
            transition: transform 0.3s ease;
            overflow-y: auto;
        }

        .sidebar-header {
            padding: 2rem 1.5rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-brand {
            font-family: 'Poppins', sans-serif;
            font-size: 1.5rem;
            font-weight: 700;
            color: white;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 0.75rem;
        }

        .sidebar-nav {
            padding: 1.5rem 0;
        }

        .nav-item {
            margin-bottom: 0.5rem;
        }

        .nav-link {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.875rem 1.5rem;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            transition: all 0.3s ease;
            border-radius: 0;
            font-weight: 500;
        }

        .nav-link:hover,
        .nav-link.active {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
            transform: translateX(4px);
        }

        .nav-link i {
            font-size: 1.1rem;
            width: 20px;
        }

        .nav-badge {
            background-color: white;
            color: var(--primary-color);
            font-size: 0.7rem;
            padding: 0.2rem 0.5rem;
            border-radius: 10px;
            margin-left: auto;
        }

        /* Main Content */
        .main-content {
            margin-left: var(--sidebar-width);
            min-height: 100vh;
            transition: margin-left 0.3s ease;
        }

        /* Header */
        .header {
            background: white;
            padding: 1rem 2rem;
            border-bottom: 1px solid var(--border-color);
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .page-title {
            font-family: 'Poppins', sans-serif;
            font-size: 1.75rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        .header-actions {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .search-form {
            position: relative;
            width: 300px;
        }

        .search-input {
            width: 100%;
            padding: 0.5rem 1rem 0.5rem 2.5rem;
            border-radius: 8px;
            border: 1px solid var(--border-color);
            font-size: 0.875rem;
            transition: all 0.2s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
        }

        .search-icon {
            position: absolute;
            left: 0.75rem;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-secondary);
        }

        .user-info {
            display: flex;
            align-items: center;
            gap: 1rem;
        }

        .user-avatar {
            width: 40px;
            height: 40px;
            background: var(--primary-light);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--primary-color);
            font-weight: 600;
        }

        .user-details h6 {
            margin: 0;
            font-weight: 600;
            color: var(--text-primary);
        }

        .user-details small {
            color: var(--text-secondary);
        }

        /* Dashboard Content */
        .dashboard-content {
            padding: 2rem;
        }

        .quick-actions {
            display: flex;
            gap: 1rem;
            margin-bottom: 2rem;
            flex-wrap: wrap;
        }

        .quick-action-btn {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.75rem 1.25rem;
            border-radius: 8px;
            font-weight: 500;
            transition: all 0.2s ease;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }

        .stat-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            cursor: pointer;
            position: relative;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 25px -5px rgba(0, 0, 0, 0.15);
        }

        .stat-header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 1rem;
        }

        .stat-icon {
            width: 48px;
            height: 48px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.25rem;
        }

        .stat-icon.primary {
            background: var(--primary-light);
            color: var(--primary-color);
        }

        .stat-icon.success {
            background: #dcfce7;
            color: var(--success-color);
        }

        .stat-icon.warning {
            background: #fef3c7;
            color: var(--warning-color);
        }

        .stat-icon.danger {
            background: #fee2e2;
            color: var(--danger-color);
        }

        .stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 0.25rem;
        }

        .stat-label {
            color: var(--text-secondary);
            font-weight: 500;
            margin-bottom: 0.5rem;
        }

        .stat-change {
            font-size: 0.875rem;
            font-weight: 500;
        }

        .stat-change.positive {
            color: var(--success-color);
        }

        .stat-change.negative {
            color: var(--danger-color);
        }

        .stat-tooltip {
            position: absolute;
            top: 1rem;
            right: 1rem;
            color: var(--text-secondary);
            cursor: help;
        }

        /* Recent Activity */
        .activity-card {
            background: white;
            border-radius: 16px;
            padding: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            border: 1px solid var(--border-color);
        }

        .activity-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1.5rem;
        }

        .activity-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: var(--text-primary);
            margin: 0;
        }

        .activity-actions {
            display: flex;
            gap: 0.5rem;
        }

        .activity-item {
            display: flex;
            align-items: center;
            gap: 1rem;
            padding: 1rem 0;
            border-bottom: 1px solid var(--border-color);
        }

        .activity-item:last-child {
            border-bottom: none;
        }

        .activity-icon {
            width: 36px;
            height: 36px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.875rem;
        }

        .activity-content h6 {
            margin: 0 0 0.25rem 0;
            font-weight: 500;
            color: var(--text-primary);
        }

        .activity-content small {
            color: var(--text-secondary);
        }

        /* Loading State */
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 1000;
            border-radius: 16px;
        }

        .spinner-border {
            width: 3rem;
            height: 3rem;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }

            .sidebar.show {
                transform: translateX(0);
            }

            .main-content {
                margin-left: 0;
            }

            .header {
                padding: 1rem;
            }

            .search-form {
                width: 100%;
                max-width: 200px;
            }

            .dashboard-content {
                padding: 1rem;
            }

            .stats-grid {
                grid-template-columns: 1fr;
            }

            .quick-actions {
                flex-direction: column;
            }
        }

        /* Buttons */
        .btn-primary {
            background: var(--primary-color);
            border-color: var(--primary-color);
            border-radius: 8px;
            font-weight: 500;
            padding: 0.5rem 1rem;
            transition: all 0.2s ease;
        }

        .btn-primary:hover {
            background: var(--primary-dark);
            border-color: var(--primary-dark);
            transform: translateY(-1px);
        }

        .btn-outline-primary {
            color: var(--primary-color);
            border-color: var(--primary-color);
            border-radius: 8px;
            font-weight: 500;
        }

        .btn-outline-primary:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }

        /* Tooltips */
        .tooltip-inner {
            max-width: 200px;
            padding: 0.5rem 1rem;
            background-color: var(--dark-color);
            border-radius: 6px;
            font-size: 0.875rem;
        }
    </style>
</head>
<body>
    <!-- Sidebar -->
    <nav class="sidebar">
        <div class="sidebar-header">
            <a href="${pageContext.request.contextPath}/admin/dashboard" class="sidebar-brand">
                <i class="bi bi-shield-check"></i>
                Kid Social Admin
            </a>
        </div>
        
        <ul class="sidebar-nav list-unstyled">
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link active">
                    <i class="bi bi-speedometer2"></i>
                    Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/users" class="nav-link">
                    <i class="bi bi-people"></i>
                    Users
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/posts" class="nav-link">
                    <i class="bi bi-file-post"></i>
                    Posts
                    <c:if test="${pendingApprovals > 0}">
                        <span class="nav-badge">${pendingApprovals}</span>
                    </c:if>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/reports" class="nav-link">
                    <i class="bi bi-flag"></i>
                    Reports
                    <c:if test="${activeReports > 0}">
                        <span class="nav-badge">${activeReports}</span>
                    </c:if>
                </a>
            </li>
            <li class="nav-item">
                <a href="${pageContext.request.contextPath}/admin/settings" class="nav-link">
                    <i class="bi bi-gear"></i>
                    Settings
                </a>
            </li>
            <li class="nav-item mt-4">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                    <i class="bi bi-box-arrow-right"></i>
                    Logout
                </a>
            </li>
        </ul>
    </nav>

    <!-- Main Content -->
    <div class="main-content">
        <!-- Header -->
        <header class="header">
            <div class="header-content">
                <h1 class="page-title">Dashboard</h1>
                
                <div class="header-actions">
                    <form class="search-form" action="${pageContext.request.contextPath}/admin/search" method="GET">
                        <i class="bi bi-search search-icon"></i>
                        <input type="text" class="search-input" placeholder="Search users, posts..." name="q">
                    </form>
                    <div class="user-info">
                        <div class="user-avatar">
                            <c:choose>
                                <c:when test="${not empty sessionScope.parentEmail}">
                                    ${sessionScope.parentEmail.substring(0,1).toUpperCase()}
                                </c:when>
                                <c:otherwise>A</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="user-details">
                            <h6>
                                <c:choose>
                                    <c:when test="${not empty sessionScope.parentEmail}">
                                        ${sessionScope.parentEmail}
                                    </c:when>
                                    <c:otherwise>Administrator</c:otherwise>
                                </c:choose>
                            </h6>
                            <small>${sessionScope.userRole}</small>
                        </div>
                    </div>
                </div>
            </div>
        </header>

        <!-- Dashboard Content -->
        <main class="dashboard-content">
            <!-- Error Message -->
            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-exclamation-triangle"></i>
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Quick Actions -->
            <div class="quick-actions">
                <a href="${pageContext.request.contextPath}/admin/posts?filter=pending" class="btn btn-warning quick-action-btn">
                    <i class="bi bi-clock"></i>
                    Review Pending Posts
                </a>
                <a href="${pageContext.request.contextPath}/admin/reports?filter=active" class="btn btn-danger quick-action-btn">
                    <i class="bi bi-flag"></i>
                    Handle Reports
                </a>
                <a href="${pageContext.request.contextPath}/admin/users?action=export" class="btn btn-outline-primary quick-action-btn">
                    <i class="bi bi-download"></i>
                    Export Data
                </a>
                <button class="btn btn-outline-secondary quick-action-btn" onclick="refreshDashboard()">
                    <i class="bi bi-arrow-clockwise"></i>
                    Refresh
                </button>
            </div>

            <!-- Statistics Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-header">
                        <h3>${stats.totalUsers}</h3>
                        <div class="stat-icon-wrapper bg-primary-light text-primary">
                            <i class="bi bi-people-fill"></i>
                            </div>
                            </div>
                    <p class="stat-label">Total Users</p>
                    <div class="stat-growth <c:if test='${stats.userGrowthPercentage < 0}'>text-danger</c:if><c:if test='${stats.userGrowthPercentage >= 0}'>text-success</c:if>">
                        <i class="bi <c:if test='${stats.userGrowthPercentage < 0}'>bi-arrow-down</c:if><c:if test='${stats.userGrowthPercentage >= 0}'>bi-arrow-up</c:if>"></i>
                        <fmt:formatNumber value="${Math.abs(stats.userGrowthPercentage)}" maxFractionDigits="1"/>% from last month
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <h3>${stats.totalPosts}</h3>
                        <div class="stat-icon-wrapper bg-success-light text-success">
                            <i class="bi bi-file-post"></i>
                        </div>
                    </div>
                    <p class="stat-label">Total Posts</p>
                    <div class="stat-growth <c:if test='${stats.postGrowthPercentage < 0}'>text-danger</c:if><c:if test='${stats.postGrowthPercentage >= 0}'>text-success</c:if>">
                        <i class="bi <c:if test='${stats.postGrowthPercentage < 0}'>bi-arrow-down</c:if><c:if test='${stats.postGrowthPercentage >= 0}'>bi-arrow-up</c:if>"></i>
                        <fmt:formatNumber value="${Math.abs(stats.postGrowthPercentage)}" maxFractionDigits="1"/>% from last month
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <h3>${stats.pendingPosts}</h3>
                        <div class="stat-icon-wrapper bg-warning-light text-warning">
                            <i class="bi bi-clock-history"></i>
                            </div>
                            </div>
                    <p class="stat-label">Pending Approvals</p>
                    <div class="stat-growth text-secondary">
                        <i class="bi bi-arrow-right"></i>
                        Awaiting review
                    </div>
                </div>

                <div class="stat-card">
                    <div class="stat-header">
                        <h3>${stats.activeReports}</h3>
                        <div class="stat-icon-wrapper bg-danger-light text-danger">
                            <i class="bi bi-flag-fill"></i>
                            </div>
                            </div>
                    <p class="stat-label">Active Reports</p>
                    <div class="stat-growth text-danger">
                        <i class="bi bi-exclamation-circle"></i>
                        <c:out value="${stats.newReportsToday}"/> new today
                        </div>
                        </div>
                    </div>
            <!-- End Stats Grid -->

            <!-- Recent Activity -->
            <div class="activity-card">
                <div class="activity-header">
                    <h3 class="activity-title">Recent Activity</h3>
                    <div class="activity-actions">
                        <button class="btn btn-outline-secondary btn-sm" onclick="refreshActivity()">
                            <i class="bi bi-arrow-clockwise"></i>
                        </button>
                        <a href="${pageContext.request.contextPath}/admin/activity" class="btn btn-outline-primary btn-sm">
                            View All
                        </a>
                    </div>
                </div>

                <div class="activity-list">
                    <c:choose>
                        <c:when test="${not empty recentActivities}">
                            <c:forEach var="activity" items="${recentActivities}">
                                <div class="activity-item">
                                    <div class="activity-icon ${activity.iconColorClass}">
                                        <i class="bi ${activity.iconClass}"></i>
                                    </div>
                                    <div class="activity-info">
                                        <p class="activity-description">${activity.description}</p>
                                        <small class="activity-timestamp">
                                            <i class="bi bi-clock"></i> 
                                            ${activity.timeAgo}
                                        </small>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center p-4">
                                <i class="bi bi-moon-stars fs-2 text-secondary"></i>
                                <p class="mt-2 text-secondary">No recent activity recorded.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </main>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Dashboard functionality
        class Dashboard {
            constructor() {
                this.refreshInterval = null;
                this.init();
            }
            
            init() {
                this.initTooltips();
                this.initEventListeners();
                this.startAutoRefresh();
                this.checkMobileView();
            }
            
            initTooltips() {
                var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
                var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
                    return new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }
            
            initEventListeners() {
                // Search form
                const searchForm = document.querySelector('.search-form');
                if (searchForm) {
                    searchForm.addEventListener('submit', this.handleSearch.bind(this));
                }
                
                // Quick action buttons
                document.querySelectorAll('.quick-action-btn').forEach(btn => {
                    if (btn.onclick === null && btn.textContent.includes('Refresh')) {
                        btn.addEventListener('click', this.refreshDashboard.bind(this));
                    }
                });
                
                // Stat cards click tracking
                document.querySelectorAll('.stat-card').forEach(card => {
                    card.addEventListener('click', this.trackCardClick.bind(this));
                });
            }
            
            handleSearch(event) {
                event.preventDefault();
                const query = event.target.querySelector('input[name="q"]').value.trim();
                if (query) {
                    this.logActivity('SEARCH_PERFORMED', `Admin searched for: ${query}`);
                    // Proceed with form submission
                    event.target.submit();
                }
            }
            
            trackCardClick(event) {
                const card = event.currentTarget;
                const label = card.querySelector('.stat-label')?.textContent || 'Unknown';
                this.logActivity('DASHBOARD_NAVIGATION', `Admin clicked on ${label} card`);
            }
            
            async refreshDashboard() {
                try {
                    this.showLoadingState();
                    
                    const response = await fetch('${pageContext.request.contextPath}/admin/dashboard/ajax?action=refresh');
                    if (!response.ok) throw new Error('Network response was not ok');
                    
                    const data = await response.json();
                    this.updateDashboard(data);
                    this.showSuccessMessage('Dashboard refreshed successfully');
                    
                } catch (error) {
                    console.error('Error refreshing dashboard:', error);
                    this.showErrorMessage('Failed to refresh dashboard');
                } finally {
                    this.hideLoadingState();
                }
            }
            
            async refreshActivity() {
                try {
                    const response = await fetch('${pageContext.request.contextPath}/admin/dashboard/ajax?action=activities&limit=5');
                    if (!response.ok) throw new Error('Network response was not ok');
                    
                    const activities = await response.json();
                    this.updateActivityList(activities);
                    
                } catch (error) {
                    console.error('Error refreshing activities:', error);
                }
            }
            
            updateDashboard(data) {
                // Update statistics
                if (data.stats) {
                    this.updateStatCards(data.stats);
                }
                
                // Update activities
                if (data.activities) {
                    this.updateActivityList(data.activities);
                }
                
                // Update health indicators
                if (data.health) {
                    this.updateHealthIndicators(data.health);
                }
            }
            
            updateStatCards(stats) {
                // Update Total Users
                const totalUsersValue = document.querySelector('.stat-card:nth-child(1) .stat-value');
                if (totalUsersValue && stats.totalUsers !== undefined) {
                    totalUsersValue.textContent = this.formatNumber(stats.totalUsers);
                }
                
                // Update Total Posts
                const totalPostsValue = document.querySelector('.stat-card:nth-child(2) .stat-value');
                if (totalPostsValue && stats.totalPosts !== undefined) {
                    totalPostsValue.textContent = this.formatNumber(stats.totalPosts);
                }
                
                // Update Pending Approvals
                const pendingApprovalsValue = document.querySelector('.stat-card:nth-child(3) .stat-value');
                if (pendingApprovalsValue && stats.pendingApprovals !== undefined) {
                    pendingApprovalsValue.textContent = stats.pendingApprovals;
                }
                
                // Update Active Reports
                const activeReportsValue = document.querySelector('.stat-card:nth-child(4) .stat-value');
                if (activeReportsValue && stats.activeReports !== undefined) {
                    activeReportsValue.textContent = stats.activeReports;
                }
                
                // Update sidebar badges
                this.updateSidebarBadges(stats);
            }
            
            updateSidebarBadges(stats) {
                // Update Posts badge
                const postsBadge = document.querySelector('a[href*="/admin/posts"] .nav-badge');
                if (postsBadge && stats.pendingApprovals !== undefined) {
                    if (stats.pendingApprovals > 0) {
                        postsBadge.textContent = stats.pendingApprovals;
                        postsBadge.style.display = 'inline-block';
                    } else {
                        postsBadge.style.display = 'none';
                    }
                }
                
                // Update Reports badge
                const reportsBadge = document.querySelector('a[href*="/admin/reports"] .nav-badge');
                if (reportsBadge && stats.activeReports !== undefined) {
                    if (stats.activeReports > 0) {
                        reportsBadge.textContent = stats.activeReports;
                        reportsBadge.style.display = 'inline-block';
                    } else {
                        reportsBadge.style.display = 'none';
                    }
                }
            }
            
            updateActivityList(activities) {
                const activityList = document.querySelector('.activity-list');
                if (!activityList) return;
                
                if (activities.length === 0) {
                    activityList.innerHTML = `
                        <div class="text-center p-4">
                            <i class="bi bi-moon-stars fs-2 text-secondary"></i>
                            <p class="mt-2 text-secondary">No recent activity recorded.</p>
                        </div>
                    `;
                    return;
                }
                
                const activitiesHtml = activities.map(activity => `
                    <div class="activity-item">
                        <div class="activity-icon ${activity.iconColorClass}">
                            <i class="bi ${activity.iconClass}"></i>
                        </div>
                        <div class="activity-info">
                            <p class="activity-description">${activity.description}</p>
                            <small class="activity-timestamp">
                                <i class="bi bi-clock"></i> 
                                ${activity.timeAgo}
                            </small>
                        </div>
                    </div>
                `).join('');
                
                activityList.innerHTML = activitiesHtml;
            }
            
            updateHealthIndicators(health) {
                // Add health indicators to header if needed
                const headerActions = document.querySelector('.header-actions');
                let healthIndicator = document.querySelector('.health-indicator');
                
                if (!healthIndicator) {
                    healthIndicator = document.createElement('div');
                    healthIndicator.className = 'health-indicator';
                    headerActions.insertBefore(healthIndicator, headerActions.firstChild);
                }
                
                const dbStatus = health.databaseConnected ? 'connected' : 'disconnected';
                const memoryUsage = health.memoryUsage || 0;
                
                healthIndicator.innerHTML = `
                    <div class="health-status ${dbStatus}" title="Database: ${dbStatus}">
                        <i class="bi bi-database"></i>
                    </div>
                    <div class="memory-usage" title="Memory Usage: ${memoryUsage.toFixed(1)}%">
                        <i class="bi bi-cpu"></i>
                        <span>${memoryUsage.toFixed(0)}%</span>
                    </div>
                `;
            }
            
            showLoadingState() {
                const refreshBtn = document.querySelector('.quick-action-btn:last-child');
                if (refreshBtn) {
                    refreshBtn.disabled = true;
                    refreshBtn.innerHTML = '<i class="bi bi-arrow-clockwise spin"></i> Refreshing...';
                }
            }
            
            hideLoadingState() {
                const refreshBtn = document.querySelector('.quick-action-btn:last-child');
                if (refreshBtn) {
                    refreshBtn.disabled = false;
                    refreshBtn.innerHTML = '<i class="bi bi-arrow-clockwise"></i> Refresh';
                }
            }
            
            showSuccessMessage(message) {
                this.showToast(message, 'success');
            }
            
            showErrorMessage(message) {
                this.showToast(message, 'danger');
            }
            
            showToast(message, type = 'info') {
                const toast = document.createElement('div');
                toast.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
                toast.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
                toast.innerHTML = `
                    ${message}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                `;
                
                document.body.appendChild(toast);
                
                setTimeout(() => {
                    if (toast.parentNode) {
                        toast.parentNode.removeChild(toast);
                    }
                }, 5000);
            }
            
            async logActivity(type, description) {
                try {
                    const formData = new FormData();
                    formData.append('action', 'log_activity');
                    formData.append('type', type);
                    formData.append('description', description);
                    
                    await fetch('${pageContext.request.contextPath}/admin/dashboard/ajax', {
                        method: 'POST',
                        body: formData
                    });
                } catch (error) {
                    console.error('Error logging activity:', error);
                }
            }
            
            formatNumber(num) {
                return new Intl.NumberFormat().format(num);
            }
            
            startAutoRefresh() {
                // Refresh every 5 minutes
                this.refreshInterval = setInterval(() => {
                    if (document.visibilityState === 'visible') {
                        this.refreshDashboard();
                    }
                }, 300000);
            }
            
            stopAutoRefresh() {
                if (this.refreshInterval) {
                    clearInterval(this.refreshInterval);
                    this.refreshInterval = null;
                }
            }
            
            checkMobileView() {
                if (window.innerWidth <= 768) {
                    this.setupMobileMenu();
                }
            }
            
            setupMobileMenu() {
                const header = document.querySelector('.header-content');
                const menuButton = document.createElement('button');
                menuButton.className = 'btn btn-outline-primary d-md-none me-2';
                menuButton.innerHTML = '<i class="bi bi-list"></i>';
                menuButton.onclick = this.toggleSidebar;
                header.insertBefore(menuButton, header.firstChild);
                
                // Close sidebar when clicking outside
                document.addEventListener('click', (event) => {
                    const sidebar = document.querySelector('.sidebar');
                    const isClickInsideSidebar = sidebar.contains(event.target);
                    const isMenuButton = event.target.closest('button')?.onclick === this.toggleSidebar;
                    
                    if (!isClickInsideSidebar && !isMenuButton && window.innerWidth <= 768) {
                        sidebar.classList.remove('show');
                    }
                });
            }
            
            toggleSidebar() {
                const sidebar = document.querySelector('.sidebar');
                sidebar.classList.toggle('show');
            }
        }
        
        // Global functions for backward compatibility
        function refreshDashboard() {
            if (window.dashboard) {
                window.dashboard.refreshDashboard();
            }
        }
        
        function refreshActivity() {
            if (window.dashboard) {
                window.dashboard.refreshActivity();
            }
        }
        
        function toggleSidebar() {
            if (window.dashboard) {
                window.dashboard.toggleSidebar();
            }
        }
        
        // Initialize dashboard when DOM is loaded
        document.addEventListener('DOMContentLoaded', function() {
            window.dashboard = new Dashboard();
        });
        
        // Cleanup on page unload
        window.addEventListener('beforeunload', function() {
            if (window.dashboard) {
                window.dashboard.stopAutoRefresh();
            }
        });
    </script>
    
    <style>
        /* Additional styles for enhanced functionality */
        .health-indicator {
            display: flex;
            align-items: center;
            gap: 0.5rem;
            margin-right: 1rem;
        }
        
        .health-status {
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.8rem;
        }
        
        .health-status.connected {
            background-color: #10b981;
            color: white;
        }
        
        .health-status.disconnected {
            background-color: #ef4444;
            color: white;
        }
        
        .memory-usage {
            display: flex;
            align-items: center;
            gap: 0.25rem;
            font-size: 0.8rem;
            color: var(--text-secondary);
        }
        
        .spin {
            animation: spin 1s linear infinite;
        }
        
        @keyframes spin {
            from { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }
        
        .loading-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(255, 255, 255, 0.8);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 10;
        }
        
        /* Mobile responsive improvements */
        @media (max-width: 768px) {
            .sidebar {
                transform: translateX(-100%);
            }
            
            .sidebar.show {
                transform: translateX(0);
            }
            
            .main-content {
                margin-left: 0;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .quick-actions {
                flex-direction: column;
            }
            
            .search-form {
                width: 100%;
                max-width: 200px;
            }
        }
    </style>
</body>
</html>


