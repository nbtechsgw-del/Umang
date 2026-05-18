<?php
session_start();
include 'db_connect.php';

$action = $_REQUEST['action'] ?? '';

if ($action == 'fetch') {
    $exam_id = (int)$_GET['exam_id'];
    $result = $conn->query("SELECT * FROM questions WHERE exam_id = $exam_id ORDER BY id DESC");
    $questions = [];
    while($row = $result->fetch_assoc()) {
        $questions[] = $row;
    }
    echo json_encode($questions);
}

if ($action == 'add') {
    $exam_id = (int)$_POST['exam_id'];
    $text = mysqli_real_escape_string($conn, $_POST['question_text']);
    $a = mysqli_real_escape_string($conn, $_POST['option_a']);
    $b = mysqli_real_escape_string($conn, $_POST['option_b']);
    $c = mysqli_real_escape_string($conn, $_POST['option_c']);
    $d = mysqli_real_escape_string($conn, $_POST['option_d']);
    $correct = $_POST['correct_option'];
    $marks = (int)$_POST['marks'];

    $sql = "INSERT INTO questions (exam_id, question_text, option_a, option_b, option_c, option_d, correct_option, marks) 
            VALUES ($exam_id, '$text', '$a', '$b', '$c', '$d', '$correct', $marks)";

    if ($conn->query($sql)) {
        echo "success";
    } else {
        echo $conn->error;
    }
}
?>