document.addEventListener('DOMContentLoaded', function() {
    loadAvailableExams();
});

function loadAvailableExams() {
    fetch('manage_exams_process.php?action=fetch')
    .then(res => res.json())
    .then(data => {
        let html = '';
        data.forEach(exam => {
            html += `
            <div class="card">
                <h3>${exam.title}</h3>
                <p>Duration: ${exam.duration} mins</p>
                <button onclick="startExam(${exam.id})" style="margin-top:15px; background-color:#007bff;">
                    Start Exam
                </button>
            </div>`;
        });
        document.getElementById('examList').innerHTML = data.length > 0 ? html : "<p>No exams available at the moment.</p>";
    });
}

function startExam(examId) {
    if(confirm("Do you want to start this exam? The timer will begin immediately.")) {
        window.location.href = `take_exam.php?id=${examId}`;
    }
}