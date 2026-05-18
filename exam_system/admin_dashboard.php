<?php
session_start();
// Security Check: If not logged in or not an admin, kick them back to login
if (!isset($_SESSION['user_role']) || $_SESSION['user_role'] !== 'admin') {
    header("Location: login.html");
    exit();
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - Exam System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <ul>
            <li><a href="admin_dashboard.php" class="active">Dashboard</a></li>
            <li><a href="manage_exams.php">Manage Exams</a></li>
            <li><a href="manage_questions.php">Manage Questions</a></li>
            <li><a href="view_results.php">View Results</a></li>
            <li><a href="logout.php">Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>
            <h1>Welcome, <?php echo $_SESSION['user_name'] ?? 'Admin'; ?></h1>
        </header>
        
        <div class="stats-container">
            <div class="card">
                <h3>Total Exams</h3>
                <p id="total-exams">0</p>
            </div>
            <div class="card">
                <h3>Active Students</h3>
                <p id="total-students">0</p>
            </div>
            <div class="card">
                <h3>Results Declared</h3>
                <p id="total-results">0</p>
            </div>
        </div>
    </div>

    <script src="admin.js"></script>
</body>
</html>