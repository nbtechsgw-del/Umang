function login() {
    const email = document.getElementById("email").value;
    const password = document.getElementById("password").value;

    fetch("http://localhost:8080/login", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify({
            email: email,
            password: password
        })
    })
    .then(res => res.text())
    .then(data => {
        if (data === "Login successful") {

            localStorage.setItem("userEmail", email);

            alert("Login successful");
            window.location.href = "viewLoans.html";
        } else {
            alert("Invalid credentials");
        }
    });
}