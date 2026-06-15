async function login() {
    if (!document.getElementById("loginForm").checkValidity()) {
        alert("Please fill all fields correctly");
        return;
    }

    const username = document.getElementById("username").value;

    const password = document.getElementById("password").value;

    const response = await fetch(`http://localhost:8081/auth/login?username=${username}&password=${password}`,
        {
            method: "POST"
        }
    );
    const result = await response.json();

    if(result.message === "Login Successful") {
        localStorage.setItem("isLoggedIn", "true");
        localStorage.setItem("username", username);
        localStorage.setItem("role", result.role);
    
        window.location.href = "admin-dashboard.html";
    }
}

function logout() {
    localStorage.removeItem("isLoggedIn");
    localStorage.removeItem("username");
    alert("Logged Out Successfully");
    window.location.href = "login.html";
}

async function addPatient() {
    if (!document.getElementById("patientForm").checkValidity()) {
        alert("Please fill all fields correctly");
        return;
    }
    const patient = {
        fullName: document.getElementById("fullName").value,
        age: document.getElementById("age").value,
        gender: document.getElementById("gender").value,
        phone: document.getElementById("phone").value,
        address: document.getElementById("address").value,
        bloodGroup: document.getElementById("bloodGroup").value
    };

    await fetch("http://localhost:8081/patients", {
        method: "POST",
        headers: {
            "Content-Type": "application/json"
        },
        body: JSON.stringify(patient)
    });

    alert("Patient Added");
    getAllPatients();
}

async function loadPatientsDropdown() {

    const response = await fetch("http://localhost:8081/patients");

    const patients = await response.json();

    console.log(patients);

    let options =
    `<option value="">Select Patient</option>`;

    patients.forEach(patient => {

        options += `

            <option value="${patient.patientId}">

                ${patient.patientId}
                -
                ${patient.fullName}

            </option>
        `;
    });

    document.getElementById("patientId")
    .innerHTML = options;
}

async function getAllPatients() {
    const response = await fetch("http://localhost:8081/patients");
    const patients = await response.json();
    let tableData = "";

    patients.forEach(patient => {
        tableData += `
            <tr>
                <td>${patient.patientId}</td>
                <td>${patient.fullName}</td>
                <td>${patient.age}</td>
                <td>${patient.gender}</td>
                <td>${patient.phone}</td>
                <td>${patient.bloodGroup}</td>
                <td>
                    <button onclick="deletePatient(${patient.patientId})">Delete</button>
                </td>
            </tr>
        `;
    });

    displayPatients(patients);
}

async function deletePatient(id) {

    await fetch(`http://localhost:8081/patients/${id}`, { method: "DELETE"});

    alert("Patient Deleted");
    getAllPatients();
}

async function bookAppointment() {

    const patientId = document.getElementById("patientId").value;
    const doctorId = document.getElementById("doctorId").value;
    const appointmentDate = document.getElementById("appointmentDate").value;
    const appointmentTime = document.getElementById("appointmentTime").value;

    if (patientId === "" || doctorId === "" || appointmentDate === "" || appointmentTime === "") {
        alert("Please fill all fields");
        return;
    }

    const appointmentData = {
        patient: {
            patientId: patientId
        },
        doctor: {
            doctorId: doctorId
        },
        appointmentDate: appointmentDate + " " + appointmentTime,
        status: "Scheduled"
    };

    const response = await fetch("http://localhost:8081/appointments",
        {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(appointmentData)
        }
    );

    if(response.ok) {
        alert("Appointment Booked Successfully");
        document.getElementById("appointmentForm").reset();
        getAllAppointments();
    }else {
        alert("Failed To Book Appointment");
    }
}

async function getAllAppointments() {
    const response = await fetch("http://localhost:8081/appointments");
    const appointments = await response.json();
    let tableData = "";

    appointments.forEach(appointment => {
        let badgeClass = "bg-secondary";
        if (appointment.status === "Completed") {
            badgeClass = "bg-success";
        }else if (appointment.status === "Cancelled") {
            badgeClass = "bg-danger";
        }else if (appointment.status === "Pending") {
            badgeClass = "bg-warning text-dark";
        }else if (appointment.status === "Scheduled") {
            badgeClass = "bg-primary";
        }
        tableData += `
            <tr>
                <td>${appointment.appointmentId}</td>
                <td>${appointment.patient.patientId}</td>
                <td>${appointment.doctor ? "Dr. " + appointment.doctor.doctorName : "Not Assigned"}</td>
                <td>${appointment.doctor ? appointment.doctor.specialization : "-"}</td>
                <td>${appointment.appointmentDate}</td>
                <td>
                <span class="badge ${badgeClass}">${appointment.status}</span>
                </td>
                <td>
                    <button class="btn btn-danger btn-sm" onclick="deleteAppointment(${appointment.appointmentId})">Delete</button>
                </td>
            </tr>
        `;
    });
    document.getElementById("appointmentTable").innerHTML = tableData;
}

