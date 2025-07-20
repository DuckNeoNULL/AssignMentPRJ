<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý bài viết - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .admin-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .post-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            margin-bottom: 1.5rem;
            overflow: hidden;
            transition: transform 0.2s;
        }
        .post-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.15);
        }
        .post-header {
            background: #f8f9fa;
            padding: 1rem;
            border-bottom: 1px solid #e9ecef;
        }
        .post-content {
            padding: 1.5rem;
        }
        .post-image {
            max-width: 100%;
            max-height: 300px;
            border-radius: 8px;
            margin: 1rem 0;
        }
        .post-type-badge {
            font-size: 0.8rem;
            padding: 0.25rem 0.5rem;
            border-radius: 12px;
            font-weight: 500;
        }
        .post-type-post { background-color: #e3f2fd; color: #1976d2; }
        .post-type-drawing { background-color: #fff3e0; color: #f57c00; }
        .post-type-story { background-color: #f3e5f5; color: #7b1fa2; }
        .action-buttons {
            display: flex;
            gap: 0.5rem;
            margin-top: 1rem;
        }
        .btn-approve {
            background-color: #28a745;
            border-color: #28a745;
        }
        .btn-reject {
            background-color: #dc3545;
            border-color: #dc3545;
        }
        .empty-state {
            text-align: center;
            padding: 3rem;
            color: #6c757d;
        }
        .empty-state i {
            font-size: 4rem;
            margin-bottom: 1rem;
            opacity: 0.5;
        }
        .content-preview {
            max-height: 150px;
            overflow: hidden;
            position: relative;
        }
        .content-preview::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 100%;
            height: 30px;
            background: linear-gradient(transparent, white);
        }
    </style>
</head>
<body>
    <div class="admin-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col">
                    <h1><i class="bi bi-file-text"></i> Quản lý bài viết</h1>
                    <p class="mb-0">Duyệt và quản lý nội dung sáng tạo của trẻ em</p>
                </div>
                <div class="col-auto">
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline-light">
                        <i class="bi bi-arrow-left"></i> Quay lại Dashboard
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Thông báo -->
        <c:if test="${not empty sessionScope.message}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                <i class="bi bi-check-circle"></i> ${sessionScope.message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>
        
        <c:if test="${not empty sessionScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> ${sessionScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <% session.removeAttribute("error"); %>
        </c:if>

        <c:if test="${not empty requestScope.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="bi bi-exclamation-triangle"></i> ${requestScope.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Danh sách bài viết chờ duyệt -->
        <c:choose>
            <c:when test="${not empty pendingPosts}">
                <div class="row">
                    <div class="col-12">
                        <h3 class="mb-4">
                            <i class="bi bi-clock"></i> 
                            Bài viết đang chờ duyệt (${pendingPosts.size()})
                        </h3>
                    </div>
                </div>

                <c:forEach var="post" items="${pendingPosts}">
                    <div class="post-card">
                        <div class="post-header">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-1">${post.title}</h5>
                                    <div class="d-flex align-items-center gap-3">
                                        <span class="text-muted">
                                            <i class="bi bi-person"></i> ${post.authorName}
                                        </span>
                                        <span class="text-muted">
                                            <i class="bi bi-calendar"></i> 
                                            <fmt:formatDate value="${post.createdAtAsDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </span>
                                        <span class="post-type-badge post-type-${post.postType.toLowerCase()}">
                                            <c:choose>
                                                <c:when test="${post.postType == 'POST'}">
                                                    <i class="bi bi-file-text"></i> Bài viết
                                                </c:when>
                                                <c:when test="${post.postType == 'DRAWING'}">
                                                    <i class="bi bi-palette"></i> Bức vẽ
                                                </c:when>
                                                <c:when test="${post.postType == 'STORY'}">
                                                    <i class="bi bi-book"></i> Truyện
                                                </c:when>
                                                <c:otherwise>${post.postType}</c:otherwise>
                                            </c:choose>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="post-content">
                            <div class="row">
                                <div class="col-md-8">
                                    <div class="content-preview">
                                        <p class="mb-3">${post.content}</p>
                                    </div>
                                </div>
                                <c:if test="${not empty post.imagePath}">
                                    <div class="col-md-4">
                                        <img src="${pageContext.request.contextPath}/${post.imagePath}" 
                                             alt="Hình ảnh bài viết" class="post-image">
                                    </div>
                                </c:if>
                            </div>

                            <div class="action-buttons">
                                <form method="post" action="${pageContext.request.contextPath}/admin/approve-post" style="display: inline;">
                                    <input type="hidden" name="postId" value="${post.postId}">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn btn-approve" 
                                            onclick="return confirm('Bạn có chắc chắn muốn phê duyệt bài viết này?')">
                                        <i class="bi bi-check-lg"></i> Duyệt
                                    </button>
                                </form>
                                
                                <form method="post" action="${pageContext.request.contextPath}/admin/approve-post" style="display: inline;">
                                    <input type="hidden" name="postId" value="${post.postId}">
                                    <input type="hidden" name="action" value="reject">
                                    <button type="submit" class="btn btn-reject" 
                                            onclick="return confirm('Bạn có chắc chắn muốn từ chối bài viết này?')">
                                        <i class="bi bi-x-lg"></i> Từ chối
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:when>
            
            <c:otherwise>
                <div class="empty-state">
                    <i class="bi bi-check-circle"></i>
                    <h4>Không có bài viết nào chờ duyệt</h4>
                    <p>Tất cả bài viết đã được xử lý hoặc chưa có bài viết mới nào được gửi.</p>
                    <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-primary">
                        <i class="bi bi-arrow-left"></i> Quay lại Dashboard
                    </a>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 