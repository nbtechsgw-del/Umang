<?php
session_start();
include 'db_connect.php';

$student_id = 3; 
$exam_id = 1;
$score = 8;
$total = 10;
$stat = 'pass'; // Removed $perc

// REMOVED 'percentage' from the columns and values list
$sql = "INSERT INTO results (student_id, exam_id, score, total_marks, status) 
        VALUES ($student_id, $exam_id, $score, $total, '$stat')";

if (mysqli_query($conn, $sql)) {
    echo "<h2 style='color:green;'>SUCCESS!</h2>";
    echo "<p>MySQL calculated the percentage for you automatically.</p>";
} else {
    echo "Error: " . mysqli_error($conn);
}
?>