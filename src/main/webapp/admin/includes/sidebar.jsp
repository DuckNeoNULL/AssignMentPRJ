<nav class="sidebar">
    <div class="sidebar-header">
        <h4>KidSocial Admin</h4>
    </div>
    
    <ul class="sidebar-nav list-unstyled">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i>
                Dashboard
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/users" 
               class="nav-link ${currentPage == 'users' ? 'active' : ''}">
                <i class="bi bi-people"></i>
                Users
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/posts" 
               class="nav-link ${currentPage == 'posts' ? 'active' : ''}">
                <i class="bi bi-file-post"></i>
                Posts
                <c:if test="${pendingApprovals > 0}">
                    <span class="nav-badge">${pendingApprovals}</span>
                </c:if>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/reports" 
               class="nav-link ${currentPage == 'reports' ? 'active' : ''}">
                <i class="bi bi-flag"></i>
                Reports
                <c:if test="${activeReports > 0}">
                    <span class="nav-badge">${activeReports}</span>
                </c:if>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/settings" 
               class="nav-link ${currentPage == 'settings' ? 'active' : ''}">
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