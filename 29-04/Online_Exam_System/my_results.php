<?php
session_start();
if (!isset($_SESSION['user_role'])) { header("Location: login.html"); exit(); }
include 'db_connect.php';

$user_id = $_SESSION['user_id'];
$query = "SELECT r.*, e.title FROM results r 
          JOIN exams e ON r.exam_id = e.id 
          WHERE r.user_id = $user_id ORDER BY r.created_at DESC";
$results = $conn->query($query);
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Results</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="sidebar">
        <h2>Student Portal</h2>
        <ul>
            <li><a href="student_dashboard.php">Available Exams</a></li>
            <li><a href="my_results.php" class="active">My Results</a></li>
            <li><a href="logout.php">Logout</a></li>
        </ul>
    </div>
    <div class="main-content">
        <h1>Your Exam History</h1>
        <div class="card">
            <table style="width:100%; border-collapse: collapse;">
                <thead>
                    <tr style="background:#f8f9fa; border-bottom: 2px solid #dee2e6;">
                        <th style="padding:12px; text-align:left;">Exam Title</th>
                        <th style="padding:12px; text-align:left;">Score</th>
                        <th style="padding:12px; text-align:left;">Percentage</th>
                        <th style="padding:12px; text-align:left;">Date Attempted</th>
                    </tr>
                </thead>
                <tbody>
                    <?php while($row = $results->fetch_assoc()): 
                        $percent = ($row['obtained_marks'] / $row['total_marks']) * 100;
                    ?>
                    <tr style="border-bottom: 1px solid #eee;">
                        <td style="padding:12px;"><?php echo $row['title']; ?></td>
                        <td style="padding:12px; font-weight:bold;"><?php echo $row['obtained_marks']; ?> / <?php echo $row['total_marks']; ?></td>
                        <td style="padding:12px;"><?php echo round($percent, 2); ?>%</td>
                        <td style="padding:12px; color:#666;"><?php echo date('M d, Y', strtotime($row['created_at'])); ?></td>
                    </tr>
                    <?php endwhile; ?>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>