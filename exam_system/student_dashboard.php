<?php
session_start();
if (!isset($_SESSION['user_role']) || $_SESSION['user_role'] !== 'student') {
    header("Location: login.html");
    exit();
}
include 'db_connect.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Dashboard - Exam System</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="sidebar">
        <h2>Student Portal</h2>
        <ul>
            <li><a href="student_dashboard.php" class="active">Available Exams</a></li>
            <li><a href="my_results.php">My Results</a></li>
            <li><a href="logout.php">Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>
            <h1>Welcome, <?php echo $_SESSION['user_name'] ?? 'Student'; ?></h1>
            <p>Select an exam below to begin.</p>
        </header>
        
        <div class="stats-container" id="examList">
        </div>
    </div>

    <script src="student.js"></script>
</body>
</html>