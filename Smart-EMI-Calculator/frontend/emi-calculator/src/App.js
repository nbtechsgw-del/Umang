import { useState } from "react";
function App() {
  const [principal, setPrincipal] = useState("");
  const [rate, setRate] = useState("");
  const [time, setTime] = useState("");
  const [emi, setEmi] = useState(null);
  const [loading, setLoading] = useState(false);

  const calculateEmi = async () => {
  if (!principal || !rate || !time) {
    alert("Please fill all fields");
    return;
  }

  try {
    const response = await fetch(
      `http://localhost:8080/calculate?principal=${principal}&rate=${rate}&time=${time}`
    );

    const data = await response.json();
    setEmi(data.toFixed(2));

  } catch (error) {
    console.error(error);
    alert("Error connecting to backend");
  }
};

  return (
    <div style={styles.card}>
      <h1>Smart EMI Calculator</h1>

      <input
  type="number"
  placeholder="Loan Amount"
  value={principal}
  style={styles.input}
  onChange={(e) => setPrincipal(e.target.value)}
/>

<br />

<input
  type="number"
  placeholder="Interest Rate (%)"
  value={rate}
  style={styles.input}
  onChange={(e) => setRate(e.target.value)}
/>

<br />

<input
  type="number"
  placeholder="Time (Years)"
  value={time}
  style={styles.input}
  onChange={(e) => setTime(e.target.value)}
/>

<br />

      <button onClick={calculateEmi} style={styles.button}>Calculate EMI</button>
      {emi && <h2>Your EMI: ₹{emi}</h2>}
    </div>
  );
}

const styles = {
  container: {
    textAlign: "center",
    marginTop: "80px",
    backgroundColor: "#f0f2f5",
    height: "100vh",
    paddingTop: "50px",
  },
  card: {
    backgroundColor: "white",
    padding: "30px",
    width: "300px",
    margin: "auto",
    borderRadius: "10px",
    boxShadow: "0 0 10px rgba(0,0,0,0.1)",
  },
  input: {
    display: "block",
    margin: "10px auto",
    padding: "10px",
    width: "250px",
    fontSize: "16px",
  },
  button: {
    padding: "10px 20px",
    fontSize: "16px",
    backgroundColor: "#007bff",
    color: "white",
    border: "none",
    borderRadius: "5px",
    cursor: "pointer",
    marginTop: "10px",
  },
};

export default App;