document.addEventListener('DOMContentLoaded', function() {
    loadExams();

    // Inside manage_exams_script.js
document.getElementById('addExamForm').addEventListener('submit', function(e) {
    e.preventDefault();
    let formData = new FormData(this);
    formData.append('action', 'add');

    fetch('manage_exams_process.php', { // Ensure this is manage_exams_process.php
        method: 'POST',
        body: formData
    })
    .then(res => res.text())
    .then(data => {
        if(data.trim() === 'success') {
            alert("Exam Added Successfully!");
            location.reload(); 
        } else {
            console.log(data); // This will help us see if there's still a PHP warning
            alert("Check console for details.");
        }
    });
});
});

function loadExams() {
    fetch('manage_exams_process.php?action=fetch')
    .then(res => res.json())
    .then(data => {
        let html = '';
        data.forEach(exam => {
            html += `<tr>
                <td style="padding:10px; border:1px solid #ddd;">${exam.id}</td>
                <td style="padding:10px; border:1px solid #ddd;">${exam.title}</td>
                <td style="padding:10px; border:1px solid #ddd;">${exam.duration} mins</td>
                <td style="padding:10px; border:1px solid #ddd;">
                    <button style="background:red; padding:5px 10px; font-size:12px;">Delete</button>
                </td>
            </tr>`;
        });
        document.getElementById('examTableBody').innerHTML = html;
    });
}