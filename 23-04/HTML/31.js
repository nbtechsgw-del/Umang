        function updateBg(chosenColor) {
            document.body.style.backgroundColor = chosenColor;
            
            if (chosenColor === '#000000') {
                document.body.style.color = "white";
            } else {
                document.body.style.color = "#333";
            }
        }