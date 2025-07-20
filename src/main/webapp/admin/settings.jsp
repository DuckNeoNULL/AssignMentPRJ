<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cài đặt Hệ thống - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include sidebar here -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Cài đặt Hệ thống</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left-circle"></i>
                            Quay lại Bảng điều khiển
                        </a>
                    </div>
                </div>

                <c:if test="${not empty param.status}">
                    <div class="alert alert-${param.status == 'success' ? 'success' : 'danger'}" role="alert">
                        Cập nhật cài đặt ${param.status == 'success' ? 'thành công' : 'thất bại'}!
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/admin/dashboard" method="post">
                    <input type="hidden" name="action" value="updateSettings">
                    
                    <div class="card">
                        <div class="card-header">
                            Cài đặt Chung
                        </div>
                        <div class="card-body">
                            <c:forEach var="setting" items="${systemSettings}">
                                <div class="mb-3">
                                    <label for="${setting.key}" class="form-label">${setting.key.replace('_', ' ')}</label>
                                    <input type="text" class="form-control" id="${setting.key}" name="${setting.key}" value="${setting.value}">
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary mt-3">Lưu thay đổi</button>
                </form>

                <div class="card mt-4">
                    <div class="card-header">
                        Trạng thái Hệ thống
                    </div>
                    <div class="card-body">
                        <p>Trạng thái Cơ sở dữ liệu: 
                            <c:choose>
                                <c:when test="${systemHealth}">
                                    <span class="badge bg-success">Đã kết nối</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Mất kết nối</span>
                                </c:otherwise>
                            </c:choose>
                        </p>
                    </div>
                </div>
            </main>
        </div>
    </div>
    <script>
        // Handle checkbox unchecked case
        document.querySelector('form').addEventListener('submit', function(e) {
            this.querySelectorAll('input[type=checkbox]').forEach(function(checkbox) {
                if (!checkbox.checked) {
                    let hidden = document.querySelector('input[name=' + checkbox.name + '_hidden]');
                    if (hidden) checkbox.value = hidden.value;
                }
            });
        });
    </script>
</body>
</html>