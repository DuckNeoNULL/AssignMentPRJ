<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="table-responsive">
    <table class="table table-striped table-hover">
        <thead>
            <tr>
                <th>ID</th>
                <th>Reported Content</th>
                <th>Reported By</th>
                <th>Reason</th>
                <th>Date</th>
                <th>Status</th>
                <th>Actions</th>
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
                                    Post #${report.post.postId}: <c:out value="${report.post.title}"/>
                                </a>
                            </td>
                            <td>
                                Parent: <c:out value="${report.reporter.fullName}"/>
                            </td>
                            <td><c:out value="${report.reason}"/></td>
                            <td><fmt:formatDate value="${report.createdAt}" pattern="MMM dd, yyyy HH:mm"/></td>
                            <td>
                                <span class="badge bg-warning text-dark">${report.status}</span>
                            </td>
                            <td>
                                <div class="dropdown">
                                    <button class="btn btn-secondary btn-sm dropdown-toggle" type="button" id="dropdownMenuButton-${report.reportId}" data-bs-toggle="dropdown" aria-expanded="false">
                                        Actions
                                    </button>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton-${report.reportId}">
                                        <li>
                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="d-inline">
                                                <input type="hidden" name="reportId" value="${report.reportId}">
                                                <input type="hidden" name="action" value="dismiss_report">
                                                <button type="submit" class="dropdown-item">Dismiss Report</button>
                                            </form>
                                        </li>
                                        <li><hr class="dropdown-divider"></li>
                                        <li>
                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="d-inline">
                                                <input type="hidden" name="reportId" value="${report.reportId}">
                                                <input type="hidden" name="postId" value="${report.post.postId}">
                                                <input type="hidden" name="action" value="delete_post">
                                                <button type="submit" class="dropdown-item text-danger">Delete Post</button>
                                            </form>
                                        </li>
                                        <li>
                                            <form action="${pageContext.request.contextPath}/admin/dashboard" method="post" class="d-inline">
                                                <input type="hidden" name="reportId" value="${report.reportId}">
                                                <input type="hidden" name="userId" value="${report.post.child.parent.parentId}">
                                                <input type="hidden" name="action" value="suspend_user">
                                                <button type="submit" class="dropdown-item text-danger">Suspend User</button>
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
                        <td colspan="7" class="text-center text-muted">No active reports at the moment.</td>
                    </tr>
                </c:otherwise>
            </c:choose>
        </tbody>
    </table>
</div> 