<?php
session_start();
include 'db_connect.php';

$action = $_REQUEST['action'] ?? '';

// Fetching exams for the table
if ($action == 'fetch') {
    $result = $conn->query("SELECT id, title, duration FROM exams ORDER BY id DESC");
    $exams = [];
    while($row = $result->fetch_assoc()) {
        $exams[] = $row;
    }
    echo json_encode($exams);
    exit();
}

// Adding a new exam
if ($action == 'add') {
    $title = mysqli_real_escape_string($conn, $_POST['title']);
    $desc = mysqli_real_escape_string($conn, $_POST['description']);
    $dur = (int)$_POST['duration'];
    $pass = (int)$_POST['pass_marks'];
    $admin_id = $_SESSION['user_id'];

    $sql = "INSERT INTO exams (title, description, duration, pass_marks, created_by) 
            VALUES ('$title', '$desc', '$dur', '$pass', '$admin_id')";

    if ($conn->query($sql)) {
        echo "success";
    } else {
        echo "Error: " . $conn->error;
    }
    exit();
}
?>