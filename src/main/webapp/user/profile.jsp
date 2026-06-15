<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%@ page import="com.tourism.model.Hotel" %>
<%@ page import="com.tourism.model.TourPackage" %>
<%@ page import="com.tourism.dao.BookingDAO" %>
<%@ page import="com.tourism.dao.HotelDAO" %>
<%@ page import="com.tourism.dao.PackageDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("../login.jsp?error=access_denied");
        return;
    }

    // 1. Fetch User Reservation Histories
    BookingDAO profileBookingDAO = new BookingDAO();
    List<Map<String, Object>> userReservations = profileBookingDAO.getBookingsByUserId(loggedInUser.getId());

    // 2. Fetch Hotels for Dynamic Selector Dropdown
    HotelDAO hotelDAO = new HotelDAO();
    List<Hotel> allHotels = hotelDAO.getAllAvailableHotels();

    // 3. Fetch Packages for Dynamic Selector Dropdown
    PackageDAO packageDAO = new PackageDAO();
    List<TourPackage> allPackages = packageDAO.getAllAvailablePackages();

    // 4. Fetch the User's Personal Feedback History
    com.tourism.dao.FeedbackDAO profileFeedbackDAO = new com.tourism.dao.FeedbackDAO();
    List<Map<String, Object>> userFeedbackLogs = profileFeedbackDAO.getFeedbackByUserId(loggedInUser.getId());
%>
<jsp:include page="../common/header.jsp" />

