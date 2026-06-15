<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<jsp:include page="common/header.jsp" />

<div class="container my-5">
    <div class="row justify-content-center align-items-center" style="min-height: 75vh;">
        <div class="col-12 col-md-8 col-lg-4">
            
            <div class="card border-0 shadow-lg p-4" style="border-radius: 16px;">
                <div class="card-body">
                    
                    <div class="text-center mb-4">
                        <h3 class="fw-bold text-dark">Welcome Back</h3>
                        <p class="text-muted small">Sign in to manage your tours and reservations</p>
                    </div>

                    <% if ("signup_success".equals(request.getParameter("msg"))) { %>
                        <div class="alert alert-success p-2 small animate-fade" role="alert">
                            <i class="fa-solid fa-circle-check me-2"></i> Account created! Please sign in below.
                        </div>
                    <% } %>

                    <% if ("invalid_credentials".equals(request.getParameter("error"))) { %>
                        <div class="alert alert-danger p-2 small" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2"></i> Invalid email or password.
                        </div>
                    <% } %>

                    <% if ("access_denied".equals(request.getParameter("error"))) { %>
                        <div class="alert alert-warning p-2 small" role="alert">
                            <i class="fa-solid fa-lock me-2"></i> Please log in to access that page.
                        </div>
                    <% } %>

                    <form action="LoginServlet" method="POST">
                        
                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">Email Address</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-envelope"></i></span>
                                <input type="email" class="form-control bg-light border-start-0" name="email" placeholder="name@example.com" required>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label text-secondary small fw-bold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0 text-muted"><i class="fa-solid fa-key"></i></span>
                                <input type="password" class="form-control bg-light border-start-0" name="password" placeholder="••••••••" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold text-white shadow-sm mb-3" style="border-radius: 10px;">
                            Sign In <i class="fa-solid fa-arrow-right-to-bracket ms-1"></i>
                        </button>
                    </form>

                    <div class="text-center mt-2">
                        <p class="text-muted small mb-0">New to ExploreHorizons? 
                            <a href="register.jsp" class="text-primary fw-bold text-decoration-none">Create an account</a>
                        </p>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<jsp:include page="common/footer.jsp" />