async function deleteAppointment(id) {
    const confirmDelete = confirm("Are you sure you want to delete this appointment?");
    if (!confirmDelete) {
        return;
    }
    const response = await fetch(`http://localhost:8081/appointments/${id}`,
        {
            method: "DELETE"
        }
    );
    if(response.ok) {
        alert("Appointment Deleted Successfully");
        getAllAppointments();
    }
    else {
        alert("Failed To Delete Appointment");
    }
}

async function loadDashboard() {
    const patientResponse = await fetch("http://localhost:8081/patients");
    const patients = await patientResponse.json();
    document.getElementById("patientCount").innerText = patients.length;
    
    const appointmentResponse = await fetch("http://localhost:8081/appointments");
    const appointments = await appointmentResponse.json();
    document.getElementById("appointmentCount").innerText = appointments.length;
    
    const recordResponse = await fetch("http://localhost:8081/records");
    const records = await recordResponse.json();
    document.getElementById("recordCount").innerText = records.length;
}

if(window.location.pathname.includes("dashboard.html")) {
    loadDashboard();
}

async function createBill() {

    const patientId = document.getElementById("patientId").value;

    const amount = parseFloat(document.getElementById("amount").value);

    const gst = parseFloat(document.getElementById("gst").value);

    const totalAmount = parseFloat(document.getElementById("totalAmount").value);

    const paymentStatus = document.getElementById("paymentStatus").value;

    const paymentMethod = document.getElementById("paymentMethod").value;

    const billingDate = document.getElementById("billingDate").value;

    if( patientId === "" || isNaN(amount) || paymentStatus === "" || paymentMethod === "" || billingDate === "") {
        alert("Please Fill All Fields");
        return;
    }
    const billingData = {
        patient: {
            patientId: patientId
        },
        amount: amount,
        gst: gst,
        totalAmount: totalAmount,
        paymentStatus: paymentStatus,
        paymentMethod: paymentMethod,
        billingDate: billingDate
    };
    const response = await fetch("http://localhost:8081/billing",
        {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(billingData)
        }
    );
    if(response.ok) {
        alert("Bill Generated Successfully");
        document.getElementById("patientForm").reset();
        document.getElementById("totalAmount").value = "";
        getAllBills();
    }else {
        alert("Failed To Generate Bill");
    }
}

function calculateTotal() {
    const amount = parseFloat(document.getElementById("amount").value) || 0;

    const gst = parseFloat(document.getElementById("gst").value) || 0;

    const totalAmount = amount + (amount * gst / 100);

    document.getElementById("totalAmount").value = totalAmount.toFixed(2);
}

async function getAllBills() {

    const response =
    await fetch("http://localhost:8081/billing");

    const bills =
    await response.json();

    console.log(bills);

    if(!Array.isArray(bills)) {

        console.error("Billing API Error");

        return;
    }

    let tableData = "";

    bills.forEach(bill => {

        tableData += `
        <tr>
            <td>${bill.billId}</td>
            <td>${bill.patient.patientId}</td>
            <td>${bill.invoiceId}</td>
            <td>Rs.${bill.amount}</td>
            <td>${bill.gst}%</td>
            <td>Rs.${bill.totalAmount}</td>
            <td>
                <span class="badge bg-success">${bill.paymentStatus}</span>
            </td>
            <td>${bill.paymentMethod}</td>
            <td>${bill.billingDate}</td>
            <td>
                <button class="btn btn-primary btn-sm me-2" onclick="printInvoice(${bill.billId})">Print</button>
                <button class="btn btn-danger btn-sm" onclick="deleteBill(${bill.billId})">Delete</button>
            </td>
        </tr>
        `;
    });

    document.getElementById("billingTable")
    .innerHTML = tableData;
}