<div class="container my-5">
    <div class="row g-4">
        
        <div class="col-12 col-lg-4">
            <div class="card border-0 shadow-sm text-center p-4" style="border-radius: 14px;">
                <div class="card-body">
                    <div class="mb-3">
                        <div class="bg-primary-subtle text-primary rounded-circle d-inline-flex align-items-center justify-content-center" style="width: 80px; height: 80px;">
                            <i class="fa-solid fa-user-astronaut fa-3x"></i>
                        </div>
                    </div>
                    <h4 class="fw-bold text-dark mb-1"><%= loggedInUser.getFullName() %></h4>
                    <span class="badge bg-secondary-subtle text-secondary mb-3 px-3 py-1.5 rounded-pill small fw-bold"><%= loggedInUser.getRole() %></span>
                    
                    <hr class="text-light-emphasis my-4">
                    
                    <div class="text-start small">
                        <div class="mb-2.5">
                            <span class="text-muted d-block small">Email Address</span>
                            <strong class="text-dark"><%= loggedInUser.getEmail() %></strong>
                        </div>
                        <div class="mb-2.5">
                            <span class="text-muted d-block small">Phone Connection</span>
                            <strong class="text-dark"><%= loggedInUser.getPhone() %></strong>
                        </div>
                        <div>
                            <span class="text-muted d-block small">Member Since</span>
                            <strong class="text-dark"><%= loggedInUser.getCreatedAt() != null ? loggedInUser.getCreatedAt().toString().substring(0, 10) : "Recent" %></strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <div class="col-12 col-lg-8">
            
            <div class="card border-0 shadow-sm p-4 mb-4" style="border-radius: 14px;">
                <div class="card-body">
                    <h4 class="fw-bold text-dark mb-1">
                        <i class="fa-solid fa-plane-departure text-primary me-2"></i>My Bookings History
                    </h4>
                    <p class="text-muted small mb-4">Track your departure schedules and processing statuses in real-time.</p>
                    
                    <% if (userReservations == null || userReservations.isEmpty()) { %>
                        <div class="text-center py-4">
                            <i class="fa-solid fa-folder-open text-muted fa-2x mb-2"></i>
                            <p class="text-secondary mb-0">No custom travel logs registered yet.</p>
                            <a href="../index.jsp" class="btn btn-primary btn-sm rounded-pill mt-2 text-white px-3">Browse Packages</a>
                        </div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 small">
                                <thead class="table-light text-secondary text-uppercase small">
                                    <tr>
                                        <th>Booking ID</th>
                                        <th>Tour Package</th>
                                        <th>Destination</th>
                                        <th>Departure Date</th>
                                        <th>Total Cost</th>
                                        <th class="text-center">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        for (Map<String, Object> reservation : userReservations) { 
                                            String status = (String) reservation.get("status");
                                            
                                            String badgeStyle = "bg-warning-subtle text-warning border border-warning";
                                            if ("APPROVED".equalsIgnoreCase(status) || "CONFIRMED".equalsIgnoreCase(status)) {
                                                badgeStyle = "bg-success-subtle text-success border border-success";
                                            } else if ("CANCELLED".equalsIgnoreCase(status) || "REJECTED".equalsIgnoreCase(status)) {
                                                badgeStyle = "bg-danger-subtle text-danger border border-danger";
                                            }
                                    %>
                                        <tr>
                                            <td class="fw-bold">#B-<%= reservation.get("id") %></td>
                                            <td class="fw-semibold text-primary"><%= reservation.get("packageName") %></td>
                                            <td>
                                                <small class="text-muted">
                                                    <i class="fa-solid fa-location-dot text-danger me-1"></i><%= reservation.get("destination") %>
                                                </small>
                                            </td>
                                            <td><%= reservation.get("travelDate") %></td>
                                            <td class="fw-bold text-success">₹<%= reservation.get("totalAmount") %></td>
                                            <td class="text-center">
                                                <span class="badge <%= badgeStyle %> px-2.5 py-1.5 rounded-pill text-uppercase">
                                                    <%= status %>
                                                </span>
                                            </td>
                                        </tr>
                                    <% 
                                        } 
                                    %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>

            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4" style="border-radius: 14px;">
                <div class="card-body">
                    <h4 class="fw-bold text-dark mb-1">
                        <i class="fa-solid fa-comments text-primary me-2"></i>Share Your Experience & Feedback
                    </h4>
                    <p class="text-muted small mb-4">Have an idea, rating, or problem? Tell us! Your submissions are directly audited by our support desks.</p>
                    
                    <%-- Alert Response Layouts --%>
                    <% if("feedback_success".equals(request.getParameter("feedbackStatus"))) { %>
                        <div class="alert alert-success alert-dismissible fade show rounded-3 small mb-4" role="alert">
                            <strong><i class="fa-solid fa-circle-check me-1"></i>Ticket Logged!</strong> Thank you for your review. Our quality and support administration team has successfully received your details.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } else if("feedback_error".equals(request.getParameter("feedbackStatus"))) { %>
                        <div class="alert alert-danger alert-dismissible fade show rounded-3 small mb-4" role="alert">
                            <strong><i class="fa-solid fa-circle-xmark me-1"></i>Transmission Error.</strong> Unable to submit your feedback log entry. Please try checking your field definitions.
                            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                        </div>
                    <% } %>

                    <form action="${pageContext.request.contextPath}/SubmitFeedbackServlet" method="POST">
                        <div class="row g-3">
        
                        <div class="col-12 col-md-6">
                            <label class="form-label text-secondary small fw-bold">Feedback Classification Type</label>
                        <select class="form-select rounded-3 small" name="category" id="feedbackCategory" onchange="handleFeedbackCategoryToggle()" required>
                            <option value="REVIEW">Hotel/Tour Review & Star Rating</option>
                            <option value="SUGGESTION">General Platform Improvement Suggestion</option>
                            <option value="COMPLAINT">Logistical Complaint or Booking Issue Management</option>
                        </select>
                        </div>

                        <div class="col-12 col-md-6" id="starRatingWrapper">
                            <label class="form-label text-secondary small fw-bold">Experience Star Rating</label>
                        <select class="form-select rounded-3 small" name="rating">
                            <option value="5">⭐⭐⭐⭐⭐ (Excellent Standards)</option>
                            <option value="4">⭐⭐⭐⭐ (Satisfactory Service)</option>
                            <option value="3">⭐⭐⭐ (Average / Normal)</option>
                            <option value="2">⭐⭐ (Needs Major Improvements)</option>
                            <option value="1">⭐ (Unsatisfactory Experience)</option>
                        </select>
                        </div>

                        <div class="col-12 col-md-6" id="hotelSelectionWrapper">
                            <label class="form-label text-secondary small fw-bold">Select Hotel Property</label>
                        <select class="form-select rounded-3 small" name="hotelId">
                            <option value="0">-- Not Applicable / No Hotel --</option>
                        <% if (allHotels != null) {
                            for (Hotel h : allHotels) { %>
                            <option value="<%= h.getId() %>"><%= h.getHotelName() %> (<%= h.getDestination() %>)</option>
                        <%  }
                        } %>
                        </select>
                        </div>

                        <div class="col-12 col-md-6" id="packageSelectionWrapper">
                            <label class="form-label text-secondary small fw-bold">Select Tour Package</label>
                        <select class="form-select rounded-3 small" name="packageId">
                            <option value="0">-- Not Applicable / No Tour Package --</option>
                        <% if (allPackages != null) {
                            for (TourPackage p : allPackages) { %>
                        <option value="<%= p.getId() %>"><%= p.getPackageName() %></option>
                        <%  }
                        } %>
                        </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label text-secondary small fw-bold">Brief Descriptive Subject Summary</label>
                            <input type="text" name="subject" class="form-control rounded-3 small" placeholder="e.g., Delightful Stay at Taj / App checkout loading lag" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label text-secondary small fw-bold">Detailed Description Message</label>
                            <textarea name="message" class="form-control rounded-3 small" rows="4" placeholder="Elaborate details regarding your selected entry category..." required></textarea>
                        </div>

                        <div class="col-12 text-end">
                            <button type="submit" class="btn btn-primary btn-sm rounded-pill px-4 fw-bold text-white">Transmit Feedback Ticket</button>
                        </div>
                       </div>
                    </form>
                </div>
            </div>

            <div class="card border-0 shadow-sm p-4" style="border-radius: 14px;">
                <div class="card-body">
                    <h4 class="fw-bold text-dark mb-1">
                        <i class="fa-solid fa-clock-history text-primary me-2"></i>My Submissions History
                    </h4>
                    <p class="text-muted small mb-4">Track your previously logged reviews, suggestions, and complaint tickets.</p>

                    <% if (userFeedbackLogs == null || userFeedbackLogs.isEmpty()) { %>
                        <div class="text-center py-4">
                            <i class="fa-solid fa-comment-slash text-muted fa-2x mb-2"></i>
                            <p class="text-secondary mb-0">You haven't posted any feedback logs or reviews yet.</p>
                        </div>
                    <% } else { %>
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0 small">
                                <thead class="table-light text-secondary text-uppercase small">
                                    <tr>
                                        <th>Type</th>
                                        <th>Target Item</th>
                                        <th>Subject & Summary</th>
                                        <th class="text-center">Rating</th>
                                        <th class="text-center">Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <% 
                                        for (Map<String, Object> log : userFeedbackLogs) { 
                                            String category = (String) log.get("category");
                                            String adminStatus = (String) log.get("adminStatus");
                                            Integer starsObj = (Integer) log.get("rating");
                                            int stars = (starsObj != null) ? starsObj : 0;
                                            
                                            // Dynamic classification styling badges
                                            String catBadge = "bg-info text-white";
                                            if("COMPLAINT".equalsIgnoreCase(category)) catBadge = "bg-danger text-white";
                                            if("SUGGESTION".equalsIgnoreCase(category)) catBadge = "bg-warning text-dark";
                                            
                                            String statusBadge = "bg-secondary text-white";
                                            if(adminStatus == null || "PENDING".equalsIgnoreCase(adminStatus)) adminStatus = "PENDING";
                                            
                                            if("PENDING".equalsIgnoreCase(adminStatus)) statusBadge = "bg-warning text-dark";
                                            if("RESOLVED".equalsIgnoreCase(adminStatus) || "APPROVED".equalsIgnoreCase(adminStatus)) {
                                                statusBadge = "bg-success text-white";
                                            }
                                    %>
                                        <tr>
                                            <td>
                                                <span class="badge <%= catBadge %> text-uppercase px-2 py-1"><%= category %></span>
                                            </td>
                                            <td>
                                                <% if (log.get("hotelName") != null) { %>
                                                    <small class="fw-semibold text-dark"><i class="fa-solid fa-hotel text-muted me-1"></i><%= log.get("hotelName") %></small>
                                                <% } else if (log.get("packageName") != null) { %>
                                                    <small class="fw-semibold text-dark"><i class="fa-solid fa-box text-muted me-1"></i><%= log.get("packageName") %></small>
                                                <% } else { %>
                                                    <span class="text-muted italic small">General Platform</span>
                                                <% } %>
                                            </td>
                                            <td>
                                                <div class="fw-bold text-dark"><%= log.get("subject") %></div>
                                                <small class="text-muted text-wrap d-block" style="max-width: 250px;"><%= log.get("message") %></small>
                                            </td>
                                            <td class="text-center text-nowrap">
                                                <% if ("REVIEW".equalsIgnoreCase(category)) { 
                                                    for(int i=0; i<stars; i++) { out.print("⭐"); }
                                                   } else { %>
                                                    <span class="text-muted">—</span>
                                                <% } %>
                                            </td>
                                            <td class="text-center">
                                                <span class="badge <%= statusBadge %> text-uppercase"><%= adminStatus %></span>
                                            </td>
                                        </tr>
                                    <% 
                                        } 
                                    %>
                                </tbody>
                            </table>
                        </div>
                    <% } %>
                </div>
            </div>

        </div>
    </div>
</div>

<script>
function handleFeedbackCategoryToggle() {
    var selectedCategory = document.getElementById("feedbackCategory").value;
    var starsWrapper = document.getElementById("starRatingWrapper");
    var hotelWrapper = document.getElementById("hotelSelectionWrapper");
    var packageWrapper = document.getElementById("packageSelectionWrapper");

    if (selectedCategory === "REVIEW") {
        starsWrapper.style.display = "block";
        hotelWrapper.style.display = "block";
        packageWrapper.style.display = "block";
    } else {
        starsWrapper.style.display = "none";
        hotelWrapper.style.display = "none";
        packageWrapper.style.display = "none";
    }
}

document.addEventListener("DOMContentLoaded", handleFeedbackCategoryToggle);
</script>

<jsp:include page="../common/footer.jsp" />