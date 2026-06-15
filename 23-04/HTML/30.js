function checkEligibility() {
            let ageInput = document.getElementById("ageInput").value;
            let isMale = document.getElementById("male").checked;
            let isFemale = document.getElementById("female").checked;
            let result = document.getElementById("display");

            if (ageInput === "") {
                result.innerHTML = "Please enter an age";
                return;
            }

            let age = Number(ageInput);

            switch (true) {
                case (age < 0 || age > 120):
                    result.innerHTML = "Invalid age";
                    result.style.color = "red";
                    break;

                case (isMale && age >= 21):
                    result.innerHTML = "Eligible for marriage (Male)";
                    result.style.color = "green";
                    break;
                
                case (isMale && age < 21):
                    result.innerHTML = "Not eligible for marriage (Male)";
                    result.style.color = "orange";
                    break;

                case (isFemale && age >= 18):
                    result.innerHTML = "Eligible for marriage (Female)";
                    result.style.color = "green";
                    break;

                case (isFemale && age < 18):
                    result.innerHTML = "Not eligible for marriage (Female)";
                    result.style.color = "orange";
                    break;

                default:
                    result.innerHTML = "Please select a gender";
                    result.style.color = "purple";
            }
        }