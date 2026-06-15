<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%@ page import="com.tourism.model.Hotel" %>
<%@ page import="com.tourism.dao.HotelDAO" %>
<%@ page import="java.util.List" %>
<%
    // Log message to confirm file execution in terminal logs
    System.out.println("LOG: Customer hotels.jsp page has been accessed!");

    // Ensure the customer is authenticated before allowing room bookings
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    
    HotelDAO hotelDAO = new HotelDAO();
    List<Hotel> dynamicHotels = hotelDAO.getAllAvailableHotels();

    if (dynamicHotels != null) {
        System.out.println("LOG: Found " + dynamicHotels.size() + " total rows in database table for hotels.jsp");
    } else {
        System.out.println("LOG: dynamicHotels list object is NULL!");
    }
%>
<jsp:include page="common/header.jsp" />

<div class="container my-5">
    <div class="text-center mb-5">
        <h2 class="fw-bold text-dark"><i class="fa-solid fa-hotel text-primary me-2"></i>Premium Accommodations & Stays</h2>
        <p class="text-muted col-md-6 mx-auto">Handpicked spaces verified for exceptional services, optimal hospitality standards, and best-in-class pricing.</p>
    </div>

    <% if("booking_success".equals(request.getParameter("status"))) { %>
        <div class="alert alert-success alert-dismissible fade show rounded-3 mb-4" role="alert">
            <strong><i class="fa-solid fa-circle-check me-2"></i>Reservation Confirmed!</strong> Your room request has been processed successfully. Track status updates inside your dashboard ledger.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <div class="row g-4">
        <%
            if (dynamicHotels == null || dynamicHotels.isEmpty()) {
        %>
            <div class="col-12 text-center py-5">
                <p class="text-muted fs-5">No luxury hotel listings are currently published live. Check back soon!</p>
            </div>
        <%
            } else {
                for (Hotel hotel : dynamicHotels) {
                    // FIX: Changed from getAvailabilityStatus() to getStatus()
                    boolean isAvailable = "AVAILABLE".equalsIgnoreCase(hotel.getStatus());
        %>
            <div class="col-12 col-md-6 col-lg-4">
                <div class="card h-100 border-0 shadow-sm" style="border-radius: 16px; overflow: hidden;">
                    <div class="bg-secondary text-white d-flex align-items-center justify-content-center" style="height: 200px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);">
                        <i class="fa-solid fa-city display-4 opacity-50"></i>
                    </div>
                    
                    <div class="card-body p-4">
                        <div class="d-flex justify-content-between align-items-start mb-2">
                            <h5 class="fw-bold text-dark mb-0"><%= hotel.getHotelName() %></h5>
                            <span class="badge rounded-pill px-2.5 py-1.5 <%= isAvailable ? "bg-success text-white border border-success" : "bg-danger text-white border border-danger" %>">
                                <%= hotel.getStatus() != null ? hotel.getStatus() : "UNKNOWN" %>
                            </span>
                        </div>
                        
                        <p class="text-muted small mb-3"><i class="fa-solid fa-location-dot me-1 text-danger"></i> <%= hotel.getDestination() %></p>
                        
                        <div class="text-warning small mb-4">
                            <% for(int i=0; i < hotel.getStars(); i++) { %>
                                <i class="fa-solid fa-star"></i>
                            <% } %>
                            <span class="text-muted small ms-1">(<%= hotel.getStars() %> Star Class)</span>
                        </div>

                        <div class="d-flex align-items-center justify-content-between pt-3 border-top">
                            <div>
                                <span class="text-muted text-xs d-block">Nightly Rate</span>
                                <span class="fs-4 fw-bold text-success">₹<%= hotel.getPricePerNight() %></span>
                            </div>
                            
                            <% if (isAvailable) { %>
                                <button type="button" class="btn btn-primary px-4 rounded-pill fw-bold text-white btn-sm shadow-sm"
                                        onclick="openBookingModal('<%= hotel.getId() %>', '<%= hotel.getHotelName() %>', '<%= hotel.getPricePerNight() %>')">
                                    Book Room
                                </button>
                            <% } else { %>
                                <button type="button" class="btn btn-secondary px-3 rounded-pill btn-sm" disabled>Sold Out</button>
                            <% } %>
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

<div class="modal fade" id="hotelBookingModal" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 shadow" style="border-radius: 16px;">
            <div class="modal-header border-0 pb-0">
                <h5 class="fw-bold text-dark" id="modalHotelTitle">Secure Suite Allocation</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="BookHotelServlet" method="POST">
                <div class="modal-body p-4">
                    <input type="hidden" name="hotelId" id="modalHotelId">
                    <input type="hidden" id="modalBasePrice">
                    
                    <% if(loggedInUser == null) { %>
                        <div class="text-center py-3">
                            <p class="text-danger fw-semibold mb-3">Authentication session missing!</p>
                            <a href="login.jsp" class="btn btn-primary rounded-pill px-4">Sign In to Complete Reservation</a>
                        </div>
                    <% } else { %>
                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">Select Preferred Room Tier</label>
                            <select class="form-select" name="roomType">
                                <option value="STANDARD">Standard Comfort Suite</option>
                                <option value="DELUXE">Deluxe Executive Suite (+ ₹50/Night)</option>
                                <option value="LUXURY">Premium Penthouse Suite (+ ₹120/Night)</option>
                            </select>
                        </div>
                        <div class="row g-3 mb-3">
                            <div class="col-6">
                                <label class="form-label text-secondary small fw-bold">Check-In Date</label>
                                <input type="date" class="form-control" name="checkInDate" required>
                            </div>
                            <div class="col-6">
                                <label class="form-label text-secondary small fw-bold">Check-Out Date</label>
                                <input type="date" class="form-control" name="checkOutDate" required>
                            </div>
                        </div>
                        <div class="bg-light p-3 rounded-3 mt-4">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="small text-muted fw-medium">Configured Baseline Cost:</span>
                                <span class="fw-bold text-dark" id="modalCostDisplay">₹0.00</span>
                            </div>
                        </div>
                    <% } %>
                </div>
                <% if(loggedInUser != null) { %>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-3 text-secondary" data-bs-dismiss="modal">Cancel</button>
                        <button type="submit" class="btn btn-success rounded-pill px-4 text-white fw-bold shadow-sm">Confirm Checkout</button>
                    </div>
                <% } %>
            </form>
        </div>
    </div>
</div>

<script>
function openBookingModal(id, name, price) {
    document.getElementById('modalHotelId').value = id;
    document.getElementById('modalHotelTitle').innerText = "Book Stay at " + name;
    document.getElementById('modalBasePrice').value = price;
    document.getElementById('modalCostDisplay').innerText = "₹" + price + " / Night";
    
    var myModal = new bootstrap.Modal(document.getElementById('hotelBookingModal'));
    myModal.show();
}
</script>

<jsp:include page="common/footer.jsp" />