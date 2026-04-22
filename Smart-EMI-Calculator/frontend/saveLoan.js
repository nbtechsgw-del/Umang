function saveLoan() {

  const name = document.getElementById("name").value.trim();
  const principal = parseFloat(document.getElementById("principal").value);
  const rate = parseFloat(document.getElementById("rate").value);
  const time = parseInt(document.getElementById("time").value);

  // Name validation
  if (name.length < 3) {
    document.getElementById("errorMsg").innerText = "Name must be at least 3 characters";
    return;
  }

  // Number validations
  if (isNaN(principal) || principal <= 0) {
    document.getElementById("errorMsg").innerText = "Enter valid principal amount";
    return;
  }

  if (isNaN(rate) || rate <= 0) {
    document.getElementById("errorMsg").innerText = "Enter valid interest rate";
    return;
  }

  if (isNaN(time) || time <= 0) {
    document.getElementById("errorMsg").innerText = "Enter valid time in years";
    return;
  }

  const data = {
    name: name,
    principal: principal,
    rate: rate,
    time: time
  };

  fetch("http://localhost:8080/saveLoan", {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(data)
  })
  .then(res => res.json())
  .then(() => {
    document.getElementById("message").innerText = "✅ Loan Saved Successfully!";
    window.location.href = "viewLoans.html";
  })
  .catch(err => {
    console.error(err);
    document.getElementById("errorMsg").innerText = "❌ Error saving loan";
  });
}

function calculateEMI() {

  let p = parseFloat(document.getElementById("principal").value);
  let r = parseFloat(document.getElementById("rate").value) / 12 / 100;
  let n = parseFloat(document.getElementById("time").value) * 12;

  if (!p || !r || !n) {
    document.getElementById("emiValue").innerText = "0";
    return;
  }

  let emi = (p * r * Math.pow(1 + r, n)) / (Math.pow(1 + r, n) - 1);

  document.getElementById("emiValue").innerText = emi.toFixed(2);
}