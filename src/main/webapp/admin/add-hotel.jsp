<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
        response.sendRedirect("../login.jsp?error=access_denied");
        return;
    }
%>
<jsp:include page="../common/header.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-12 col-lg-6">
            <div class="card border-0 shadow-sm p-4" style="border-radius: 12px;">
                <div class="card-body">
                    <h4 class="fw-bold text-dark mb-4"><i class="fa-solid fa-hotel text-primary me-2"></i>Add New Hotel Property</h4>
                    <form action="../AddHotelServlet" method="POST">
    <div class="mb-3">
        <label>Hotel Business Name</label>
        <input type="text" name="hotelName" class="form-control" required> </div>
    <div class="mb-3">
        <label>Geographic Location City/Country</label>
        <input type="text" name="destination" class="form-control" required> </div>
    <div class="mb-3">
        <label>Star Rating Class</label>
        <select class="form-select" name="rating"> <option value="3">3 Star Standard</option>
            <option value="4">4 Star Executive</option>
            <option value="5">5 Star Luxury</option>
        </select>
    </div>
    <div class="mb-3">
        <label>Price Per Night (₹)</label>
        <input type="number" step="0.01" name="pricePerNight" class="form-control" required> </div>
    <button type="submit" class="btn btn-primary">Save Property</button>
</form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />