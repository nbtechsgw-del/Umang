document.addEventListener('DOMContentLoaded', function() {
    const examSelect = document.getElementById('examSelect');
    
    // Load questions when exam selection changes
    examSelect.addEventListener('change', function() {
        loadQuestions(this.value);
    });

    // Handle Form Submission
    document.getElementById('addQuestionForm').addEventListener('submit', function(e) {
        e.preventDefault();
        let formData = new FormData(this);
        formData.append('action', 'add');

        fetch('manage_questions_process.php', {
            method: 'POST',
            body: formData
        })
        .then(res => res.text())
        .then(data => {
            if(data.trim() === 'success') {
                alert("Question added successfully!");
                loadQuestions(examSelect.value); // Refresh list
                this.reset();
            } else {
                alert("Error: " + data);
            }
        });
    });
});

function loadQuestions(examId) {
    if(!examId) return;
    
    fetch(`manage_questions_process.php?action=fetch&exam_id=${examId}`)
    .then(res => res.json())
    .then(data => {
        let html = '<table style="width:100%; border-collapse: collapse; margin-top:15px;">' +
                   '<tr style="background:#eee;"><th>Question</th><th>Correct</th><th>Action</th></tr>';
        data.forEach(q => {
            html += `<tr>
                <td style="padding:10px; border:1px solid #ddd;">${q.question_text}</td>
                <td style="padding:10px; border:1px solid #ddd; text-align:center;">${q.correct_option}</td>
                <td style="padding:10px; border:1px solid #ddd; text-align:center;">
                    <button style="background:red; color:white; border:none; padding:5px; cursor:pointer;">Delete</button>
                </td>
            </tr>`;
        });
        html += '</table>';
        document.getElementById('questionsDisplay').innerHTML = data.length > 0 ? html : "<p>No questions found for this exam.</p>";
    });
}