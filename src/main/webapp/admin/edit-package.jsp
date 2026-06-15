<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%@ page import="com.tourism.model.TourPackage" %>
<%@ page import="com.tourism.dao.PackageDAO" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    if (loggedInUser == null || !"ADMIN".equals(loggedInUser.getRole())) {
        response.sendRedirect("../login.jsp?error=access_denied");
        return;
    }

    String idStr = request.getParameter("id");
    TourPackage pkg = null;
    if (idStr != null) {
        PackageDAO packageDAO = new PackageDAO();
        pkg = packageDAO.getPackageById(Integer.parseInt(idStr));
    }
    if (pkg == null) {
        response.sendRedirect("dashboard.jsp?error=package_not_found");
        return;
    }
%>
<jsp:include page="../common/header.jsp" />

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-12 col-lg-8">
            <nav class="mb-4" aria-label="breadcrumb">
                <ol class="breadcrumb small">
                    <li class="breadcrumb-item"><a href="dashboard.jsp" class="text-decoration-none">Dashboard</a></li>
                    <li class="breadcrumb-item active">Modify Package</li>
                </ol>
            </nav>

            <div class="card border-0 shadow-sm p-4" style="border-radius: 12px;">
                <div class="card-body">
                    <h4 class="fw-bold text-dark mb-4"><i class="fa-solid fa-pen-to-square text-warning me-2"></i>Edit Tour Package Details</h4>
                    
                    <form action="../EditPackageServlet" method="POST">
                        <input type="hidden" name="id" value="<%= pkg.getId() %>">
                        
                        <div class="row g-3 mb-3">
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Package Title Name</label>
                                <input type="text" class="form-control" name="packageName" value="<%= pkg.getPackageName() %>" required>
                            </div>
                            <div class="col-md-6">
                                <label class="form-label small fw-bold">Geographic Destination</label>
                                <input type="text" class="form-control" name="destination" value="<%= pkg.getDestination() %>" required>
                            </div>
                        </div>

                        <div class="row g-3 mb-3">
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Category Variant Style</label>
                                <select class="form-select" name="category">
                                    <option value="Adventure" <%= "Adventure".equals(pkg.getCategory()) ? "selected" : "" %>>Adventure / Trekking</option>
                                    <option value="Luxury" <%= "Luxury".equals(pkg.getCategory()) ? "selected" : "" %>>Luxury / Executive</option>
                                    <option value="Beach" <%= "Beach".equals(pkg.getCategory()) ? "selected" : "" %>>Beach / Honeymoon</option>
                                    <option value="Cultural" <%= "Cultural".equals(pkg.getCategory()) ? "selected" : "" %>>Historical / Cultural</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Price per Person (₹)</label>
                                <input type="number" step="0.01" class="form-control" name="price" value="<%= pkg.getPrice() %>" required>
                            </div>
                            <div class="col-md-4">
                                <label class="form-label small fw-bold">Duration Timeframe</label>
                                <input type="text" class="form-control" name="duration" value="<%= pkg.getDuration() %>" placeholder="e.g., 5 Days / 4 Nights" required>
                            </div>
                        </div>

                        <div class="mb-3">
                            <label class="form-label small fw-bold">Package Image Link URL</label>
                            <input type="text" class="form-control" name="imageUrl" value="<%= pkg.getImageUrl() != null ? pkg.getImageUrl() : "" %>">
                        </div>

                        <div class="mb-4">
                            <label class="form-label small fw-bold">Detailed Itinerary Schedule</label>
                            <textarea class="form-control" name="itinerary" rows="5" required><%= pkg.getItinerary() %></textarea>
                        </div>

                        <div class="d-flex justify-content-end gap-2">
                            <a href="dashboard.jsp" class="btn btn-light px-4 rounded-pill">Cancel</a>
                            <button type="submit" class="btn btn-warning px-4 rounded-pill fw-bold text-dark shadow-sm">Update Package</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />