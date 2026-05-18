document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    let formData = new FormData(this);

    fetch('login_process.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        if (data === 'admin') {
            window.location.href = 'admin_dashboard.php';
        } else if (data === 'student') {
            window.location.href = 'student_dashboard.php';
        } else {
            alert("Invalid Credentials!");
        }
    });
});