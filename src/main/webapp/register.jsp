<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page="common/header.jsp" />

<div class="container my-5">
    <div class="row justify-content-center align-items-center" style="min-height: 75vh;">
        <div class="col-12 col-md-8 col-lg-5">
            
            <div class="card border-0 shadow-lg p-4" style="border-radius: 16px;">
                <div class="card-body">
                    
                    <div class="text-center mb-4">
                        <h3 class="fw-bold text-dark">Create Your Account</h3>
                        <p class="text-muted small">Join us to explore and book amazing global travel paths</p>
                    </div>

                    <% if (request.getParameter("error") != null) { %>
                        <div class="alert alert-danger p-2 small" role="alert">
                            <i class="fa-solid fa-circle-exclamation me-2"></i> Registration failed. Email might already be taken.
                        </div>
                    <% } %>

                    <form action="RegistrationServlet" method="POST" onsubmit="return validateForm();">
                        
                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">Full Name</label>
                            <input type="text" class="form-control" name="fullName" placeholder="ABC PQR" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">Email Address</label>
                            <input type="email" class="form-control" name="email" placeholder="xyz@example.com" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">Phone Number</label>
                            <input type="tel" class="form-control" name="phone" maxlength="10" placeholder="1234567890" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label text-secondary small fw-bold">Password</label>
                            <input type="password" class="form-control" id="password" name="password" placeholder="••••••••" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label text-secondary small fw-bold">Confirm Password</label>
                            <input type="password" class="form-control" id="confirmPassword" placeholder="••••••••" required>
                            <div id="passwordError" class="text-danger small mt-1 d-none">Passwords do not match!</div>
                        </div>

                        <button type="submit" class="btn btn-primary w-100 py-2 fw-bold text-white shadow-sm mb-3" style="border-radius: 10px;">
                            Sign Up <i class="fa-solid fa-user-plus ms-1"></i>
                        </button>
                    </form>

                    <div class="text-center mt-2">
                        <p class="text-muted small mb-0">Already registered? 
                            <a href="login.jsp" class="text-primary fw-bold text-decoration-none">Sign in here</a>
                        </p>
                    </div>

                </div>
            </div>

        </div>
    </div>
</div>

<script>
function validateForm() {
    var password = document.getElementById("password").value;
    var confirmPassword = document.getElementById("confirmPassword").value;
    var errorDiv = document.getElementById("passwordError");

    if (password !== confirmPassword) {
        errorDiv.classList.remove("d-none");
        return false;
    }
    errorDiv.classList.add("d-none");
    return true;
}
</script>

<jsp:include page="common/footer.jsp" />