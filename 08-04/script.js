const buttons = document.querySelectorAll('.read-more');

buttons.forEach(button => {
    button.addEventListener('click',function(){
        const moreText = this.previousElementSibling;

        if(moreText.style.display === "none"){
            moreText.style.display = "block";
            this.innerText = "Read less";
        }else{
            moreText.style.display = "none";
            this.innerText = "Read more";
        }
    });
});