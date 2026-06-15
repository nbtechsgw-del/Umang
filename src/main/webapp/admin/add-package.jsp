<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%@ page import="com.tourism.dao.DestinationDAO, com.tourism.model.Destination, java.util.List" %>
<%
    // Security Access Control Checkpoint
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=access_denied");
        return;
    }
%>
<jsp:include page="../common/header.jsp" />

<div class="container my-5" style="max-width: 800px;">
    <div class="card border-0 shadow-sm p-4 rounded-4 bg-white">
        
        <div class="d-flex align-items-center mb-4">
            <a href="dashboard.jsp" class="btn btn-light rounded-circle p-2 me-3" style="width: 40px; height: 40px; display: inline-flex; align-items: center; justify-content: center;">
                <i class="fa-solid fa-arrow-left text-muted"></i>
            </a>
            <div>
                <h3 class="fw-bold text-dark mb-0">Create Travel Package</h3>
                <p class="text-muted small mb-0">Publish a new holiday package directly to the customer directory.</p>
            </div>
        </div>

        <%-- Dynamic System Message Prompts --%>
        <% String error = request.getParameter("error"); %>
        <% if ("database_failed".equals(error)) { %>
            <div class="alert alert-danger">Error: DB failed to record package row constraint rules.</div>
        <% } else if ("invalid_pricing_format".equals(error)) { %>
            <div class="alert alert-danger">Error: Numeric evaluation breakdown on pricing attributes.</div>
        <% } else if ("system_fault".equals(error)) { %>
            <div class="alert alert-danger">Error: Internal critical application system trap.</div>
        <% } %>

        <form action="<%= request.getContextPath() %>/AddPackageServlet" method="POST">
            <div class="row g-3">
                <div class="col-12">
                    <label class="form-label fw-semibold text-secondary small">Package Title Name</label>
                    <input type="text" name="packageName" class="form-control" placeholder="e.g., Majestic European Gateway" required>
                </div>

                <div class="col-12">
                    <label class="form-label fw-semibold text-secondary small">Assign Destination Location Group</label>
                    <select name="destinationId" class="form-select" required>
                        <option value="">-- Select a Location --</option>
                        <%
                            DestinationDAO destDao = new DestinationDAO();
                            List<Destination> destList = destDao.getAllDestinations();
                            for(Destination d : destList) {
                        %>
                            <option value="<%= d.getId() %>"><%= d.getName() %>, <%= d.getStateCountry() %></option>
                        <% 
                            } 
                        %>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold text-secondary small">Travel Category Group</label>
                    <select name="category" class="form-select" required>
                        <option value="DOMESTIC">Domestic Tour</option>
                        <option value="INTERNATIONAL">International Tour</option>
                        <option value="SEASONAL">Seasonal Special Offer</option>
                    </select>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold text-secondary small">Price per Traveler (INR)</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light">₹</span>
                        <input type="number" name="price" class="form-control" placeholder="45000" min="0" required>
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label fw-semibold text-secondary small">Duration (Days & Nights)</label>
                    <input type="text" name="duration" class="form-control" placeholder="e.g., 5 Days / 4 Nights" required>
                </div>

                <div class="col-12">
                    <label class="form-label fw-semibold text-secondary small">Travel Itinerary Schedule Description</label>
                    <textarea name="description" class="form-control" rows="5" placeholder="Provide day-by-day sightseeing specifics, hotel stays, and standard inclusions..." required></textarea>
                </div>

                <div class="col-12 mt-4 d-flex gap-2 justify-content-end">
                    <a href="dashboard.jsp" class="btn btn-light rounded-pill px-4 fw-semibold">Cancel</a>
                    <button type="submit" class="btn btn-primary text-white rounded-pill px-4 fw-bold">
                        <i class="fa-solid fa-paper-plane me-2"></i>Publish Catalog Listing
                    </button>
                </div>
            </div>
        </form>

    </div>
</div>

<jsp:include page="../common/footer.jsp" />