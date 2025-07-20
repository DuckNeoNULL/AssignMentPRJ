<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chào mừng Phụ huynh!</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f0f4ff;
            font-family: 'Baloo 2', cursive;
        }
        .profile-selection-container {
            max-width: 800px;
            margin: 50px auto;
            padding: 40px;
            background-color: #fff;
            border-radius: 24px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.1);
            text-align: center;
        }
        .profile-header h1 {
            font-weight: 700;
        }
        .profile-header p {
            font-size: 1.2rem;
            color: #6c757d;
        }
        .child-profiles {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-top: 40px;
        }
        .child-profile-card {
            text-decoration: none;
            color: #333;
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .child-profile-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 12px 28px rgba(0,0,0,0.15);
        }
        .child-profile-card .avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            border: 5px solid #fff;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            margin-bottom: 15px;
        }
        .child-profile-card h3 {
            font-size: 1.5rem;
            font-weight: 700;
        }
        .parent-actions {
            margin-top: 40px;
            border-top: 1px solid #e9ecef;
            padding-top: 30px;
        }
    </style>
</head>
<body>
    <div class="profile-selection-container">
        <%-- Thêm thông báo khi chuyển về từ friend-posts --%>
        <c:if test="${param.message == 'please_select_child'}">
            <div class="alert alert-info alert-dismissible fade show" role="alert">
                <i class="bi bi-info-circle"></i>
                Vui lòng chọn một hồ sơ bé để xem bài viết của bạn bè.
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>
        
        <div class="profile-header">
            <h1>Chào mừng, ${sessionScope.username}!</h1>
            <p>Vui lòng chọn một hồ sơ để tiếp tục.</p>
        </div>

        <div class="child-profiles">
            <c:choose>
                <c:when test="${not empty childrenList}">
                    <c:forEach var="child" items="${childrenList}">
                        <a href="${pageContext.request.contextPath}/kid/home?childId=${child.childId}" class="child-profile-card">
                            <img src="https://i.pravatar.cc/120?u=${child.childId}" alt="Ảnh đại diện của ${child.fullName}" class="avatar">
                            <h3><c:out value="${child.fullName}"/></h3>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="text-muted">Không tìm thấy hồ sơ của bé nào. Bạn có thể thêm hồ sơ trong phần quản lý tài khoản.</p>
                </c:otherwise>
            </c:choose>
        </div>

        <div class="parent-actions">
            <a href="${pageContext.request.contextPath}/user/home?action=add_child" class="btn btn-outline-primary"><i class="bi bi-person-plus-fill"></i> Thêm hồ sơ bé</a>
            <a href="${pageContext.request.contextPath}/user/home?action=manage_account" class="btn btn-outline-primary"><i class="bi bi-person-circle"></i> Quản lý tài khoản</a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger"><i class="bi bi-box-arrow-right"></i> Đăng xuất</a>
        </div>
    </div>
</body>
</html> 