function changeText() {
    var element = document.getElementById("mainHeading");

    if (element.innerHTML === "This is the original text.") {
        element.innerHTML = "Hello! The content has been changed.";
    } else {
        element.innerHTML = "This is the original text.";
    }
}