<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="common/header.jsp" />

<div class="container my-5 py-5 text-center">
    <div class="card border-0 shadow-sm p-5 mx-auto" style="max-width: 600px; border-radius: 14px;">
        <div class="card-body">
            <i class="fa-solid fa-circle-check text-success fa-4x mb-4"></i>
            <h1 class="fw-bold text-dark mb-2">Booking Confirmed!</h1>
            <p class="text-muted mb-4">Your tour request has been sent successfully. An administrator is currently reviewing the itinerary clearance details on the master dashboard pipeline.</p>
            
            <div class="d-flex gap-3 justify-content-center">
                <a href="index.jsp" class="btn btn-primary px-4 py-2 rounded-pill fw-bold text-white">Explore More Packages</a>
            </div>
        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />