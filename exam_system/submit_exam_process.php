<?php
session_start();
include 'db_connect.php';

if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    $student_id = $_SESSION['user_id'];
    $exam_id = (int)$_POST['exam_id'];
    $answers = isset    ($_POST['answer']) ? $_POST['answer'] : [];

    $total_score = 0;
    $max_marks = 0;

    // 1. Fetch questions to calculate score
    $q_query = "SELECT id, correct_option, marks FROM questions WHERE exam_id = $exam_id";
    $q_result = mysqli_query($conn, $q_query);

    while ($q_row = mysqli_fetch_assoc($q_result)) {
        $qid = $q_row['id'];
        $correct = $q_row['correct_option'];
        $q_marks = $q_row['marks'];
        $max_marks += $q_marks;

        $chosen = isset($answers[$qid]) ? $answers[$qid] : '';
        if ($chosen === $correct) {
            $total_score += $q_marks;
        }
    }

    // 2. INSERT into results (REMOVED 'percentage' and 'status' from the query)
    // The database will calculate these for you!
    $insert_sql = "INSERT INTO results (student_id, exam_id, score, total_marks) 
                   VALUES ($student_id, $exam_id, $total_score, $max_marks)";

    if (mysqli_query($conn, $insert_sql)) {
        echo "success";
    } else {
        echo "error: " . mysqli_error($conn);
    }
}
?>