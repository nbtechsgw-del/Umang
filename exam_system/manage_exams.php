<?php
session_start();
if (!isset($_SESSION['user_role']) || $_SESSION['user_role'] !== 'admin') {
    header("Location: login.html");
    exit();
}
include 'db_connect.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Exams - Admin</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <ul>
            <li><a href="admin_dashboard.php">Dashboard</a></li>
            <li><a href="manage_exams.php" class="active">Manage Exams</a></li>
            <li><a href="manage_questions.php">Manage Questions</a></li>
            <li><a href="logout.php">Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>
            <h1>Manage Exams</h1>
        </header>

        <!-- Add Exam Form -->
        <div class="card" style="text-align: left; margin-bottom: 30px;">
            <h3>Create New Exam</h3>
            <form id="addExamForm">
                <div class="input-group">
                    <input type="text" name="title" placeholder="Exam Title" required>
                </div>
                <div class="input-group">
                    <textarea name="description" placeholder="Description"></textarea>
                </div>
                <div style="display:flex; gap:10px;">
                    <input type="number" name="duration" placeholder="Duration (mins)" required>
                    <input type="number" name="pass_marks" placeholder="Passing Marks" required>
                </div>
                <button type="submit">Add Exam</button>
            </form>
        </div>

        <!-- Exam List Table -->
        <div class="card" style="text-align: left;">
            <h3>Existing Exams</h3>
            <table style="width:100%; border-collapse: collapse; margin-top:15px;">
                <thead>
                    <tr style="background:#eee;">
                        <th style="padding:10px; border:1px solid #ddd;">ID</th>
                        <th style="padding:10px; border:1px solid #ddd;">Title</th>
                        <th style="padding:10px; border:1px solid #ddd;">Duration</th>
                        <th style="padding:10px; border:1px solid #ddd;">Actions</th>
                    </tr>
                </thead>
                <tbody id="examTableBody">
                    <!-- Data will be loaded here via JS -->
                </tbody>
            </table>
        </div>
    </div>

    <script src="manage_exams.js"></script>
</body>
</html>