<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.dao.FeedbackDAO, java.util.List, java.util.Map" %>
<%
    List<Map<String, Object>> publicReviews = null;
    int totalReviews = 0;
    double globalAverage = 0.0;
    
    try {
        FeedbackDAO feedbackDAO = new FeedbackDAO();
        publicReviews = feedbackDAO.getAllPublicReviews();
        
        if (publicReviews != null && !publicReviews.isEmpty()) {
            totalReviews = publicReviews.size();
            double totalStars = 0;
            for(Map<String, Object> r : publicReviews) {
                Integer ratingObj = (Integer) r.get("rating");
                totalStars += (ratingObj != null) ? ratingObj : 0;
            }
            globalAverage = totalStars / totalReviews;
        }
    } catch (Exception e) {
        System.err.println("CRITICAL ERROR: Failed loading data header metrics inside reviews.jsp");
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Reviews & Testimonials</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<% try { %>
    <jsp:include page="common/header.jsp" />
<% } catch(Exception e) { %>
    <p class="text-danger small p-2">Warning: Global navbar header component path could not resolve.</p>
<% } %>

<div class="container my-5" style="min-height: 75vh;">
    
    <div class="card border-0 shadow-sm rounded-4 text-center p-5 mb-5 bg-white">
        <h1 class="fw-bold text-dark mb-2">What Our Explorers Say</h1>
        <p class="text-muted text-wrap mx-auto mb-4" style="max-width: 600px;">
            Real ratings and experiential reviews submitted straight from our holidaymakers.
        </p>
        
        <div class="row justify-content-center align-items-center g-4 mt-2">
            <div class="col-6 col-md-3 border-end">
                <h2 class="fw-extrabold text-primary mb-0"><%= String.format("%.1f", globalAverage) %> <small class="fs-5">/ 5</small></h2>
                <div class="text-warning my-1">
                    <% for(int i=0; i < Math.round(globalAverage); i++) { out.print("★"); } %>
                </div>
                <small class="text-muted text-uppercase fw-bold">Platform Rating</small>
            </div>
            <div class="col-6 col-md-3">
                <h2 class="fw-extrabold text-dark mb-0"><%= totalReviews %></h2>
                <p class="text-muted small text-uppercase fw-bold mt-2 mb-0">Verified Reviews</p>
            </div>
        </div>
    </div>

    <div class="row">
        <% if (publicReviews == null || publicReviews.isEmpty()) { %>
            <div class="col-12 text-center py-5">
                <i class="fa-regular fa-comments text-muted fa-4x mb-3"></i>
                <h4 class="text-secondary">No Public Reviews Yet</h4>
                <p class="text-muted small">Be the first to leave a platform appraisal under your account dashboard!</p>
            </div>
        <% } else { 
            for (Map<String, Object> rev : publicReviews) { 
                Integer starsObj = (Integer) rev.get("rating");
                int stars = (starsObj != null) ? starsObj : 0;
                
                // Safe Date Extraction parsing
                Object dateObj = rev.get("submissionDate");
                String displayDate = (dateObj != null) ? dateObj.toString() : "Recent";
                if(displayDate.length() > 10) {
                    displayDate = displayDate.substring(0, 10);
                }
        %>
            <div class="col-md-6 col-lg-4 mb-4">
                <div class="card border-0 shadow-sm rounded-4 h-100 p-4 bg-white d-flex flex-column justify-content-between">
                    <div>
                        <div class="d-flex justify-content-between align-items-start mb-3">
                            <div>
                                <h6 class="fw-bold text-dark mb-0"><%= rev.get("userName") != null ? rev.get("userName") : "Anonymous Traveler" %></h6>
                                <small class="text-muted" style="font-size: 0.75rem;"><%= displayDate %></small>
                            </div>
                            
                            <div class="text-warning small text-nowrap">
                                <% for(int i=0; i<stars; i++) { out.print("★"); } %>
                                <% for(int i=stars; i<5; i++) { out.print("☆"); } %>
                            </div>
                        </div>

                        <div class="mb-3">
                            <% if (rev.get("hotelName") != null) { %>
                                <span class="badge bg-info-subtle text-info text-wrap text-start"><i class="fa-solid fa-hotel me-1"></i><%= rev.get("hotelName") %></span>
                            <% } else if (rev.get("packageName") != null) { %>
                                <span class="badge bg-success-subtle text-success text-wrap text-start"><i class="fa-solid fa-earth-americas me-1"></i><%= rev.get("packageName") %></span>
                            <% } else { %>
                                <span class="badge bg-secondary-subtle text-secondary"><i class="fa-solid fa-globe me-1"></i>General Service</span>
                            <% } %>
                        </div>

                        <h6 class="fw-bold text-dark mb-2"><%= rev.get("subject") != null ? rev.get("subject") : "No Subject" %></h6>
                        <p class="text-muted small mb-0" style="line-height: 1.5;"><%= rev.get("message") != null ? rev.get("message") : "" %></p>
                    </div>
                </div>
            </div>
        <% 
            } 
        } 
        %>
    </div>
</div>

<% try { %>
    <jsp:include page="common/footer.jsp" />
<% } catch(Exception e) {} %>

</body>
</html>