<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post Management - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar can be included here -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Pending Posts for Approval</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left-circle"></i>
                            Back to Dashboard
                        </a>
                    </div>
                </div>

                <c:if test="${not empty param.status}">
                    <div class="alert alert-${param.status == 'success' ? 'success' : 'danger'}" role="alert">
                        Action ${param.status == 'success' ? 'succeeded' : 'failed'}!
                    </div>
                </c:if>

                <div class="row">
                    <c:choose>
                        <c:when test="${not empty pendingPosts}">
                            <c:forEach var="post" items="${pendingPosts}">
                                <div class="col-md-6">
                                    <div class="card mb-4">
                                        <div class="card-header d-flex justify-content-between">
                                            <span>By: <strong><c:out value="${post.child.fullName}"/></strong></span>
                                            <small class="text-muted"><fmt:formatDate value="${post.createdAt}" pattern="MMM dd, yyyy"/></small>
                                        </div>
                                        <div class="card-body">
                                            <h5 class="card-title"><c:out value="${post.title}"/></h5>
                                            <p class="card-text"><c:out value="${post.content}"/></p>
                                        </div>
                                        <div class="card-footer text-center">
                                            <form action="${pageContext.request.contextPath}/admin/posts" method="post" class="d-inline">
                                                <input type="hidden" name="postId" value="${post.postId}">
                                                <button type="submit" name="action" value="approve" class="btn btn-success"><i class="bi bi-check-circle"></i> Approve</button>
                                                <button type="submit" name="action" value="reject" class="btn btn-danger"><i class="bi bi-x-circle"></i> Reject</button>
                                            </form>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="col">
                                <p class="text-center text-muted">No pending posts to review.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </main>
        </div>
    </div>
</body>
</html>