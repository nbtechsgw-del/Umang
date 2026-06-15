<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%@ page import="com.tourism.dao.BookingDAO" %>
<%@ page import="com.tourism.dao.PackageDAO" %>
<%@ page import="com.tourism.dao.UserDAO" %>
<%@ page import="com.tourism.model.TourPackage" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    // Security Access Control Checkpoint
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
        response.sendRedirect("../login.jsp?error=access_denied");
        return;
    }

    BookingDAO bookingDAO = new BookingDAO();
    PackageDAO packageDAO = new PackageDAO();
    UserDAO userDAO = new UserDAO();
    
    List<Map<String, Object>> allBookings = bookingDAO.getAllBookingsWithDetails();
    List<TourPackage> allPackages = packageDAO.getAllAvailablePackages();
    List<User> registeredUsers = userDAO.getAllRegisteredUsers();
%>
<jsp:include page="../common/header.jsp" />

<div class="container-fluid my-4 px-md-5">
    <div class="row">
        <div class="col-12 mb-4">
            <h2 class="fw-bold text-dark">Administrative Workspace</h2>
            <p class="text-muted small">Manage tour inventories, track bookings, and update system parameters.</p>
        </div>
    </div>

    <% if ("package_added".equals(request.getParameter("status"))) { %>
        <div class="alert alert-success alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
            <i class="fa-solid fa-circle-check me-2"></i> New tour package successfully added to the catalog!
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } else if ("package_updated".equals(request.getParameter("status"))) { %>
        <div class="alert alert-warning alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
            <i class="fa-solid fa-pen-to-square me-2"></i> Tour package parameters modified and compiled successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } else if ("package_deleted".equals(request.getParameter("status"))) { %>
        <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm mb-4" role="alert">
            <i class="fa-solid fa-trash-can me-2"></i> Tour package soft-deletion flagged inside the database rows.
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    <% } %>

    <div class="row g-4">
        <div class="col-12 col-lg-3">
            <div class="card border-0 shadow-sm p-3 mb-4" style="border-radius: 12px;">
                <div class="card-body">
                    <h6 class="text-secondary small uppercase fw-bold mb-3">Inventory Quick Actions</h6>
                    <a href="add-package.jsp" class="btn btn-primary w-100 fw-bold text-white rounded-pill mb-2 shadow-sm">
                        <i class="fa-solid fa-plus me-2"></i>Create New Package
                    </a>
                    <a href="add-hotel.jsp" class="btn btn-outline-secondary w-100 fw-bold rounded-pill shadow-sm mb-2">
                        <i class="fa-solid fa-hotel me-2"></i>Add New Hotel
                    </a>
                    
                    <a href="${pageContext.request.contextPath}/ManageHotelBookingServlet" class="btn btn-outline-primary w-100 fw-bold rounded-pill shadow-sm mb-2">
                        <i class="fa-solid fa-receipt me-2"></i>Manage Hotel Bookings
                    </a>
                    
                    <hr class="text-muted my-3">
                    
                    <h6 class="text-secondary small uppercase fw-bold mb-3"><i class="fa-solid fa-map text-warning me-1"></i>Covered Regions</h6>
                    <ul class="list-group list-group-flush small">
                        <%
                            List<Map<String, Object>> destSummary = packageDAO.getDestinationSummary();
                            if(destSummary == null || destSummary.isEmpty()){
                        %>
                            <li class="list-group-item text-muted ps-0 bg-transparent border-0">No destination clusters mapped.</li>
                        <%
                            } else {
                                for(Map<String, Object> dest : destSummary){
                        %>
                            <li class="list-group-item d-flex justify-content-between align-items-center ps-0 bg-transparent border-0 py-1.5">
                                <span class="text-dark"><i class="fa-solid fa-location-dot text-danger me-2 small"></i><%= dest.get("name") %></span>
                                <span class="badge bg-secondary-subtle text-secondary rounded-pill"><%= dest.get("count") %> Tours</span>
                            </li>
                        <%
                                }
                            }
                        %>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-12 col-lg-9">
            
            <div class="card border-0 shadow-sm p-4 mb-5" style="border-radius: 14px;">
                <h5 class="fw-bold text-dark mb-4"><i class="fa-solid fa-receipt text-primary me-2"></i>Customer Booking Requests</h5>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 text-center small">
                        <thead class="table-light text-secondary">
                            <tr>
                                <th>Booking ID</th>
                                <th>Customer</th>
                                <th>Selected Package</th>
                                <th>Travel Date</th>
                                <th>Total Price</th>
                                <th>Status</th>
                                <th style="min-width: 180px;">Actions Flag</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (allBookings == null || allBookings.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="7" class="text-muted py-4">No active booking requests found inside database tracking.</td>
                                </tr>
                            <%
                                } else {
                                    for (Map<String, Object> booking : allBookings) {
                                        String status = (String) booking.get("status");
                                        String badgeClass = "bg-warning-subtle text-warning border border-warning";
                                        if ("APPROVED".equalsIgnoreCase(status) || "CONFIRMED".equalsIgnoreCase(status)) badgeClass = "bg-success-subtle text-success border border-success";
                                        if ("CANCELLED".equalsIgnoreCase(status) || "REJECTED".equalsIgnoreCase(status)) badgeClass = "bg-danger-subtle text-danger border border-danger";
                            %>
                            <tr>
                                <td class="fw-bold">#B-<%= booking.get("id") %></td>
                                <td class="fw-semibold text-dark"><%= booking.get("customerName") %></td>
                                <td><%= booking.get("packageName") %></td>
                                <td><%= booking.get("travelDate") %></td>
                                <td class="fw-bold text-success">₹<%= booking.get("totalAmount") %></td>
                                <td><span class="badge <%= badgeClass %> px-2.5 py-1.5 rounded-pill text-uppercase"><%= status %></span></td>
                                <td>
                                    <% if ("PENDING".equalsIgnoreCase(status)) { %>
                                        <form action="../UpdateBookingStatusServlet" method="POST" class="d-inline-flex gap-2">
                                            <input type="hidden" name="bookingId" value="<%= booking.get("id") %>">
                                            <button type="submit" name="action" value="APPROVE" class="btn btn-sm btn-success text-white rounded-pill px-2.5 shadow-sm" title="Confirm Booking Itinerary">
                                                <i class="fa-solid fa-check me-1"></i>Approve
                                            </button>
                                            <button type="submit" name="action" value="REJECT" class="btn btn-sm btn-danger text-white rounded-pill px-2.5 shadow-sm" title="Cancel Booking Itinerary">
                                                <i class="fa-solid fa-xmark me-1"></i>Reject
                                            </button>
                                        </form>
                                    <% } else { %>
                                        <span class="text-muted small"><i class="fa-solid fa-check-double text-success me-1"></i>Processed</span>
                                    <% } %>
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

            <div class="card border-0 shadow-sm p-4 mb-5" style="border-radius: 14px;">
                <h5 class="fw-bold text-dark mb-4"><i class="fa-solid fa-map-location-dot text-warning me-2"></i>Active Tour Packages Inventory</h5>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 small">
                        <thead class="table-light text-secondary text-center">
                            <tr>
                                <th>ID</th>
                                <th class="text-start">Package Name</th>
                                <th>Destination</th>
                                <th>Category</th>
                                <th>Duration</th>
                                <th>Price</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (allPackages.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="7" class="text-center text-muted py-4">No active tour packages currently published.</td>
                                </tr>
                            <%
                                } else {
                                    for (TourPackage tour : allPackages) {
                            %>
                            <tr class="text-center">
                                <td class="fw-bold">#P-<%= tour.getId() %></td>
                                <td class="fw-semibold text-dark text-start"><%= tour.getPackageName() %></td>
                                <td><i class="fa-solid fa-location-dot text-danger me-1 small"></i><%= tour.getDestination() %></td>
                                <td><span class="badge bg-light text-dark border px-2.5 py-1.5 rounded-pill"><%= tour.getCategory() %></span></td>
                                <td><i class="fa-solid fa-clock text-muted me-1 small"></i><%= tour.getDuration() %></td>
                                <td class="fw-bold text-success">₹<%= tour.getPrice() %></td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <a href="edit-package.jsp?id=<%= tour.getId() %>" class="btn btn-sm btn-outline-warning px-2.5" title="Modify Package Elements">
                                            <i class="fa-solid fa-pen-to-square"></i> Edit
                                        </a>
                                        <a href="../DeletePackageServlet?id=<%= tour.getId() %>" class="btn btn-sm btn-outline-danger px-2.5" onclick="return confirm('Are you sure you want to flag this travel package out of circulation?');" title="Soft-delete Package">
                                            <i class="fa-solid fa-trash-can"></i> Delete
                                        </a>
                                    </div>
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

            <div class="card border-0 shadow-sm p-4 mb-5" style="border-radius: 14px;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold text-dark mb-0"><i class="fa-solid fa-hotel text-primary me-2"></i>Active Hotel Accommodations</h5>
                    <%
                        com.tourism.dao.HotelDAO dashboardHotelDAO = new com.tourism.dao.HotelDAO();
                        List<com.tourism.model.Hotel> totalHotels = dashboardHotelDAO.getAllAvailableHotels();
                    %>
                    <span class="badge bg-primary-subtle text-primary border border-primary px-3 py-2 rounded-pill fw-semibold small">
                        Total Tracked: <%= totalHotels != null ? totalHotels.size() : 0 %>
                    </span>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 small text-center">
                        <thead class="table-light text-secondary">
                            <tr>
                                <th>ID</th>
                                <th class="text-start">Hotel Name</th>
                                <th>Destination Region</th>
                                <th>Class Rating</th>
                                <th>Price Per Night</th>
                                <th>Status</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (totalHotels == null || totalHotels.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="6" class="text-muted py-4">No hotel properties mapped inside database records.</td>
                                </tr>
                            <%
                                } else {
                                    for (com.tourism.model.Hotel property : totalHotels) {
                            %>
                            <tr>
                                <td class="fw-bold">#H-<%= property.getId() %></td>
                                <td class="fw-semibold text-dark text-start"><%= property.getHotelName() %></td>
                                <td><i class="fa-solid fa-map-location text-muted me-1 small"></i><%= property.getDestination() %></td>
                                <td class="text-warning">
                                    <% for(int i=0; i < property.getStars(); i++) { %>
                                        <i class="fa-solid fa-star"></i>
                                    <% } %>
                                </td>
                                <td class="fw-bold text-success">₹<%= property.getPricePerNight() %></td>
                                <td>
                                    <span class="badge bg-success-subtle text-success border border-success px-2.5 py-1.5 rounded-pill small">
                                        <i class="fa-solid fa-circle-dot me-1 small"></i>OPERATIONAL
                                    </span>
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

            <div class="card border-0 shadow-sm p-4 mb-5" style="border-radius: 14px;">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h5 class="fw-bold text-dark mb-0"><i class="fa-solid fa-users text-info me-2"></i>Registered User Directory</h5>
                    <span class="badge bg-info-subtle text-info border border-info px-3 py-2 rounded-pill fw-semibold small">
                        Active Accounts: <%= registeredUsers != null ? registeredUsers.size() : 0 %>
                    </span>
                </div>
                
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0 small text-center">
                        <thead class="table-light text-secondary">
                            <tr>
                                <th>User ID</th>
                                <th class="text-start">Full Name</th>
                                <th>Email Address</th>
                                <th>Phone Contact</th>
                                <th>System Role</th>
                            </tr>
                        </thead>
                        <tbody>
                            <%
                                if (registeredUsers == null || registeredUsers.isEmpty()) {
                            %>
                                <tr>
                                    <td colspan="5" class="text-muted py-4">No consumer accounts registered inside the database.</td>
                                </tr>
                            <%
                                } else {
                                    for (User customer : registeredUsers) {
                            %>
                            <tr>
                                <td class="fw-bold">#U-<%= customer.getId() %></td>
                                <td class="fw-semibold text-dark text-start"><%= customer.getFullName() %></td>
                                <td><i class="fa-solid fa-envelope text-muted me-1 small"></i><%= customer.getEmail() %></td>
                                <td><i class="fa-solid fa-phone text-muted me-1 small"></i><%= customer.getPhone() != null ? customer.getPhone() : "N/A" %></td>
                                <td>
                                    <span class="badge bg-light text-dark border px-2.5 py-1.5 rounded-pill uppercase">
                                        <%= customer.getRole() %>
                                    </span>
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

        </div> 
    </div> 
</div> 
<jsp:include page="../common/footer.jsp" />