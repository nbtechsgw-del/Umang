<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String txnId = request.getParameter("txnId");
    String amount = request.getParameter("amount");
    String bookingId = request.getParameter("bookingId");
    
    if (txnId == null || amount == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<jsp:include page="common/header.jsp" />

<div class="container my-5" style="max-width: 650px;">
    <div class="card border-0 shadow-sm p-5 rounded-4 bg-white text-center mb-4">
        <div class="mb-3">
            <i class="fa-solid fa-circle-check text-success fa-5x"></i>
        </div>
        <h2 class="fw-bold text-dark">Booking Confirmed!</h2>
        <p class="text-muted">Pack your bags! Your payments settled successfully, and your itinerary registration is securely logged.</p>
        
        <hr class="my-4 opacity-50">

        <div class="bg-light p-4 rounded-3 text-start border" id="invoicePrintArea">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold text-primary mb-0">EXPLOREHORIZONS</h5>
                <span class="badge bg-success text-white px-3 py-2 rounded-pill small">PAID RECEIPT</span>
            </div>
            
            <div class="row g-3 small text-secondary">
                <div class="col-6">
                    <strong>Invoice System Reference:</strong><br>
                    <span class="text-dark fw-medium">#BK-<%= bookingId %></span>
                </div>
                <div class="col-6 text-end">
                    <strong>Payment Timestamp:</strong><br>
                    <span class="text-dark fw-medium"><%= new java.util.Date().toString().substring(0, 16) %></span>
                </div>
                <div class="col-12">
                    <div class="border-top my-2"></div>
                </div>
                <div class="col-6">
                    <strong>Bank Authorization ID:</strong><br>
                    <span class="text-dark font-monospace fw-bold"><%= txnId %></span>
                </div>
                <div class="col-6 text-end">
                    <strong>Total Settled Amount:</strong><br>
                    <span class="text-primary fw-extrabold fs-5">₹<%= amount %></span>
                </div>
            </div>
        </div>

        <div class="mt-4 d-flex gap-2 justify-content-center no-print">
            <button onclick="window.print();" class="btn btn-outline-secondary rounded-pill px-4 fw-semibold">
                <i class="fa-solid fa-print me-2"></i>Print/Save Invoice
            </button>
            <a href="index.jsp" class="btn btn-primary text-white rounded-pill px-4 fw-bold">
                Return to Dashboard
            </a>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />