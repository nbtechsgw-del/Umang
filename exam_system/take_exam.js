let currentQuestion = 0;
let questions = [];
let timeLeft = DURATION;

document.addEventListener('DOMContentLoaded', function() {
    startTimer();
    loadQuestions();

    document.getElementById('examForm').addEventListener('submit', function(e) {
        e.preventDefault();
        submitExam();
    });
});

function loadQuestions() {
    fetch(`manage_questions_process.php?action=fetch&exam_id=${EXAM_ID}`)
    .then(res => res.json())
    .then(data => {
        questions = data;
        renderQuestions();
    });
}

function renderQuestions() {
    const container = document.getElementById('questions-container');
    container.innerHTML = questions.map((q, index) => `
        <div class="question-card ${index === 0 ? 'active' : ''}" id="q-${index}">
            <h3>Question ${index + 1} of ${questions.length}</h3>
            <p style="font-size: 18px; margin: 20px 0;">${q.question_text}</p>
            <label class="option"><input type="radio" name="answer[${q.id}]" value="A"> ${q.option_a}</label>
            <label class="option"><input type="radio" name="answer[${q.id}]" value="B"> ${q.option_b}</label>
            <label class="option"><input type="radio" name="answer[${q.id}]" value="C"> ${q.option_c}</label>
            <label class="option"><input type="radio" name="answer[${q.id}]" value="D"> ${q.option_d}</label>
        </div>
    `).join('');
    updateButtons();
}

function changeQuestion(step) {
    document.getElementById(`q-${currentQuestion}`).classList.remove('active');
    currentQuestion += step;
    document.getElementById(`q-${currentQuestion}`).classList.add('active');
    updateButtons();
}

function updateButtons() {
    document.getElementById('prevBtn').style.display = currentQuestion === 0 ? 'none' : 'block';
    if (currentQuestion === questions.length - 1) {
        document.getElementById('nextBtn').style.display = 'none';
        document.getElementById('submitBtn').style.display = 'block';
    } else {
        document.getElementById('nextBtn').style.display = 'block';
        document.getElementById('submitBtn').style.display = 'none';
    }
}

function startTimer() {
    const display = document.getElementById('time-display');
    const timerInterval = setInterval(() => {
        let minutes = Math.floor(timeLeft / 60);
        let seconds = timeLeft % 60;
        display.textContent = `${minutes}:${seconds < 10 ? '0' : ''}${seconds}`;
        
        if (timeLeft <= 0) {
            clearInterval(timerInterval);
            alert("Time's up! Your exam will be submitted automatically.");
            submitExam();
        }
        timeLeft--;
    }, 1000);
}

function submitExam() {
    const formData = new FormData(document.getElementById('examForm'));
    
    fetch('submit_exam_process.php', {
        method: 'POST',
        body: formData
    })
    .then(res => res.text())
    .then(data => {
        // .trim() removes any accidental whitespace from the PHP output
        if (data.trim() === "success") {
            alert("Exam submitted successfully!");
            // This line performs the redirect
            window.location.href = 'student_dashboard.php';
        } else {
            // This helps you catch errors like the "Generated Column" issue
            alert("Error: " + data);
        }
    })
    .catch(error => {
        console.error('Error:', error);
        alert("An error occurred during submission.");
    });
}