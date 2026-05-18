let allLoans = [];

const email = localStorage.getItem("userEmail");

if (!email) {
    alert("Please login first");
    window.location.href = "login.html";
}

function loadData() {
  document.querySelector("button").innerText = "Loaded ✅";
  fetch(`http://localhost:8080/getUserLoans/${email}`)
    .then(res => res.json())
    .then(data => {
      allLoans = data;
      displayLoans(data);
    })
    .catch(err => {
      console.error(err);
      alert("Error loading loans");
    });
}


// 🔹 Display function
function displayLoans(data) {
  let rows = "";

  if (data.length === 0) {
    rows = `<tr><td colspan="6">No loans found</td></tr>`;
  } else {
    data.forEach(loan => {
      rows += `
        <tr>
          <td><input type="checkbox" class="compareCheck" value='${JSON.stringify(loan)}'></td>
          <td>${loan.name}</td>
          <td>₹${loan.principal}</td>
          <td>${loan.rate}%</td>
          <td>${loan.time} yrs</td>
          <td>₹${loan.emi ? loan.emi.toFixed(2) : 0}</td>
          <td>
            <button onclick="editLoan(${loan.id})">Edit</button>
            <button onclick="deleteLoan(${loan.id})" style="background:red;">Delete</button>
          </td>
          <td>
            <button onclick="showDetails(${loan.principal}, ${loan.rate}, ${loan.time}, ${loan.emi})">View Details</button>
  </td>
        </tr>
      `;
    });
  }

  document.getElementById("tableData").innerHTML = rows;
}

function deleteLoan(id) {
  if (!confirm("Are you sure you want to delete this loan?")) return;

  fetch(`http://localhost:8080/deleteLoan/${id}`, {
    method: "DELETE"
  })
  .then(() => {
    alert("Deleted successfully");
    loadData(); // refresh table
  })
  .catch(err => {
    console.error(err);
    alert("Error deleting loan");
  });
}

function editLoan(id) {
  window.location.href = `editLoan.html?id=${id}`;
}

function filterLoans() {
  const searchValue = document.getElementById("searchInput").value.toLowerCase();

  const filtered = allLoans.filter(loan =>
    loan.name.toLowerCase().includes(searchValue)
  );

  displayLoans(filtered);
}

function createChart(principal, emi, years) {
  const totalPayment = emi * years * 12;
  const interest = totalPayment - principal;

  const ctx = document.getElementById('emiChart').getContext('2d');

  new Chart(ctx, {
    type: 'pie',
    data: {
      labels: ['Principal', 'Interest'],
      datasets: [{
        data: [principal, interest],
        backgroundColor: ['#3498db', '#e74c3c']
      }]
    },
    options: {
      responsive: true
    }
  });
}

function showDetails(principal, rate, years, emi) {

  const section = document.getElementById("detailsSection");
  section.style.display = "block";
  setTimeout(() => section.classList.add("show"), 10);
  document.getElementById("detailsSection").style.display = "block";

  showChart(principal, emi, years);
  showSchedule(principal, rate, years, emi);
}

let chart;

function showChart(principal, emi, years) {

  const totalPayment = emi * years * 12;
  const interest = totalPayment - principal;

  const ctx = document.getElementById('emiChart').getContext('2d');

  if (chart) {
    chart.destroy();
  }

  chart = new Chart(ctx, {
    type: 'pie',
    data: {
      labels: ['Principal', 'Interest'],
      datasets: [{
        data: [principal, interest],
        backgroundColor: ['#3498db', '#e74c3c']
      }]
    }
  });
}

function showSchedule(principal, rate, years, emi) {

  let monthlyRate = rate / 12 / 100;
  let months = years * 12;

  let balance = principal;

  let tbody = document.querySelector("#scheduleTable tbody");
  tbody.innerHTML = ""; // clear old data

  for (let i = 1; i <= months; i++) {

    let interest = balance * monthlyRate;
    let principalPaid = emi - interest;
    balance = balance - principalPaid;

    let row = `
      <tr>
        <td>${i}</td>
        <td>${emi.toFixed(2)}</td>
        <td>${interest.toFixed(2)}</td>
        <td>${principalPaid.toFixed(2)}</td>
        <td>${balance.toFixed(2)}</td>
      </tr>
    `;

    tbody.innerHTML += row;

    if (balance <= 0) break;
  }
}

function openModal() {
  console.log("Modal clicked");
  document.getElementById("compareModal").style.display = "block";
}

function closeModal() {
  document.getElementById("compareModal").style.display = "none";
}

window.onclick = function(event) {
  let modal = document.getElementById("compareModal");
  if (event.target == modal) {
    modal.style.display = "none";
  }
}

function compareLoans() {

  let selected = document.querySelectorAll(".compareCheck:checked");

  if (selected.length < 2) {
    alert("Select at least 2 loans");
    return;
  }

  if (selected.length > 4) {
    alert("You can compare max 4 loans");
    return;
  }

  let loans = Array.from(selected).map(cb => JSON.parse(cb.value));

  let tbody = document.querySelector("#compareTable tbody");
  let thead = document.querySelector("#compareTable thead");

  let headerRow = `<tr><th>Feature</th>`;
  loans.forEach((_, index) => {
    headerRow += `<th>Loan ${index + 1}</th>`;
  });
  headerRow += `</tr>`;
  thead.innerHTML = headerRow;

  function calculateTotal(loan) {
    let total = loan.emi * loan.time * 12;
    let interest = total - loan.principal;
    return { total, interest };
  }

  function createRow(label, values) {
    let row = `<tr><td>${label}</td>`;
    values.forEach(val => {
      row += `<td>₹${val}</td>`;
    });
    row += `</tr>`;
    return row;
  }

  let principalRow = loans.map(l => l.principal);
  let emiRow = loans.map(l => l.emi);
  let interestRow = loans.map(l => calculateTotal(l).interest.toFixed(2));
  let totalRow = loans.map(l => calculateTotal(l).total.toFixed(2));

  tbody.innerHTML = `
    ${createRow("Principal", principalRow)}
    ${createRow("EMI", emiRow)}
    ${createRow("Interest", interestRow)}
    ${createRow("Total", totalRow)}
  `;

  // 🔥 SHOW TABLE + MODAL
  document.getElementById("compareTable").style.display = "table";
  openModal();
}

function logout() {
    localStorage.removeItem("userEmail");
    window.location.href = "login.html";
}