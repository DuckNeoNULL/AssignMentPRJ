<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<div class="overview-section">
    <!-- Recent Activity -->
    <div class="row">
        <div class="col-md-8">
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Recent Activity</h5>
                    <button class="btn btn-sm btn-outline-primary" onclick="dashboard.refreshActivity()">
                        <i class="bi bi-arrow-clockwise"></i> Refresh
                    </button>
                </div>
                <div class="card-body">
                    <div id="activityList">
                        <c:choose>
                            <c:when test="${not empty recentActivities}">
                                <c:forEach var="activity" items="${recentActivities}" varStatus="status">
                                    <div class="activity-item d-flex align-items-start mb-3 ${status.index >= 5 ? 'd-none' : ''}">
                                        <div class="activity-icon me-3">
                                            <i class="bi ${activity.type == 'USER_REGISTERED' ? 'bi-person-plus text-success' : 
                                                         activity.type == 'POST_CREATED' ? 'bi-file-plus text-primary' :
                                                         activity.type == 'POST_APPROVED' ? 'bi-check-circle text-success' :
                                                         activity.type == 'REPORT_CREATED' ? 'bi-flag text-warning' :
                                                         activity.type == 'USER_SUSPENDED' ? 'bi-person-x text-danger' :
                                                         'bi-info-circle text-info'}"></i>
                                        </div>
                                        <div class="activity-content flex-grow-1">
                                            <h6 class="mb-1">${activity.description}</h6>
                                            <small class="text-muted">
                                                <fmt:formatDate value="${activity.createdAt}" pattern="MMM dd, yyyy HH:mm"/>
                                            </small>
                                        </div>
                                    </div>
                                </c:forEach>
                            </c:when>
                            <c:otherwise>
                                <p class="text-muted">No recent activities found.</p>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-4">
            <!-- System Health -->
            <div class="card mb-4">
                <div class="card-header">
                    <h5 class="mb-0">System Health</h5>
                </div>
                <div class="card-body">
                    <div class="health-indicator mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span>Database</span>
                            <span class="badge bg-success">Connected</span>
                        </div>
                    </div>
                    <div class="health-indicator mb-3">
                        <div class="d-flex justify-content-between align-items-center">
                            <span>Memory Usage</span>
                            <span class="badge bg-warning">75%</span>
                        </div>
                    </div>
                    <div class="health-indicator">
                        <div class="d-flex justify-content-between align-items-center">
                            <span>Active Sessions</span>
                            <span class="badge bg-info">${stats.activeSessions != null ? stats.activeSessions : 0}</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Quick Stats -->
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Today's Summary</h5>
                </div>
                <div class="card-body">
                    <div class="quick-stat mb-3">
                        <div class="d-flex justify-content-between">
                            <span>New Users</span>
                            <strong class="text-success">${stats.newUsersToday != null ? stats.newUsersToday : 0}</strong>
                        </div>
                    </div>
                    <div class="quick-stat mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Posts Created</span>
                            <strong class="text-primary">${stats.postsCreatedToday != null ? stats.postsCreatedToday : 0}</strong>
                        </div>
                    </div>
                    <div class="quick-stat mb-3">
                        <div class="d-flex justify-content-between">
                            <span>Posts Approved</span>
                            <strong class="text-success">${stats.postsApprovedToday != null ? stats.postsApprovedToday : 0}</strong>
                        </div>
                    </div>
                    <div class="quick-stat">
                        <div class="d-flex justify-content-between">
                            <span>New Reports</span>
                            <strong class="text-warning">${stats.newReportsToday != null ? stats.newReportsToday : 0}</strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Charts Row -->
    <div class="row mt-4">
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">User Registration Trend</h5>
                </div>
                <div class="card-body">
                    <canvas id="userRegistrationChart" height="200"></canvas>
                </div>
            </div>
        </div>
        
        <div class="col-md-6">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">Content Activity</h5>
                </div>
                <div class="card-body">
                    <canvas id="contentActivityChart" height="200"></canvas>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    initializeOverviewCharts();
});

async function initializeOverviewCharts() {
    try {
        const response = await fetch('${pageContext.request.contextPath}/admin/dashboard/ajax?action=chart-data&period=7days');
        const data = await response.json();
        
        renderUserRegistrationChart(data.userRegistrations);
        renderContentActivityChart(data.contentActivity);
    } catch (error) {
        console.error('Error loading chart data:', error);
    }
}

function renderUserRegistrationChart(data) {
    const ctx = document.getElementById('userRegistrationChart');
    if (!ctx) return;
    
    new Chart(ctx, {
        type: 'line',
        data: {
            labels: data?.labels || ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
            datasets: [{
                label: 'New Users',
                data: data?.values || [12, 19, 3, 5, 2, 3, 9],
                borderColor: 'rgb(59, 130, 246)',
                backgroundColor: 'rgba(59, 130, 246, 0.1)',
                tension: 0.4
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}

function renderContentActivityChart(data) {
    const ctx = document.getElementById('contentActivityChart');
    if (!ctx) return;
    
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: data?.labels || ['Posts', 'Comments', 'Reports', 'Approvals'],
            datasets: [{
                label: 'Count',
                data: data?.values || [65, 59, 80, 81],
                backgroundColor: [
                    'rgba(59, 130, 246, 0.8)',
                    'rgba(16, 185, 129, 0.8)',
                    'rgba(245, 158, 11, 0.8)',
                    'rgba(239, 68, 68, 0.8)'
                ]
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            scales: {
                y: {
                    beginAtZero: true
                }
            }
        }
    });
}
</script>