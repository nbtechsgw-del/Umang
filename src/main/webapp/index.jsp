<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.dao.PackageDAO" %>
<%@ page import="com.tourism.model.TourPackage" %>
<%@ page import="java.util.List" %>
<jsp:include page="common/header.jsp" />

<div class="bg-primary text-white py-5 shadow-sm">
    <div class="container text-center py-4">
        <h1 class="display-4 fw-bold mb-3">Find Your Next Adventure</h1>
        <p class="lead mb-4">Discover, customize, and secure elite travel packages across global destinations instantly.</p>
        <a href="#explore-section" class="btn btn-light text-primary btn-lg px-4 fw-bold rounded-pill shadow">Explore Packages</a>
    </div>
</div>

<%-- Capture active search filter parameters from the request --%>
<%
    String searchKeyword = request.getParameter("keyword");
    String searchCategory = request.getParameter("category");
    String searchPrice = request.getParameter("maxPrice");

    PackageDAO packageDAO = new PackageDAO();
    List<TourPackage> featuredPackages;

    // Direct routing: If any filter is running, run filtered search, otherwise fetch default catalog
    if (searchKeyword != null || searchCategory != null || searchPrice != null) {
        featuredPackages = packageDAO.getFilteredPackages(searchKeyword, searchCategory, searchPrice);
    } else {
        featuredPackages = packageDAO.getAllAvailablePackages();
    }
%>

<% if ("booking_success".equals(request.getParameter("msg"))) { %>
    <div class="container mt-4">
        <div class="alert alert-success border-0 shadow-sm p-3 d-flex align-items-center" role="alert" style="border-radius: 12px;">
            <i class="fa-solid fa-circle-check text-success fa-2x me-3"></i>
            <div>
                <h6 class="fw-bold mb-0 text-dark">Reservation Successfully Placed!</h6>
                <small class="text-muted">Your booking request was logged under a PENDING status. Administrators can review it from their workspaces.</small>
            </div>
        </div>
    </div>
<% } %>

<div class="container my-5" id="explore-section">
    
    <div class="card border-0 shadow-sm p-4 mb-5 bg-white" style="border-radius: 16px;">
        <form method="GET" action="index.jsp#explore-section" class="row g-3 align-items-end">
            
            <div class="col-12 col-md-4">
                <label class="form-label text-secondary small fw-bold"><i class="fa-solid fa-magnifying-glass me-1"></i> Search Destination</label>
                <input type="text" class="form-control" name="keyword" placeholder="e.g., Paris, Europe, Mountains..." value="<%= (searchKeyword != null) ? searchKeyword : "" %>">
            </div>
            
            <div class="col-12 col-md-3">
                <label class="form-label text-secondary small fw-bold"><i class="fa-solid fa-tags me-1"></i> Category Style</label>
                <select class="form-select" name="category">
                    <option value="ALL" <%= "ALL".equals(searchCategory) ? "selected" : "" %>>All Travel Formats</option>
                    <option value="Adventure" <%= "Adventure".equals(searchCategory) ? "selected" : "" %>>Adventure / Trekking</option>
                    <option value="Luxury" <%= "Luxury".equals(searchCategory) ? "selected" : "" %>>Luxury / Executive</option>
                    <option value="Beach" <%= "Beach".equals(searchCategory) ? "selected" : "" %>>Beach / Honeymoon</option>
                    <option value="Cultural" <%= "Cultural".equals(searchCategory) ? "selected" : "" %>>Historical / Cultural</option>
                </select>
            </div>
            
            <div class="col-12 col-md-3">
                <label class="form-label text-secondary small fw-bold"> Max Budget (₹)</label>
                <input type="number" class="form-control" name="maxPrice" placeholder="Maximum budget price" value="<%= (searchPrice != null) ? searchPrice : "" %>">
            </div>
            
            <div class="col-12 col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary w-100 fw-bold text-white shadow-sm" style="height: 40px; border-radius: 8px;">
                    Filter
                </button>
                <a href="index.jsp" class="btn btn-light border" style="height: 40px; border-radius: 8px;" title="Reset Filters">
                    <i class="fa-solid fa-arrow-rotate-left text-secondary pt-1"></i>
                </a>
            </div>
        </form>
    </div>

    <div class="mb-4">
        <h3 class="fw-bold text-dark mb-1">Available Vacation Packages</h3>
        <p class="text-muted small">Showing <%= featuredPackages.size() %> elite travel opportunities discovered matching your preferences.</p>
    </div>

    <div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
        <%
            if (featuredPackages.isEmpty()) {
        %>
            <div class="col-12 text-center py-5">
                <i class="fa-solid fa-map-location-dot fa-3x text-muted mb-3"></i>
                <h5 class="fw-bold text-dark">No Travel Arrangements Found</h5>
                <p class="text-muted small">Try modifying your text query parameters, removing budget restrictions, or checking alternative category catalogs.</p>
            </div>
        <%
            } else {
                for (TourPackage tour : featuredPackages) {
        %>
            <div class="col">
                <div class="card h-100 border-0 shadow-sm border-hover transition-all" style="border-radius: 14px; overflow: hidden;">
                    <div style="height: 200px; background-color: #eaeaea; position: relative;">
                        <% if (tour.getImageUrl() != null && !tour.getImageUrl().trim().isEmpty()) { %>
                            <img src="<%= tour.getImageUrl() %>" class="w-100 h-100" style="object-fit: cover;" alt="<%= tour.getPackageName() %>">
                        <% } else { %>
                            <div class="d-flex align-items-center justify-content-center h-100 text-muted small"><i class="fa-solid fa-image fa-2x mb-1"></i> No Image</div>
                        <% } %>
                        <span class="badge bg-dark text-white position-absolute top-0 end-0 m-3 px-2.5 py-1.5 rounded-pill small fw-bold"><%= tour.getCategory() %></span>
                    </div>
                    
                    <div class="card-body d-flex flex-column p-4">
                        <div class="d-flex align-items-center gap-3 mb-2">
                            <span class="text-muted small"><i class="fa-solid fa-clock text-primary me-1"></i> <%= tour.getDuration() %></span>
                            <span class="text-muted small"><i class="fa-solid fa-location-dot text-danger me-1"></i> <%= tour.getDestination() %></span>
                        </div>
                        
                        <h5 class="card-title fw-bold text-dark mb-2"><%= tour.getPackageName() %></h5>
                        <p class="card-text text-secondary small mb-4 flex-grow-1">
                            <%= tour.getItinerary().length() > 110 ? tour.getItinerary().substring(0, 110) + "..." : tour.getItinerary() %>
                        </p>

                        <div class="d-flex align-items-center justify-content-between mt-auto pt-3 border-top border-light">
                            <div>
                                <small class="text-muted d-block small uppercase">Price per person</small>
                                <h4 class="fw-bold text-success mb-0">₹<%= tour.getPrice() %></h4>
                            </div>
                            <a href="booking-details.jsp?packageId=<%= tour.getId() %>" class="btn btn-primary rounded-pill px-4 btn-sm fw-bold text-white shadow-sm">
                                View Deal <i class="fa-solid fa-chevron-right ms-1 small"></i>
                            </a>
                        </div>
                    </div>
                </div>
            </div>
        <%
                }
            }
        %>
    </div>
</div>

<jsp:include page="common/footer.jsp" />