<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%@ page import="com.tourism.model.HotelBooking" %>
<%@ page import="com.tourism.dao.HotelDAO" %>
<%@ page import="java.util.List" %>
<%
    // Security Access Control Checkpoint
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
        response.sendRedirect("../login.jsp?error=access_denied");
        return;
    }

    // FIX: Read data passed dynamically from request scope via our Servlet controller wrapper
    List<HotelBooking> bookingsList = (List<HotelBooking>) request.getAttribute("hotelBookingsList");
    
    // Fallback protection: if accessed directly without running the servlet first, invoke redirect
    if (bookingsList == null) {
        response.sendRedirect(request.getContextPath() + "/ManageHotelBookingServlet");
        return;
    }
%>
<jsp:include page="../common/header.jsp" />

<div class="container my-5">
    <nav class="mb-4" style="--bs-breadcrumb-divider: '>';" aria-label="breadcrumb">
        <ol class="breadcrumb small">
            <li class="breadcrumb-item"><a href="dashboard.jsp" class="text-decoration-none">Dashboard</a></li>
            <li class="breadcrumb-item active" aria-current="page">Hotel Operations Ledger</li>
        </ol>
    </nav>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold mb-1">Hotel Bookings Management</h3>
            <p class="text-muted small mb-0">Review, process check-ins, check-outs, and monitor accommodation status metrics.</p>
        </div>
        <span class="badge bg-primary rounded-pill px-3 py-2 fw-semibold">Total Rows: <%= bookingsList.size() %></span>
    </div>

    <div class="card border-0 shadow-sm rounded-3 overflow-hidden">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark small text-uppercase tracking-wider">
                        <tr>
                            <th class="ps-4 py-3">ID</th>
                            <th class="py-3">Customer Details</th>
                            <th class="py-3">Hotel & Room</th>
                            <th class="py-3">Stay Timeline</th>
                            <th class="py-3">Total Payable</th>
                            <th class="py-3">Live Status</th>
                            <th class="pe-4 py-3 text-end">Action controls</th>
                        </tr>
                    </thead>
                    <tbody class="small">
                        <%
                            if (bookingsList.isEmpty()) {
                        %>
                            <tr>
                                <td colspan="7" class="text-center py-5 text-muted italic">
                                    <i class="fa-solid fa-folder-open d-block mb-2 fa-2x"></i>
                                    No active room bookings recorded inside the data log.
                                </td>
                            </tr>
                        <%
                            } else {
                                for (HotelBooking booking : bookingsList) {
                                    String status = booking.getBookingStatus();
                                    String badgeColor = "bg-secondary-subtle text-secondary";
                                    
                                    if ("CONFIRMED".equalsIgnoreCase(status)) badgeColor = "bg-primary-subtle text-primary";
                                    else if ("CHECKED_IN".equalsIgnoreCase(status)) badgeColor = "bg-success-subtle text-success";
                                    else if ("CHECKED_OUT".equalsIgnoreCase(status)) badgeColor = "bg-dark-subtle text-dark";
                                    else if ("CANCELLED".equalsIgnoreCase(status)) badgeColor = "bg-danger-subtle text-danger";
                        %>
                            <tr>
                                <td class="ps-4 fw-bold text-secondary">#<%= booking.getId() %></td>
                                <td>
                                    <div class="fw-bold text-dark"><%= booking.getCustomerName() %></div>
                                    <div class="text-muted text-xs">UID Reference: #<%= booking.getUserId() %></div>
                                </td>
                                <td>
                                    <div class="fw-semibold text-primary"><%= booking.getHotelName() %></div>
                                    <span class="badge bg-light text-dark border px-2 py-0.5 mt-1 rounded font-monospace"><%= booking.getRoomType() %></span>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-1.5">
                                        <span class="text-success fw-medium"><%= booking.getCheckInDate() %></span>
                                        <i class="fa-solid fa-arrow-right-long text-muted text-xs"></i>
                                        <span class="text-danger fw-medium"><%= booking.getCheckOutDate() %></span>
                                    </div>
                                </td>
                                <td class="fw-bold text-dark text-base">₹<%= booking.getTotalPrice() %></td>
                                <td>
                                    <span class="badge <%= badgeColor %> px-2.5 py-1.5 rounded rounded-pill text-uppercase tracking-wide fw-bold" style="font-size: 0.65rem;">
                                        <%= status %>
                                    </span>
                                </td>
                                <td class="pe-4 text-end">
                                    <div class="d-inline-flex gap-2">
                                        <% if ("CONFIRMED".equalsIgnoreCase(status)) { %>
                                            <a href="../ManageHotelBookingServlet?id=<%= booking.getId() %>&action=CHECK_IN" 
                                               class="btn btn-sm btn-success rounded-pill px-3 py-1 fw-bold small">
                                                <i class="fa-solid fa-door-open me-1"></i> Check-In
                                            </a>
                                            <a href="../ManageHotelBookingServlet?id=<%= booking.getId() %>&action=CANCEL" 
                                               class="btn btn-sm btn-outline-danger rounded-circle p-1.5" title="Cancel Booking">
                                                <i class="fa-solid fa-xmark"></i>
                                            </a>
                                        <% } else if ("CHECKED_IN".equalsIgnoreCase(status)) { %>
                                            <a href="../ManageHotelBookingServlet?id=<%= booking.getId() %>&action=CHECK_OUT" 
                                               class="btn btn-sm btn-dark rounded-pill px-2.5 py-1 fw-bold small">
                                                <i class="fa-solid fa-keys me-1"></i> Check-Out
                                            </a>
                                        <% } else { %>
                                            <span class="text-muted small italic">Archived</span>
                                        <% } %>
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
    </div>
</div>

<jsp:include page="../common/footer.jsp" />