async function printInvoice(billId) {

    const response = await fetch(`http://localhost:8081/billing/${billId}`);
    const bill = await response.json();
    const invoiceWindow = window.open("", "_blank");
    invoiceWindow.document.write(`
    <html>
        <head>
            <title>
                Hospital Invoice
            </title>
            <style>
                body {
                    font-family: Arial;
                    padding: 30px;
                }
                h1 {
                    text-align: center;
                }
                table {
                    width: 100%;
                    border-collapse: collapse;
                    margin-top: 20px;
                }
                th, td {
                    border: 1px solid black;
                    padding: 10px;
                    text-align: left;
                }
            </style>
        </head>
        <body>
            <h1>
                Hospital Invoice
            </h1>
            <table>
                <tr>
                    <th>Invoice ID</th>
                    <td>${bill.invoiceId}</td>
                </tr>
                <tr>
                    <th>Bill ID</th>
                    <td>${bill.billId}</td>
                </tr>
                <tr>
                    <th>Patient ID</th>
                    <td>${bill.patient.patientId}</td>
                </tr>
                <tr>
                    <th>Amount</th>
                    <td>₹${bill.amount}</td>
                </tr>
                <tr>
                    <th>GST</th>
                    <td>${bill.gst}%</td>
                </tr>
                <tr>
                    <th>Total Amount</th>
                    <td>₹${bill.totalAmount}</td>
                </tr>
                <tr>
                    <th>Status</th>
                    <td>${bill.paymentStatus}</td>
                </tr>
                <tr>
                    <th>Payment Method</th>
                    <td>${bill.paymentMethod}</td>
                </tr>
                <tr>
                    <th>Billing Date</th>
                    <td>${bill.billingDate}</td>
                </tr>
            </table>
        </body>
    </html>
    `);
    invoiceWindow.document.close();
    invoiceWindow.print();
}

async function deleteBill(id) {
    await fetch(`http://localhost:8081/billing/${id}`, {
        method: "DELETE"
    });
    alert("Bill Deleted");
    getAllBills();
}

if(window.location.pathname.includes("billing.html")) {
    getAllBills();
}

async function searchPatientByName() {
    const name = document.getElementById("searchName").value;
    const response = await fetch(`http://localhost:8081/patients/search/name/${name}`);
    const patients = await response.json();
    displayPatients(patients);
}

async function searchPatientByPhone() {
    const phone = document.getElementById("searchPhone").value;
    const response = await fetch(`http://localhost:8081/patients/search/phone/${phone}`);
    const patients = await response.json();
    displayPatients(patients);
}

function displayPatients(patients) {

    let tableData = "";
    patients.forEach(patient => {
        tableData += `
            <tr>
                <td>${patient.patientId}</td>
                <td>${patient.fullName}</td>
                <td>${patient.age}</td>
                <td>${patient.gender}</td>
                <td>${patient.phone}</td>
                <td>${patient.bloodGroup}</td>
                <td>
                    <button onclick="editPatient(${patient.patientId})">Edit</button>
                    <button onclick="deletePatient(${patient.patientId})">Delete</button>
                </td>
            </tr>
        `;
    });

    document.getElementById("patientTable").innerHTML = tableData;
}

async function editPatient(id) {
    const response = await fetch(`http://localhost:8081/patients/${id}`);
    const patient = await response.json();

    document.getElementById("patientId").value = patient.patientId;
    document.getElementById("patientName").value = patient.patientName;
    document.getElementById("age").value = patient.age;
    document.getElementById("gender").value = patient.gender;
    document.getElementById("contact").value = patient.contact;
    document.getElementById("address").value = patient.address;
    document.getElementById("bloodGroup").value = patient.bloodGroup;
    document.getElementById("saveBtn").innerText = "Update Patient";
}

