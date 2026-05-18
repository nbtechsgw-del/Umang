function updateBackground() {
            // 1. Find all checkboxes that are checked
            const checkboxes = document.querySelectorAll('.color-check:checked');
            
            // 2. Extract the hex values into an array
            let selectedColors = [];
            checkboxes.forEach((cb) => {
                selectedColors.push(cb.value);
            });

            // 3. Decide what to show based on how many are selected
            if (selectedColors.length === 0) {
                // No colors: Reset to gray
                document.body.style.background = "#f0f0f0";
            } 
            else if (selectedColors.length === 1) {
                // One color: Solid background
                document.body.style.background = selectedColors[0];
            } 
            else {
                // Multiple colors: Create a linear gradient string
                // Example format: linear-gradient(to right, #color1, #color2)
                let gradientString = "linear-gradient(to right, " + selectedColors.join(", ") + ")";
                document.body.style.background = gradientString;
            }
        }