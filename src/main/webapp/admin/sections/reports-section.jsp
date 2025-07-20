<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Nội dung bị báo cáo</th>
                <th>Người báo cáo</th>
                <th>Lý do</th>
                <th>Ngày</th>
                <th>Trạng thái</th>
                <th>Hành động</th>
            </tr>
        </thead>
        <tbody>
            <c:choose>
                <c:when test="${not empty activeReports}">
                    <c:forEach var="report" items="${activeReports}">
                        <tr>
                            <td>${report.reportId}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/admin/posts?view=${report.post.postId}" target="_blank">
                                    Bài viết #${report.post.postId}: <c:out value="${report.post.title}"/>
                                </a>
                            </td>
                            <td>
                                Phụ huynh: <c:out value="${report.reporter.fullName}"/>
                            </td>
                            <td><c:out value="${report.reason}"/></td>
                            <td><fmt:formatDate value="${report.createdAt}" pattern="dd/MM/yyyy HH:mm"/></td>
                            <td>
                                <span class="badge bg-warning text-dark">${report.status}</span>
                            </td>
                            <td>
                                <div class="dropdown">
                                    <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" id="dropdownMenuButton-${report.reportId}" data-bs-toggle="dropdown" aria-expanded="false">
                                        Hành động
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton-${report.reportId}">
                                        <li>
                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="d-inline">
                                                <input type="hidden" name="reportId" value="${report.reportId}">
                                                <input type="hidden" name="action" value="dismiss_report">
                                                <button type="submit" class="dropdown-item">Bỏ qua Báo cáo</button>
                                            </form>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li>
                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="d-inline">
                                                <input type="hidden" name="reportId" value="${report.reportId}">
                                                <input type="hidden" name="postId" value="${report.post.postId}">
                                                <input type="hidden" name="action" value="delete_post">
                                                <button type="submit" class="dropdown-item text-danger">Xóa Bài viết</button>
                                            </form>
                                        </li>
                                        <li>
                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="d-inline">
                                                <input type="hidden" name="reportId" value="${report.reportId}">
                                                <input type="hidden" name="userId" value="${report.post.child.parent.parentId}">
                                                <input type="hidden" name="action" value="suspend_user">
                                                <button type="submit" class="dropdown-item text-danger">Khóa Người dùng</button>
                                            </form>
                                        </li>
                                    </ul>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <tr>
                        <td colspan="7" class="text-center text-muted">Không có báo cáo nào đang hoạt động.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div> 