<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Management - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include sidebar here -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">User Management</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left-circle"></i>
                            Back to Dashboard
                        </a>
                    </div>
                </div>
                
                <c:if test="${not empty param.status}">
                    <div class="alert alert-${param.status == 'success' ? 'success' : 'danger'}" role="alert">
                        User status update ${param.status}!
                    </div>
                </c:if>

                <!-- Stats Overview -->
                <div class="row mb-4">
                    <div class="col-md-3">
                        <div class="card text-white bg-primary">
                            <div class="card-body">
                                <h5 class="card-title">${usersOverview.totalUsers}</h5>
                                <p class="card-text">Total Users</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-success">
                            <div class="card-body">
                                <h5 class="card-title">${usersOverview.activeUsers}</h5>
                                <p class="card-text">Active Users</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-warning">
                            <div class="card-body">
                                <h5 class="card-title">${usersOverview.suspendedUsers}</h5>
                                <p class="card-text">Suspended</p>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="card text-white bg-info">
                            <div class="card-body">
                                <h5 class="card-title">${usersOverview.newUsersToday}</h5>
                                <p class="card-text">New Today</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Users Table -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Full Name</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Joined On</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="user" items="${allUsers}">
                                <tr>
                                    <td>${user.parentId}</td>
                                    <td><c:out value="${user.fullName}"/></td>
                                    <td><c:out value="${user.email}"/></td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${user.status == 'ACTIVE'}">
                                                <span class="badge bg-success">ACTIVE</span>
                                            </c:when>
                                            <c:when test="${user.status == 'SUSPENDED'}">
                                                <span class="badge bg-warning text-dark">SUSPENDED</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary">${user.status}</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td><fmt:formatDate value="${user.createdAt}" pattern="MMM dd, yyyy"/></td>
                                    <td>
                                        <form action="${pageContext.request.contextPath}/admin/users" method="post" class="d-inline">
                                            <input type="hidden" name="userId" value="${user.parentId}">
                                            <c:if test="${user.status == 'ACTIVE'}">
                                                <button type="submit" name="userAction" value="suspend" class="btn btn-warning btn-sm">
                                                    <i class="bi bi-lock-fill"></i> Lock
                                                </button>
                                            </c:if>
                                            <c:if test="${user.status == 'SUSPENDED'}">
                                                <button type="submit" name="userAction" value="activate" class="btn btn-success btn-sm">
                                                    <i class="bi bi-unlock-fill"></i> Unlock
                                                </button>
                                            </c:if>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </main>
        </div>
    </div>
</body>
</html>