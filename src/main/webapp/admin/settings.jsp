<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>System Settings - Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Include sidebar here -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">System Settings</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-sm btn-outline-secondary">
                            <i class="bi bi-arrow-left-circle"></i>
                            Back to Dashboard
                        </a>
                    </div>
                </div>

                <c:if test="${not empty param.status}">
                    <div class="alert alert-${param.status == 'success' ? 'success' : 'danger'}" role="alert">
                        Settings update ${param.status}!
                    </div>
                </c:if>

                <div class="card">
                    <div class="card-body">
                        <form action="${pageContext.request.contextPath}/admin/settings" method="post">
                            <input type="hidden" name="settingsAction" value="update">

                            <div class="mb-3">
                                <label for="site_name" class="form-label">Site Name</label>
                                <input type="text" class="form-control" id="site_name" name="site_name" value="<c:out value='${systemSettings.site_name}'/>">
                            </div>

                            <div class="mb-3">
                                <label for="max_posts_per_day" class="form-label">Max Posts Per Day</label>
                                <input type="number" class="form-control" id="max_posts_per_day" name="max_posts_per_day" value="<c:out value='${systemSettings.max_posts_per_day}'/>">
                            </div>

                            <div class="form-check form-switch mb-3">
                                <input class="form-check-input" type="checkbox" id="maintenance_mode" name="maintenance_mode" value="true" ${systemSettings.maintenance_mode == 'true' ? 'checked' : ''}>
                                <label class="form-check-label" for="maintenance_mode">Maintenance Mode</label>
                            </div>
                            
                            <div class="form-check form-switch mb-4">
                                <input class="form-check-input" type="checkbox" id="registration_enabled" name="registration_enabled" value="true" ${systemSettings.registration_enabled == 'true' ? 'checked' : ''}>
                                <label class="form-check-label" for="registration_enabled">Enable User Registration</label>
                            </div>
                            
                            <input type="hidden" name="maintenance_mode_hidden" value="false" />
                            <input type="hidden" name="registration_enabled_hidden" value="false" />

                            <button type="submit" class="btn btn-primary">Save Settings</button>
                        </form>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-header">System Health</div>
                    <div class="card-body">
                        <p>Database Connection: 
                            <span class="badge ${systemHealth ? 'bg-success' : 'bg-danger'}">
                                ${systemHealth ? 'Connected' : 'Disconnected'}
                            </span>
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