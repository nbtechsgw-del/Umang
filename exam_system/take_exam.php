<?php
session_start();
if (!isset($_SESSION['user_role']) || $_SESSION['user_role'] !== 'student') {
    header("Location: login.html");
    exit();
}
include 'db_connect.php';

$exam_id = (int)$_GET['id'];

$exam_query = $conn->query("SELECT * FROM exams WHERE id = $exam_id");
$exam = $exam_query->fetch_assoc();

if (!$exam) {
    die("Exam not found.");
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title><?php echo $exam['title']; ?> - Live Exam</title>
    <link rel="stylesheet" href="style.css">
    <style>
        .exam-header { display: flex; justify-content: space-between; align-items: center; background: #fff; padding: 20px; border-radius: 8px; margin-bottom: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
        #timer { font-size: 24px; font-weight: bold; color: #e74c3c; }
        .question-card { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); display: none; }
        .question-card.active { display: block; }
        .option { display: block; padding: 15px; margin: 10px 0; border: 1px solid #ddd; border-radius: 5px; cursor: pointer; transition: 0.3s; }
        .option:hover { background: #f0f7ff; border-color: #3498db; }
        .option input { margin-right: 15px; }
        .nav-buttons { margin-top: 20px; display: flex; justify-content: space-between; }
    </style>
</head>
<body style="display: block; padding: 40px; background-color: #f4f7f6;">
    <div class="exam-header">
        <h2><?php echo $exam['title']; ?></h2>
        <div id="timer">Time Left: <span id="time-display">--:--</span></div>
    </div>

    <form id="examForm">
        <input type="hidden" name="exam_id" value="<?php echo $exam_id; ?>">
        <div id="questions-container">
        </div>
        
        <div class="nav-buttons">
            <button type="button" id="prevBtn" onclick="changeQuestion(-1)" style="width: auto; background: #95a5a6; display: none;">Previous</button>
            <button type="button" id="nextBtn" onclick="changeQuestion(1)" style="width: auto;">Next</button>
            <button type="submit" id="submitBtn" style="width: auto; background: #27ae60; display: none;">Submit Exam</button>
        </div>
    </form>

    <script>
        const EXAM_ID = <?php echo $exam_id; ?>;
        const DURATION = <?php echo $exam['duration']; ?> * 60;
    </script>
    <script src="take_exam.js"></script>
</body>
</html>