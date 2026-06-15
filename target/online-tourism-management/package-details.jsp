<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.dao.PackageDAO, com.tourism.model.TourPackage, com.tourism.dao.FeedbackDAO, com.tourism.model.Feedback, java.util.List" %>
<%
    String idStr = request.getParameter("id");
    if (idStr == null || idStr.isEmpty()) {
        response.sendRedirect("packages.jsp");
        return;
    }
    
    int packageId = Integer.parseInt(idStr);
    PackageDAO packageDAO = new PackageDAO();
    TourPackage pkg = packageDAO.getPackageById(packageId);
    
    if (pkg == null) {
        response.sendRedirect("packages.jsp?error=not_found");
        return;
    }
    
    FeedbackDAO feedbackDAO = new FeedbackDAO();
    List<Feedback> reviews = feedbackDAO.getReviewsByPackageId(packageId);
    
    // Calculate average rating
    double avgRating = 0.0;
    if (reviews != null && !reviews.isEmpty()) {
        int totalStars = 0;
        for (Feedback f : reviews) {
            totalStars += f.getRating();
        }
        avgRating = (double) totalStars / reviews.size();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= pkg.getPackageName() %> - Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container my-5">
    <div class="card border-0 shadow-sm mb-4 rounded-4 overflow-hidden">
        <div class="row g-0">
            <div class="col-md-5">
                <img src="<%= (pkg.getImageUrl() != null && !pkg.getImageUrl().isEmpty()) ? pkg.getImageUrl() : "https://images.unsplash.com/photo-1469854523086-cc02fe5d8800" %>" class="img-fluid h-100 w-100 object-fit-cover" alt="Package Image" style="min-height: 300px;">
            </div>
            <div class="col-md-7 p-4 d-flex flex-column justify-content-between">
                <div>
                    <span class="badge bg-primary mb-2 text-uppercase"><%= pkg.getCategory() %></span>
                    <h2 class="fw-bold text-dark"><%= pkg.getPackageName() %></h2>
                    <p class="text-muted"><i class="fa-solid fa-location-dot text-danger me-1"></i><%= pkg.getDestination() %></p>
                    
                    <div class="mb-3">
                        <% if(reviews.isEmpty()) { %>
                            <span class="text-muted small">No reviews yet</span>
                        <% } else { %>
                            <span class="text-warning fw-bold"><%= String.format("%.1f", avgRating) %> ★</span>
                            <span class="text-muted small">(Based on <%= reviews.size() %> reviews)</span>
                        <% } %>
                    </div>
                    
                    <p class="text-secondary"><%= pkg.getItinerary() %></p>
                </div>
                <div class="d-flex justify-content-between align-items-center mt-3">
                    <div>
                        <small class="text-muted d-block">Duration: <%= pkg.getDuration() %></small>
                        <h3 class="text-success fw-bold mb-0">₹<%= pkg.getPrice() %></h3>
                    </div>
                    <a href="book.jsp?packageId=<%= pkg.getId() %>" class="btn btn-primary px-4 py-2 rounded-pill fw-bold">Book This Tour</a>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm rounded-4 p-4">
                <h4 class="fw-bold text-dark mb-4">
                    <i class="fa-solid fa-star-half-stroke text-warning me-2"></i>Customer Reviews & Ratings
                </h4>

                <% if (reviews == null || reviews.isEmpty()) { %>
                    <div class="text-center py-4">
                        <i class="fa-regular fa-comments text-muted fa-3x mb-3"></i>
                        <h5>No Reviews Available</h5>
                        <p class="text-muted small">Be the first client to reserve and drop an evaluation feedback track!</p>
                    </div>
                <% } else { 
                    for (Feedback rev : reviews) { 
                %>
                    <div class="border-bottom pb-3 mb-3">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <h6 class="fw-bold text-dark mb-0"><%= rev.getUserName() %></h6>
                                <div class="text-warning my-1 small">
                                    <% for(int i=0; i < rev.getRating(); i++) { out.print("★ "); } %>
                                    <% for(int i=rev.getRating(); i < 5; i++) { out.print("☆ "); } %>
                                </div>
                            </div>
                            <small class="text-muted"><%= rev.getSubmissionDate() != null ? rev.getSubmissionDate().toString().substring(0, 10) : "" %></small>
                        </div>
                        <p class="fw-semibold text-secondary mb-1 small mt-2"><%= rev.getSubject() %></p>
                        <p class="text-muted small mb-0"><%= rev.getMessage() %></p>
                    </div>
                <% 
                    } 
                } 
                %>
            </div>
        </div>
    </div>
</div>

</body>
</html>