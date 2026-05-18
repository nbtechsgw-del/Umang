        const text = document.getElementById("targetText");

        function changeColor(c) { text.style.color = c; }
        
        function changeSize(s) { text.style.fontSize = s; }
        
        function toggleVisibility(v) { text.style.visibility = v; }
        
        function makeBold(isBold) { text.style.fontWeight = isBold ? "bold" : "normal"; }
        
        function alignText(pos) { 
            // Note: For 'center' to work visibly, the H1 needs width
            text.style.width = "100%";
            text.style.textAlign = pos; 
        }
        
        function changeBg(color) { document.body.style.backgroundColor = color; }
        
        function changeFont(f) { text.style.fontFamily = f; }   