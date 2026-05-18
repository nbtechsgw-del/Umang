<?php
session_start();
include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $exam_id = (int)$_POST['exam_id'];
    $user_id = $_SESSION['user_id'];
    $answers = $_POST['answer'] ?? []; 

    $total_marks = 0;
    $obtained_marks = 0;

    $query = "SELECT id, correct_option, marks FROM questions WHERE exam_id = $exam_id";
    $result = $conn->query($query);

    while ($row = $result->fetch_assoc()) {
        $q_id = $row['id'];
        $correct = $row['correct_option'];
        $weight = (int)$row['marks'];

        $total_marks += $weight;

        if (isset($answers[$q_id]) && $answers[$q_id] === $correct) {
            $obtained_marks += $weight;
        }
    }

    $stmt = $conn->prepare("INSERT INTO results (user_id, exam_id, total_marks, obtained_marks) VALUES (?, ?, ?, ?)");
    $stmt->bind_param("iiii", $user_id, $exam_id, $total_marks, $obtained_marks);

    if ($stmt->execute()) {
        echo "success";
    } else {
        echo "error";
    }
    $stmt->close();
}
?>