<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.tourism.model.User" %>
<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ExploreHorizons | Online Tourism System</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    
    <style>
        body {
            font-family: 'Poppins', sans-serif;
            background-color: #fdfdfd;
        }
        .navbar {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            background-color: #ffffff !important;
        }
        .navbar-brand {
            font-weight: 700;
            color: #0d6efd !important;
        }
        .nav-link {
            font-weight: 500;
            color: #495057 !important;
            margin-right: 15px;
            transition: color 0.2s ease-in-out;
        }
        .nav-link:hover {
            color: #0d6efd !important;
        }
        .btn-custom {
            border-radius: 30px;
            font-weight: 600;
            padding: 6px 20px;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-light sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/online-tourism-management/index.jsp">
            <i class="fa-solid fa-earth-americas text-primary me-2"></i>ExploreHorizons
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        
        <div class="collapse navbar-collapse" id="navbarNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link" href="/online-tourism-management/index.jsp">Home</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/online-tourism-management/reviews.jsp">Reviews</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="/online-tourism-management/hotels.jsp">Hotels</a>
                </li>
            </ul>
            
            <div class="d-flex align-items-center">
            <% if (loggedInUser == null) { %>
                <a href="<%= request.getContextPath() %>/login.jsp" class="btn btn-outline-primary btn-custom me-2">Login</a>
                <a href="<%= request.getContextPath() %>/register.jsp" class="btn btn-primary btn-custom text-white">Sign Up</a>
            <% } else { %>
                <span class="me-3 text-muted">Welcome, <strong><%= loggedInUser.getFullName() %></strong></span>
        
            <% if ("ADMIN".equals(loggedInUser.getRole())) { %>
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp" class="btn btn-dark btn-custom me-2">
                    <i class="fa-solid fa-gauge me-1"></i> Dashboard
                </a>
            <% } else { %>
                <a href="<%= request.getContextPath() %>/user/profile.jsp" class="btn btn-outline-primary btn-custom me-2">
                    <i class="fa-solid fa-user me-1"></i> My Profile
                </a>
            <% } %>
        
                <a href="<%= request.getContextPath() %>/LogoutServlet" class="btn btn-danger btn-custom text-white">
                    <i class="fa-solid fa-power-off"></i>
                </a>
            <% } %>
            </div>
        </div>
    </div>
</nav>