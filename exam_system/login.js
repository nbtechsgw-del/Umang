document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();
    
    let formData = new FormData(this);

    fetch('login_process.php', {
        method: 'POST',
        body: formData
    })
    .then(response => response.text())
    .then(data => {
        console.log("Server response:", data);
        const response = data.trim();
    
        if (response === 'admin') {
            window.location.href = 'admin_dashboard.php';
        } else if (response === 'student') {
            window.location.href = 'student_dashboard.php';
        } else {
            alert("Invalid Credentials! Server said: " + response);
        }
    });
});