var clickCount = 0;

function cycleStyles() {
    var x = document.getElementById("box");

    if (clickCount == 0) {
        x.style.color = "white";
        x.style.backgroundColor = "blue";
        x.style.fontSize = "25px";
        x.style.borderRadius = "10px";
        clickCount = 1; // Set for next click
    } 
    else if (clickCount == 1) {
        x.style.color = "yellow";
        x.style.backgroundColor = "red";
        x.style.fontStyle = "italic";
        x.style.border = "5px dashed black";
        clickCount = 2;
    } 
    else if (clickCount == 2) {
        x.style.color = "black";
        x.style.backgroundColor = "green";
        x.style.fontWeight = "bold";
        x.style.textAlign = "right";
        clickCount = 3;
    } 
    else {
        x.style.color = "pink";
        x.style.backgroundColor = "purple";
        x.style.fontSize = "40px";
        x.style.textAlign = "center";
        clickCount = 0; // Go back to start
    }
}

function resetStyles() {
    var x = document.getElementById("box");
    clickCount = 0;

    x.style.color = "";
    x.style.backgroundColor = "";
    x.style.fontSize = "";
    x.style.fontStyle = "";
    x.style.fontWeight = "";
    x.style.border = "";
    x.style.borderRadius = "";
    x.style.textAlign = "";
}