let loanId = null;

// ✅ Get ID from URL
window.onload = function () {
  const params = new URLSearchParams(window.location.search);
  loanId = params.get("id");

  loadLoanData();
};

// ✅ Load existing data
function loadLoanData() {
  fetch(`http://localhost:8080/getLoans`)
    .then(res => res.json())
    .then(data => {

      const loan = data.find(l => l.id == loanId);

      if (!loan) {
        alert("Loan not found");
        return;
      }

      document.getElementById("name").value = loan.name;
      document.getElementById("principal").value = loan.principal;
      document.getElementById("rate").value = loan.rate;
      document.getElementById("time").value = loan.time;
    })
    .catch(err => {
      console.error(err);
      alert("Error loading loan");
    });
}

// ✅ Update loan
function updateLoan() {

  const name = document.getElementById("name").value.trim();
  const principal = parseFloat(document.getElementById("principal").value);
  const rate = parseFloat(document.getElementById("rate").value);
  const time = parseInt(document.getElementById("time").value);

  // Validation
  if (!name || principal <= 0 || rate <= 0 || time <= 0) {
    alert("Please enter valid data");
    return;
  }

  const updatedData = { name, principal, rate, time };

  fetch(`http://localhost:8080/updateLoan/${loanId}`, {
    method: "PUT",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify(updatedData)
  })
  .then(() => {
    alert("✅ Loan Updated Successfully!");
    window.location.href = "viewLoans.html";
  })
  .catch(err => {
    console.error(err);
    alert("❌ Error updating loan");
  });
}