async function savePatient() {

    const patientId = document.getElementById("patientId").value;

    const patientData = {
        patientName: document.getElementById("patientName").value,
        age: document.getElementById("age").value,
        gender: document.getElementById("gender").value,
        contact: document.getElementById("contact").value,
        address: document.getElementById("address").value,
        bloodGroup: document.getElementById("bloodGroup").value
    };

    if(patientId == "") {
        await fetch("http://localhost:8081/patients", {method: "POST",headers: 
            {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(patientData)
            }
        );
        alert("Patient Added Successfully");
    }
    else {
        await fetch(`http://localhost:8081/patients/${patientId}`,{method: "PUT",headers:
            {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(patientData)
            }
        );
        alert("Patient Updated Successfully");
    }

    document.getElementById("patientForm").reset();
    document.getElementById("patientId").value = "";
    document.getElementById("saveBtn").innerText = "Save Patient";
    getAllPatients();
}

async function registerUser() {

    const user = {
        username: document.getElementById("username").value,
        password: document.getElementById("password").value,
        role: document.getElementById("role").value
    };

    const response = await fetch("http://localhost:8081/auth/register",{
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(user)
        }
    );

    const result = await response.text();
    alert(result);
    window.location.href = "login.html";
}

function togglePassword() {
    const passwordField = document.getElementById("password");
    const button = event.target;

    if (passwordField.type === "password") {
        passwordField.type = "text";
        button.innerText = "Hide";
    } else {
        passwordField.type = "password";
        button.innerText = "Show";
    }
}

async function addDoctor() {
    const doctorName = document.getElementById("doctorName").value;
    const specialization = document.getElementById("specialization").value;
    const doctorPhone = document.getElementById("doctorPhone").value;

    if(doctorName === "" || specialization === "" || doctorPhone === "") {
        alert("Please fill all fields");
        return;
    }

    const doctorData = {
        doctorName: doctorName,
        specialization: specialization,
        phone: doctorPhone
    };

    const response = await fetch("http://localhost:8081/doctors",{
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(doctorData)
        }
    );

    if(response.ok) {
        alert("Doctor Added Successfully");
        document.getElementById("doctorForm").reset();
        getAllDoctors();
    }else{
        alert("Failed To Add Doctor");
    }
}

async function getAllDoctors() {
    const response = await fetch("http://localhost:8081/doctors");
    const doctors = await response.json();
    let tableData = "";

    doctors.forEach(doctor => {
        tableData += `
            <tr>
                <td>${doctor.doctorId}</td>
                <td>${doctor.doctorName}</td>
                <td>${doctor.specialization}</td>
                <td>${doctor.phone}</td>
                <td>
                    <button class="btn btn-danger btn-sm" onclick="deleteDoctor(${doctor.doctorId})">Delete</button>
                </td>
            </tr>
        `;
    });
    document.getElementById("doctorTable").innerHTML = tableData;
}

async function deleteDoctor(id) {
    const confirmDelete = confirm("Are you sure you want to delete this doctor?");

    if(!confirmDelete) {
        return;
    }
    const response = await fetch(`http://localhost:8081/doctors/${id}`,{
            method: "DELETE"
        }
    );

    if(response.ok) {
        alert("Doctor Deleted Successfully");
        getAllDoctors();
    }else{
        alert("Failed To Delete Doctor");
    }
}

async function loadDoctors() {
    const response = await fetch("http://localhost:8081/doctors");
    const doctors = await response.json();
    let options = `<option value="">Select Doctor</option>`;

    doctors.forEach(doctor => {
        options += `
            <option value="${doctor.doctorId}">
                Dr. ${doctor.doctorName}
                (${doctor.specialization})
            </option>
        `;
    });

    document.getElementById("doctorId").innerHTML = options;
}

async function searchPatientById() {

    const id = document.getElementById("searchId").value;

    if(id === "") {
        alert("Please Enter Patient ID");
        return;
    }

    const response = await fetch(`http://localhost:8081/patients/id/${id}`);

    if(!response.ok) {
        alert("Patient Not Found");
        return;
    }

    const patient = await response.json();
    let tableData = `
        <tr>
            <td>${patient.patientId}</td>
            <td>${patient.fullName}</td>
            <td>${patient.age}</td>
            <td>${patient.gender}</td>
            <td>${patient.phone}</td>
            <td>${patient.bloodGroup}</td>
            <td>
                <button class="btn btn-danger btn-sm" onclick="deletePatient(${patient.patientId})">Delete</button>
            </td>
        </tr>
    `;
    document.getElementById("patientTable").innerHTML = tableData;
}

async function sortPatientsByName() {
    const response = await fetch("http://localhost:8081/patients");
    const patients = await response.json();

    patients.sort((a, b) => a.fullName.localeCompare(b.fullName));
    displayPatients(patients);
}

async function sortPatientsByAge() {

    const response = await fetch("http://localhost:8081/patients");
    const patients = await response.json();

    patients.sort((a, b) => a.age - b.age);
    displayPatients(patients);
}