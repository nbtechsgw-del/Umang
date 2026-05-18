<?php
session_start();
if (!isset($_SESSION['user_role']) || $_SESSION['user_role'] !== 'admin') {
    header("Location: login.html");
    exit();
}
include 'db_connect.php';

// Fetch exams for the dropdown
$exams = $conn->query("SELECT id, title FROM exams WHERE is_active = 1");
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Questions - Admin</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="sidebar">
        <h2>Admin Panel</h2>
        <ul>
            <li><a href="admin_dashboard.php">Dashboard</a></li>
            <li><a href="manage_exams.php">Manage Exams</a></li>
            <li><a href="manage_questions.php" class="active">Manage Questions</a></li>
            <li><a href="logout.php">Logout</a></li>
        </ul>
    </div>

    <div class="main-content">
        <header>
            <h1>Manage Questions</h1>
        </header>

        <div class="card" style="text-align: left; margin-bottom: 30px;">
            <h3>Add New Question</h3>
            <form id="addQuestionForm">
                <div class="input-group">
                    <label>Select Exam:</label>
                    <select name="exam_id" id="examSelect" required style="width:100%; padding:10px; border-radius:5px;">
                        <option value="">-- Select Exam --</option>
                        <?php while($row = $exams->fetch_assoc()): ?>
                            <option value="<?php echo $row['id']; ?>"><?php echo $row['title']; ?></option>
                        <?php endwhile; ?>
                    </select>
                </div>
                <div class="input-group">
                    <textarea name="question_text" placeholder="Enter Question Text" required style="width:100%; padding:10px; border-radius:5px; margin-top:10px;"></textarea>
                </div>
                <div style="display:grid; grid-template-columns: 1fr 1fr; gap:10px;">
                    <input type="text" name="option_a" placeholder="Option A" required>
                    <input type="text" name="option_b" placeholder="Option B" required>
                    <input type="text" name="option_c" placeholder="Option C" required>
                    <input type="text" name="option_d" placeholder="Option D" required>
                </div>
                <div class="input-group" style="margin-top:10px;">
                    <label>Correct Option:</label>
                    <select name="correct_option" required style="padding:5px;">
                        <option value="A">A</option>
                        <option value="B">B</option>
                        <option value="C">C</option>
                        <option value="D">D</option>
                    </select>
                    <label style="margin-left:20px;">Marks:</label>
                    <input type="number" name="marks" value="1" style="width:60px; padding:5px;">
                </div>
                <button type="submit" style="margin-top:15px; background-color:#28a745;">Save Question</button>
            </form>
        </div>

        <div class="card" style="text-align: left;">
            <h3>Questions List</h3>
            <div id="questionsDisplay">
                <p style="color:gray;">Select an exam above to view its questions.</p>
            </div>
        </div>
    </div>

    <script src="manage_questions.js"></script>
</body>
</html>