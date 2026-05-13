const form = document.getElementById('regForm');

document.querySelectorAll('.toggle-password').forEach(toggle => {
    toggle.addEventListener('click', () => {
        const input = toggle.previousElementSibling;
        input.type = input.type === 'password' ? 'text' : 'password';
        toggle.innerText = input.type === 'password' ? 'Show' : 'Hide';
    });
});

function setError(input, message) {
    const error = input.parentElement.parentElement.querySelector('.error');
    error.innerText = message;
}

form.addEventListener('submit', e => {
    e.preventDefault();

    let isValid = true;

    const name = fullname.value.trim();
    const emailVal = email.value;
    const passVal = password.value;
    const confVal = confirmPass.value;

    if (!name) {
        setError(fullname, "Name required");
        isValid = false;
    } else setError(fullname, "");

    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailVal)) {
        setError(email, "Invalid email");
        isValid = false;
    } else setError(email, "");

    if (passVal.length < 6) {
        setError(password, "Min 6 chars");
        isValid = false;
    } else setError(password, "");

    if (passVal !== confVal) {
        setError(confirmPass, "Passwords mismatch");
        isValid = false;
    } else setError(confirmPass, "");

    if (!document.querySelector('[name="gender"]:checked')) {
        genderError.innerText = "Select gender";
        isValid = false;
    } else genderError.innerText = "";

    if (!document.querySelectorAll('[name="skills"]:checked').length) {
        skillsError.innerText = "Select skill";
        isValid = false;
    } else skillsError.innerText = "";

    if (isValid) {
        successMsg.innerText = "Registration Successful!";
        form.reset();

        setTimeout(() => {
            successMsg.innerText = "";
        }, 2000);
    }
});