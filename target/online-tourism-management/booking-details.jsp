<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.dao.PackageDAO" %>
<%@ page import="com.tourism.model.TourPackage" %>
<%@ page import="com.tourism.model.User" %>
<%@ page import="com.tourism.dao.HotelDAO" %>
<%@ page import="com.tourism.model.Hotel" %>
<%@ page import="java.util.List" %>
<%
    // 1. Capture the targeted ID string from the URL anchor parameter query
    String idStr = request.getParameter("packageId");
    if (idStr == null || idStr.trim().isEmpty()) {
        idStr = request.getParameter("id");
    }
    
    if (idStr == null || idStr.trim().isEmpty()) {
        response.sendRedirect("index.jsp");
        return;
    }
    
    TourPackage selectedTour = null;
    
    try {
        int packageId = Integer.parseInt(idStr);
        
        // 2. CLEARED INTERNAL DB BLOCKS: Fetch data safely via centralized PackageDAO
        PackageDAO packageDAO = new PackageDAO();
        selectedTour = packageDAO.getPackageById(packageId);
        
    } catch (NumberFormatException e) {
        e.printStackTrace();
    }

    // Safety fallback checkpoint: If model matching failed, abort and return home
    if (selectedTour == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Check user login context state to determine if booking interaction forms lock up
    User loggedInUser = (User) session.getAttribute("loggedInUser");
%>
<jsp:include page="common/header.jsp" />

<div class="container my-5">
    <div class="row g-4">
        
        <div class="col-12 col-lg-7">
            <div class="card border-0 shadow-sm overflow-hidden mb-4" style="border-radius: 14px;">
                <% 
                    String finalImg = (selectedTour.getImageUrl() != null && !selectedTour.getImageUrl().trim().isEmpty()) 
                                      ? selectedTour.getImageUrl() : "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=800&q=80";
                %>
                <img src="<%= finalImg %>" class="w-100" style="height: 380px; object-fit: cover;" alt="<%= selectedTour.getPackageName() %>">
                <div class="card-body p-4">
                    <span class="badge bg-primary px-3 py-2 rounded-pill mb-2"><%= selectedTour.getCategory() %> Tour</span>
                    <h2 class="fw-bold text-dark mb-1"><%= selectedTour.getPackageName() %></h2>
                    <p class="text-muted"><i class="fa-solid fa-location-dot text-danger me-1"></i> Hub: <%= selectedTour.getDestination() %> | <i class="fa-solid fa-clock text-primary me-1"></i> Timeline: <%= selectedTour.getDuration() %></p>
                    
                    <hr class="text-light-emphasis my-4">
                    
                    <h5 class="fw-bold mb-3"><i class="fa-solid fa-route text-primary me-2"></i>Full Detailed Itinerary Schedule</h5>
                    <p class="text-secondary small style-itinerary" style="white-space: pre-line; line-height: 1.7;"><%= selectedTour.getItinerary() %></p>
                </div>
            </div>
        </div>

        <div class="col-12 col-lg-5">
            <div class="card border-0 shadow-sm p-4 sticky-md-top" style="border-radius: 14px; top: 90px; z-index: 10;">
                <div class="card-body">
                    
                    <div class="mb-4 text-center text-lg-start">
                        <small class="text-muted uppercase small d-block">Guaranteed Best Total Package Price</small>
                        <h1 class="fw-bold text-success mb-0">₹<%= selectedTour.getPrice() %> <span class="fs-6 text-muted fw-normal">/ per traveler</span></h1>
                    </div>

                    <% if (loggedInUser == null) { %>
                        <div class="alert alert-warning text-center small p-3" role="alert" style="border-radius: 10px;">
                            <i class="fa-solid fa-lock d-block mb-2 fa-2x"></i>
                            <strong>Account Login Required</strong>
                            <p class="mb-0 mt-1 small">Please log in to your ExploreHorizons profile to book this custom package.</p>
                            <a href="login.jsp?error=access_denied" class="btn btn-primary btn-sm w-100 fw-bold mt-3 text-white rounded-pill">Sign In Now</a>
                        </div>
                    <% } else { 
                        HotelDAO hotelDAO = new HotelDAO();
                        List<Hotel> matchingHotels = hotelDAO.getHotelsByDestination(selectedTour.getDestination());
                    %>

                        <form action="payment-gateway.jsp" method="GET" class="mt-4">
                            <input type="hidden" name="packageId" value="<%= selectedTour.getId() %>">
                            <input type="hidden" name="price" value="<%= selectedTour.getPrice() %>">

                            <div class="mb-3">
                                <label class="form-label text-secondary small fw-bold" for="travelDate">Select Departure Date</label>
                                <input type="date" class="form-control" name="travelDate" id="travelDate" required>
                            </div>

                            <div class="mb-4">
                                <label class="form-label text-secondary small fw-bold" for="hotelId">Select Accommodation Lodge Option</label>
                                <select class="form-select" name="hotelId" id="hotelId" required>
                                    <% if(matchingHotels == null || matchingHotels.isEmpty()) { %>
                                        <option value="0">Standard Local Lodging Accommodations Included</option>
                                    <% } else { %>
                                        <% for (Hotel hotel : matchingHotels) { %>
                                            <option value="<%= hotel.getId() %>">
                                                <%= hotel.getHotelName() %> (<%= hotel.getStars() %>★) — +₹<%= hotel.getPricePerNight() %>/night
                                            </option>
                                        <% } %>
                                    <% } %>
                                </select>
                            </div>

                            <button type="submit" class="btn btn-primary w-100 fw-bold text-white rounded-pill shadow-sm py-2.5">
                                <i class="fa-solid fa-credit-card me-2"></i>Proceed to Checkout
                            </button>
                        </form>
                    <% } %>

                    <div class="bg-light p-3 rounded-3 mt-4 small">
                        <h6 class="fw-bold text-dark small mb-2"><i class="fa-solid fa-shield-halved text-success me-1"></i> Booking Terms</h6>
                        <ul class="text-muted ps-3 mb-0 small" style="line-height: 1.5;">
                            <li>Free cancellation up to 7 days before departure.</li>
                            <li>Integrated hotel room allocation processes immediately upon reservation clearance.</li>
                        </ul>
                    </div>

                </div>
            </div>
        </div>

    </div>
</div>

<script>
    document.addEventListener("DOMContentLoaded", function() {
        var dateField = document.getElementById('travelDate');
        if (dateField) {
            var today = new Date().toISOString().split('T')[0];
            dateField.setAttribute('min', today);
        }
    });
</script>

<jsp:include page="common/footer.jsp" />