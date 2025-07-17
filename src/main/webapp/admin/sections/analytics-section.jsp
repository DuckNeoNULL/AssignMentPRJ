<div class="analytics-section">
    <div class="section-header">
        <h4><i class="bi bi-graph-up"></i> Analytics Dashboard</h4>
        <div class="section-controls">
            <select class="form-select" id="analytics-period" onchange="loadAnalytics()">
                <option value="7days">Last 7 Days</option>
                <option value="30days">Last 30 Days</option>
                <option value="90days">Last 90 Days</option>
                <option value="1year">Last Year</option>
            </select>
        </div>
    </div>
    
    <div class="analytics-grid">
        <!-- User Analytics -->
        <div class="analytics-card">
            <h6>User Growth</h6>
            <canvas id="userGrowthChart"></canvas>
        </div>
        
        <!-- Post Analytics -->
        <div class="analytics-card">
            <h6>Content Activity</h6>
            <canvas id="postActivityChart"></canvas>
        </div>
        
        <!-- Engagement Metrics -->
        <div class="analytics-card">
            <h6>Engagement Metrics</h6>
            <div id="engagementMetrics">Loading...</div>
        </div>
        
        <!-- Safety Metrics -->
        <div class="analytics-card">
            <h6>Safety & Moderation</h6>
            <canvas id="safetyChart"></canvas>
        </div>
    </div>
</div>

<script>
async function loadAnalytics() {
    const period = document.getElementById('analytics-period').value;
    try {
        const response = await fetch(`${pageContext.request.contextPath}/admin/dashboard/ajax?action=analytics&period=${period}`);
        const data = await response.json();
        renderAnalytics(data);
    } catch (error) {
        console.error('Error loading analytics:', error);
    }
}

function renderAnalytics(data) {
    // Render charts using Chart.js or similar library
    renderUserGrowthChart(data.userRegistrations);
    renderPostActivityChart(data.postActivity);
    renderEngagementMetrics(data.engagementMetrics);
    renderSafetyChart(data.reportTrends);
}

// Initialize analytics on page load
document.addEventListener('DOMContentLoaded', function() {
    if (document.getElementById('analytics-period')) {
        loadAnalytics();
    }
});
</script>