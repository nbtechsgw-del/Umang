function checkAge() {
            // 1. Get the value from the input field
            let ageValue = document.getElementById("userAge").value;
            let resultText = document.getElementById("result");

            // 2. Convert input to a number
            let age = Number(ageValue);

            // 3. Logic: Invalid, Adult, or Not Adult
            if (ageValue === "" || age < 0 || age > 120) {
                resultText.innerHTML = "Result: Invalid Age";
                resultText.style.color = "red";
            } 
            else if (age >= 18) {
                resultText.innerHTML = "Result: Adult";
                resultText.style.color = "green";
            } 
            else {
                resultText.innerHTML = "Result: Not Adult";
                resultText.style.color = "orange";
            }
        }