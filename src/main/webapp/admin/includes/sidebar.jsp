<%@ page pageEncoding="UTF-8" %>
<nav class="sidebar">
    <div class="sidebar-header">
        <h4>Quản trị KidSocial</h4>
    </div>
    
    <ul class="sidebar-nav list-unstyled">
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/dashboard" 
               class="nav-link ${currentPage == 'dashboard' ? 'active' : ''}">
                <i class="bi bi-speedometer2"></i>
                Bảng điều khiển
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/users" 
               class="nav-link ${currentPage == 'users' ? 'active' : ''}">
                <i class="bi bi-people"></i>
                Người dùng
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/posts" 
               class="nav-link ${currentPage == 'posts' ? 'active' : ''}">
                <i class="bi bi-file-text"></i>
                Quản lý bài viết
                <c:if test="${stats.pendingPosts > 0}">
                    <span class="nav-badge">${stats.pendingPosts}</span>
                </c:if>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/reports" 
               class="nav-link ${currentPage == 'reports' ? 'active' : ''}">
                <i class="bi bi-flag"></i>
                Báo cáo
                <c:if test="${activeReports > 0}">
                    <span class="nav-badge">${activeReports}</span>
                </c:if>
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/admin/settings" 
               class="nav-link ${currentPage == 'settings' ? 'active' : ''}">
                <i class="bi bi-gear"></i>
                Cài đặt
            </a>
        </li>
        <li class="nav-item">
            <a href="${pageContext.request.contextPath}/" 
               class="nav-link">
                <i class="bi bi-house"></i>
                Về trang chủ
            </a>
        </li>
        <li class="nav-item mt-4">
            <a href="${pageContext.request.contextPath}/logout" class="nav-link">
                <i class="bi bi-box-arrow-right"></i>
                Đăng xuất
            </a>
        </li>
    </ul>
</nav>