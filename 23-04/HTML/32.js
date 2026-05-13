        function changeBg(color) {
            const body = document.getElementById("mainBody");
            
            body.style.backgroundColor = color;

            if (color === "#2c3e50") {
                body.style.color = "white";
            } else {
                body.style.color = "#333";
            }
        }
    