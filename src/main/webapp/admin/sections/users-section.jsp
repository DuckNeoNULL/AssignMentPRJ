<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<div class="container-fluid mt-4">
    <!-- User stats overview cards -->
    <div class="row">
        <!-- Display overview stats here if needed, or keep it focused on the user list -->
    </div>

    <!-- Users table -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">All Users</h5>
            <div class="input-group" style="width: 300px;">
                <input type="text" class="form-control" placeholder="Search users...">
                <button class="btn btn-outline-secondary" type="button"><i class="bi bi-search"></i></button>
            </div>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead class="table-light">
                        <tr>
                            <th>ID</th>
                            <th>Full Name</th>
                            <th>Email</th>
                            <th>Status</th>
                            <th>Joined Date</th>
                            <th>Last Login</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="user" items="${allUsers}">
                            <tr>
                                <td>${user.parentId}</td>
                                <td>${user.fullName}</td>
                                <td>${user.email}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${user.isVerified}">
                                            <span class="badge bg-success">Verified</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-warning text-dark">Pending</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td><fmt:formatDate value="${user.lastLogin}" pattern="dd/MM/yyyy HH:mm" /></td>
                                <td>
                                    <button class="btn btn-sm btn-outline-primary"><i class="bi bi-pencil-square"></i> Edit</button>
                                    <button class="btn btn-sm btn-outline-danger"><i class="bi bi-lock"></i> Lock</button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty allUsers}">
                            <tr>
                                <td colspan="7" class="text-center">No users found.</td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div> 