<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null) {
        response.sendRedirect("login.jsp?error=login_required");
        return;
    }
    
    // Extract intent parameters passed from the package details card
    String packageId = request.getParameter("packageId");
    String travelDate = request.getParameter("travelDate");
    String price = request.getParameter("price");
    String hotelId = request.getParameter("hotelId"); // Captured from package details selection
    
    if (packageId == null || travelDate == null || price == null) {
        response.sendRedirect("index.jsp?error=invalid_checkout");
        return;
    }
%>
<jsp:include page="common/header.jsp" />

<div class="container my-5" style="max-width: 600px;">
    <div class="card border-0 shadow-sm rounded-4 overflow-hidden">
        <div class="bg-primary p-4 text-white text-center">
            <i class="fa-solid fa-shield-halved fa-3x mb-2 text-warning"></i>
            <h4 class="fw-bold mb-0">Secure Checkout Sandbox</h4>
            <p class="small opacity-75 mb-0">Your transaction is protected with 256-bit encryption monitoring.</p>
        </div>
        
        <div class="card-body p-4 bg-white">
            <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded-3 mb-4 border">
                <div>
                    <span class="text-secondary small d-block">TOTAL PAYABLE FARE</span>
                    <strong class="text-dark fs-5">Tour Booking Package Summary</strong>
                </div>
                <h3 class="fw-extrabold text-primary mb-0">₹<%= price %></h3>
            </div>

            <form action="ProcessPaymentServlet" method="POST">
                <input type="hidden" name="packageId" value="<%= packageId %>">
                <input type="hidden" name="travelDate" value="<%= travelDate %>">
                <input type="hidden" name="amount" value="<%= price %>">
                <input type="hidden" name="hotelId" value="<%= (request.getParameter("hotelId") != null && !request.getParameter("hotelId").isEmpty()) ? request.getParameter("hotelId") : "" %>">

                <div class="mb-4">
                    <label class="form-label fw-bold text-secondary small">Select Payment Mode</label>
                    
                    <div class="form-check card-select p-3 border rounded-3 mb-2 d-flex align-items-center">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="upi" value="UPI" checked>
                        <label class="form-check-label w-100 d-flex justify-content-between align-items-center" for="upi">
                            <span class="fw-semibold text-dark"><i class="fa-solid fa-qrcode me-2 text-primary"></i>Instant UPI (GPay/PhonePe)</span>
                            <span class="badge bg-success-subtle text-success small border">Popular</span>
                        </label>
                    </div>

                    <div class="form-check card-select p-3 border rounded-3 mb-2 d-flex align-items-center">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="card" value="CREDIT_DEBIT_CARD">
                        <label class="form-check-label w-100 d-flex justify-content-between align-items-center" for="card">
                            <span class="fw-semibold text-dark"><i class="fa-solid fa-credit-card me-2 text-primary"></i>Credit / Debit Card</span>
                        </label>
                    </div>
                </div>

                <div class="alert alert-warning border-0 small p-3 rounded-3 d-flex align-items-start">
                    <i class="fa-solid fa-triangle-exclamation me-2 mt-1"></i>
                    <div>This is a staging checkout sandbox. Clicking the confirmation button will automatically simulate a successful financial settlement callback layer.</div>
                </div>

                <button type="submit" class="btn btn-success text-white w-100 py-3 rounded-pill fw-bold fs-5 mt-2 shadow-sm">
                    <i class="fa-solid fa-lock me-2"></i>Authorize & Pay ₹<%= price %>
                </button>
            </form>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />