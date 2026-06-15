<%@ page import="com.tourism.dao.DestinationDAO, com.tourism.model.Destination, java.util.List" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Admin - Manage Destinations</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Destination Management Console</h2>
        <a href="admin-dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
    </div>

    <%-- Status Messages --%>
    <% String status = request.getParameter("status"); %>
    <% if ("success".equals(status)) { %>
        <div class="alert alert-success">Destination added successfully!</div>
    <% } else if ("error".equals(status)) { %>
        <div class="alert alert-danger">Error creating destination. Please try again.</div>
    <% } else if ("delete_success".equals(status)) { %>
        <div class="alert alert-warning">Destination deleted successfully.</div>
    <% } else if ("delete_error".equals(status)) { %>
        <div class="alert alert-danger">Cannot delete destination. It might be linked to an active package.</div>
    <% } %>
    
    <%-- Add Destination Form --%>
    <div class="card p-4 mb-5 shadow-sm">
        <h4 class="card-title text-primary mb-3">Add New Destination</h4>
        <form action="<%= request.getContextPath() %>/ManageDestinationServlet" method="POST">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">Destination Name</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g., Paris, Bali" required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">State / Country</label>
                    <input type="text" name="stateCountry" class="form-control" placeholder="e.g., France, Indonesia" required>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label">Description / Details</label>
                <textarea name="description" class="form-control" rows="3" placeholder="Describe the target destination attractions..."></textarea>
            </div>
            <button type="submit" class="btn btn-success px-4">Save Destination</button>
        </form>
    </div>

    <%-- View Destinations Table --%>
    <div class="card p-4 shadow-sm">
        <h4 class="text-secondary mb-3">Existing Registered Locations</h4>
        <table class="table table-hover border">
            <thead class="table-dark">
                <tr>
                    <th style="width: 10%;">ID</th>
                    <th style="width: 25%;">Destination</th>
                    <th style="width: 20%;">Region / Country</th>
                    <th style="width: 30%;">Description</th>
                    <th style="width: 15%;" class="text-center">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    DestinationDAO dao = new DestinationDAO();
                    List<Destination> list = dao.getAllDestinations();
                    if(list.isEmpty()) {
                %>
                <tr>
                    <td colspan="5" class="text-center text-muted">No destinations added yet.</td>
                </tr>
                <% 
                    } else {
                        for(Destination d : list) {
                %>
                <tr>
                    <td><strong>#<%= d.getId() %></strong></td>
                    <td><%= d.getName() %></td>
                    <td><%= d.getStateCountry() %></td>
                    <td><%= d.getDescription() != null ? d.getDescription() : "N/A" %></td>
                    <td class="text-center">
                        <a href="<%= request.getContextPath() %>/DeleteDestinationServlet?id=<%= d.getId() %>" 
                           class="btn btn-danger btn-sm" 
                           onclick="return confirm('Are you sure you want to delete this destination?');">
                           Delete
                        </a>
                    </td>
                </tr>
                <% 
                        }
                    } 
                %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>