<?php
include 'db_connect.php'; 
session_start();


if (!isset($_SESSION['user_id'])) {
    header("Location: login.php");
    exit();
}

$student_id = $_SESSION['user_id']; 

$query = "SELECT r.score, r.total_marks, r.percentage, r.status, e.title 
          FROM results r 
          JOIN exams e ON r.exam_id = e.id 
          WHERE r.student_id = $student_id 
          ORDER BY r.attempted_at DESC"; 

$result = mysqli_query($conn, $query);
?>

<!DOCTYPE html>
<html>
<head>
    <title>My Results</title>
    <style>
        table { width: 100%; border-collapse: collapse; font-family: sans-serif; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background-color: #333; color: white; }
        tr:nth-child(even) { background-color: #f2f2f2; }
    </style>
</head> 
<body>

<h2>Exam Results</h2>

<table>
    <thead>
        <tr>
            <th>Exam</th>
            <th>Score</th>
            <th>Total Marks</th>
            <th>Percentage</th>
            <th>Status</th>
        </tr>
    </thead>
    <tbody>
        <?php 
        if (mysqli_num_rows($result) > 0) {
            while($row = mysqli_fetch_assoc($result)) { 
        ?>
        <tr>
            <td><?php echo htmlspecialchars($row['title']); ?></td>
            <td><?php echo $row['score']; ?></td> <!-- Matches image_9b2441.png[cite: 4] -->
            <td><?php echo $row['total_marks']; ?></td> <!-- Matches image_9b2441.png[cite: 4] -->
            <td><?php echo $row['percentage']; ?>%</td> <!-- Matches image_9b2441.png[cite: 4] -->
            <td><?php echo $row['status']; ?></td> <!-- Matches image_9b2441.png[cite: 4] -->
        </tr>
        <?php 
            } 
        } else {
            echo "<tr><td colspan='5'>No results found.</td></tr>";
        }
        ?>
    </tbody>
</table>

</body>
</html>