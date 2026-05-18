function copyAddress() {
    var checkBox = document.getElementById("same_as");
    
    var permanent = document.getElementById("p_address");
    var current = document.getElementById("c_address");

    if (checkBox.checked == true) {
        current.value = permanent.value;
    } else {
        current.value = "";
    }
}